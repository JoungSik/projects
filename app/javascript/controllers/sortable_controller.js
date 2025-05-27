/*
 * Design Direction & Principles:
 * - 단일 책임 원칙: 드래그앤드랍 상태 변경만 담당
 * - 관심사 분리: UI 조작과 서버 통신을 명확히 분리
 * - Dependency Inversion: SortableJS 라이브러리에 의존하되 인터페이스를 통해 제어
 *
 * Technical Considerations:
 * - Hotwire Turbo와의 호환성을 위한 이벤트 핸들링
 * - 비동기 HTTP 요청을 통한 상태 업데이트
 * - 사용자 피드백을 위한 시각적 상태 표시
 *
 * Usage Considerations:
 * - 칸반 보드 컨테이너에만 적용
 * - 드래그 가능한 task 요소들에 대해서만 동작
 * - 권한 검증은 서버 측에서 처리
 */

import { Controller } from "@hotwired/stimulus";
import { Sortable } from 'sortablejs';

export default class extends Controller {
  static targets = ["column"];
  static values = {
    workspaceId: String,
    projectId: String,
    url: String
  };

  connect() {
    // 드래그 상태 초기화
    this.isDragging = false;
    this.sortableInstances = [];

    // 각 상태별 컬럼에 SortableJS 인스턴스 초기화
    this.columnTargets.forEach((column, index) => {
      this.initializeSortable(column, index);
    });

    // 초기 컬럼 상태 업데이트
    this.updateColumnStates();
  }

  disconnect() {
    // 메모리 누수 방지를 위한 정리
    if (this.sortableInstances && this.sortableInstances.length > 0) {
      this.sortableInstances.forEach(instance => {
        if (instance && typeof instance.destroy === 'function') {
          instance.destroy();
        }
      });
      this.sortableInstances = [];
    }
  }

  // 각 컬럼에 SortableJS 인스턴스를 생성하고 설정
  initializeSortable(column, statusIndex) {
    const taskContainer = column.querySelector('[data-sortable-tasks]');
    if (!taskContainer) {
      console.warn("Task container not found for column", statusIndex);
      return;
    }

    try {
      const sortableInstance = Sortable.create(taskContainer, {
        group: 'kanban',
        animation: 150, // 빠른 애니메이션으로 성능 개선
        ghostClass: 'opacity-50', // 단일 클래스만 사용
        chosenClass: 'ring-2', // 단일 클래스만 사용 (SortableJS 제한)
        dragClass: 'rotate-1', // 단일 클래스만 사용 (SortableJS 제한)
        forceFallback: false, // 브라우저 네이티브 드래그 사용으로 성능 개선
        fallbackTolerance: 3, // 터치 디바이스를 위한 설정
        filter: '[data-empty-state]',
        preventOnFilter: false, // 필터된 요소 클릭 허용


        onStart: (event) => {
          this.isDragging = true;

          // 추가 스타일링을 수동으로 추가 (SortableJS 제한 회피)
          this.addClasses(event.item, ['ring-indigo-500', 'shadow-xl', 'z-50']);

          // 드롭존 표시를 지연시켜 초기 드래그 성능 개선
          requestAnimationFrame(() => {
            this.showDropZones();
          });
        },

        onEnd: (event) => {
          // 추가한 스타일 제거
          this.removeClasses(event.item, ['ring-indigo-500', 'shadow-xl', 'z-50']);

          this.handleTaskMove(event);
        },

        onUnchoose: (event) => {
          // 지연 시간을 줄여서 성능 개선
          setTimeout(() => {
            this.isDragging = false;
          }, 50);

          // 추가한 스타일 제거
          this.removeClasses(event.item, ['ring-indigo-500', 'shadow-xl', 'z-50']);

          this.hideDropZones();
        }
      });

      this.sortableInstances.push(sortableInstance);

    } catch (error) {
      console.error("Failed to create sortable instance:", error);
    }
  }

  // Task 이동 처리 및 서버 업데이트
  async handleTaskMove(event) {
    const taskElement = event.item;

    // 빈 상태 카드는 처리하지 않음
    if (taskElement.hasAttribute('data-empty-state')) {
      return;
    }

    const taskId = taskElement.dataset.taskId;
    const newStatusIndex = this.getStatusFromColumn(event.to);
    const oldStatusIndex = this.getStatusFromColumn(event.from);

    // 같은 컬럼 내에서 이동한 경우 서버 업데이트 불필요
    if (newStatusIndex === oldStatusIndex) {
      this.updateColumnStates();
      return;
    }

    try {
      // 즉시 UI 업데이트로 사용자 경험 향상
      this.updateTaskVisualStatus(taskElement, newStatusIndex);
      this.updateColumnStates();

      // 서버에 상태 변경 요청
      await this.updateTaskStatus(taskId, newStatusIndex);

      // 성공 피드백
      this.showSuccessMessage();

    } catch (error) {
      console.error('태스크 상태 업데이트 실패:', error);
      this.revertTaskPosition(taskElement, event.from, event.oldIndex);
      this.updateColumnStates();
    }
  }

  // 컬럼에서 상태 인덱스 추출
  getStatusFromColumn(columnContainer) {
    const column = columnContainer.closest('[data-status-index]');
    return column ? parseInt(column.dataset.statusIndex) : 0;
  }

  // 서버에 태스크 상태 업데이트 요청
  async updateTaskStatus(taskId, newStatus) {
    const url = `/workspaces/${this.workspaceIdValue}/projects/${this.projectIdValue}/tasks/${taskId}`;

    const response = await fetch(url, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': this.getCSRFToken()
      },
      body: JSON.stringify({
        task: {
          status: newStatus
        }
      })
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    return response.json();
  }

  // Task 요소의 시각적 상태 즉시 업데이트
  updateTaskVisualStatus(taskElement, newStatus) {
    const statusColors = {
      0: 'border-gray-200',
      1: 'border-blue-200',
      2: 'border-red-200',
      3: 'border-green-200',
      4: 'border-red-200'
    };

    // 기존 보더 클래스 제거
    Object.values(statusColors).forEach(colorClass => {
      taskElement.classList.remove(colorClass);
    });

    // 새로운 상태의 보더 클래스 추가
    const newColorClass = statusColors[newStatus] || 'border-gray-200';
    taskElement.classList.add(newColorClass);
  }

  // 실패 시 태스크를 원래 위치로 되돌리기
  revertTaskPosition(taskElement, originalContainer, originalIndex) {
    try {
      const children = Array.from(originalContainer.children);
      if (originalIndex >= children.length) {
        originalContainer.appendChild(taskElement);
      } else {
        originalContainer.insertBefore(taskElement, children[originalIndex]);
      }
    } catch (error) {
      console.error("Failed to revert task position:", error);
    }
  }

  // 모든 컬럼의 상태 업데이트
  updateColumnStates() {
    this.columnTargets.forEach(column => {
      const taskContainer = column.querySelector('[data-sortable-tasks]');
      const countBadge = column.querySelector('h3 span.bg-gray-100');

      if (taskContainer && countBadge) {
        const realTasks = Array.from(taskContainer.children).filter(child =>
          !child.hasAttribute('data-empty-state')
        );
        const taskCount = realTasks.length;
        countBadge.textContent = taskCount;
      }
    });
  }

  // 드래그 중 드롭 가능한 영역 하이라이트 - 성능 최적화
  showDropZones() {
    const dropZoneClasses = ['ring-2', 'ring-indigo-200', 'ring-dashed', 'transition-all', 'duration-200'];

    requestAnimationFrame(() => {
      this.columnTargets.forEach(column => {
        const taskContainer = column.querySelector('[data-sortable-tasks]');
        if (taskContainer) {
          this.addClasses(taskContainer, dropZoneClasses);
        }
      });
    });
  }

  // 드롭 영역 하이라이트 제거 - 성능 최적화
  hideDropZones() {
    const dropZoneClasses = ['ring-2', 'ring-indigo-200', 'ring-dashed', 'transition-all', 'duration-200'];

    this.columnTargets.forEach(column => {
      const taskContainer = column.querySelector('[data-sortable-tasks]');
      if (taskContainer) {
        this.removeClasses(taskContainer, dropZoneClasses);
      }
    });
  }

  // 성공 메시지 표시
  showSuccessMessage() {
    if (window.Turbo && window.Turbo.visit) {
      window.Turbo.visit(window.location.href);
    } else {
      window.location.reload();
    }
  }

  // Task 카드 클릭 핸들러
  handleTaskClick(event) {
    if (this.isDragging) {
      event.preventDefault();
      return;
    }

    const taskContent = event.target.closest('[data-task-content]');
    if (!taskContent) return;

    const taskUrl = taskContent.dataset.taskUrl;
    if (taskUrl) {
      fetch(taskUrl, {
        method: 'GET',
        headers: {
          'Accept': 'text/vnd.turbo-stream.html',
          'X-CSRF-Token': this.getCSRFToken()
        }
      })
        .then(response => response.text())
        .then(html => {
          if (window.Turbo && window.Turbo.renderStreamMessage) {
            window.Turbo.renderStreamMessage(html);
          }
        })
        .catch(error => {
          console.error('Task 상세 페이지 로드 실패:', error);
        });
    }
  }

  // CSRF 토큰 가져오기
  getCSRFToken() {
    const token = document.querySelector('meta[name="csrf-token"]');
    return token ? token.getAttribute('content') : '';
  }

  // 다중 클래스 추가/제거 헬퍼 메서드
  addClasses(element, classes) {
    classes.forEach(cls => element.classList.add(cls));
  }

  removeClasses(element, classes) {
    classes.forEach(cls => element.classList.remove(cls));
  }
}
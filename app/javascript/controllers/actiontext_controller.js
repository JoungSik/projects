/*
 * 설계 원칙: ActionText와 Turbo 간 호환성 개선
 * - Turbo 탐색 후 ActionText 재초기화 보장
 * - 링크 다이얼로그 이벤트 핸들링 강화
 * - 사용자 경험 개선을 위한 추가 기능
 * 
 * 기술적 고려사항:
 * - Trix 에디터의 라이프사이클 관리
 * - 이벤트 리스너 적절한 해제
 * - 메모리 누수 방지
 * 
 * 사용 고려사항:
 * - 각 rich_text_area에 data-controller="actiontext" 추가 필요
 * - Turbo 프레임과의 상호작용 고려
 * - 접근성 기준 준수
 */

import { Controller } from "@hotwired/stimulus"

// ActionText 에디터와 관련된 기능을 담당하는 컨트롤러
export default class extends Controller {
  static targets = ["editor"]

  connect() {
    // 컨트롤러가 DOM에 연결될 때 실행
    this.initializeEditor()
    this.setupEventListeners()
  }

  disconnect() {
    // 컨트롤러가 DOM에서 분리될 때 실행 (메모리 누수 방지)
    this.cleanupEventListeners()
  }

  /**
   * Trix 에디터 초기화 및 설정
   */
  initializeEditor() {
    // Trix 에디터가 로드될 때까지 기다림
    this.waitForTrix().then(() => {
      this.configureEditor()
      this.enhanceLinkDialog()
    })
  }

  /**
   * Trix 라이브러리가 로드될 때까지 대기
   * @returns {Promise} Trix가 로드되면 resolve되는 Promise
   */
  waitForTrix() {
    return new Promise((resolve) => {
      if (window.Trix) {
        resolve()
      } else {
        // Trix가 아직 로드되지 않았다면 잠시 후 다시 확인
        setTimeout(() => this.waitForTrix().then(resolve), 100)
      }
    })
  }

  /**
   * Trix 에디터 기본 설정
   */
  configureEditor() {
    const editor = this.editorTarget
    if (!editor) return

    // 에디터 기본 설정
    editor.addEventListener("trix-initialize", this.onEditorInitialize.bind(this))
    editor.addEventListener("trix-selection-change", this.onSelectionChange.bind(this))
    editor.addEventListener("trix-change", this.onContentChange.bind(this))
  }

  /**
   * 링크 다이얼로그 기능 강화
   */
  enhanceLinkDialog() {
    // 링크 버튼 클릭 시 다이얼로그가 확실히 표시되도록 처리
    document.addEventListener("trix-action-invoke", this.onActionInvoke.bind(this))
  }

  /**
   * 이벤트 리스너 설정
   */
  setupEventListeners() {
    // Turbo 탐색 완료 후 ActionText 재초기화
    document.addEventListener("turbo:load", this.onTurboLoad.bind(this))
    document.addEventListener("turbo:frame-load", this.onTurboFrameLoad.bind(this))
  }

  /**
   * 이벤트 리스너 정리
   */
  cleanupEventListeners() {
    document.removeEventListener("turbo:load", this.onTurboLoad.bind(this))
    document.removeEventListener("turbo:frame-load", this.onTurboFrameLoad.bind(this))
    document.removeEventListener("trix-action-invoke", this.onActionInvoke.bind(this))
  }

  /**
   * 에디터 초기화 완료 시 실행
   */
  onEditorInitialize(event) {

    // 에디터 툴바 개선
    this.improveToolbar(event.target)
  }

  /**
   * 선택 영역 변경 시 실행
   */
  onSelectionChange(event) {
    // 선택된 텍스트가 있을 때 링크 버튼 활성화 상태 업데이트
    this.updateLinkButtonState(event.target)
  }

  /**
   * 콘텐츠 변경 시 실행
   */
  onContentChange(event) {
    // 자동 저장이나 유효성 검사 등을 여기서 수행할 수 있음
  }

  /**
   * Trix 액션 호출 시 실행 (링크 다이얼로그 등)
   */
  onActionInvoke(event) {
    if (event.actionName === "link") {

      // 다이얼로그가 생성된 후 스타일 조정
      setTimeout(() => {
        this.ensureDialogVisibility(event.target)
      }, 50)
    }
  }

  /**
   * Turbo 페이지 로드 완료 시 실행
   */
  onTurboLoad() {
    this.initializeEditor()
  }

  /**
   * Turbo 프레임 로드 완료 시 실행
   */
  onTurboFrameLoad() {
    this.initializeEditor()
  }

  /**
   * 툴바 개선 작업
   */
  improveToolbar(editor) {
    const toolbar = editor.toolbarElement
    if (!toolbar) return

    // 툴바에 접근성 개선
    this.improveAccessibility(toolbar)

    // 커스텀 클래스 추가
    toolbar.classList.add("enhanced-trix-toolbar")
  }

  /**
   * 링크 버튼 상태 업데이트
   */
  updateLinkButtonState(editor) {
    const linkButton = editor.toolbarElement?.querySelector(".trix-button--icon-link")
    if (!linkButton) return

    const selectedRange = editor.editor.getSelectedRange()
    const hasSelection = selectedRange && selectedRange[0] !== selectedRange[1]

    // 선택된 텍스트가 있을 때만 링크 버튼 활성화
    linkButton.disabled = !hasSelection
    linkButton.classList.toggle("has-selection", hasSelection)
  }

  /**
   * 다이얼로그 가시성 보장
   */
  ensureDialogVisibility(editor) {
    const toolbar = editor.toolbarElement
    const dialog = toolbar?.querySelector(".trix-dialog")

    if (dialog) {

      // Trix의 기본 동작을 존중하면서 필요한 스타일만 조정
      // display는 Trix가 관리하도록 두고, z-index와 위치만 보정
      if (getComputedStyle(dialog).display !== 'none') {
        dialog.style.zIndex = "1000"

        // 다이얼로그 위치 조정
        this.adjustDialogPosition(dialog, toolbar)

        // 첫 번째 입력 필드에 포커스
        const firstInput = dialog.querySelector("input")
        if (firstInput) {
          setTimeout(() => firstInput.focus(), 100)
        }
      }
    }
  }

  /**
   * 다이얼로그 위치 조정
   */
  adjustDialogPosition(dialog, toolbar) {
    const toolbarRect = toolbar.getBoundingClientRect()
    const dialogRect = dialog.getBoundingClientRect()
    const viewportWidth = window.innerWidth
    const viewportHeight = window.innerHeight

    // 화면 범위를 벗어나지 않도록 위치 조정
    if (toolbarRect.left + dialogRect.width > viewportWidth) {
      dialog.style.left = "auto"
      dialog.style.right = "0"
    }

    if (toolbarRect.bottom + dialogRect.height > viewportHeight) {
      dialog.style.top = "auto"
      dialog.style.bottom = "100%"
      dialog.style.marginBottom = "0.25rem"
      dialog.style.marginTop = "0"
    }
  }

  /**
   * 접근성 개선
   */
  improveAccessibility(toolbar) {
    const buttons = toolbar.querySelectorAll(".trix-button")

    buttons.forEach(button => {
      // ARIA 레이블 추가
      if (!button.getAttribute("aria-label")) {
        const title = button.getAttribute("title") || button.textContent
        if (title) {
          button.setAttribute("aria-label", title)
        }
      }

      // 키보드 탐색 개선
      button.setAttribute("tabindex", "0")
    })

    // 툴바에 role 속성 추가
    toolbar.setAttribute("role", "toolbar")
    toolbar.setAttribute("aria-label", "텍스트 편집 도구")
  }
}
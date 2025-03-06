# projects

간단함에 초점을 맞춘 프로젝트 관리 서비스입니다. GitHub, Slack과의 연동을 지원하여 보다 편리하고 직관적으로 프로젝트를 관리할 수 있습니다.

## 주요 기능

- 칸반 형식 프로젝트 및 작업 관리
- GitHub 연동을 통한 작업 트래킹
- 일정 기반 Slack 알림 전송

## 기술 스택

- Ruby 3.4.1
- Rails 8.0.1

## 설치 및 사용법

### 개발자 환경 세팅

Ruby 3.4.1과 Rails 8.0.1을 설치한 뒤 프로젝트를 클론하여 실행합니다.

```sh
git clone https://github.com/joungsik/projects.git
cd projects
bundle install
rails db:setup
rails server
```

### 사용자 환경 세팅

- 호스팅된 서비스 이용: [projects.joungsik.com](https://projects.joungsik.com)
- 셀프 호스팅: Docker 이미지를 사용하여 실행

```sh
docker pull joungsik/projects:latest
docker run -d -p 3000:3000 joungsik/projects:latest
```

## 기여 방법

프로젝트에 기여하거나 아이디어를 제안하고 싶다면 다음 방법으로 참여해주세요:

- 이메일로 아이디어 제안: [tjstlr2010@gmail.com](mailto:tjstlr2010@gmail.com)
- [GitHub Issues](https://github.com/joungsik/projects/issues) 또는 Pull Requests 제출

## 라이센스

이 프로젝트는 [MIT 라이센스](https://github.com/JoungSik/projects/blob/main/LICENSE)를 따릅니다.

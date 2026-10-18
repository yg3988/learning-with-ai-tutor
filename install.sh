#!/usr/bin/env bash
# ==============================================================================
# AI Study Workspace Scaffolder (macOS / Linux)
# 원격 실행: curl -fsSL https://raw.githubusercontent.com/yg3988/learning-with-ai-tutor/main/install.sh | bash
# ==============================================================================
set -e

# curl ... | bash 파이프 실행 시 표준 입력(stdin)을 사용자의 터미널(/dev/tty)로 연결하여
# read 입력 프롬프트가 건너뛰어지지 않고 키보드 입력을 정상적으로 받도록 보장
if [ ! -t 0 ] && [ -e /dev/tty ]; then
  exec < /dev/tty
fi

# 기본 설정 (GitHub 리포지토리 설정)
GITHUB_REPO="${AI_STUDY_REPO:-yg3988/learning-with-ai-tutor}"
GITHUB_BRANCH="${AI_STUDY_BRANCH:-main}"

echo "======================================================"
echo "  🌟 AI 자기주도 학습 워크스페이스 스캐폴더"
echo "  시스템 OS: $(uname -s) ($(uname -m))"
echo "======================================================"
echo ""

# 1. 프로젝트 이름 입력
PROJECT_NAME="${1}"
if [ -z "$PROJECT_NAME" ]; then
  read -p "📁 새 학습 프로젝트 이름을 입력하세요 (기본값: my-study): " PROJECT_NAME
fi
PROJECT_NAME=${PROJECT_NAME:-my-study}

if [ -d "$PROJECT_NAME" ]; then
  echo "⚠️ 경고: '$PROJECT_NAME' 폴더가 이미 존재합니다. 다른 이름을 사용해주세요."
  exit 1
fi

# 2. 사용할 AI 에이전트 선택
AGENT_CHOICE="${2}"
if [ -z "$AGENT_CHOICE" ]; then
  echo ""
  echo "🤖 주로 사용할 AI 에이전트를 선택하세요:"
  echo "  1) Antigravity CLI        (-> AGENTS.md 생성)"
  echo "  2) Claude Code            (-> CLAUDE.md 생성)"
  echo "  3) Cursor IDE             (-> .cursorrules 생성)"
  echo "  4) 모든 에이전트 호환     (-> All-in-One 전체 브릿지 생성)"
  read -p "선택 (1-4, 기본값: 1): " AGENT_CHOICE
fi
AGENT_CHOICE=${AGENT_CHOICE:-1}

echo ""
echo "📦 '$PROJECT_NAME' 워크스페이스를 구성하는 중..."
mkdir -p "$PROJECT_NAME"

# 3. 소스 가져오기 (Git 최신 커밋 직접 복제 - 압축 도구 의존성 0%)
echo "⬇️ GitHub ($GITHUB_REPO@$GITHUB_BRANCH)에서 최신 학습 엔진을 복제하는 중..."
CLONE_URL="https://github.com/$GITHUB_REPO.git"
TEMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/temp-XXXXXX" 2>/dev/null || mktemp -d)"

if ! git clone --depth 1 -b "$GITHUB_BRANCH" "$CLONE_URL" "$TEMP_DIR" -q; then
  echo ""
  echo "❌ GitHub에서 엔진을 가져오지 못했습니다!"
  echo "   시도한 저장소: $CLONE_URL (브랜치: $GITHUB_BRANCH)"
  echo "   1. 저장소가 Public(공개) 상태인지 확인하세요."
  echo "   2. 저장소 이름($GITHUB_REPO)과 브랜치($GITHUB_BRANCH)가 정확한지 확인하세요."
  rm -rf "$PROJECT_NAME" "$TEMP_DIR"
  exit 1
fi

if [ -d "$TEMP_DIR/engine" ]; then
  cp -r "$TEMP_DIR/engine/." "$PROJECT_NAME/"
else
  cp -r "$TEMP_DIR/." "$PROJECT_NAME/"
  rm -rf "$PROJECT_NAME/.git"
fi
rm -rf "$TEMP_DIR"

# 4. 대상 폴더로 이동하여 에이전트별 컨텍스트 조립 및 배치 (DRY: Header + Core Pipeline)
cd "$PROJECT_NAME"

build_agent_context() {
  local header_file="$1"
  local out_file="$2"
  { cat "contexts/$header_file"; echo ""; cat "contexts/core-pipeline.md"; } > "$out_file"
}

install_cursor_rules() {
  if [ -d "contexts/cursor-rules" ]; then
    mkdir -p .cursor/rules
    cp -r contexts/cursor-rules/* .cursor/rules/
  fi
}

case "$AGENT_CHOICE" in
  1)
    echo "⚙️ Antigravity CLI 맞춤 컨텍스트(AGENTS.md) 구성 완료"
    build_agent_context "antigravity.md" "AGENTS.md"
    ;;
  2)
    echo "⚙️ Claude Code 맞춤 컨텍스트(CLAUDE.md) 구성 완료"
    build_agent_context "claude.md" "CLAUDE.md"
    ;;
  3)
    echo "⚙️ Cursor 맞춤 컨텍스트(.cursorrules 및 .cursor/rules/*.mdc) 구성 완료"
    build_agent_context "cursor.md" ".cursorrules"
    install_cursor_rules
    ;;
  4)
    echo "⚙️ 모든 에이전트 호환 브릿지 파일 전체 구성 완료"
    build_agent_context "antigravity.md" "AGENTS.md"
    build_agent_context "claude.md" "CLAUDE.md"
    build_agent_context "cursor.md" ".cursorrules"
    build_agent_context "antigravity.md" "GEMINI.md"
    install_cursor_rules
    ;;
  *)
    echo "⚙️ 기본 설정: Antigravity CLI (AGENTS.md) 구성"
    build_agent_context "antigravity.md" "AGENTS.md"
    ;;
esac

# 임시 contexts 템플릿 폴더 제거 (루트 정리)
rm -rf contexts

# 5. Git 초기화 및 LF 줄바꿈 강제
if [ ! -f ".gitattributes" ]; then
  echo "* text=auto eol=lf" > .gitattributes
fi

git init -q
git add .
git commit -qm "feat: initialize ai study workspace engine"

echo ""
echo "======================================================"
echo "🎉 '$PROJECT_NAME' 학습 환경 준비가 완료되었습니다!"
echo "======================================================"
echo ""
echo "👉 학습 시작 방법:"
echo "   cd $PROJECT_NAME"
echo ""
case "$AGENT_CHOICE" in
  1) echo "   antigravity 를 실행한 후 '학습 시작하고 싶어'라고 말씀하세요." ;;
  2) echo "   claude 를 실행한 후 '학습 시작하고 싶어'라고 말씀하세요." ;;
  3) echo "   cursor . 로 에디터를 열고 AI 채팅에 '학습 시작하고 싶어'라고 말씀하세요." ;;
  *) echo "   선호하는 AI 에이전트를 열고 '학습 시작하고 싶어'라고 말씀하세요." ;;
esac
echo "   (에이전트가 새 주제 인터뷰를 진행하여 커리큘럼을 맞춤 생성해 줍니다!)"
echo ""

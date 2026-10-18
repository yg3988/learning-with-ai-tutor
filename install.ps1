# ==============================================================================
# AI Study Workspace Scaffolder (Windows PowerShell)
# 원격 실행: irm https://raw.githubusercontent.com/yg3988/learning-with-ai-tutor/main/install.ps1 | iex
# ==============================================================================
param(
    [string]$ProjectName = "",
    [string]$AgentChoice = "",
    [string]$GithubRepo = ""
)

$ErrorActionPreference = "Stop"

# 기본 설정 (GitHub 리포지토리 설정)
if ([string]::IsNullOrWhiteSpace($GithubRepo)) {
    $GithubRepo = if ($env:AI_STUDY_REPO) { $env:AI_STUDY_REPO } else { "yg3988/learning-with-ai-tutor" }
}
$GithubBranch = if ($env:AI_STUDY_BRANCH) { $env:AI_STUDY_BRANCH } else { "main" }

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  🌟 AI 자기주도 학습 워크스페이스 스캐폴더" -ForegroundColor Cyan
Write-Host "  시스템 OS: Windows ($([System.Environment]::OSVersion.VersionString))" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# 1. 프로젝트 이름 입력
if ([string]::IsNullOrWhiteSpace($ProjectName)) {
    $ProjectName = Read-Host "📁 새 학습 프로젝트 이름을 입력하세요 (기본값: my-study)"
}
if ([string]::IsNullOrWhiteSpace($ProjectName)) { $ProjectName = "my-study" }

if (Test-Path $ProjectName) {
    Write-Host "⚠️ 경고: '$ProjectName' 폴더가 이미 존재합니다. 다른 이름을 사용해주세요." -ForegroundColor Red
    exit 1
}

# 2. 사용할 AI 에이전트 선택
if ([string]::IsNullOrWhiteSpace($AgentChoice)) {
    Write-Host ""
    Write-Host "🤖 주로 사용할 AI 에이전트를 선택하세요:" -ForegroundColor Yellow
    Write-Host "  1) Antigravity CLI        (-> AGENTS.md 생성)"
    Write-Host "  2) Claude Code            (-> CLAUDE.md 생성)"
    Write-Host "  3) Cursor IDE             (-> .cursorrules 생성)"
    Write-Host "  4) 모든 에이전트 호환     (-> All-in-One 전체 브릿지 생성)"
    $AgentChoice = Read-Host "선택 (1-4, 기본값: 1)"
}
if ([string]::IsNullOrWhiteSpace($AgentChoice)) { $AgentChoice = "1" }

Write-Host ""
Write-Host "📦 '$ProjectName' 워크스페이스를 구성하는 중..." -ForegroundColor Green
New-Item -ItemType Directory -Force -Path $ProjectName | Out-Null

# 3. 소스 가져오기 (Git 최신 커밋 직접 복제 - 압축 도구 의존성 0%)
Write-Host "⬇️ GitHub ($GithubRepo@$GithubBranch)에서 최신 학습 엔진을 복제하는 중..." -ForegroundColor Gray
$CloneUrl = "https://github.com/$GithubRepo.git"
$TempClone = Join-Path $env:TEMP "temp-$([System.Guid]::NewGuid())"

try {
    git clone --depth 1 -b $GithubBranch $CloneUrl $TempClone -q
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path $TempClone)) {
        throw "git clone 실패 (저장소 또는 브랜치 확인 필요)"
    }
    
    $EnginePath = Join-Path $TempClone "engine"
    if (Test-Path $EnginePath) {
        Copy-Item -Recurse -Force "$EnginePath\*" "$ProjectName\"
    } else {
        Copy-Item -Recurse -Force "$TempClone\*" "$ProjectName\"
        if (Test-Path "$ProjectName\.git") {
            Remove-Item -Recurse -Force "$ProjectName\.git" -ErrorAction SilentlyContinue
        }
    }
} catch {
    Write-Host ""
    Write-Host "❌ GitHub에서 엔진을 가져오지 못했습니다!" -ForegroundColor Red
    Write-Host "   시도한 저장소: $CloneUrl (브랜치: $GithubBranch)" -ForegroundColor DarkRed
    Write-Host "   오류 내용: $($_.Exception.Message)" -ForegroundColor DarkRed
    Write-Host ""
    Write-Host "🔍 확인 사항:" -ForegroundColor Yellow
    Write-Host "   1. 저장소가 'Public(공개)' 상태인지 확인하세요."
    Write-Host "   2. 저장소 이름($GithubRepo)과 기본 브랜치($GithubBranch)가 정확한지 확인하세요."
    
    # 롤백 정리
    if (Test-Path $ProjectName) { Remove-Item -Recurse -Force $ProjectName -ErrorAction SilentlyContinue }
    exit 1
} finally {
    if (Test-Path $TempClone) { Remove-Item -Recurse -Force $TempClone -ErrorAction SilentlyContinue }
}

# 4. 대상 폴더로 이동하여 에이전트별 컨텍스트 조립 및 배치 (DRY: Header + Core Pipeline)
$TargetDir = Resolve-Path $ProjectName
$Utf8NoBom = [Text.UTF8Encoding]::new($false)

function Build-AgentContext([string]$HeaderFile, [string]$OutFile) {
    $Header = [IO.File]::ReadAllText("$TargetDir\contexts\$HeaderFile", $Utf8NoBom).TrimEnd()
    $Core   = [IO.File]::ReadAllText("$TargetDir\contexts\core-pipeline.md", $Utf8NoBom).TrimStart()
    [IO.File]::WriteAllText("$TargetDir\$OutFile", "$Header`n`n$Core", $Utf8NoBom)
}

function Install-CursorRules() {
    if (Test-Path "$TargetDir\contexts\cursor-rules") {
        New-Item -ItemType Directory -Force -Path "$TargetDir\.cursor\rules" | Out-Null
        Copy-Item "$TargetDir\contexts\cursor-rules\*" "$TargetDir\.cursor\rules\" -Force
    }
}

switch ($AgentChoice) {
    "1" {
        Write-Host "⚙️ Antigravity CLI 맞춤 컨텍스트(AGENTS.md) 구성 완료" -ForegroundColor Green
        Build-AgentContext "antigravity.md" "AGENTS.md"
    }
    "2" {
        Write-Host "⚙️ Claude Code 맞춤 컨텍스트(CLAUDE.md) 구성 완료" -ForegroundColor Green
        Build-AgentContext "claude.md" "CLAUDE.md"
    }
    "3" {
        Write-Host "⚙️ Cursor 맞춤 컨텍스트(.cursorrules 및 .cursor/rules/*.mdc) 구성 완료" -ForegroundColor Green
        Build-AgentContext "cursor.md" ".cursorrules"
        Install-CursorRules
    }
    "4" {
        Write-Host "⚙️ 모든 에이전트 호환 브릿지 파일 전체 구성 완료" -ForegroundColor Green
        Build-AgentContext "antigravity.md" "AGENTS.md"
        Build-AgentContext "claude.md" "CLAUDE.md"
        Build-AgentContext "cursor.md" ".cursorrules"
        Build-AgentContext "antigravity.md" "GEMINI.md"
        Install-CursorRules
    }
    Default {
        Write-Host "⚙️ 기본 설정: Antigravity CLI (AGENTS.md) 구성" -ForegroundColor Green
        Build-AgentContext "antigravity.md" "AGENTS.md"
    }
}

# 임시 contexts 템플릿 폴더 제거 (루트 정리)
if (Test-Path "$TargetDir\contexts") {
    Remove-Item -Recurse -Force "$TargetDir\contexts"
}

# 5. Git 초기화 및 LF 줄바꿈 강제
Push-Location $TargetDir
try {
    if (-not (Test-Path ".gitattributes")) {
        [IO.File]::WriteAllText(".gitattributes", "* text=auto eol=lf`n", [Text.UTF8Encoding]::new($false))
    }
    git init -q
    git add .
    git commit -qm "feat: initialize ai study workspace engine"
} finally {
    Pop-Location
}

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "🎉 '$ProjectName' 학습 환경 준비가 완료되었습니다!" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "👉 학습 시작 방법:" -ForegroundColor Yellow
Write-Host "   cd $ProjectName"
Write-Host ""
switch ($AgentChoice) {
    "1" { Write-Host "   antigravity 를 실행한 후 '학습 시작하고 싶어'라고 말씀하세요." }
    "2" { Write-Host "   claude 를 실행한 후 '학습 시작하고 싶어'라고 말씀하세요." }
    "3" { Write-Host "   cursor . 로 에디터를 열고 AI 채팅에 '학습 시작하고 싶어'라고 말씀하세요." }
    Default { Write-Host "   선호하는 AI 에이전트를 열고 '학습 시작하고 싶어'라고 말씀하세요." }
}
Write-Host "   (에이전트가 새 주제 인터뷰를 진행하여 커리큘럼을 맞춤 생성해 줍니다!)" -ForegroundColor Gray
Write-Host ""

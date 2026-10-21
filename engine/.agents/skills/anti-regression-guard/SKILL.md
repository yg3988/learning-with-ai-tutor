---
name: anti-regression-guard
description: >-
  Prevents conceptual regressions, repeated technical errors, and context-compaction drift
  by enforcing the rules and shared code contracts in CORRECTIONS.md before explanations,
  code snippets, or sandbox examples are output. Use before finalizing any lecture,
  regular sandbox, review sandbox, or capstone assembly code, or when recording a new
  correction or step contract.
---

# Anti-Regression Guard

## 목적
학습 세션 중 과거에 확정된 프로젝트 결정, 정정된 오개념(금지 라이브러리, 포트 혼동 등), 그리고 **스텝 진행에 따라 누적 확정된 코드·아키텍처 규약** (`Shared Contract`: 도메인 모델/DTO 시그니처, 패키지 구조, 포트 매핑, 공통 설정 등)이 **대화 컨텍스트 압축(Compaction)** 이후에도 절대 변질되거나 재발하지 않도록 출력 직전에 대조하고 강제합니다.

> [!IMPORTANT]
> 규칙 및 공유 코드 규약의 **유일한 출처는 디스크의 `CORRECTIONS.md`**입니다. 대화 요약본(메모리)에 의존하지 말고 반드시 디스크의 `CORRECTIONS.md`를 직접 읽어야 합니다.

## 절차

### Step 1: 제약 및 공유 코드 규약 적재 (디스크 강제 Read)
- 강의 설명이나 실습/복습/조립 코드 생성 전 반드시 `CORRECTIONS.md`를 디스크에서 다시 읽어 아래 3대 섹션의 모든 항목을 적재합니다:
  1. `## 프로젝트 결정` (`[규칙 N]`)
  2. `## 오개념 정정` (`[규칙 N]`)
  3. `## 누적 코드 & 아키텍처 규약 (Shared Contract)` (현재 상태 표)
- 세 섹션 모두 동일하게 **최우선 불변식**으로 취급합니다.

### Step 2: 출력 및 코드 생성 전 감사 (Compaction Drift 차단)
- 답변 초안과 생성할 샌드박스 코드(`labs/step_{N}_{slug}/`, `labs/review_*/step_{K}_{slug}/`, `labs/project/`)를 각 규칙 및 누적 코드 규약과 대조합니다.
  - 금지 패턴(예: 규칙이 금지한 라이브러리 호출, 잘못된 포트 매핑) 또는 이전 오개념 서술이 있는지 확인합니다.
  - **스텝 간 규약 일관성**: 이전 스텝에서 확정된 엔티티/DTO/이벤트 명칭, 패키지/모듈 경로, 포트 번호, 환경 변수명, API 경로가 임의 추론(환각)으로 바뀌지 않았는지 확인합니다.
  - 위반이나 표류(Drift)가 발견되면 출력 전에 `CORRECTIONS.md`에 맞도록 문장과 코드를 즉시 교정합니다.

### Step 3: 신규 정정 규칙 등록 (사용자가 정정을 언급한 경우)
1. 성격을 판단합니다.
   - 사실 관계의 오류 수정 → `## 오개념 정정`
   - 프로젝트의 기술 선택·구조 결정 → `## 프로젝트 결정`
2. 해당 섹션 끝에 추가합니다. 번호 `N`은 **두 섹션 통틀어** 기존 최대 번호 + 1입니다.

   ```markdown
   - [규칙 {N}] ({YYYY-MM-DD}) {정정된 사실 또는 결정} / 금지 패턴: {재발하면 안 되는 서술·코드}
   ```

3. `progress.json`의 `corrections_count`를 1 증가시키고 `last_synced`를 갱신합니다.
4. 사용자에게 보고합니다: "알려주신 정정 사항을 [규칙 N]으로 CORRECTIONS.md에 등록하여 향후 강의 및 실습 코드에서 재발을 방지하겠습니다."

### Step 4: 누적 코드 & 아키텍처 규약 갱신 (각 정규 스텝 샌드박스 생성/완료 시)
- `## 누적 코드 & 아키텍처 규약 (Shared Contract)`은 스텝별 기록을 덧붙이는 로그가 아니라 **현재 유효한 규약만 담는 현재 상태 원장**입니다. 스텝이 늘어도 크기가 선형으로 커지지 않도록 유지합니다.
- 각 정규 Step `M`의 샌드박스(`labs/step_{M}_{slug}/`)를 생성하거나 스텝을 완료할 때, 확정된 패키지·모듈 경로, 핵심 모델·인터페이스 시그니처, 포트, 환경 변수, API 경로를 해당 표에 **병합**합니다:
  - **새 항목**: 표에 행을 추가하고 `도입 Step`과 `최종 변경 Step`을 `M`으로 기록합니다.
  - **기존 항목 변경**: 기존 행을 **덮어쓰고** `최종 변경 Step`만 `M`으로 갱신합니다. 이전 값은 이 섹션에 남기지 않습니다.
  - **폐기된 항목**: 행을 삭제합니다.
- 변경·폐기 이력과 그 이유는 해당 스텝의 `knowledge/step_{M}_{slug}/04_qa_archive.md` 또는 `02_foundations_*.md`의 ADR에 기록하고, 세부 이력은 git 기록에 맡깁니다.
- 기존 규약을 바꾸는 것은 학습 흐름상 의도된 경우에만 허용하며, 강의 본문에서 "Step {M}에서 `{항목}`이 `{이전}`에서 `{현재}`로 바뀌었다"고 명시적으로 안내합니다.

  ```markdown
  | 이름 | 시그니처 요약 | 위치 | 도입 Step | 최종 변경 Step |
  | :-- | :-- | :-- | :-- | :-- |
  | `OrderCreatedEvent` | `orderId: UUID, amount: Money` | `order/domain/event` | 2 | 4 |
  ```

## 검증
- 등록 후 `CORRECTIONS.md`의 규칙 번호가 중복되지 않는지 확인합니다.
- `progress.json`의 `corrections_count`가 `(사전 정의)` 표시가 없는 규칙의 개수와 일치하는지 확인합니다.
- `## 누적 코드 & 아키텍처 규약`의 각 표에 같은 이름의 행이 두 번 이상 존재하지 않는지 확인합니다.
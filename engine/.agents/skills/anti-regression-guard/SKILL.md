---
name: anti-regression-guard
description: >-
  Prevents conceptual regressions and repeated technical errors by enforcing the rules in
  CORRECTIONS.md before explanations, code snippets, or configuration examples are output.
  Use before finalizing any lecture content, or when the user provides a new correction.
---

# Anti-Regression Guard

## 목적
학습 세션 중 과거에 확정된 프로젝트 결정이나 정정된 오개념(금지 라이브러리, 포트 혼동 등)이 재발하지 않도록, 출력 직전에 네거티브 제약을 대조하고 강제합니다.

> [!IMPORTANT]
> 규칙의 **유일한 출처는 `CORRECTIONS.md`**입니다. 이 스킬 파일에 규칙 내용을 복사하지 마십시오.

## 절차

### Step 1: 제약 적재
- 출력문 생성 전 `CORRECTIONS.md`를 읽어 `## 프로젝트 결정`과 `## 오개념 정정`의 모든 `[규칙 N]`을 적재합니다.
- 두 섹션 모두 동일하게 불변식으로 취급합니다.

### Step 2: 출력 전 감사
- 답변 초안과 코드 블록을 각 규칙과 대조합니다.
  - 금지 패턴(예: 규칙이 금지한 라이브러리 호출, 잘못된 포트 매핑) 또는 이전 오개념 서술이 있는지 확인합니다.
  - 위반이 있으면 출력 전에 규칙에 맞도록 문장과 코드를 재작성합니다.

### Step 3: 신규 규칙 등록 (사용자가 정정을 언급한 경우)
1. 성격을 판단합니다.
   - 사실 관계의 오류 수정 → `## 오개념 정정`
   - 프로젝트의 기술 선택·구조 결정 → `## 프로젝트 결정`
2. 해당 섹션 끝에 추가합니다. 번호 `N`은 **두 섹션 통틀어** 기존 최대 번호 + 1입니다.

   ```markdown
   - [규칙 {N}] ({YYYY-MM-DD}) {정정된 사실 또는 결정} / 금지 패턴: {재발하면 안 되는 서술·코드}
   ```

3. `progress.json`의 `corrections_count`를 1 증가시키고 `last_synced`를 갱신합니다.
4. 사용자에게 보고합니다: "알려주신 정정 사항을 [규칙 N]으로 CORRECTIONS.md에 등록하여 향후 강의에서 재발을 방지하겠습니다."

## 검증
- 등록 후 `CORRECTIONS.md`의 규칙 번호가 중복되지 않는지 확인합니다.
- `progress.json`의 `corrections_count`가 `(사전 정의)` 표시가 없는 규칙의 개수와 일치하는지 확인합니다.
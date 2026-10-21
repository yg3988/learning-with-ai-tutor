---
name: step-lecture-runner
description: >-
  Executes the regular curriculum step loop (Stages 1 to 5: Session Resume & Compaction
  Warm-up, Mandatory Disk Re-hydration & Quality Gate verification, Guided Sandbox
  creation at labs/step_{N}_{slug}/ with Shared Contract merge, 4-tier Knowledge
  Archiving, Q&A archiving, and step transition) and enforces the standard lecture
  Output Format. Use when CURRICULUM.md exists and progress.json status is READY_TO_START
  or IN_PROGRESS.
---

# Step Lecture & Sandbox Runner (정규 스텝 1~5단계 실행기)

당신은 정규 커리큘럼(`1 ~ total_steps`)의 각 스텝을 진행하는 메인 멘토입니다.
`CURRICULUM.md`가 존재하고 `progress.json`의 `status`가 `"READY_TO_START"` 또는 `"IN_PROGRESS"`일 때 이 스킬의 1~5단계 절차와 출력 형식을 엄격히 수행합니다.

---

## 1단계: 스텝 개시, 세션 재개(Resume) 워밍업 및 리서치

1. `progress.json`을 읽어 `current_step`, `status`, `completed_steps`를 확인합니다.
   - `status`가 `COMPLETED`이면 강의를 시작하지 않고 `NEXT_CURRICULUM.md` 안내로 전환합니다.
   - `status`가 `REVIEW_PHASE` 또는 `CAPSTONE_ASSEMBLY`이면 즉시 `.agents/skills/mastery-review-coach/SKILL.md`로 전환합니다.
   - **세션 재개 및 대화 압축 후 복습 프로토콜** (Resume & Compaction Warm-up): 이전 학습 이력(`completed_steps`가 존재하거나 `status == "IN_PROGRESS"`)이 있는 상태에서 새로운 대화 세션이 시작되거나 대화 압축(Compaction)이 발생한 경우, 본 강의나 코드 생성에 들어가기 전에 반드시 디스크에서 `CORRECTIONS.md` (`## 누적 코드 & 아키텍처 규약` 포함)와 직전 완료 스텝의 문서를 다시 읽고, 직전 스텝의 `핵심 체득 지식 (Key Competencies)`, 현재 활성화된 `CORRECTIONS.md` 핵심 불변식 및 코드 규약, 누적된 `user_interests`를 **3~5줄로 간결하게 브리핑** (Context Warm-up)하여 학습 맥락을 복원합니다.
   - `status`가 `READY_TO_START`이면 `IN_PROGRESS`로 바꾸어 저장합니다.
2. `research/step_{current_step}_research.md` 파일 존재 여부 확인:
   - 없으면 `.agents/skills/step-researcher/SKILL.md` 스킬을 실행하여 공식 문서 및 RFC 조사 보고서를 작성하고, 있으면 준비를 진행합니다.

---

## 2단계: 디스크 원본 재로드(Re-hydration) 및 강의·샌드박스 사전 검증

1. **디스크 원본 강제 재로드** (대화 압축 오염 방지):
   - 강의 초안과 샌드박스 코드를 설계하기 직전에 대화 기억에만 의존하지 말고 반드시 디스크에서 아래 파일들을 직접 다시 읽습니다:
     - `CURRICULUM.md` (`## 학습자 프로필`, `## 확정 기술 스택 및 버전 매트릭스`, 현재 Step 블록)
     - `CORRECTIONS.md` (`## 프로젝트 결정`, `## 오개념 정정`, `## 누적 코드 & 아키텍처 규약 (Shared Contract)`)
     - `research/step_{current_step}_research.md`
     - (`current_step > 1`인 경우) 직전 스텝의 `labs/step_{current_step-1}_{slug}/` **핵심 설정·모델 파일** (도메인 모델명, 패키지 구조, 포트 번호의 연속성 확보)
2. **강의 및 샌드박스 초안 수립**:
   - `CURRICULUM.md`의 `## 학습자 프로필` (학습 목적, 주당 학습 시간)에 맞춰 설명 깊이와 실습 크기를 조절합니다.
   - 사용자에게 설명할 강의 계획, **Mermaid 아키텍처/시퀀스 다이어그램**, **ADR** (대안 기술 비교 및 선택 근거), 그리고 `labs/step_{current_step}_{slug}/`에 생성할 **독립 실행 가능한 완성형 샌드박스 코드 및 실행 가이드** (`README.md`) 초안을 수립합니다.
3. **품질 게이트 감사 (`lecture-verifier`)**:
   - `.agents/skills/lecture-verifier/SKILL.md` 스킬을 실행하여 강의 초안과 샌드박스 코드를 통합 검증합니다 (`CURRICULUM.md` 확정 버전 매트릭스, `CORRECTIONS.md` 불변식 및 Shared Contract, `research/step_{current_step}_research.md` 공식 레퍼런스 대조).
   - 결함 발견 시 최대 2회까지 자동 수정 루프를 수행하여 최종 `VERIFIED (PASS)` 판정을 획득하고 `research/step_{current_step}_verification.md`를 저장합니다.

---

## 3단계: 가이드형 샌드박스 생성, 공유 코드 규약 병합 및 정제 강의 즉시 제공 (순서 전진 ⚡)

2단계 검증이 통과(`VERIFIED`)되면 다음 순서로 실행합니다:

1. **가이드형 샌드박스 생성**:
   - `labs/step_{current_step}_{slug}/` 디렉터리에 **즉시 실행 가능한 완성형 실습 코드, 설정 파일, 그리고 devcontainer 내부 기준 실행/실험 방법이 적힌 가이드 문서** (`README.md`)를 생성하고, `progress.json`의 `lab_modules`에 경로를 등록합니다.
2. **공유 코드 규약 (`Shared Contract`) 현재 상태 병합**:
   - `.agents/skills/anti-regression-guard/SKILL.md`의 Step 4에 따라, 방금 생성된 Step `{current_step}` 샌드박스에서 확정된 **패키지/모듈 경로, 핵심 도메인 모델/인터페이스 시그니처, 포트/엔드포인트 설정**을 `CORRECTIONS.md`의 `## 누적 코드 & 아키텍처 규약 (Shared Contract)` 표에 현재 상태로 병합합니다 (새 항목은 추가, 바뀐 항목은 덮어쓰기, 폐기 항목은 삭제).
3. **정제 강의 출력**:
   - 아래 **[정규 강의 출력 형식]**을 엄수하여 사용자에게 정제 강의를 출력합니다.

---

## 4단계: 주제별 분할 지식 아카이빙 (100% 필수 생성)

- 에이전트 런타임 방식(백그라운드 서브에이전트 위임 또는 직접 수행)에 따라 `.agents/agents/modular-knowledge-investigator/agent.md`의 **Task 1** 절차를 실행하여 `knowledge/step_{current_step}_{slug}/` **분할 문서 3종(`01_prerequisites`, `02_foundations`, `03_deep_dive`) 작성 및 `knowledge/index.md` 마스터 색인 등록을 100% 수행**합니다 (ADR, Mermaid 다이어그램, `labs/` 코드 연동 해설, Production Readiness 운영 체크리스트 포함).
- 생성된 파일 경로 및 심화 키워드를 `progress.json` (`knowledge_modules`, `deep_dive_queue`)에 병합합니다 (`progress.json`은 메인 에이전트만 수정).

---

## 4-B단계: 스텝 내 질의응답 및 샌드박스 실험 영구 아카이빙 (휘발 방지)

- 사용자가 다음 단계로 넘어가지 않고 해당 스텝에서 추가 질문, 개념 질문, `labs/` 샌드박스 변형 실험, 에러 트러블슈팅, 코드 설명을 요청하는 경우:
  1. 상세히 답변함과 동시에 해당 문답을 `knowledge/step_{current_step}_{slug}/04_qa_archive.md`에 구조화(질문, 답변, 핵심 통찰, 관련 키워드)하여 영구 보관(append)하고 `knowledge/index.md`에 링크를 갱신합니다 (`.agents/agents/modular-knowledge-investigator/agent.md`의 **Task 1-B**).
  2. 질문에서 파악된 관심사와 `04_qa_archive.md` 경로를 `progress.json`의 `user_interests` 및 `knowledge_modules`에 실시간 추가합니다.

---

## 5단계: 스텝 종료 및 전이

사용자가 "다음 단계로 가자", "계속해줘" 등으로 진행을 승인하면:
1. 분할 지식 문서(`01~03`), 질의응답 아카이빙(`04_qa_archive.md`), 그리고 `CORRECTIONS.md`의 `## 누적 코드 & 아키텍처 규약 (Shared Contract)` 병합 완료 여부를 확인하고 `progress.json`에 최종 반영합니다.
2. `completed_steps` 배열에 현재 단계를 기록합니다.
3. **상태 전이**:
   - `current_step < total_steps`: `current_step`을 1 증가시키고 `progress.json` 저장 후 다음 스텝 1단계를 실행합니다 (필요 시 새 세션 또는 `/compact` 체크포인트 안내 병기).
   - `current_step == total_steps`: `status`를 `"REVIEW_PHASE"`로 변경하여 저장하고, 즉시 `.agents/skills/mastery-review-coach/SKILL.md`를 읽어 **6단계** (선택형 스텝별 실전 마스터리 복습 트랙)로 진입합니다.

---

## 정규 강의 출력 형식 (Output Format)

- **최상단 헤더**:
  `[진도: {current_step}단계 / 전체 {total_steps}단계 | 모드: 가이드형 샌드박스 | 상태: {status} | 사전 검증: 통과(VERIFIED) | 정정 규칙: {corrections_count}건 | 관심사: {user_interests 길이}건]`
- **본문 구조**:
  1. 【 핵심 개요 및 ADR (기술 선택 근거) 】
  2. 【 아키텍처 및 동작 흐름 (Mermaid 다이어그램) 】
  3. 【 사전 검증 완료 상세 영역 (표준 설정·코드·운영 주의점) 】
  4. 【 가이드형 샌드박스 실습 안내 (`./labs/step_{current_step}_{slug}/`) 】 (생성된 파일 구성 및 devcontainer 터미널 실행/실험 명령어 안내)
  5. 【 주제별 지식 모듈 안내 (`./knowledge/step_{current_step}_{slug}/`) 】 (아래 5대 상대 경로 링크 필수 포함)
     - 🛠️ [가이드형 샌드박스 실습 폴더](./labs/step_{current_step}_{slug}/) (완성형 실행 코드 & 가이드)
     - 📘 [선행 기반 지식](./knowledge/step_{current_step}_{slug}/01_prerequisites_*.md)
     - ⚙️ [핵심 실무 지식](./knowledge/step_{current_step}_{slug}/02_foundations_*.md)
     - 🚀 [확장 심화 지식](./knowledge/step_{current_step}_{slug}/03_deep_dive_*.md)
     - 💬 [학습 질답 기록](./knowledge/step_{current_step}_{slug}/04_qa_archive.md) (질문/실험 발생 시 실시간 누적)
  6. 【 다음 단계 연결 다리 (Bridge) 】
- **맺음말**:
  - (`current_step < total_steps`일 때): "생성된 `./labs/step_{current_step}_{slug}/` 샌드박스를 직접 실행해 보시거나 궁금한 점을 질문해 주세요! 바로 다음 단계인 [{다음 단계 번호}단계: {다음 단계 제목}]로 넘어가시려면 말씀해 주세요. (Step {current_step}의 기록은 모두 디스크에 저장되므로 언제든 `/compact` 또는 새 세션에서 이어서 진행하실 수 있습니다.)"
  - (`current_step == total_steps`일 때): "정규 커리큘럼의 마지막 단계입니다! `./labs/step_{current_step}_{slug}/` 실습과 질의응답을 마치고 '다음 단계로 가자'고 말씀해 주시면, 배운 내용을 완전히 내 것으로 만드는 **선택형 스텝별 실전 복습 트랙** (페어 구현 / 트러블슈팅) 및 **단일 프로젝트 점진적 조립** 선택 안내로 이어집니다."

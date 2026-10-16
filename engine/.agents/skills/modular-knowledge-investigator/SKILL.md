---
name: modular-knowledge-investigator
description: >-
  Investigates and archives prerequisite knowledge, core foundations, deep-dive
  topics, and user Q&A interactions into separate modular files under knowledge/step_{N}_{slug}/,
  updates the master index at knowledge/index.md, and designs the next personalized roadmap
  at NEXT_CURRICULUM.md upon curriculum completion. Use when a verified step's knowledge
  needs modularization, when archiving learner Q&As, or when curriculum is completed.
---

# Modular Knowledge Investigator

당신은 지식 구조화 및 모듈형 문서화 전문 에이전트입니다.
검증을 통과한 강의 내용과 리서치 자료를 기반으로, 학습자가 알아야 할 **선행 기반 지식**, **핵심 실무 지식**, **추가 학습 심화 내용**을 심층 조사하여 **주제별 분할 파일**로 저장하고, 스텝 진행 중 발생하는 **학습자 질의응답(Q&A)을 영구 보관**하여 마스터 색인에 연결합니다.

---

## 4대 지식 계층 및 파일 분할 기준

지식은 단일 파일에 합치지 않고, 아래와 같이 스텝별 전용 디렉터리(`knowledge/step_{N}_{slug}/`) 아래에 **주제별 독립 파일**로 분할 생성합니다.

| 계층 | 파일 명명 규칙 | 다루는 내용 및 깊이 |
| :-- | :-- | :-- |
| **Tier 1. 선행 기반 지식** | `01_prerequisites_{주제}.md` | OS/네트워크/메모리 모델, 데이터 구조, 언어 타입 시스템, 기본 프로토콜 등 본 단계를 이해하기 위한 필수 CS·기초 이론 |
| **Tier 2. 핵심 실무 지식** | `02_foundations_{주제}.md` | 핵심 표준 명세, **ADR (대안 비교 및 기술 선택 근거)**, **Mermaid 동작 다이어그램**, 공식 CLI/프레임워크 설정 및 실무 표준 코드 |
| **Tier 3. 확장 심화 내용** | `03_deep_dive_{주제}.md` | 대규모 환경 확장성, 성능 최적화, 하위 호환성, **Production Readiness (관측성/Observability, 장애 폭발 반경 격리, 타임아웃·재시도 전략)** |
| **Tier 4. 학습자 질의응답** | `04_qa_archive.md` | 스텝 진행 중 학습자가 질문한 내용, 멘토의 심층 답변, 트러블슈팅/코드 해설, 핵심 인사이트를 누적 보관 |

---

## Task 1: 스텝별 주제별 분할 파일 작성 및 색인 등록

### 1단계: 자료 분석 및 주제 도출
- `research/step_{N}_research.md`와 `research/step_{N}_verification.md`를 분석합니다.
- 해당 단계의 핵심 영역에서 다루는 주제들을 기반/실무/심화 관점으로 분리합니다.

### 2단계: 디렉터리 및 분할 파일 작성
- 디렉터리 생성: `knowledge/step_{N}_{slug}/` (예: `knowledge/step_1_core-architecture/`)
- 분할 문서 작성 (`markdown-doc-guard` 스킬의 5대 서식 원칙을 준수하여 괄호 분리 및 VS Code Preview 렌더링 무결성 보장):
  - `01_prerequisites_{주제}.md`
  - `02_foundations_{주제}.md`
  - `03_deep_dive_{주제}.md`

각 분할 문서 계층별 필수 포함 구조:
```markdown
# [Step {N} - {계층명}] {주제명}

- **단계**: Step {N} ({단계 제목})
- **계층**: {선행 기반 지식 | 핵심 실무 지식 | 확장 심화 내용}
- **대상 기술 및 버전**: {CURRICULUM.md 기준 대상 기술 및 버전}

---

## 1. 개요 및 핵심 원리
## 2. 상세 메커니즘 및 아키텍처 다이어그램 (Mermaid 필수 포함)
   - (흐름/구조를 나타내는 flowchart, sequenceDiagram, stateDiagram-v2 등 최소 1개 포함)
## 3. 계층별 특화 섹션
   - [01_prerequisites 인 경우]: 필수 CS/런타임 기반 배경지식 및 멘탈 모델
   - [02_foundations 인 경우]: ADR (Architecture Decision Record - 대안 기술 비교 및 트레이드오프) + 실무 표준 코드/설정 가이드 + **샌드박스 실습 코드(`[labs/step_{N}_{slug}/](../../labs/step_{N}_{slug}/)`) 연동 해설**
   - [03_deep_dive 인 경우]: 대규모 트래픽/성능 한계 돌파 + Production Readiness 체크리스트 (관측성 메트릭/로깅, 장애 격리/Blast Radius, 타임아웃·재시도·폴백)
## 4. 실무 주의점 및 안티패턴 정리
```

### 3단계: 마스터 색인(`knowledge/index.md`) 등록
- `knowledge/index.md`가 없으면 초기 헤더(`# 📚 지식 아카이브 마스터 색인` 및 `## [스텝별 지식 모듈 목록]`)를 먼저 생성합니다.
- `## [스텝별 지식 모듈 목록]` 아래에 계층형 리스트로 등록하며, **생성된 샌드박스 실습 폴더(`../labs/step_{N}_{slug}/`) 링크도 함께 기재**합니다 (2칸 들여쓰기, 부모 항목 후 줄바꿈 엄수):

```markdown
* **Step {N}: [{단계 제목}](./step_{N}_{slug}/)**
  * **기반 지식**: [01_prerequisites_{주제}.md](./step_{N}_{slug}/01_prerequisites_{주제}.md) - {핵심 요약}
  * **핵심 실무**: [02_foundations_{주제}.md](./step_{N}_{slug}/02_foundations_{주제}.md) - {핵심 요약}
  * **심화 학습**: [03_deep_dive_{주제}.md](./step_{N}_{slug}/03_deep_dive_{주제}.md) - {핵심 요약}
  * **샌드박스 실습**: [labs/step_{N}_{slug}/](../labs/step_{N}_{slug}/) - {독립 실행 예제 및 가이드}
  * **상태**: `Archived` ({현재 날짜})
```

### 4단계: 상태 반영 및 심화 큐 전달 (동시성 안전 원칙)
- **비동기 서브에이전트로 실행 중인 경우 (Antigravity 등)**: 메인 에이전트와의 파일 쓰기 충돌(Race Condition)을 방지하기 위해 `progress.json`을 직접 수정하지 말고, 생성된 파일 상대 경로 목록(`knowledge_modules`)과 심화 키워드(`deep_dive_queue`)를 완료 메시지에 담아 메인 멘토에게 반환합니다.
- **단일 에이전트가 순차 실행 중인 경우 (Claude Code, Cursor 등)**: 생성된 파일 상대 경로들을 `progress.json`의 `knowledge_modules`에 추가하고, `03_deep_dive_{주제}.md`에서 도출된 심화 키워드를 `deep_dive_queue`에 직접 반영합니다.

---

## Task 1-B: 스텝 내 학습자 질의응답(Q&A), 스텝별 복습 트랙 및 프로젝트 점진적 조립 실시간 누적 아카이빙

학습자가 스텝을 즉시 넘어가지 않고 의문점, 샌드박스 실험 결과, 추가 코드 설명, 트러블슈팅 등을 문의할 때마다(또는 정규 과정 완료 후 **스텝별 복습 트랙** (`REVIEW_PHASE`) 및 **단일 프로젝트 점진적 조립** (`CAPSTONE_ASSEMBLY`) 진행 시) 질의와 응답을 영구 보관합니다.

### 1단계: 파일 준비 및 생성
- 정규 스텝 경로: `knowledge/step_{N}_{slug}/04_qa_archive.md`
- 선택형 복습 및 프로젝트 조립 트랙 경로: `knowledge/review_mastery/04_qa_archive.md` (`REVIEW_PHASE`의 스텝별 복습 `step_{K}_{slug}` 또는 `CAPSTONE_ASSEMBLY`의 `labs/project/` 점진적 조립 진행 시)
- 파일이 없으면 아래 헤더 구조를 신규 생성합니다:

```markdown
# [Step {N} - 학습 질의응답] {단계 제목} Q&A 아카이브

- **단계**: Step {N} ({단계 제목})
- **기록 대상**: 학습자-멘토 간 스텝 내 심층 질의응답, 샌드박스 실습 실험 및 트러블슈팅 내역
- **최근 갱신**: {YYYY-MM-DD}

---

## 📌 질답 요약 목록 (Index)
```

### 2단계: 구조화된 질답 블록 추가 (Append)
- `## 📌 질답 요약 목록 (Index)` 아래에 색인 링크 `- [Q{N}. {질문 요약}](#q{n}-{앵커})`를 추가합니다.
- 본문 하단에 표준 질답 블록을 추가합니다:

```markdown
### Q{N}. {질문 핵심 요약 제목}
- **학습자 질문 / 실습 상황**:
  > "{학습자의 실제 질문 원문, 스텝별 복습 예제 질의, 페어 코딩 구현 코드, 트러블슈팅 진단 내용 또는 단일 프로젝트 점진적 조립 이슈}"
- **멘토 답변 및 기술 해설**:
  {개념 원리, 코드 리뷰, 비교 분석, 모듈 간 통합 해설, 실무 조언 등 상세 내용}
- **핵심 통찰** (Key Takeaways):
  - {핵심 요점 1}
  - {핵심 요점 2}
- **관련 기술 및 키워드**: `{키워드1}`, `{키워드2}`

---
```

### 3단계: 마스터 색인 및 관심사 동기화
- `knowledge/index.md` 해당 스텝(또는 `## [실전 마스터리 복습 및 프로젝트 조립 기록]` 섹션)에 질답 및 샌드박스 항목을 등록/갱신합니다:
  `* **질답 기록**: [04_qa_archive.md](./step_{N}_{slug}/04_qa_archive.md) - {누적 Q&A N건 요약}`
- **상태 갱신**: 단일 에이전트 모드에서는 `progress.json`의 `knowledge_modules`와 `user_interests`를 즉시 갱신하고, 비동기 서브에이전트 모드에서는 추출된 `user_interests` 키워드와 경로를 메인 멘토에게 반환하여 메인 멘토가 `progress.json`을 일괄 갱신하도록 합니다.

---

## Task 2: 차기 커리큘럼 개인화 설계 (정규 스텝, 스텝별 복습 및 점진적 조립 완료/건너뛰기 시)

실행 조건: `progress.json`의 `status == "COMPLETED"` 일 때 (정규 스텝 완료 후 복습 트랙/단일 프로젝트 점진적 조립을 마쳤거나 건너뛰기를 선택한 시점).

1. 모든 `knowledge/step_*/03_deep_dive_*.md` 파일들과 함께 모든 `04_qa_archive.md` (정규 스텝 Q&A 및 `knowledge/review_mastery/`의 스텝별 페어 구현·트러블슈팅 복습과 `labs/project/` 단일 프로젝트 점진적 조립 기록 포함)에 수록된 **학습자의 실제 질문 및 페인포인트**를 종합 분석합니다.
2. `progress.json`의 `user_interests`, `deep_dive_queue`를 전수 취합하여 학습자가 자주 질문하고 궁금해했던 실무 엔지니어링 문제를 직접 다루는 2차 프로젝트 계획서 `NEXT_CURRICULUM.md`를 작성합니다.
3. 각 스텝은 `CURRICULUM.md`와 동일하게 **상단** (3대 지식 모듈별 학습 기대점 및 `labs/` 샌드박스 실습 구성)과 **하단** (핵심 체득 지식 및 상세 학습 내용) 규격으로 설계합니다.

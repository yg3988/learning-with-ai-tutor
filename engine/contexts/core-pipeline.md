## 파일 맵 (단일 진실 공급원 원칙)

| 파일/경로 | 역할 | 갱신 주체 |
| :-- | :-- | :-- |
| `CURRICULUM.md` | 상세 커리큘럼 원본 (학습자 프로필, 확정 버전 매트릭스, 각 Step의 `slug` 및 선행 관계 포함) | 사용자 / `curriculum-architect` 스킬 |
| `CORRECTIONS.md` | 프로젝트 결정 + 오개념 정정 + **누적 코드 & 아키텍처 규약** (`Shared Contract` 현재 상태 표) 원장. **CURRICULUM.md보다 우선** | 멘토 (`anti-regression-guard`) / `curriculum-architect` |
| `progress.json` | 진도/상태/관심사/심화 후보 큐/생성된 지식 및 실습 모듈 추적 (**단일 쓰기 주체**: 메인 멘토) | 메인 멘토 (`curriculum-architect` 포함) |
| `.devcontainer/` | 확정 버전 매트릭스에서 파생한 실습 실행 환경 (`devcontainer.json`, 필요 시 `docker-compose.yml`). 매트릭스 변경 시 함께 갱신 | `curriculum-architect` 스킬 |
| `research/intake_notes.md` | 커리큘럼 인터뷰 답변·버전 확인 근거·범위 점검 결과 원장 (대화 압축 대비) | `curriculum-architect` 스킬 |
| `research/step_{N}_research.md` | 단계별 기술 표준 및 RFC 조사 보고서 | `step-researcher` 스킬 |
| `research/step_{N}_verification.md` | 강의 내용 무결성, CLI/API 실존 여부(Grounding) 및 버전 정합성 사전 검증 보고서 | `lecture-verifier` 스킬 |
| `knowledge/step_{N}_{slug}/` | 주제별 분할 지식 모듈 (`01_prerequisites`, `02_foundations` [ADR 포함], `03_deep_dive` [운영 체크리스트 포함], `04_qa_archive.md`) | `modular-knowledge-investigator` 절차 |
| `knowledge/index.md` | 분할 지식 모듈 및 샌드박스 실습들의 마스터 색인 (계층형 링크 카드) | `curriculum-architect` / `modular-knowledge-investigator` |
| `labs/step_{N}_{slug}/` | **가이드형 샌드박스 실습 모드** (정규 스텝 기본값): 스텝별 독립 실행 가능한 완성형 예제 코드 및 실행 가이드(`README.md`) | `step-lecture-runner` 스킬 |
| `labs/review_pair_coding/step_{K}_{slug}/` | **선택형 복습 - 3안**: `labs/step_{K}_{slug}/` 원본을 디스크에서 읽어 파생한 스텝별 페어 구현(`TODO` 빈칸 채우기) 샌드박스 | `mastery-review-coach` 스킬 / 사용자 |
| `labs/review_troubleshooting/step_{K}_{slug}/` | **선택형 복습 - 4안**: `labs/step_{K}_{slug}/` 원본을 디스크에서 읽어 파생한 스텝별 장애/안티패턴 진단 샌드박스 | `mastery-review-coach` 스킬 / 사용자 |
| `labs/project/` | **선택형 단일 프로젝트 점진적 조립**: 복습 완료 후 Step 또는 마일스톤 라운드 단위로 누적 조립하는 통합 프로젝트 (`ASSEMBLY.md` 조립 장부 포함) | `mastery-review-coach` 스킬 / 사용자 |
| `knowledge/review_mastery/04_qa_archive.md` | 선택형 복습 단계 및 단일 프로젝트 점진적 조립 과정의 코드 리뷰·진단·질답 영구 아카이브 | `mastery-review-coach` 스킬 / `modular-knowledge-investigator` |
| `NEXT_CURRICULUM.md` | 전 과정 수료 후 개인화 차기 로드맵 (`## 후속 Part 예정 범위` 및 심화 큐·질답 종합) | `modular-knowledge-investigator` 절차 |

---

## 상태 기반 오케스트레이션 라우터 (State Machine Router)

> **점진적 스킬 로딩 (Progressive Disclosure)**: 컨텍스트 윈도우를 절약하기 위해 각 단계의 상세 실행 절차와 출력 템플릿은 전용 스킬 파일로 분리되어 있습니다. 매 턴을 시작할 때 `CURRICULUM.md` 존재 여부와 `progress.json`의 `status`를 먼저 확인하고, **해당 상태의 전담 스킬 `SKILL.md`를 디스크에서 직접 읽어 그 절차를 엄격히 수행**하십시오.

| 단계 | 진입 조건 (`progress.json` 상태) | 즉시 로드할 전담 스킬 / 에이전트 지침 | 핵심 수행 요약 |
| :-- | :-- | :-- | :-- |
| **0단계: 부트스트래핑 & 인터뷰** | `CURRICULUM.md` 부재 또는 비어있음 | `.agents/skills/curriculum-architect/SKILL.md` | 분야·프리셋 탐색 또는 일반 인터뷰(`research/intake_notes.md` 실시간 저장), 버전 웹 검색 검증, 범위 점검(최대 8스텝/Part 분할), `CURRICULUM.md`·`CORRECTIONS.md`·`.devcontainer/`·`progress.json` 생성 및 자체 검증 |
| **1~5단계: 정규 스텝 강의 & 샌드박스** | `status == "READY_TO_START"` 또는 `"IN_PROGRESS"` | `.agents/skills/step-lecture-runner/SKILL.md` | 세션 재개 워밍업 → `step-researcher` 조사 → 디스크 원본 재로드 & `lecture-verifier` 사전 검증 → `labs/step_{N}_{slug}/` 생성 & `Shared Contract` 현재 상태 병합 & 정제 강의 출력 → `modular-knowledge-investigator` 지식 3종(`01~03`) 및 질답(`04_qa_archive.md`) 아카이빙 → 다음 스텝 또는 `REVIEW_PHASE` 전이 |
| **6~7단계: 실전 복습 & 프로젝트 조립** | `status == "REVIEW_PHASE"` 또는 `"CAPSTONE_ASSEMBLY"` | `.agents/skills/mastery-review-coach/SKILL.md` | **6단계**: 옵션 1(페어 구현)·2(트러블슈팅)·3(통합)·4(건너뛰기) 선택 후 `K = 1..total_steps` 순차 진행 (디스크 원본 4종 강제 Read, 매 스텝 질의응답 및 다음 스텝 진행 의사 확인). **7단계**: 희망 시 `labs/project/ASSEMBLY.md` 조립 장부 기반으로 Step 또는 마일스톤 라운드 단위 누적 조립 후 `COMPLETED` 전이 |
| **수료 후: 차기 커리큘럼 기획** | `status == "COMPLETED"` | `.agents/agents/modular-knowledge-investigator/agent.md` (Task 2) | `CURRICULUM.md`의 `## 후속 Part 예정 범위`, 모든 `03_deep_dive`, 모든 `04_qa_archive.md` (정규·복습·조립 포함)를 취합해 `NEXT_CURRICULUM.md` 자동 기획 및 브리핑 |

---

## 전역 핵심 불변식 (Global Invariants)

1. **사전 검증 미통과 출력 금지**: 정규 강의나 `labs/` 코드는 반드시 `.agents/skills/lecture-verifier/SKILL.md` 검증(`VERIFIED`)을 통과한 후에만 제공합니다.
2. **대화 압축 오염 및 임의 추론 절대 금지** (Mandatory Disk Re-hydration): 대화가 압축되었거나 세션을 재개했을 때 대화 요약본(메모리)에 의존하여 코드를 추론·생성하지 마십시오. 모든 코드(`labs/step_*`, `labs/review_*`, `labs/project/`) 생성 직전에는 반드시 디스크의 `CORRECTIONS.md` (`## 누적 코드 & 아키텍처 규약`), `CURRICULUM.md`, 해당 스텝의 `labs/step_{K}_{slug}/` 원본 및 `knowledge/step_{K}_{slug}/` 문서를 직접 다시 읽고 작성하십시오.
3. **지식 문서 4종 및 질답 아카이빙 누락 금지**: 가이드형 샌드박스(`labs/step_{N}_{slug}/`)를 제공하더라도 강의 본문 출력과 `knowledge/step_{N}_{slug}/` 이하 분할 지식 문서(`01~03` 및 질문 발생 시 `04_qa_archive.md`) 아카이빙은 100% 수행합니다.
4. **스텝별 순차 진행 및 정규 스텝 과제 강요 금지**: 정규 스텝(1~N단계)은 완성된 실행 코드를 제공하는 **가이드형 샌드박스 모드**로 진행합니다. 6~7단계 복습·조립 시에는 절대 전 스텝 코드를 일괄 생성하지 말고 한 스텝(또는 마일스톤 라운드)씩 제공하며 궁금한 점과 다음 진행 여부를 확인하십시오.
5. **상시 가드 스킬 준수**:
   - 코드·강의 출력 전 `.agents/skills/anti-regression-guard/SKILL.md`로 `CORRECTIONS.md` 불변식과 `Shared Contract` 표를 대조합니다.
   - 모든 마크다운 작성 시 `.agents/skills/markdown-doc-guard/SKILL.md`의 5대 원칙(괄호 분리 `**키워드** (설명)`, 백틱 중첩 금지, 콜론 뒤 공백)을 준수합니다.
   - 학습자가 흥미를 보인 키워드는 `progress.json`의 `user_interests`에 실시간 기록합니다 (`progress.json`은 메인 멘토만 수정).

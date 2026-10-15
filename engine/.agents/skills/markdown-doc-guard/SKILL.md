---
name: markdown-doc-guard
description: >-
  Enforces CommonMark rendering safety and technical writing standards across all generated
  documentation, knowledge modules, research reports, and curriculum files. Prevents VS Code
  Markdown Preview breakages caused by bold-punctuation collisions, nested backticks, and CJK
  particle attachment. Use whenever generating or editing any Markdown (.md) documents.
---

# Markdown Document Guard (마크다운 문서 렌더링 세이프티 가드)

## 목적
VS Code의 미리보기(`markdown-it` 엔진), GitHub, 각종 마크다운 뷰어에서 괄호, 특수문자, CJK(한국어) 조사, 인라인 코드 백틱으로 인해 볼드(`**`)나 서식이 깨지거나 렌더링되지 않는 현상을 사전에 100% 방지하고, 테크니컬 라이팅(Technical Writing) 표준에 맞춰 문서의 가독성을 극대화합니다.

---

## 핵심 5대 렌더링 안전 원칙 (Formatting Rules)

### 1. 문장 부호(괄호/콜론/마침표)는 볼드 바깥으로 분리 (Punctuation Outside Bold)
CommonMark 스펙상 닫는 별표(`**`) 바로 안쪽에 닫는 괄호 `)`가 위치하면, 파서가 닫는 구분 기호(Right-flanking delimiter run)로 인정하지 않아 볼드가 닫히지 않고 그대로 노출되는 오류가 발생합니다.
부가 설명, 약어, 영문 표기 등 괄호 내용은 반드시 볼드 바깥에 위치시킵니다.

- ❌ **금지**: `**OpenAPI 명세서(OAS 3.1)**`
- ❌ **금지**: `**Protocol Buffers (Proto3)**`
- ⭕ **준수**: `**OpenAPI 명세서** (OAS 3.1)`
- ⭕ **준수**: `**Protocol Buffers** (Proto3)`
- ⭕ **괄호 전체를 묶어야 할 때**: `(**OpenAPI 명세서**)`

### 2. 볼드와 인라인 코드(백틱)의 중첩 금지 (No Inline Code Inside Bold)
볼드 태그 안쪽에 백틱(`` ` ``)을 넣으면 파서의 인라인 토큰 분리 엔진에서 구문 분석 오류가 발생합니다.
파일 경로나 CLI 명령어는 백틱만 단독으로 사용하거나, 볼드 텍스트로만 표현합니다.

- ❌ **금지**: `**`contracts/openapi.yaml` 파일**`
- ❌ **금지**: `**`npx buf lint` 명령어**`
- ⭕ **준수**: `` `contracts/openapi.yaml` 파일 `` (인라인 코드 단독)
- ⭕ **준수**: `**openapi.yaml** 파일` (볼드 단독)

### 3. 한국어 조사 결합 시 단어 경계 확보 (Korean Particle Boundary)
볼드 바로 뒤에 한글 조사가 공백 없이 붙을 때 오래된 파서나 일부 뷰어에서 닫는 경계를 오인할 수 있습니다.
가급적 콜론(`:`)이나 명사형 종결, 또는 괄호 분리를 활용하여 경계를 안전하게 확보합니다.

- ❌ **지양**: `**OpenAPI 명세서**는 시스템의 단일 진실 공급원입니다.`
- ⭕ **권장**: `**OpenAPI 명세서**: 시스템의 단일 진실 공급원입니다.`
- ⭕ **권장**: `**OpenAPI 명세서** (OAS 3.1)는 시스템의...` (괄호가 완충 역할)

### 4. 리스트 불릿 및 콜론 뒤 반드시 공백 1칸 확보 (Strict Spacing)
리스트 항목에서 볼드 라벨 뒤에 콜론을 사용할 때는 반드시 콜론 뒤에 1칸의 공백을 둡니다.
공백이 없으면 텍스트 전체가 하나의 식별자로 인식되어 렌더링이 깨집니다.

- ❌ **금지**: `- **기반 지식**:내용`
- ⭕ **준수**: `- **기반 지식**: 내용`

### 5. 불가피한 괄호 포함 강조 시 HTML `<strong>` 태그 사용 (HTML Fallback)
반드시 괄호까지 포함하여 한 단어로 볼드 처리해야 하는 특별한 요구사항이 있는 경우, 마크다운 별표 대신 HTML 태그를 사용합니다.
HTML 태그는 CommonMark 파서의 별표 구분 기호 규칙에 구애받지 않으므로 100% 안전하게 렌더링됩니다.

- ⭕ **폴백**: `<strong>OpenAPI 명세서(OAS 3.1)</strong>`

---

## 사전 감사 체크리스트 (Self-Audit Checklist)

문서(`CURRICULUM.md`, `knowledge/**/*.md`, `research/**/*.md`, `04_qa_archive.md`, `README.md`)를 저장하거나 사용자에게 강의를 출력하기 전에 아래 4개 항목을 자가 점검합니다:

1. [ ] `**` 바로 안쪽에 `(`, `)`, `[`, `]`, `:`, `.` 등 문장 부호가 갇혀있는 패턴이 없는가?
2. [ ] `**` 안에 백틱(`` ` ``)이 감싸져 있는 구문이 없는가?
3. [ ] 리스트 불릿의 `- **라벨**:` 뒤에 공백이 누락되지 않았는가?
4. [ ] 표(Table) 내부에서 파이프(`|`) 문자나 태그가 셀 구분을 깨뜨리지 않는가?

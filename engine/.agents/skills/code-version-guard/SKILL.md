---
name: code-version-guard
description: Ensure programming code, debugging, and API explanations match the user's specific runtime, framework, and library versions. Triggers when writing code, refactoring, or explaining APIs for libraries, frameworks, or languages where major versions have breaking changes.
---

# Code Version Guard

A skill to ensure all code implementations, API explanations, and debugging strictly match the user's runtime and library version, preventing deprecated syntax, breaking changes, or version mismatch errors.

## When to Use

- Writing code, functions, scripts, or application templates in any programming language
- Explaining third-party APIs, libraries, or SDKs
- Refactoring or upgrading existing code
- Debugging runtime errors that could stem from version incompatibilities

## Core Workflow

### 1. Version Detection & Clarification
- **Check User Input**: Look for explicit version numbers, configuration files (such as package.json, pyproject.toml, requirements.txt, pom.xml, go.mod), or syntax clues.
- **Targeted Clarification**: If the library or framework has notorious breaking changes across major versions (e.g., Next.js App Router vs Pages Router, Pydantic v1 vs v2, React 18 vs 19, Spring Boot 2 vs 3, Vue 2 vs 3) and the user has not specified their version:
  - State the assumed baseline version clearly in the opening line (e.g., "Assuming Python 3.12 and Pydantic v2..."), OR
  - Briefly ask for the user's active version if the implementation would completely break on an older version.

### 2. Version-Strict Implementation
- **Adhere to Specified Version**: Once the version is established, strictly use APIs, methods, and types available in that specific version.
- **Prohibit Hallucinated Future APIs**: Never mix future or unreleased API syntax with current versions.
- **Deprecation Warnings**: When providing code for an older version, add a brief note pointing out the modern or current equivalent and migration path.
- **No Syntax Conflation**: Never blend syntax across major version boundaries (e.g., mixing classmethod validators from Pydantic v1 with field_validator from Pydantic v2).

### 3. Verification & Gotchas
- Double-check import paths (import paths frequently change across major releases).
- Verify function arguments and return types against the target version's documentation.
- Avoid generic "latest" assumptions without explicitly declaring the version number.

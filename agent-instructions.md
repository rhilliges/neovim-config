# Development Instructions

These instructions apply to development tasks and supplement the global assistant instructions.

## Coding

- Match the existing coding style of the project.
- Try to implement features with as few changes as possible.
- Keep existing comments accurate. Avoid comments that restate the code; add comments only to explain non-obvious intent or constraints.
- If-statements shouldn't be too long. Create variables with good descriptive names if needed.
- Avoid unnecessary helpers. Extract functions when they meaningfully improve clarity or isolate complex logic.
- After changing something, check if documentation needs to get updated.

## Workflow Selection

- Choose the workflow based on scope, uncertainty, and risk. Follow an explicit user choice.
- A ticket ID alone does not require the full workflow; substantial work without a ticket may still need it.
- Research: the main agent investigates and reports findings without implementing changes. No mandatory plan, artifacts, or subagents.
- Quick change: the main agent implements a small, well-understood change, adds or updates relevant tests, runs checks, and summarizes the result. No mandatory formal plan, subagents, recordings, or QA report.
- Full implementation: use separate dev, reviewer, and QA subagents for substantial or risky changes. Follow the workflow below.
- If a quick change grows beyond its scope, explain why and propose switching workflows before launching subagents.
- The reviewer and QA stages are authorized as part of the full workflow and need no separate approval.

## Full Implementation Workflow

The main agent coordinates the work, maintains handoffs, and reports results. It does not implement production-code fixes or commit in this workflow. Give each subagent the ticket, acceptance criteria, applicable repository instructions, relevant artifacts, and selected stack.

### 1. Capture the Work

- Save the supplied ticket description as `ticket.md`, when there is one.
- Establish acceptance criteria, scope, and unresolved requirements before implementation.
- Check repository instructions, existing artifacts, and branch state. Record open questions and answers in `questions.md` when needed.

### 2. Plan and Implement — Dev Subagent

- Investigate the code and create `implementation-plan.md` with intended behavior, affected components, implementation steps, unit tests, regression risks, and how QA can exercise the acceptance criteria.
- Proceed without user approval of the plan. Ask only when missing requirements or consequential decisions block safe progress.
- Keep the plan's progress current.
- Own production-code changes, unit tests, and fixes throughout the workflow.
- For behavior changes, write a focused failing test first where practical, then implement the change and run relevant tests and project checks.
- Check whether documentation needs updating. Record verification commands, results, and anything not verified.

### 3. Review and Fix — Reviewer and Dev Subagents

- The reviewer checks the complete work-item changes against the ticket and plan, not just the latest commit.
- Review correctness, edge cases, security, authorization, code reuse, unnecessary complexity, repository coding guidelines, test quality, compatibility, error handling, and documentation as applicable.
- The reviewer reports findings with locations, impact, and concrete explanations; it does not edit production code.
- Send findings to the dev subagent. It verifies each finding, fixes valid issues, and explains rejected feedback with evidence.
- The reviewer checks the resolutions. After two fix/review rounds, escalate unresolved findings or disagreements to the user rather than looping indefinitely.

### 4. Test and Record Evidence — QA Subagent

- Derive tests independently from the acceptance criteria rather than merely repeating the dev subagent's tests.
- Own executable acceptance tests and QA evidence, but do not edit production code or commit.
- Use testing and automation tools appropriate to the application's platform and follow the repository's established frameworks and commands. Keep tool-specific setup in repository instructions rather than requiring a particular tool globally.
- Include relevant negative cases and verify resulting state or side effects, not only successful responses.
- Exercise the actual target application where acceptance criteria require it. Component tests or tests of an alternative build do not replace end-to-end verification of the target platform.
- For UI changes, record important interaction flows. Screenshots or automated assertions may suffice for small visual changes. Keep traces where useful.
- For API changes, retain sanitized request/response evidence and assertion results. A response dump alone is not proof of correctness.
- Write `qa-report.md` mapping acceptance criteria to tests, results, and evidence. Include the tested revision and any uncommitted changes, selected stack, execution time, exact rerun commands, and unverified items.
- Machine-readable test-runner reports may supplement the evidence but are not a substitute for the QA report.
- Report missing environments, tools, or access as verification blockers.

### 5. Resolve QA Failures and Hand Back

- QA sends failures and reproduction evidence to the dev subagent, which fixes the issues and adds regression tests.
- Route changed code back through review as relevant, then have QA rerun affected checks. Escalate after two unsuccessful QA fix/retest rounds.
- Ensure review and QA evidence cover the final code, including changes made after earlier checks. Report anything not rerun.
- The main agent summarizes the implementation, verification, evidence locations, remaining risks, and blockers for the user's own code review and testing.

## Git Permissions

- Only the implementing agent may commit: the main agent for quick changes, or the dev subagent for full implementations.
- Commits may happen throughout the work and do not require user approval.
- Reviewer and QA subagents never commit. The dev subagent may commit their intended test and evidence changes.
- Commit only intended work-item files; do not include unrelated staged or unstaged changes.

### Branch Safety

- Before implementation on a protected or shared branch, such as `main`, `master`, or `sprint`, propose a work branch and ask for approval before creating it. Use a ticket ID when available; otherwise use a descriptive name.
- If the current Git branch is behind its remote, ask the user whether to continue before making changes. You can use fetch to find out.

## Artifacts and Context

### Planning Artifacts

- Store artifacts under `plans/<work-item>/` in the repository that owns the work:
  - For single-service work, use the service repository.
  - For cross-service work or changes to the parent repository itself, use the parent repository.
- Use the ticket ID as `<work-item>`. If there is no ticket ID, use the full branch name.
- Keep artifacts for one work item together in the owning repository. Do not duplicate them across repositories.
- Use these filenames:
  - `ticket.md`: the ticket description supplied by the user.
  - `implementation-plan.md`: implementation steps and current progress.
  - `questions.md`: missing requirements, open questions, and their answers.
  - `qa-report.md`: acceptance-test results, evidence references, and verification limitations for full implementations.
  - `*.http`: a small set of requests for quick manual sanity checks, not the full automated test workflow.
- Keep supporting notes and review findings in descriptive `.md` or `.txt` files in the same directory when needed.
- Put executable tests in the repository's established test locations; reference them from the plan and QA report rather than duplicating them.
- Follow repository conventions for recordings, traces, and test-result storage. Reference large evidence files from `qa-report.md`; do not commit them by default.
- Research and quick changes do not require artifacts merely to follow a process. For full implementations, the implementation plan and QA report are required; create other artifacts only when applicable.
- For cross-service work, identify the affected repositories and branches in `implementation-plan.md`. Use project-specific filenames when separate supporting artifacts are needed.

### Implementation Plans

- Before creating an implementation plan, check the current branch in every repository that needs changes.
- When using planning artifacts and the user supplies a ticket description, save it as `ticket.md` in the artifact directory.
- Save implementation plans as `implementation-plan.md` in the artifact directory and keep progress updated.
- Record missing requirements and open questions in `questions.md`. Update it with answers when they become available.

### Testing Outside the Full Workflow

- Choose verification appropriate to the change and target platform, including unit tests, integration tests, or manual UI checks. Follow repository testing conventions and report commands, results, and limitations.
- Use `.http` files only for quick sanity-check requests, including when supplementing an HTTP test plan. They do not replace automated assertions or represent the full test workflow.

### Context

- At the start of a task, check the current repository's `plans/` directory for artifacts matching the current branch. Do not automatically search parent or service repositories.
- Match using the ticket ID in the branch name, or the full branch name if there is no ticket ID.
- If matching artifacts exist, ask the user whether to load their contents into context before proceeding. Listing filenames is allowed before approval.
- If multiple directories match, ask which one applies.

## Local and Testing Stacks

- Run applications and acceptance tests only locally or against testing stacks. Stop and ask if the target is unclear or appears to be production.
- Agents may read and use credentials from the repository's `.env.<stack>` files.
- Follow repository instructions for available stacks, environment loading, startup and test commands, credential-variable names, test-user roles, and test-data setup and cleanup. Do not assume `.env` files can be shell-sourced.
- Repository instructions should document these details or link to a testing guide such as `docs/testing.md`.
- Dev and QA use the same selected stack. Record the stack name, not credentials, in the QA report.
- If a file or required variable is missing, report its name and ask for setup.

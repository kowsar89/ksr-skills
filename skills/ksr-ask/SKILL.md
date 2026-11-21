---
name: ksr-ask
description: Enter ask-only mode. Answer questions, explain, inspect, and reason, but never take actions, modify files, run commands, or make changes.
disable-model-invocation: true
---

# Ask Mode

This skill is activated only by explicit user invocation.

While active, act strictly as a read-only question-answering assistant.

## Rules

- Answer the user's questions.
- Explain code, files, systems, errors, concepts, and possible approaches.
- Analyze information that is already available.
- You may inspect or read information when needed to answer accurately.
- Do not modify, create, delete, rename, or move files.
- Do not edit code.
- Do not run commands that change state.
- Do not install packages or dependencies.
- Do not commit, push, deploy, open pull requests, or make configuration changes.
- Do not send messages, create events, or perform external actions.
- Do not implement suggestions yourself.
- Do not proactively begin work beyond answering the question.

If the user asks you to perform an action, explain what would need to be done instead of doing it.

Remain in ask-only mode for the duration of the request.

---
description: Analyzes staged changes and prints a formatted commit message draft.
---

Read my currently staged git changes.
Write a conventional commit message based on these changes.

**CRITICAL RULES:**

1. Do NOT execute `git commit`. You are only drafting the text.
2. Do NOT include the "Co-Authored-By: Claude" tag or any other AI attribution.
3. Do NOT ask me "Want me to go ahead and create this commit?" or any other follow-up questions.
4. Just print the final commit message to the console and stop.

Format the output exactly like this:
<type>(<scope>): <subject>

<body>

# Language

## 1. Conversation
我是一個在科技領域工作幾十年的臺灣人，習慣的對話是繁體中文，但技術關鍵字我比較習慣使用英文。

例如：
1. CPU 會比「中央處理器」好理解
2. Cache 會比「快取記憶體」好理解
3. Bus 會比「匯流排」好理解

我專長的領域是 Computer Architecture，所以你我在對話的時候，請用繁體中文與我溝通，但技術關鍵字還是要保留英文，這樣我最能夠理解。

## 2. Coding

在程式撰寫方面，裡面的註解等語言應該要用全英文，因為我是在國際公司工作，需要全球的人都能看得懂。

## 3. md file

你不需要產生 MD 檔來向我說明你改了什麼。
如果我有要你產生 MD 檔的話，裡面要用全英文的。

# SiFive server environment

## Use web browser to show the server file

For files under /nfs/teams/perf/share/https/users/fuchingy/, we can show it via https://nfsweb.internal.sifive.com/perf/users/fuchingy/

# Coding guidelines

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

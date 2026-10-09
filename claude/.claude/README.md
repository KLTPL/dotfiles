# 🤖 My Claude Code config

## 🧩 Skills

### 🎨 Design

#### ⬩ [frontend-design](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/frontend-design)

Anthropic's skill. Makes Claude pick a visual direction that fits the brief (fonts, colors, layout) instead of template defaults. Loads by itself whenever I build UI.

#### ⬩ [apple-design](https://github.com/emilkowalski/skills/tree/main/skills/apple-design)

Emil Kowalski's skill about how an interface moves: springs, gestures, sheets, momentum. It's not a visual style, so it works with any look.

Run it on interactive parts: `/apple-design:apple-design review the mobile menu`.

#### ⬩ [web-design-guidelines](https://github.com/vercel-labs/agent-skills/tree/main/skills/web-design-guidelines)

Vercel's checklist review: accessibility, focus states, forms, tap targets. It downloads the latest rules from GitHub on every run.

Run it once at the end: `/web-design-guidelines:web-design-guidelines src/`.

### ✍️ Writing

#### ⬩ [humanizer](https://github.com/blader/humanizer)

Rewrites text that sounds AI-written.

### 🧠 Decisions

#### ⬩ llm-council

Runs a question through 5 advisors who review each other, then gives one verdict. Only runs when I say "council".

## 🖌️ Website design workflow

One skill per job, so they don't give Claude conflicting rules:

| Job    | Skill                 | When                        |
| :----- | :-------------------- | :-------------------------- |
| Look   | frontend-design       | Every time, loads by itself |
| Motion | apple-design          | Only for interactive parts  |
| Check  | web-design-guidelines | Once, before shipping       |

1. **Brief first, ask for directions.** A vague prompt gets a generic site. The brief decides the style, so not every site ends up looking like Apple's:

   > Landing page for a small coffee roaster. Audience: locals, 25–45. Feel: warm, handmade, not corporate. I like [site A] and [site B]. Before coding, propose 3 visual directions and wait for me to pick one.

2. **Pick a direction, let Claude build it.** frontend-design handles fonts, colors and layout.
3. **Polish interactive parts** (menus, galleries, transitions) with apple-design. Skip for mostly static pages.
4. **Final check** with web-design-guidelines on the whole site.

### Skipped skills, and when to revisit them

- [taste-skill](https://github.com/leonxlnx/taste-skill): preset styles (minimalist, brutalist, agency look). When I want a specific named style quickly.
- [ui-ux-pro-max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill): style, palette and font databases. Only if I have no idea where to start; reference sites do the same job.
- [impeccable](https://github.com/pbakaus/impeccable): 24 review and polish commands, but it installs its own binary and hooks, and overlaps with frontend-design.
- [interface-design](https://github.com/Dammyjay93/interface-design): for dashboards and admin apps, not websites.

Don't enable many design skills globally. Their descriptions overlap, so Claude may load two with conflicting rules. Enable a style skill only in the project that needs it.

## 📦 How skills are installed

- **Own skills** are folders in `claude/.claude/skills/`, which stow links into `~/.claude/skills/`. They're also listed in the catalog, so other PCs can install them.
- **Third-party skills with their own marketplace** (frontend-design, humanizer) are listed in `settings.json` under `extraKnownMarketplaces` and `enabledPlugins`.
- **Third-party skills without one** (apple-design, web-design-guidelines) are entries in my catalog, `.claude-plugin/marketplace.json` at the root of this repo, plus a line in `enabledPlugins`. Each entry downloads only that skill's folder from the author's repo.
- Never use `npx skills add`. It installs outside this repo.

On a new machine, the first Claude session downloads the plugins and the next session loads them. `autoUpdate` on my catalog keeps them up to date. `claude plugin` commands can drop it from `settings.json`, so check it's still there after running them.

## 💻 Using my skills on another PC

Without cloning this repo:

```bash
claude plugin marketplace add KLTPL/dotfiles

# then for each skill
claude plugin install <skill-name>@kltpl-skills

claude plugin install frontend-design@claude-plugins-official
```

On that PC, llm-council runs as `/llm-council:llm-council`.

When done, remove my catalog and everything installed from it:

```bash
claude plugin marketplace remove kltpl-skills
claude plugin uninstall frontend-design@claude-plugins-official
```

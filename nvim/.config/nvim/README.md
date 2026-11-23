# 💤 My LazyVim config

## 🧩 Plugins

### 🎓 Learning LazyVim and good practices

#### ⬩ [hardtime.nvim](https://github.com/m4xshen/hardtime.nvim)

Blocks you from using the mouse and ineffective keymaps.

#### ⬩ [precognition.nvim](https://github.com/tris203/precognition.nvim)

Displays tips under the selected line on how to move to a particular place.

Currently disabled (`enabled = false` in `lua/plugins/precognition.lua`).

### 📈 Workflow and productivity

#### ⬩ [scope.nvim](https://github.com/tiagovla/scope.nvim)

Makes tabpages separated, so they don't share the same buffers, making them effectively a workspace tool.

Use with the [lualine.nvim](#lualine-nvim) plugin to see tabpages' numbers clearly (by default scope makes the tabs disappear when there's only one buffer opened in a tabpage).

#### ⬩ [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)

File explorer, enabled through the LazyVim extra. Dotfiles are shown by default.

### 🖥️ UI

<a id="lualine-nvim"></a>

#### ⬩ [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)

I use it to move tabpage labels (numbers you see on the top right buffer powerd by the bufferline.nvim plugin) to the bottom right bar.

#### ⬩ [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)

Terminal buffers show a custom label instead of `<pid>:/usr/bin/zsh`. Run `:Tn <label>` (or `:TermName <label>`, Tab-completes known labels) in a terminal to set it (defaults to `term <bufnr>`). Running `claude` in an unlabelled terminal labels it automatically as `claude 1`, `claude 2`, ...; hand-set labels are never overridden and get a number only when taken. Labels listed in `lua/config/term_icons.lua` (`claude`, `interactive`, `exec`, `logs`) get their own icon, numbered ones included; `<leader>Tc` opens Claude Code in a new labelled terminal. The commands and auto-labelling live in `lua/util/term_name.lua`, the display logic in `lua/plugins/bufferline.lua`.

#### ⬩ [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)

Renders markdown in the buffer, enabled through the LazyVim `lang.markdown` extra. Rendering is off by default; toggle it with `<leader>um`.

### 🛠️ Tools

#### ⬩ [kulala.nvim](https://github.com/mistweaverco/kulala.nvim)

Lets you fetch APIs from a simple .http file.

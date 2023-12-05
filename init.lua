return {
  plugins = {
    {
      "github/copilot.vim",
      lazy = false,
      config = function()
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_filetypes = { yaml = true }
        local keymap = vim.keymap.set
        -- https://github.com/orgs/community/discussions/29817#discussioncomment-4217615
        keymap("i", "<C-g>", 'copilot#Accept("<CR>")',
          { silent = true, expr = true, script = true, replace_keycodes = false })
        keymap("i", "<C-j>", "<Plug>(copilot-next)")
        keymap("i", "<C-k>", "<Plug>(copilot-previous)")
        keymap("i", "<C-o>", "<Plug>(copilot-dismiss)")
        keymap("i", "<C-s>", "<Plug>(copilot-suggest)")
      end
    },
    {
      "neo-tree.nvim",
      opts = function()
        return {
          filesystem = {
            window = {
              mappings = {
                -- disable fuzzy finder
                ["/"] = "noop",
                -- Jump to current nodes parent
                -- like `p` in NERDTree Mappings
                ["P"] = function(state)
                  local tree = state.tree
                  local node = tree:get_node()
                  local parent_node = tree:get_node(node:get_parent_id())
                  local renderer = require("neo-tree.ui.renderer")
                  renderer.redraw(state)
                  renderer.focus_node(state, parent_node:get_id())
                end,
                ["T"] = { "toggle_preview", config = { use_float = true } },
              }
            },
            filtered_items = {
              visible = true,
              hide_dotfiles = false
            }
          }
        }
      end
    },
    {
      "rebelot/heirline.nvim",
      opts = function(_, opts)
        local status = require("astronvim.utils.status")

        opts.statusline = {
          -- statusline
          hl = { fg = "fg", bg = "bg" },
          status.component.mode { mode_text = { padding = { left = 1, right = 1 } } },
          status.component.git_branch(),
          status.component.separated_path {
            max_depth = 1000,
            path_func = status.provider.filename { modify = ":.:h" },
            separator = "/"
          },
          status.component.file_info {
            filename = {
              fallback = "Empty",
            },
            filetype = false,
            file_modified = false
          },
          status.component.git_diff(),
          status.component.diagnostics(),
          status.component.fill(),
          status.component.cmd_info(),
          status.component.fill(),
          status.component.lsp(),
          status.component.treesitter(),
          status.component.nav(),
          status.component.mode { surround = { separator = "right" } },
        }
      end
    },
    {
      "rust-lang/rust.vim",
      lazy = false,
      config = function()
        vim.g.rustfmt_autosave = 1
      end
    }
  },
  -- This function is run last
  -- good place to configure mappings and vim options
  polish = function()
    -- Set autocommands
    vim.api.nvim_create_autocmd("VimEnter", {
      command = "Neotree toggle",
    })
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.go',
      callback = function()
        vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
      end
    })
  end
}

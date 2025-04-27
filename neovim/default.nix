{ config, pkgs, lib, ... }:
{
  options.neovimconfig = {
    users = lib.options.mkOption { type = with lib.types; listOf str; };
  };

  config = {
    environment.systemPackages = with pkgs; [
      ripgrep
      jdt-language-server
      pyright
      rust-analyzer
      clang-tools
      haskell-language-server
      nixd
      cmake-language-server
    ];

    home-manager.users = with builtins; listToAttrs (map
      (username: {
        name = username;
        value = { pkgs, ... }:
        {
          programs.neovim = {
            enable = true;
            plugins = with pkgs.vimPlugins; [
              nvim-treesitter.withAllGrammars
              undotree
              vim-fugitive
              lsp-zero-nvim
              nvim-lspconfig
              nvim-cmp
              cmp-nvim-lsp
              luasnip # Needed for LSP to work properly
              { plugin = telescope-nvim;
                type = "lua";
                config = ''
                  local builtin = require('telescope.builtin')
                  vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
                  vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
                  vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
                  vim.keymap.set('n', '<leader>pas', builtin.live_grep, {})
                '';
              }
              {
                plugin = harpoon;
                type = "lua";
                config = ''
                  local mark = require('harpoon.mark')
                  local ui = require('harpoon.ui')
                  vim.keymap.set('n', '<leader>a', mark.add_file)
                  vim.keymap.set('n', '<leader>e', ui.toggle_quick_menu)
                  vim.keymap.set('n', '<leader>t', function() ui.nav_file(1) end)
                  vim.keymap.set('n', '<leader>y', function() ui.nav_file(2) end)
                  vim.keymap.set('n', '<leader>u', function() ui.nav_file(3) end)
                  vim.keymap.set('n', '<leader>i', function() ui.nav_file(4) end)
                '';
              }
              { plugin = onedark-nvim;
                type = "lua";
                config = ''
                  local od = require('onedark')
                  od.setup {
                    style = 'warmer'
                  }
                '';
              }
              { plugin = midnight-nvim;
                type = "lua";
                config = ''
                  vim.cmd([[ colorscheme midnight ]])
                '';
              }
            ];
            extraLuaConfig = ''
              vim.g.mapleader = " "

              vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
              vim.keymap.set("n", "<leader>pe", vim.diagnostic.setqflist)
              vim.keymap.set("n", "<leader>w", "<Cmd>w<CR>")

              vim.opt.nu = true
              vim.opt.relativenumber = true
              vim.opt.tabstop = 4
              vim.opt.softtabstop = 4
              vim.opt.shiftwidth = 4
              vim.opt.expandtab = true
              vim.opt.wrap = true
              vim.opt.smartindent = true

              vim.opt.swapfile = false
              vim.opt.backup = false
              vim.opt.undodir = vim.fn.stdpath('data') .. '/undodir'
              vim.opt.undofile = true

              vim.opt.incsearch = true
              vim.opt.hlsearch = false

              vim.opt.termguicolors = true

              vim.opt.scrolloff = 8
              vim.opt.signcolumn = "yes"

              vim.opt.updatetime = 250
              vim.opt.modelines = 0

              vim.opt.fixeol = false



              
              local lsp = require('lsp-zero')
              local cmp = require('cmp')
              local lspconfig = require('lspconfig')
              lsp.preset('recommended')
              lsp.set_sign_icons()
              local cmp_select = {behavior = cmp.SelectBehavior.Select}
              cmp.setup({
                  sources = {
                      { name = 'path' },
                      { name = 'nvim_lsp' },
                      { name = 'nvim_lua' },
                      { name = 'luasnip', keyword_length = 2 },
                      { name = 'buffer', keyword_length = 3 },
                  },
                  formatting = lsp.cmp_format(),
                  mapping = cmp.mapping.preset.insert({
                      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                      ['<C-e>'] = cmp.mapping.abort(),
                      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                      ['<C-d>'] = cmp.mapping.scroll_docs(4),
                      ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                      ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                      ['<C-Space>'] = cmp.mapping.complete(),
                  }),
              })
              lsp.on_attach(function(client, bufnr)
                  local opts = {buffer = bufnr, remap = false}
                  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                  vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
                  vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
                  vim.keymap.set("n", "go", function() vim.lsp.buf.type_definition() end, opts)
                  vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
                  vim.keymap.set("n", "gs", function() vim.lsp.buf.signature_help() end, opts)
                  vim.keymap.set("n", "<F2>", function() vim.lsp.buf.rename() end, opts)
                  vim.keymap.set({"n", "v"}, "<F3>", function() vim.lsp.buf.format() end, opts)
                  vim.keymap.set("n", "<F4>", function() vim.lsp.buf.code_action() end, opts)
                  vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts)
                  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
                  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
                  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
              end)
              lspconfig.jdtls.setup({})
              lspconfig.pyright.setup({})
              lspconfig.rust_analyzer.setup({})
              lspconfig.clangd.setup({})
              lspconfig.hls.setup({})
              lspconfig.nixd.setup({})
              lspconfig.cmake.setup({})
              lsp.setup()
              vim.diagnostic.config({
                  virtual_text = true,
                  update_in_insert = true,
              })
            '';
          };
        };
      }) config.neovimconfig.users);
    };
}

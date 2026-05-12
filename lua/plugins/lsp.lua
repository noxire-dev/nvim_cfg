return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'mason-org/mason.nvim',                  cmd = 'Mason', opts = {} },
      { 'mason-org/mason-lspconfig.nvim',        opts = {} },
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim',                     opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('grr', function() Snacks.picker.lsp_references() end, '[G]oto [R]eferences')
          map('gri', function() Snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation')
          map('grd', function() Snacks.picker.lsp_definitions() end, '[G]oto [D]efinition')
          map('grt', function() Snacks.picker.lsp_type_definitions() end, '[G]oto [T]ype Definition')
          map('gO', function() Snacks.picker.lsp_symbols() end, 'Open Document Symbols')
          map('gW', function() Snacks.picker.lsp_workspace_symbols() end, 'Open Workspace Symbols')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('user-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('user-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'user-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client:supports_method('textDocument/inlayHint', event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      local servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              completeUnimported = true,
              usePlaceholders = true,
              staticcheck = true,
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },

        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
              },
            },
          },
        },

        vtsls = {
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = 'literals' },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
              },
            },
            javascript = {
              inlayHints = {
                parameterNames = { enabled = 'literals' },
                variableTypes = { enabled = true },
              },
            },
          },
        },

        jsonls = {},
        yamlls = {},
        bashls = {},

        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
                return
              end
            end
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                version = 'LuaJIT',
                path = { 'lua/?.lua', 'lua/?/init.lua' },
              },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file('', true),
              },
              diagnostics = {
                globals = { 'vim', 'Snacks' },
              },
            })
          end,
          settings = { Lua = {} },
        },
      }

      local ensure_installed = vim.tbl_keys(servers)
      vim.list_extend(ensure_installed, {
        'stylua',
        'goimports',
        'gofumpt',
        'ruff',
        'prettierd',
        'eslint_d',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end
    end,
  },

  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    event = { 'BufReadPost', 'BufNewFile' },
    keys = {
      { 'zR', function() require('ufo').openAllFolds() end,  desc = 'Open all folds' },
      { 'zM', function() require('ufo').closeAllFolds() end, desc = 'Close all folds' },
      { 'zr', function() require('ufo').openFoldsExceptKinds() end, desc = 'Open folds except kinds' },
      { 'zp', function() require('ufo').peekFoldedLinesUnderCursor() end, desc = 'Peek folded lines' },
    },
    opts = {
      provider_selector = function(_, ft, _)
        local fallback = { 'treesitter', 'indent' }
        local lsp_only = { 'lsp', 'indent' }
        local map = {
          go = lsp_only,
          python = lsp_only,
          typescript = lsp_only,
          javascript = lsp_only,
          typescriptreact = lsp_only,
          javascriptreact = lsp_only,
          lua = lsp_only,
        }
        return map[ft] or fallback
      end,
      open_fold_hl_timeout = 0,
      close_fold_kinds_for_ft = {
        default = { 'imports', 'comment' },
      },
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ('  %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end,
    },
  },
}

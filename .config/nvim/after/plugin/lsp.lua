-- nvim-cmp
local cmp = require("cmp")

-- icons
local lspkind = require("lspkind")
lspkind.init()

cmp.setup({
    mapping = {
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
        ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 'c'}),
        ["<C-e>"] = cmp.mapping.close(),
        ["<c-y>"] = cmp.mapping(cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        }, {"i", "c"}),
        ["<C-Space>"] = cmp.mapping {
            i = cmp.mapping.complete(),
            c = function(_ --[[fallback]] )
                if cmp.visible() then
                    if not cmp.confirm {select = true} then
                        return
                    end
                else
                    cmp.complete()
                end
            end
        },
        ["<tab>"] = cmp.config.disable
    },
    -- order ranks priority in completion drop-down -- higher has more priority
    sources = {
        {name = "nvim_lsp"}, -- update neovim lsp capabilities https://github.com/hrsh7th/cmp-nvim-lsp
        {name = "luasnip", keyword_length = 2}, -- snippets
        {name = "path"}, -- complete names of files
        {name = "buffer", keyword_length = 4}
    },
    experimental = {native_menu = false, ghost_text = true},
    formatting = {
        -- Youtube: How to set up nice formatting for your sources.
        format = lspkind.cmp_format {
            with_text = true,
            menu = {
                buffer = "[buf]",
                nvim_lsp = "[lsp]",
                nvim_lua = "[lua]",
                path = "[path]",
                luasnip = "[snip]"
            }
        }
    },
    snippet = {
        expand = function(args) require("luasnip").lsp_expand(args.body) end
    }
})

-- completions for '/' based on current buffer
-- cmp.setup.cmdline('/', {sources = {{name = 'buffer', keyword_length = 4}}})

-- https://github.com/hrsh7th/cmp-nvim-lsp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.workspace = {
    didChangeWatchedFiles = {
        -- https://github.com/neovim/neovim/issues/23725#issuecomment-1561364086
        -- https://github.com/neovim/neovim/issues/23291
        -- disable watchfiles for lsp, runs slow on linux
        dynamicRegistration = false
    }
}

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

-- web stuff
require("lspconfig").jsonls.setup {capabilities = capabilities}
require("lspconfig").cssls.setup {capabilities = capabilities}
require("lspconfig").html.setup {capabilities = capabilities}
require("lspconfig").eslint.setup {capabilities = capabilities}
require("lspconfig").cssmodules_ls.setup {capabilities = capabilities}
require("lspconfig").tailwindcss.setup {capabilities = capabilities}
require("lspconfig").tsserver.setup {capabilities = capabilities}
require("lspconfig").prismals.setup {capabilities = capabilities}

-- python
-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md
require("lspconfig").pyright.setup {
    capabilities = capabilities,
    flags = {debounce_text_changes = 100}
}

-- yaml
require("lspconfig").yamlls.setup {
    capabilities = capabilities,
    settings = {yaml = {keyOrdering = false}}
}

-- shell
require("lspconfig").bashls.setup {capabilities = capabilities}

-- golang
require("lspconfig").gopls.setup {capabilities = capabilities}

-- elixir
local elixir_ls_bin = vim.fn.exepath("elixir-ls")
if elixir_ls_bin ~= "" then
    require'lspconfig'.elixirls.setup {
        cmd = {elixir_ls_bin},
        capabilities = capabilities
    }
end

-- rust
require'lspconfig'.rust_analyzer.setup {capabilities = capabilities}

-- lua
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require"lspconfig".lua_ls.setup {
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {version = "LuaJIT", path = runtime_path},
            diagnostics = {globals = {"vim"}},
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                -- disable prompts for luv/luassert
                checkThirdParty = false
            }
        }
    }
}

-- if asdf install file exists, use it
if vim.fn.filereadable("~/.asdf/installs/nodejs") == 1 then
    -- use asdf nodejs for copilot
    -- TODO: check if it exists or use asdfs system installed nodejs in bin?
    vim.g.copilot_node_command = "~/.asdf/installs/nodejs/17.0.1/bin/node"
else
    -- use system nodejs for copilot
    vim.g.copilot_node_command = "node"
end

-- https://www.reddit.com/r/neovim/comments/w2exp5/comment/j1lbogi/?utm_source=share&utm_medium=web2x&context=3
local copilot_on = true
vim.api.nvim_create_user_command("CopilotToggle", function()
    if copilot_on then
        vim.cmd("Copilot disable")
        print("Copilot OFF")
    else
        vim.cmd("Copilot enable")
        print("Copilot ON")
    end
    copilot_on = not copilot_on
end, {nargs = 0})
vim.keymap.set("", "<M-\\>", ":CopilotToggle<CR>",
               {noremap = true, silent = true})

-- disable lsp diagnostics for .env files
local lsp_grp = vim.api.nvim_create_augroup("lsp_disable", {clear = true})
vim.api.nvim_create_autocmd({"BufEnter", "BufNewFile"}, {
    group = lsp_grp,
    pattern = {".env", ".env.*"},
    callback = function() vim.diagnostic.disable(0) end
})


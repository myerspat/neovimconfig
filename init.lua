-- AstroNvim Configuration Table
local config = {
    -- Configure AstroNvim updates
    updater = {
        remote = "origin",
        channel = "nightly",
        version = "latest",
        branch = "main",
        commit = nil,
        pin_plugins = nil,
        skip_prompts = false,
        show_changelog = true,
        auto_reload = false,
        auto_quit = false
    },

    -- Set colorscheme config
    colorscheme = "carbonfox",

    -- Set vim options
    options = {
        opt = {relativenumber = false, wrap = true, clipboard = "unnamedplus"},
        g = {
            mapleader = " ",
            vimwiki_list = {
                {
                    path = '~/vimwiki',
                    template_path = '~/vimwiki/templates',
                    template_default = 'default',
                    syntax = 'markdown',
                    ext = '.md',
                    path_html = '~/vimwiki/site_html',
                    custom_wiki2html = 'vimwiki_markdown',
                    html_filename_parameterization = 1,
                    template_ext = '.tpl'
                }
            }
        }
    },

    mappings = {
        n = {["<leader>ta"] = {":TagbarToggle<cr>", desc = "Toggle Tagbar"}}
    },

    -- Set dashboard header
    header = {
        "███    ██ ██    ██ ██ ███    ███",
        "████   ██ ██    ██ ██ ████  ████",
        "██ ██  ██ ██    ██ ██ ██ ████ ██",
        "██  ██ ██  ██  ██  ██ ██  ██  ██",
        "██   ████   ████   ██ ██      ██"
    },

    -- Diagnostic configuration
    diagnostics = {virtual_text = false, underline = false},

    -- Extended LSP Configuration
    lsp = {
        -- Enable servers
        servers = {"pyright", "clangd", "sumneko_lua"}
    },

    -- Configure plugins
    plugins = {
        init = {
            {"vimwiki/vimwiki"}, {"EdenEast/nightfox.nvim"},
            {"preservim/tagbar"}
        },

        -- All other entries override the require("<key>").setup({...}) call for default plugins
        ["null-ls"] = function(config) -- overrides `require("null-ls").setup(config)`
            -- config variable is the default configuration table for the setup functino call
            local null_ls = require "null-ls"
            local formatting = null_ls.builtins.formatting

            config.sources = {formatting.lua_format, formatting.black}

            -- set up null-ls's on_attach function
            -- NOTE: You can remove this on attach function to disable format on save
            config.on_attach = function(client)
                if client.resolved_capabilities.document_formatting then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        desc = "Auto format before save",
                        pattern = "<buffer>",
                        callback = vim.lsp.buf.formatting_sync
                    })
                end
            end
            return config -- return final config table to use in require("null-ls").setup(config)
        end,
        treesitter = { -- overrides `require("treesitter").setup(...)`
            ensure_installed = {
                "lua", "python", "cpp", "c", "latex", "markdown"
            }
        },
        ["nvim-lsp-installer"] = {
            ensure_installed = {"sumneko_lua", "clangd", "cmake", "pyright"}
        },
        packer = { -- overrides `require("packer").setup(...)`
            compile_path = vim.fn.stdpath "data" .. "/packer_compiled.lua"
        }
    },

    -- CMP Source Priorities
    -- modify here the priorities of default cmp sources
    -- higher value == higher priority
    -- The value can also be set to a boolean for disabling default sources:
    -- false == disabled
    -- true == 1000
    cmp = {
        source_priority = {
            nvim_lsp = 1000,
            luasnip = 750,
            buffer = 500,
            path = 250
        }
    },

    -- This function is run last and is a good place to configuring
    -- augroups/autocommands and custom filetypes also this just pure lua so
    -- anything that doesn't fit in the normal config locations above can go here
    polish = function()
        -- Set key binding
        -- Set autocommands
        vim.api.nvim_create_augroup("packer_conf", {clear = true})
        vim.api.nvim_create_autocmd("BufWritePost", {
            desc = "Sync packer after modifying plugins.lua",
            group = "packer_conf",
            pattern = "plugins.lua",
            command = "source <afile> | PackerSync"
        })
    end
}

return config

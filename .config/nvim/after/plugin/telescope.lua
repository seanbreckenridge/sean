local cached_repo_bases = function()
    -- cache/roots.txt gets populated by a bgproc job
    -- https://sean.fish/d/cached_repo_bases.job?dark
    local cache_dir = os.getenv('XDG_CACHE_HOME')
    local cache_file = cache_dir .. '/repo_bases.txt'
    local f = io.open(cache_file, 'r')
    if f == nil then return {} end
    local roots = {}
    for line in f:lines() do table.insert(roots, line) end
    return roots
end

local tl = require('telescope')
local actions = require('telescope.actions')

local previewers = require('telescope.previewers')

-- this is a no-op for now, just here incase I want to modify things
-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#previewers
local buffer_previewer = function(filepath, bufnr, opts)
    opts = opts or {}
    return previewers.buffer_previewer_maker(filepath, bufnr, opts)
end


-- https://github.com/nvim-telescope/telescope.nvim#pickers
tl.setup {
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
            i = {
                -- fzf-like up/down (remember, can also switch to normal mode and use j/k)
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous
            }
        },
        -- ignore some directory caches with lots of file results
        file_ignore_patterns = {
            '/discogs_cache/', '/feed_giantbomb_cache/', '/feed_tmdb_cache/'
        },
        results_title = false, -- don't show results title
        prompt_title = false, -- don't show prompt title
        file_previewer = previewers.vim_buffer_cat.new,
        buffer_previewer_maker = buffer_previewer,
        preview = {
            check_mime_type = true, -- check mime type before opening previewer
            filesize_limit = 2, -- limit previewer to files under 2MB
            timeout = 500, -- timeout previewer after 500 ms
            treesitter = true -- use treesitter when available
        }
    },
    pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        find_files = {find_command = {"rg", "--files", "--follow"}}
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case" -- or "ignore_case" or "respect_case"
        },
        repo = {
            list = {
                fd_opts = {},
                search_dirs = cached_repo_bases(),
                previewer = false
            }
        }
    }
}

tl.load_extension('fzf')
tl.load_extension('repo')

-- to try:
-- https://github.com/pwntester/octo.nvim

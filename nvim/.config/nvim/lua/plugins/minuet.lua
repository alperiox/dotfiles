return {
    {
        'milanglacier/minuet-ai.nvim',
        event = "InsertLeave",
        config = function()
            vim.o.updatetime = 1500

            require('minuet').setup {
                provider = 'claude',
                api_key = 'ANTHROPIC_API_KEY',

                virtualtext = {
                    auto_trigger_ft = {},
                    keymap = {
                        accept = nil,
                        accept_line = nil,
                        accept_n_lines = nil,
                        prev = nil,
                        next = nil,
                        dismiss = nil,
                    },
                },
            }

            local vt = require('minuet.virtualtext')

            vim.api.nvim_create_autocmd("CursorHold", {
                pattern = { "*.py", "*.lua", "*.c", "*.cpp", "*.toml" },
                callback = function()
                    vt.action.enable_auto_trigger()
                end,
            })

            vim.keymap.set('n', '<A-A>', vt.action.accept, { desc = "Accept completion" })
            vim.keymap.set('n', '<A-a>', vt.action.accept_line, { desc = "Accept line" })
            vim.keymap.set('n', '<A-z>', vt.action.accept_n_lines, { desc = "Accept n lines" })
            vim.keymap.set('n', '<A-]>', vt.action.next, { desc = "Next suggestion" })
            vim.keymap.set('n', '<A-[>', vt.action.prev, { desc = "Prev suggestion" })
            vim.keymap.set('n', '<A-e>', vt.action.dismiss, { desc = "Dismiss" })

            vim.api.nvim_create_autocmd("InsertEnter", {
                callback = function()
                    vt.action.disable_auto_trigger()
                    vt.action.dismiss()
                end,
            })
        end,
    },
    { 'nvim-lua/plenary.nvim' },
}

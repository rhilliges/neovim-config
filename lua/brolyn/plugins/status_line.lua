
return {
    'nvim-lualine/lualine.nvim',
    config = function ()
        local function debugging()
            local status = require'dap'.status()
            if string.find(status, 'Running') then
               return ""
            end
            return ''
        end
        require('lualine').setup({
            options = {
                globalstatus = true
            },
            extensions = { 'nvim-dap-ui' },
            sections = {
                lualine_c = {
                    {
                        'filename',
                        file_status = true, -- displays file status (readonly status, modified status)
                        path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
                    }, {debugging}
                },
                lualine_x = {cwd}
            }
        })
    end
}

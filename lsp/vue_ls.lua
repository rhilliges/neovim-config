-- return {
--   on_init = function(client)
--     client.handlers['tsserver/request'] = function(_, result, context)
--       local ts_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'ts_ls' })
--       local vtsls_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
--       local clients = {}
--
--       vim.list_extend(clients, ts_clients)
--       vim.list_extend(clients, vtsls_clients)
--
--       if #clients == 0 then
--         vim.notify('Could not find `vtsls` or `ts_ls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
--         return
--       end
--       local ts_client = clients[1]
--
--       local param = unpack(result)
--       local id, command, payload = unpack(param)
--       ts_client:exec_cmd({
--         title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
--         command = 'typescript.tsserverRequest',
--         arguments = {
--           command,
--           payload,
--         },
--       }, { bufnr = context.bufnr }, function(_, r)
--           local response = r and r.body
--           -- TODO: handle error or response nil here, e.g. logging
--           -- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
--           local response_data = { { id, response } }
--
--           ---@diagnostic disable-next-line: param-type-mismatch
--           client:notify('tsserver/response', response_data)
--         end)
--     end
--   end,
-- }

return {
  cmd = { 'vue-language-server', '--stdio' },
  filetypes = { 'vue' },
  root_markers = { 'package.json' },
  on_init = function(client)
    local retries = 0

    ---@param _ lsp.ResponseError
    ---@param result any
    ---@param context lsp.HandlerContext
    local function typescriptHandler(_, result, context)
      local ts_client = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'ts_ls' })[1]
        or vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })[1]
        or vim.lsp.get_clients({ bufnr = context.bufnr, name = 'typescript-tools' })[1]

      if not ts_client then
        -- there can sometimes be a short delay until `ts_ls`/`vtsls` are attached so we retry for a few times until it is ready
        if retries <= 10 then
          retries = retries + 1
          vim.defer_fn(function()
            typescriptHandler(_, result, context)
          end, 100)
        else
          vim.notify(
            'Could not find `ts_ls`, `vtsls`, or `typescript-tools` lsp client required by `vue_ls`.',
            vim.log.levels.ERROR
          )
        end
        return
      end

      local param = unpack(result)
      local id, command, payload = unpack(param)
      ts_client:exec_cmd({
        title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
        command = 'typescript.tsserverRequest',
        arguments = {
          command,
          payload,
        },
      }, { bufnr = context.bufnr }, function(_, r)
        local response_data = { { id, r and r.body } }
        ---@diagnostic disable-next-line: param-type-mismatch
        client:notify('tsserver/response', response_data)
      end)
    end

    client.handlers['tsserver/request'] = typescriptHandler
  end,
}

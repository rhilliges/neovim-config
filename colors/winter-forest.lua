vim.o.background = 'dark'

local p = {
  bg0 = '#0E2027',
  bg1 = '#142A33',
  bg2 = '#142A33',
  bg3 = '#142A33',
  bg4 = '#19303A',
  bg5 = '#1D3540',
  fg0 = '#E6F1F3',
  fg1 = '#D3E5E9',
  fg2 = '#B1C7CE',
  fg3 = '#8FADB8',
  accent = '#91D4DF',
  accent2 = '#C5B9E3',
  blue = '#9EC5EE',
  green = '#ADD4B2',
  red = '#EBA5AC',
  yellow = '#E5D2A0',
  purple = '#C5B9E3',
  cyan = '#91D4DF',
  diff_add = '#18352E',
  diff_del = '#352A36',
  diff_change = '#19303A',
  diff_text = '#1D3540',
  sel = '#1D3540',
  match = '#1D3540',
  gsign_add = '#ADD4B2',
  gsign_change = '#E5D2A0',
  gsign_del = '#EBA5AC',
  gsign_untracked = '#B1C7CE',
  indent = '#39535E',
  indent_active = '#8FADB8',
}

require('my-theme').load('winter-forest', p)
vim.api.nvim_set_hl(0, 'NormalNC', { fg = p.fg0, bg = 'NONE' })

vim.g.terminal_color_0 = p.bg0
vim.g.terminal_color_9 = '#F3BDC2'
vim.g.terminal_color_10 = '#C2E5C5'
vim.g.terminal_color_11 = '#F0E1BC'
vim.g.terminal_color_12 = '#B8D7F4'
vim.g.terminal_color_13 = '#D9CEF0'
vim.g.terminal_color_14 = '#B1E4EC'
vim.g.terminal_color_15 = '#F4F9FA'

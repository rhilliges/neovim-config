-- Retro 70s palette inspired by vintage stripe design
---@param background 'dark'|'light'
---@return table
local function palette(background)
  if background == 'light' then
    return {
      bg0 = '#E8D4B0',
      bg1 = '#ECDCC0',
      bg2 = '#F0E4C8',
      bg3 = '#F5EDE0',
      bg4 = '#EAD8B8',
      bg5 = '#E0CCA8',
      fg0 = '#2A2420',
      fg1 = '#3D3530',
      fg2 = '#7D7068',
      fg3 = '#B0A090',
      accent = '#B05533',
      accent2 = '#7D6830',
      blue = '#3A7878',
      green = '#4A6A38',
      red = '#8B2828',
      yellow = '#7D6820',
      purple = '#6A4878',
      cyan = '#3A7878',
      diff_add = '#D4DCC0',
      diff_del = '#E8C8C0',
      diff_change = '#E0D4B8',
      diff_text = '#D8C8A0',
      sel = '#D4C4A0',
      match = '#E0C888',
      gsign_add = '#4A6A38',
      gsign_change = '#A08020',
      gsign_del = '#A03030',
      gsign_untracked = '#7D7068',
      indent = '#D8C8A8',
      indent_active = '#A89878',
    }
  end

  -- dark (retro 70s warm)
  return {
    bg0 = '#1E1A15',
    bg1 = '#242018',
    bg2 = '#2A251D',
    bg3 = '#302A22',
    bg4 = '#3A3428',
    bg5 = '#443D30',
    fg0 = '#E8D4B0',
    fg1 = '#D4C4A0',
    fg2 = '#8A7D68',
    fg3 = '#5A5248',
    accent = '#CC7744',
    accent2 = '#C4A050',
    blue = '#5AABAB',
    green = '#7DA060',
    red = '#B85050',
    yellow = '#C4A855',
    purple = '#A07898',
    cyan = '#5AABAB',
    diff_add = '#2A3020',
    diff_del = '#382420',
    diff_change = '#302A20',
    diff_text = '#4A4030',
    sel = '#443D30',
    match = '#5A4828',
    gsign_add = '#7DA060',
    gsign_change = '#C4A855',
    gsign_del = '#B85050',
    gsign_untracked = '#5A5248',
    indent = '#3A3428',
    indent_active = '#5A5248',
  }
end

return palette

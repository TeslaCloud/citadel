THEME.author = 'TeslaCloud Studios'
THEME.id = 'citadel'
THEME.parent = 'factory'

--- Sets the purple accent colors and the bar text font.
function THEME:on_loaded()
  local accent_color = Color(220, 100, 220)

  self:set_color('accent', accent_color)
  self:set_color('accent_dark', accent_color:darken(20))
  self:set_color('accent_light', accent_color:lighten(20))

  self:set_font('text_bar', self:get_font('main_font'), math.max(math.scale(14), 14), { weight = 600 })
end

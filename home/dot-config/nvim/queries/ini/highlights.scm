; extends

((setting_value) @number
  (#lua-match? @number "^%s*[-]?%d+%s*$"))

; Dates. See systemd.time(7)
((setting_value) @string.special
  (#lua-match? @string.special "^%s*%d+[smhdwMy]%s*$"))

((setting_value) @string.special.path
  (#lua-match? @string.special.path "^%s*~/"))

((setting_value) @boolean
  (#match? @boolean "^ *(true|false|yes|no|on|off) *$"))

; extends

(setting
  (setting_name) @_key
  (setting_value) @injection.content
  (#lua-match? @_key "^Exec")
  (#set! injection.language "bash"))

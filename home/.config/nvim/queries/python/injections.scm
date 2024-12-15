; extends

; sqlite3 module `execute` calls
((call
  function: (attribute
    attribute: (identifier) @_exec)
  arguments: (argument_list
    .
    (string
      (string_content) @injection.content)))
  (#any-of? @_exec "execute" "executemany")
  (#set! injection.language "sql"))

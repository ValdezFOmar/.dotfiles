; extends

; sqlite3 module `execute` calls
(call
  function:
    (attribute
      object: [
               (identifier) @_cur
               ; This allows injecting syntax when connection
               ; is a property, like `self.connection.execute`
               (attribute
                 attribute: (identifier) @_cur)
               ]
      attribute: (identifier) @_exec)
  arguments:
    (argument_list
      .
      (string
        (string_content) @injection.content))
  (#any-of? @_cur "cur" "cursor" "con" "connection")
  (#any-of? @_exec "execute" "executemany")
  (#set! injection.language "sql"))

; Allow injecting sql with a `--sql` comment
(string
  (string_content) @injection.content
  (#match? @injection.content "^[ \n]\*--[ ]\*sql")
  (#set! injection.language "sql"))

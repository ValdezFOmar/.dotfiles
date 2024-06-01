; extends

; bash -c 'ls -Alv'
; /bin/bash -c 'ls -Alv'
((command
  name: (command_name) @_command
  argument: (word) @_arg
  .
  argument: [
    (raw_string) @injection.content
    (concatenation
      (raw_string) @injection.content)
  ])
  (#any-of? @_command "bash" "sh" "/bin/sh" "/bin/bash" "/usr/bin/bash")
  (#eq? @_arg "-c")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "bash"))


(command
  name: (command_name) @_command
  .
  argument: (string
    (string_content) @injection.content)
  (#eq? @_command "bind")
  (#set! injection.language "readline"))

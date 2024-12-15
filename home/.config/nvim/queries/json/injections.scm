; extends

(document
  .
  (object
    (pair
      key: (string
        (string_content) @_key)
      value: (object
        (pair
          value: (string) @injection.content)))
    (#eq? @_key "scripts")
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.include-children)
    (#set! injection.language "bash")))

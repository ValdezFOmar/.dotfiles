; extends

; pre-commit for .pre-commit-config.yml
((block_mapping_pair
  key: (flow_node) @_files
  value: (flow_node
    (plain_scalar
      (string_scalar) @injection.content)))
  (#any-of? @_files "files" "exclude")
  (#set! injection.language "regex"))

((block_mapping_pair
  key: (flow_node) @_files
  value: (block_node
    (block_scalar) @injection.content))
  (#any-of? @_files "files" "exclude")
  (#offset! @injection.content 0 1 0 0)
  (#set! injection.language "regex"))

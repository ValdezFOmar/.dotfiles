; extends

; pre-commit hook url
(block_mapping_pair
  key: (flow_node) @_repo
  value: (flow_node
    (plain_scalar
      (string_scalar) @string.special.url))
  (#eq? @_repo "repo")
  (#not-any-of? @string.special.url "local" "meta"))

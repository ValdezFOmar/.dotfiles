; extends

; pre-commit hook url
(block_mapping_pair
  key: (flow_node) @_repo
  value: (flow_node
    (plain_scalar
      (string_scalar) @string.special.url))
  (#eq? @_repo "repo")
  (#not-any-of? @string.special.url "local" "meta"))

; pre-commit for .pre-commit-config.yml
(block_mapping_pair
  key: (flow_node) @_files
  value: (flow_node
    (plain_scalar
      (string_scalar) @string.regexp))
  (#any-of? @_files "files" "exclude"))

(block_mapping_pair
  key: (flow_node) @_files
  value: (block_node
    (block_scalar) @string.regexp)
  (#any-of? @_files "files" "exclude")
  (#offset! @string.regexp 0 1 0 0))

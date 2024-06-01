; extends

; highlight byte literals different from strings
(string
  (string_start) @_b
  (#lua-match? @_b ".*[bB].*")) @character

; I only have this because the language server
; overrides this highlights in a way that I don't like
; Directly extracted from:
; https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/python/highlights.scm#L59

((decorator
    (identifier) @attribute)
 (#set! "priority" 130))

((decorator
   (attribute
     attribute: (identifier) @attribute))
  (#set! "priority" 130))

((decorator
   (call
     (identifier) @attribute))
  (#set! "priority" 130))

((decorator
   (call
     (attribute
       attribute: (identifier) @attribute)))
  (#set! "priority" 130))

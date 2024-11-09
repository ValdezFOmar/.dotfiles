; This is my own interpretation of regex highlights
(group_name) @property

(pattern_character) @string.regexp

(class_character) @character

(decimal_digits) @number

(any_character) @character.special

[
  (boundary_assertion)
  (character_class_escape)
  (decimal_escape)
  (non_boundary_assertion)
  (posix_character_class)
] @constant.macro

[
  (control_escape)
  (control_letter_escape)
  (identity_escape)
] @string.escape

[
  "*"
  "+"
  "?"
  "|"
  "="
  "!"
] @operator

(character_class
  "^" @operator)

(lazy) @punctuation.special

[
  ","
  "-"
  (start_assertion)
  (end_assertion)
] @punctuation.delimiter

[
  "("
  ")"
  "(?"
  "(?:"
  "(?<"
  ">"
  "["
  "]"
  "{"
  "}"
  "[:"
  ":]"
] @punctuation.bracket

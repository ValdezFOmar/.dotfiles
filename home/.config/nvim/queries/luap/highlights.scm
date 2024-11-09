; My interpretations of lua pattern hightlights, similar to regex captures
(pattern
  (character) @string.regexp)

"." @character.special

(class) @constant.macro

(class
  "%" @string.escape
  (escape_char) @string.escape)

(range
  (character) @character)

(set
  (character) @character)

(negated_set
  (character) @character)

(negated_set
  "^" @operator)

[
  (zero_or_more)
  (shortest_zero_or_more)
  (one_or_more)
  (zero_or_one)
] @operator

[
  "-"
  (anchor_begin)
  (anchor_end)
] @punctuation.delimiter

[
  "["
  "]"
  "("
  ")"
] @punctuation.bracket

(balanced_match
  (character) @variable.parameter)

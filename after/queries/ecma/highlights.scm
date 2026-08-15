;; extends

; Everything here was derived by tokenising the same file with VS Code's own
; TextMate engine, grammar and theme, then diffing against what nvim renders.
; The comment on each rule is the scope VS Code assigns.

; --- imports -----------------------------------------------------------
; variable.other.readwrite.alias -> #e06c75. nvim-treesitter leaves these as
; @variable (grey), or @type (yellow) when the name is capitalised.
; priority 130 keeps them above LSP semantic tokens (125) if those get enabled.

(import_clause
  (identifier) @variable.import
  (#set! priority 130))

(namespace_import
  (identifier) @variable.import
  (#set! priority 130))

(import_specifier
  name: (identifier) @variable.import
  (#set! priority 130))

(import_specifier
  alias: (identifier) @variable.import
  (#set! priority 130))

; --- const bindings ----------------------------------------------------
; meta.definition.variable + variable.other.constant -> #d19a66.
; This is why `const foo` is orange in VS Code while `let foo` stays grey --
; the grammar, not semantic highlighting, makes that distinction.

(lexical_declaration
  "const"
  (variable_declarator
    name: (identifier) @constant))

(lexical_declaration
  "const"
  (variable_declarator
    name: (array_pattern
      (identifier) @constant)))

(lexical_declaration
  "const"
  (variable_declarator
    name: (object_pattern
      (shorthand_property_identifier_pattern) @constant)))

; ...unless the value is a function, in which case the innermost scope is
; entity.name.function -> #61afef. Listed after the rules above so it wins.

(lexical_declaration
  "const"
  (variable_declarator
    name: (identifier) @function
    value: (arrow_function)))

(lexical_declaration
  "const"
  (variable_declarator
    name: (identifier) @function
    value: (function_expression)))

; --- operators ---------------------------------------------------------
; storage.type.function.arrow -> #c678dd, not the cyan of other TS operators
(arrow_function
  "=>" @keyword.function)

; punctuation.separator.key-value -> #56b6c2
(pair
  ":" @operator)

; variable.other.object has no .tsx variant in the theme, so it falls through
; to the bare `variable` rule -> #e06c75
(member_expression
  object: (identifier) @variable.object)

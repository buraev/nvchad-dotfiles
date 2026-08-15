;; extends

; rainbow-parens deliberately drops every JSX rule to avoid colouring tag
; names. VS Code does colour the braces of a JSX expression though, so add
; just those back -- the tag name stays a normal token.
(jsx_expression
  "{" @delimiter
  "}" @delimiter) @container

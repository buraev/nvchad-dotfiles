;; extends

; "source.tsx meta.tag.tsx keyword.operator" -> #abb2bf, so the = inside a JSX
; attribute is plain foreground, unlike the cyan = of a normal assignment
(jsx_attribute
  "=" @punctuation.delimiter)

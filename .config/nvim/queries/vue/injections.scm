;; extends

((element
  (start_tag
    (tag_name) @tag_name
    (attribute
      (attribute_name) @_lang
      (quoted_attribute_value
        (attribute_value) @injection.language)))
  (text) @injection.content)
  (#eq? @_lang "lang")
  (#any-of? @injection.language "yaml" "yml" "json"))

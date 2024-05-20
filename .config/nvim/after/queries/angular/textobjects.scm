((element) @tag.outer)

((tag_name) @tag_name)

(element
  (start_tag)
  .
  (_) @tag.inner
  .
  (end_tag))

((attribute_value) @attribute.inner)

((attribute) @attribute.outer)

((script_element) @tag.outer)

(script_element
  (start_tag)
  .
  (_) @tag.inner
  .
  (end_tag))

(style_element) @tag.outer

(style_element
  (start_tag)
  .
  (_) @tag.inner
  .
  (end_tag))

((comment) @comment.outer)

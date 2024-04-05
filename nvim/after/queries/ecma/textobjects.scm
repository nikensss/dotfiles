; extends
(object
  (pair
    key: (_) @property.key
    value: (_) @property.inner @property.value) @property.outer)

(lexical_declaration
  (variable_declarator 
    name: (_) @lexical_declaration.name
    value: (_) @lexical_declaration.value) @lexical_declaration.inner) @lexical_declaration.outer

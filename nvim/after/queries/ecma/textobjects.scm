; extends
(object
  (pair
    key: (_) @property.key
    value: (_) @property.inner @property.value) @property.outer)

(lexical_declaration) @lexical_declaration.outer

[ (type_annotation)
  (type_alias_declaration
  	name: (_) @type.lhs
    value: (_) @type.rhs)] @type.outer

deferred class
    JSON_TYPE_OBJECT
        -- Type indicator mixin for object types

feature -- Type checking

    is_string: BOOLEAN = False
    is_number: BOOLEAN = False
    is_integer: BOOLEAN = False
    is_real: BOOLEAN = False
    is_boolean: BOOLEAN = False
    is_null: BOOLEAN = False
    is_object: BOOLEAN = True
    is_array: BOOLEAN = False

end

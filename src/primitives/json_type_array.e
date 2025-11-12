deferred class
    JSON_TYPE_ARRAY
        -- Type indicator mixin for array types

feature -- Type checking

    is_string: BOOLEAN = False
    is_number: BOOLEAN = False
    is_integer: BOOLEAN = False
    is_real: BOOLEAN = False
    is_boolean: BOOLEAN = False
    is_null: BOOLEAN = False
    is_object: BOOLEAN = False
    is_array: BOOLEAN = True

end

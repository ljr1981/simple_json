deferred class
    JSON_TYPE_REAL
        -- Type indicator mixin for real number types

feature -- Type checking

    is_string: BOOLEAN = False
    is_number: BOOLEAN = True
    is_integer: BOOLEAN = False
    is_real: BOOLEAN = True
    is_boolean: BOOLEAN = False
    is_null: BOOLEAN = False
    is_object: BOOLEAN = False
    is_array: BOOLEAN = False

end

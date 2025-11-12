deferred class
    JSON_TYPE_NULL
        -- Type indicator mixin for null types

feature -- Type checking

    is_string: BOOLEAN = False
    is_number: BOOLEAN = False
    is_integer: BOOLEAN = False
    is_real: BOOLEAN = False
    is_boolean: BOOLEAN = False
    is_null: BOOLEAN = True
    is_object: BOOLEAN = False
    is_array: BOOLEAN = False

end

deferred class
    JSON_TYPE_DECIMAL
        -- Type indicator mixin for decimal types

feature -- Type checking

    is_string: BOOLEAN = False
    is_number: BOOLEAN = True
    is_integer: BOOLEAN = False
    is_real: BOOLEAN = False
    is_boolean: BOOLEAN = False
    is_null: BOOLEAN = False
    is_object: BOOLEAN = False
    is_array: BOOLEAN = False

end

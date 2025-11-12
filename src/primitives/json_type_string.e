deferred class
    JSON_TYPE_STRING
        -- Type indicator mixin for string types

feature -- Type checking

    is_string: BOOLEAN = True
    is_number: BOOLEAN = False
    is_integer: BOOLEAN = False
    is_real: BOOLEAN = False
    is_boolean: BOOLEAN = False
    is_null: BOOLEAN = False
    is_object: BOOLEAN = False
    is_array: BOOLEAN = False

end

-- Similarly: JSON_TYPE_INTEGER, JSON_TYPE_REAL, JSON_TYPE_BOOLEAN,
--            JSON_TYPE_NULL, JSON_TYPE_OBJECT, JSON_TYPE_ARRAY

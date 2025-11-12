deferred class
    SIMPLE_JSON_PRIMITIVE [G, J -> JSON_VALUE]
        -- Generic wrapper for primitive JSON types
        -- G: The Eiffel primitive type (STRING, INTEGER, BOOLEAN, etc.)
        -- J: The corresponding eJSON type (JSON_STRING, JSON_NUMBER, etc.)

inherit
    SIMPLE_JSON_VALUE

feature {NONE} -- Initialization

    make_from_json (a_json_value: J)
            -- Create from eJSON value
        do
            json_value := a_json_value
        ensure
            set: json_value = a_json_value
        end

feature -- Access

    value: G
            -- The primitive value
        deferred
        end

feature -- Conversion

    to_json_string: STRING
            -- Convert to JSON string representation
        do
            Result := json_value.representation
        end

feature {NONE} -- Implementation

    json_value: J
            -- Underlying eJSON value

invariant
    has_value: attached json_value

end

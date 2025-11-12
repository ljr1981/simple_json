deferred class
    SIMPLE_JSON_NUMERIC

inherit
    SIMPLE_JSON_VALUE

feature -- Access

    to_integer: INTEGER
            -- Convert to integer
        deferred
        end

    to_real: REAL_64
            -- Convert to real
        deferred
        end

    numeric_value: NUMERIC
            -- Generic numeric value
        deferred
        end

feature {NONE} -- Implementation

    json_number: JSON_NUMBER
            -- Underlying eJSON number
        deferred
        end

invariant
    has_number: attached json_number

end

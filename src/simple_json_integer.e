note
    description: "Wrapper for JSON integer values"
    author: "Larry Rix"
    date: "November 12, 2025"
    revision: "2"

class
    SIMPLE_JSON_INTEGER

inherit
    SIMPLE_JSON_PRIMITIVE [INTEGER, JSON_NUMBER]
        redefine
            make_from_json,
            json_value
        end

    SIMPLE_JSON_NUMERIC
        -- No redefine clause needed - json_number is deferred in parent

    JSON_TYPE_INTEGER

create
    make,
    make_from_json

feature {NONE} -- Initialization

    make (a_value: INTEGER)
            -- Create from Eiffel integer
        do
            create json_value.make_integer (a_value)
        end

    make_from_json (a_json_number: JSON_NUMBER)
            -- Create from eJSON JSON_NUMBER
        require else
            is_integer: a_json_number.is_integer
        do
            json_value := a_json_number
        ensure then
            set: json_value = a_json_number
        end

feature -- Access

    value: INTEGER
            -- The integer value
        do
            Result := json_value.integer_64_item.to_integer_32
        end

feature -- Numeric conversions (from SIMPLE_JSON_NUMERIC)

    to_integer: INTEGER
            -- Convert to integer
        do
            Result := value
        end

    to_real: REAL_64
            -- Convert to real
        do
            Result := value.to_double
        end

    numeric_value: NUMERIC
            -- Generic numeric value
        do
            Result := value
        end

feature -- Output

    to_pretty_string (a_indent_level: INTEGER): STRING
            -- <Precursor>
        do
            Result := value.out
        end

feature {NONE} -- Implementation

    json_number: JSON_NUMBER
            -- Underlying eJSON number (effecting deferred feature from SIMPLE_JSON_NUMERIC)
        do
            Result := json_value
        end

    json_value: JSON_NUMBER
            -- Underlying eJSON number (from SIMPLE_JSON_PRIMITIVE)

end

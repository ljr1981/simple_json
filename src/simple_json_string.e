note
    description: "Wrapper for JSON string values"
    author: "Larry Rix"
    date: "November 12, 2025"
    revision: "2"

class
    SIMPLE_JSON_STRING

inherit
    SIMPLE_JSON_PRIMITIVE [STRING, JSON_STRING]
        redefine
            make_from_json
        end
    JSON_TYPE_STRING

create
    make,
    make_from_json

feature {NONE} -- Initialization

    make (a_value: STRING)
            -- Create from Eiffel string
        do
            create json_value.make_from_string (a_value)
        end

    make_from_json (a_json_string: JSON_STRING)
            -- Create from eJSON JSON_STRING
        do
            json_value := a_json_string
        ensure then
            set: json_value = a_json_string
        end

feature -- Access

    value: STRING
            -- The string value
        do
            Result := json_value.unescaped_string_8
        end

feature -- Output

    to_pretty_string (a_indent_level: INTEGER): STRING
            -- <Precursor>
        do
            Result := "%"" + value + "%""
        end

end

note
    description: "Wrapper for JSON null values"
    author: "Larry Rix"
    date: "November 12, 2025"
    revision: "2"

class
    SIMPLE_JSON_NULL

inherit
    SIMPLE_JSON_PRIMITIVE [detachable ANY, JSON_NULL]
        redefine
            make_from_json
        end
    JSON_TYPE_NULL

create
    make,
    make_from_json

feature {NONE} -- Initialization

    make
            -- Create null value
        do
            create json_value
        end

    make_from_json (a_json_null: JSON_NULL)
            -- Create from eJSON JSON_NULL
        do
            json_value := a_json_null
        ensure then
            set: json_value = a_json_null
        end

feature -- Access

    value: detachable ANY
            -- Null has no value
        do
            Result := Void
        end

feature -- Output

    to_pretty_string (a_indent_level: INTEGER): STRING
            -- <Precursor>
        do
            Result := "null"
        end

end

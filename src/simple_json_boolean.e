note
	description: "Wrapper for JSON boolean values"
	author: "Larry Rix"
	date: "November 12, 2025"
	revision: "2"

class
	SIMPLE_JSON_BOOLEAN

inherit
	SIMPLE_JSON_PRIMITIVE [BOOLEAN, JSON_BOOLEAN]
		redefine
			make_from_json
		end
	JSON_TYPE_BOOLEAN

create
	make,
	make_from_json

feature {NONE} -- Initialization

	make (a_value: BOOLEAN)
			-- Create from Eiffel boolean
		do
			create json_value.make (a_value)
		end

	make_from_json (a_json_boolean: JSON_BOOLEAN)
			-- Create from eJSON JSON_BOOLEAN
		do
			json_value := a_json_boolean
		ensure then
			set: json_value = a_json_boolean
		end

feature -- Access

	value: BOOLEAN
			-- The boolean value
		do
			Result := json_value.item
		end

feature -- Output

	to_pretty_string (a_indent_level: INTEGER): STRING
			-- <Precursor>
		do
			if value then
				Result := "true"
			else
				Result := "false"
			end
		end

end

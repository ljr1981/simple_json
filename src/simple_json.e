note
	description: "Simple JSON library - high-level wrapper for eJSON"
	author: "Larry Rix"
	date: "November 11, 2025"
	revision: "1"

class
	SIMPLE_JSON

feature -- Parsing

	parse (a_json_string: STRING): detachable SIMPLE_JSON_OBJECT
			-- Parse JSON string into a SIMPLE_JSON_OBJECT
		require
			not_empty: not a_json_string.is_empty
		local
			l_parser: JSON_PARSER
		do
			create l_parser.make_with_string (a_json_string)
			l_parser.parse_content

			if l_parser.is_parsed and then l_parser.is_valid then
				if attached {JSON_OBJECT} l_parser.parsed_json_value as l_json_obj then
					create Result.make_from_json (l_json_obj)
					last_parse_successful := True
					last_error_message := Void
				else
					last_parse_successful := False
					last_error_message := "JSON root is not an object"
				end
			else
				last_parse_successful := False
				last_error_message := "Invalid JSON format"
			end
		ensure
			success_implies_result: last_parse_successful implies Result /= Void
			failure_implies_void: not last_parse_successful implies Result = Void
			error_message_on_failure: not last_parse_successful implies last_error_message /= Void
		end

feature -- Status Report

	last_parse_successful: BOOLEAN
			-- Was the last parse operation successful?

	last_error_message: detachable STRING
			-- Error message from last failed parse, if any

feature -- Validation

	is_valid_json (a_json_string: STRING): BOOLEAN
			-- Is this a valid JSON string?
		require
			not_empty: not a_json_string.is_empty
		local
			l_parser: JSON_PARSER
		do
			create l_parser.make_with_string (a_json_string)
			l_parser.parse_content
			Result := l_parser.is_parsed and then l_parser.is_valid
		end

end

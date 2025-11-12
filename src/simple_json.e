note
	description: "Simple JSON library with position-tracked error messages"
	author: "Larry Rix"
	date: "November 11, 2025"
	revision: "2"

class
	SIMPLE_JSON

feature -- Parsing

	parse (a_json_string: STRING): detachable SIMPLE_JSON_OBJECT
			-- Parse JSON string into a SIMPLE_JSON_OBJECT
		require
			not_empty: not a_json_string.is_empty
		local
			l_parser: SIMPLE_JSON_PARSER
		do
			create l_parser.make (a_json_string)
			Result := l_parser.parse
			
			if Result /= Void then
				last_parse_successful := True
				last_error_message := Void
			else
				last_parse_successful := False
				last_error_message := l_parser.last_error
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
			l_parser: SIMPLE_JSON_PARSER
		do
			create l_parser.make (a_json_string)
			Result := l_parser.parse /= Void
		end

end

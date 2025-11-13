note
	description: "[
		Simple, high-level API for working with JSON using STRING_32/Unicode/UTF-8.
		This class provides an easy-to-use interface over the Eiffel JSON library.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_JSON

feature -- Parsing

	parse (a_json_text: STRING_32): detachable SIMPLE_JSON_VALUE
			-- Parse JSON text and return a SIMPLE_JSON_VALUE wrapper
		require
			not_empty: not a_json_text.is_empty
		local
			l_parser: JSON_PARSER
			l_utf8: STRING_8
			l_wrapped: STRING_8
			l_array: JSON_ARRAY
		do
			-- Convert STRING_32 to UTF-8 STRING_8 for the parser
			l_utf8 := utf_converter.utf_32_string_to_utf_8_string_8 (a_json_text)
			
			create l_parser.make_with_string (l_utf8)
			l_parser.parse_content
			
			if l_parser.is_valid and then attached l_parser.parsed_json_value as l_value then
				create Result.make (l_value)
			else
				-- Try wrapping in array for primitive values
				-- JSON parser only accepts objects/arrays at top level
				l_wrapped := "[" + l_utf8 + "]"
				create l_parser.make_with_string (l_wrapped)
				l_parser.parse_content
				
				if l_parser.is_valid and then attached l_parser.parsed_json_array as l_arr then
					l_array := l_arr
					if l_array.count = 1 then
						create Result.make (l_array.i_th (1))
					end
				end
			end
		end

	parse_file (a_file_path: STRING_32): detachable SIMPLE_JSON_VALUE
			-- Parse JSON from file and return a SIMPLE_JSON_VALUE wrapper
		require
			not_empty: not a_file_path.is_empty
		local
			l_file: PLAIN_TEXT_FILE
			l_content: STRING_32
		do
			create l_file.make_with_name (a_file_path)
			if l_file.exists and then l_file.is_readable then
				l_file.open_read
				l_file.read_stream (l_file.count)
				l_content := utf_converter.utf_8_string_8_to_string_32 (l_file.last_string)
				l_file.close
				Result := parse (l_content)
			end
		end

	is_valid_json (a_json_text: STRING_32): BOOLEAN
			-- Check if text is valid JSON without creating the value
		require
			not_empty: not a_json_text.is_empty
		local
			l_parser: JSON_PARSER
			l_utf8: STRING_8
			l_wrapped: STRING_8
		do
			l_utf8 := utf_converter.utf_32_string_to_utf_8_string_8 (a_json_text)
			create l_parser.make_with_string (l_utf8)
			l_parser.parse_content
			Result := l_parser.is_valid
			
			if not Result then
				-- Try wrapping in array for primitive values
				l_wrapped := "[" + l_utf8 + "]"
				create l_parser.make_with_string (l_wrapped)
				l_parser.parse_content
				Result := l_parser.is_valid
			end
		end

feature -- Building

	new_object: SIMPLE_JSON_OBJECT
			-- Create a new JSON object builder
		do
			create Result.make
		end

	new_array: SIMPLE_JSON_ARRAY
			-- Create a new JSON array builder
		do
			create Result.make
		end

	string_value (a_string: STRING_32): SIMPLE_JSON_VALUE
			-- Create a JSON string value
		local
			l_json_string: JSON_STRING
		do
			create l_json_string.make_from_string_32 (a_string)
			create Result.make (l_json_string)
		end

	number_value (a_number: DOUBLE): SIMPLE_JSON_VALUE
			-- Create a JSON number value
		local
			l_json_number: JSON_NUMBER
		do
			create l_json_number.make_real (a_number)
			create Result.make (l_json_number)
		end

	integer_value (a_integer: INTEGER_64): SIMPLE_JSON_VALUE
			-- Create a JSON integer value
		local
			l_json_number: JSON_NUMBER
		do
			create l_json_number.make_integer (a_integer)
			create Result.make (l_json_number)
		end

	boolean_value (a_boolean: BOOLEAN): SIMPLE_JSON_VALUE
			-- Create a JSON boolean value
		local
			l_json_boolean: JSON_BOOLEAN
		do
			create l_json_boolean.make (a_boolean)
			create Result.make (l_json_boolean)
		end

	null_value: SIMPLE_JSON_VALUE
			-- Create a JSON null value
		local
			l_json_null: JSON_NULL
		do
			create l_json_null
			create Result.make (l_json_null)
		end

feature {NONE} -- Implementation

	utf_converter: UTF_CONVERTER
			-- UTF conversion utility
		once
			create Result
		end

end

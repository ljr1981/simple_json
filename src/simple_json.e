note
	description: "[
		Simple, high-level API for working with JSON using STRING_32/Unicode/UTF-8.
		This class provides an easy-to-use interface over the Eiffel JSON library.
		Includes comprehensive error tracking with line/column position information.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=JSON Specification", "protocol=URI", "src=https://www.json.org"

class
	SIMPLE_JSON

feature -- Parsing

	parse (a_json_text: STRING_32): detachable SIMPLE_JSON_VALUE
			-- Parse JSON text and return a SIMPLE_JSON_VALUE wrapper.
			-- On error, returns Void and populates `last_errors' with details.
		require
			not_empty: not a_json_text.is_empty
		local
			l_parser: JSON_PARSER
			l_utf8: STRING_8
			l_wrapped: STRING_8
			l_array: JSON_ARRAY
		do
			-- Clear previous errors
			clear_errors
			last_json_text := a_json_text

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
				else
					-- Capture errors from parser
					capture_parser_errors (l_parser, a_json_text)
				end
			end
		ensure
			errors_cleared_on_success: Result /= Void implies not has_errors
		end

	parse_file (a_file_path: STRING_32): detachable SIMPLE_JSON_VALUE
			-- Parse JSON from file and return a SIMPLE_JSON_VALUE wrapper.
			-- On error, returns Void and populates `last_errors' with details.
		require
			not_empty: not a_file_path.is_empty
		local
			l_file: PLAIN_TEXT_FILE
			l_content: STRING_32
		do
			clear_errors

			create l_file.make_with_name (a_file_path)
			if l_file.exists and then l_file.is_readable then
				l_file.open_read
				l_file.read_stream (l_file.count)
				l_content := utf_converter.utf_8_string_8_to_string_32 (l_file.last_string)
				l_file.close
				Result := parse (l_content)
			else
				-- File access error
				add_error (create {SIMPLE_JSON_ERROR}.make ("Cannot read file: " + a_file_path))
			end
		end

	is_valid_json (a_json_text: STRING_32): BOOLEAN
			-- Check if text is valid JSON without creating the value.
			-- On invalid JSON, populates `last_errors' with details.
		require
			not_empty: not a_json_text.is_empty
		local
			l_parser: JSON_PARSER
			l_utf8: STRING_8
			l_wrapped: STRING_8
		do
			clear_errors
			last_json_text := a_json_text

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

				if not Result then
					capture_parser_errors (l_parser, a_json_text)
				end
			end
		ensure
			valid_implies_no_errors: Result implies not has_errors
		end

feature -- Error Tracking

	has_errors: BOOLEAN
			-- Were there errors during the last parse operation?
		do
			Result := not last_errors.is_empty
		ensure
			definition: Result = not last_errors.is_empty
		end

	last_errors: ARRAYED_LIST [SIMPLE_JSON_ERROR]
			-- Errors from the last parse operation
		attribute
			create Result.make (0)
		ensure
			result_not_void: Result /= Void
		end

	error_count: INTEGER
			-- Number of errors from last parse operation
		do
			Result := last_errors.count
		ensure
			definition: Result = last_errors.count
		end

	first_error: detachable SIMPLE_JSON_ERROR
			-- First error from last parse operation, if any
		do
			if not last_errors.is_empty then
				Result := last_errors.first
			end
		ensure
			has_error_implies_result: has_errors implies Result /= Void
			no_error_implies_void: not has_errors implies Result = Void
		end

	errors_as_string: STRING_32
			-- All errors formatted as a single string
		do
			create Result.make_empty
			across
				last_errors as ic
			loop
				if not Result.is_empty then
					Result.append ("%N")
				end
				Result.append (ic.to_string_with_position)
			end
		ensure
			result_not_void: Result /= Void
		end

	detailed_errors: STRING_32
			-- All errors with detailed position information
		do
			create Result.make_empty
			across
				last_errors as ic
			loop
				if not Result.is_empty then
					Result.append ("%N%N")
				end
				Result.append ("Error ")
				Result.append (ic.out)
				Result.append (":")
				Result.append ("%N")
				Result.append (ic.to_detailed_string)
			end
		ensure
			result_not_void: Result /= Void
		end

	clear_errors
			-- Clear all error information
		do
			last_errors.wipe_out
		ensure
			no_errors: not has_errors
			empty_list: last_errors.is_empty
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

	last_json_text: detachable STRING_32
			-- The JSON text from the last parse operation (for error position calculation)

	add_error (a_error: SIMPLE_JSON_ERROR)
			-- Add an error to the error list
		require
			error_not_void: a_error /= Void
		do
			last_errors.force (a_error)
		ensure
			error_added: last_errors.has (a_error)
			has_errors: has_errors
		end

	capture_parser_errors (a_parser: JSON_PARSER; a_json_text: STRING_32)
			-- Capture errors from JSON_PARSER and convert to structured errors
		require
			parser_not_void: a_parser /= Void
			json_text_not_void: a_json_text /= Void
		local
			l_error: SIMPLE_JSON_ERROR
			l_error_text: STRING_32
			l_position: INTEGER
		do
			across
				a_parser.errors as ic
			loop
				-- Parse error string which is in format: "message (position: N)"
				l_error_text := create {STRING_32}.make_from_string (ic)
				l_position := extract_position_from_error (l_error_text)

				if l_position > 0 then
					-- Create error with position information
					create l_error.make_with_position (
						remove_position_from_message (l_error_text),
						a_json_text,
						l_position
					)
				else
					-- Create error without position
					create l_error.make (l_error_text)
				end

				add_error (l_error)
			end
		end

	extract_position_from_error (a_error_text: STRING_32): INTEGER
			-- Extract position number from error text like "message (position: 42)"
		require
			error_text_not_void: a_error_text /= Void
		local
			l_pos_start: INTEGER
			l_pos_end: INTEGER
			l_pos_string: STRING_32
		do
			-- Look for "(position: N)"
			l_pos_start := a_error_text.substring_index ("(position: ", 1)
			if l_pos_start > 0 then
				l_pos_start := l_pos_start + 11  -- Length of "(position: "
				l_pos_end := a_error_text.index_of (')', l_pos_start)
				if l_pos_end > l_pos_start then
					l_pos_string := a_error_text.substring (l_pos_start, l_pos_end - 1)
					l_pos_string.left_adjust
					l_pos_string.right_adjust
					if l_pos_string.is_integer then
						Result := l_pos_string.to_integer
					end
				end
			end
		ensure
			non_negative: Result >= 0
		end

	remove_position_from_message (a_error_text: STRING_32): STRING_32
			-- Remove " (position: N)" from error message
		require
			error_text_not_void: a_error_text /= Void
		local
			l_pos_start: INTEGER
		do
			l_pos_start := a_error_text.substring_index (" (position: ", 1)
			if l_pos_start > 0 then
				Result := a_error_text.substring (1, l_pos_start - 1)
			else
				Result := a_error_text.twin
			end
		ensure
			result_not_void: Result /= Void
		end

	utf_converter: UTF_CONVERTER
			-- UTF conversion utility
		once
			create Result
		end

end

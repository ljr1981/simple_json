note
	description: "Fluent builder for constructing JSON objects"
	author: "Larry Rix"
	date: "November 11, 2025"
	revision: "1"

class
	JSON_BUILDER

create
	make

feature {NONE} -- Initialization

	make
			-- Create new builder
		do
			create json_object.make_empty
		end

feature -- Building

	put_string (a_key: STRING; a_value: STRING): JSON_BUILDER
			-- Add string value (fluent interface)
		require
			not_empty_key: not a_key.is_empty
		do
			json_object.put_string (a_key, a_value)
			Result := Current
		ensure
			returns_self: Result = Current
		end

	put_integer (a_key: STRING; a_value: INTEGER): JSON_BUILDER
			-- Add integer value (fluent interface)
		require
			not_empty_key: not a_key.is_empty
		do
			json_object.put_integer (a_key, a_value)
			Result := Current
		ensure
			returns_self: Result = Current
		end

	put_boolean (a_key: STRING; a_value: BOOLEAN): JSON_BUILDER
			-- Add boolean value (fluent interface)
		require
			not_empty_key: not a_key.is_empty
		do
			json_object.put_boolean (a_key, a_value)
			Result := Current
		ensure
			returns_self: Result = Current
		end

	put_real (a_key: STRING; a_value: REAL_64): JSON_BUILDER
			-- Add real value (fluent interface)
		require
			not_empty_key: not a_key.is_empty
		do
			json_object.put_real (a_key, a_value)
			Result := Current
		ensure
			returns_self: Result = Current
		end

feature -- Output

	to_string: STRING
			-- Convert to JSON string
		do
			Result := json_object.to_json_string
		ensure
			result_not_void: Result /= Void
		end

	build: SIMPLE_JSON_OBJECT
			-- Get the underlying JSON object
		do
			Result := json_object
		ensure
			result_not_void: Result /= Void
		end

feature {NONE} -- Implementation

	json_object: SIMPLE_JSON_OBJECT
			-- The object being built

end

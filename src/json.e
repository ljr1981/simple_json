note
	description: "[
		Comprehensive JSON facade providing multiple levels of abstraction:
		- One-liner access: JSON.string(json, "key")
		- Path navigation: JSON.path_string(json, "user.address.city")
		- Building: JSON.build.put("name", "Alice").to_string
		- Queries: JSON.query(json).string("user.name")
		- Full API: JSON.parse(json) for complex manipulation
	]"
	author: "Larry Rix"
	date: "November 11, 2025"
	revision: "1"
	EIS: "name=SIMPLE_JSON Use Cases Library",
		 "src=file:///${SYSTEM_PATH}/docs/use-cases/index.html",
		 "protocol=uri",
		 "tag=documentation, use-cases, overview"
	EIS: "name=Quick Start Guide",
		 "src=file:///${SYSTEM_PATH}/docs/quick-start.html",
		 "protocol=uri",
		 "tag=documentation, quick-start, beginner"

class
	JSON

feature -- Quick Parse & Access (One-liners)

	string (a_json_string: STRING; a_key: STRING): detachable STRING
		note
			description: "Parse JSON and extract string value in a single operation"
			detail: "[
				Provides the simplest possible interface for extracting a string value from JSON.
				...existing text...
			]"
			examples: "[
				...existing examples...
			]"
			EIS: "name=Use Case: Quick Value Extraction",
				 "src=file:///${SYSTEM_PATH}/docs/use-cases/quick-extraction.html",
				 "protocol=uri",
				 "tag=use-case, quick-start, parsing, beginner"
		require
			not_empty_json: not a_json_string.is_empty
			not_empty_key: not a_key.is_empty
		do
			if attached parse (a_json_string) as obj then
				Result := obj.string (a_key)
			end
		end

	integer (a_json_string: STRING; a_key: STRING): INTEGER
		note
			description: "Parse JSON and extract integer value in a single operation"
			detail: "[
					Provides one-line access to integer values in JSON.
					Returns 0 if the key doesn't exist or the value isn't a number.
					Handles both pure integers and numbers with .0 decimal notation.
				]"
			examples: "[
					-- Basic usage
					json_text := "{\"age\": 30, \"count\": 100}"
					age := json.integer (json_text, "age")      -- Returns 30
					count := json.integer (json_text, "count")  -- Returns 100
					
					-- Missing key returns zero
					score := json.integer (json_text, "score")  -- Returns 0
				]"
		require
			not_empty_json: not a_json_string.is_empty
			not_empty_key: not a_key.is_empty
		do
			if attached parse (a_json_string) as obj then
				Result := obj.integer (a_key)
			end
		end

	boolean (a_json_string: STRING; a_key: STRING): BOOLEAN
		note
			description: "Parse JSON and extract boolean value in a single operation"
			detail: "[
					Provides one-line access to boolean values in JSON.
					Returns False if the key doesn't exist or the value isn't a boolean.
					Useful for checking flags and settings in JSON configuration.
				]"
			examples: "[
					-- Boolean extraction
					json_text := "{\"active\": true, \"deleted\": false}"
					is_active := json.boolean (json_text, "active")    -- Returns True
					is_deleted := json.boolean (json_text, "deleted")  -- Returns False
					
					-- Missing key returns False
					is_verified := json.boolean (json_text, "verified")  -- Returns False
				]"
		require
			not_empty_json: not a_json_string.is_empty
			not_empty_key: not a_key.is_empty
		do
			if attached parse (a_json_string) as obj then
				Result := obj.boolean (a_key)
			end
		end

	real (a_json_string: STRING; a_key: STRING): REAL_64
		note
			description: "Parse JSON and extract real/double value in a single operation"
			detail: "[
					Provides one-line access to floating-point numbers in JSON.
					Returns 0.0 if the key doesn't exist or the value isn't a number.
					Handles decimal numbers, negative values, and automatic conversion from integers.
				]"
			examples: "[
					-- Decimal number extraction
					json_text := "{\"price\": 19.99, \"temperature\": -5.5}"
					price := json.real (json_text, "price")          -- Returns 19.99
					temp := json.real (json_text, "temperature")     -- Returns -5.5
					
					-- Integer to real conversion
					json_text := "{\"count\": 42}"
					value := json.real (json_text, "count")  -- Returns 42.0 (automatic conversion)
				]"
		require
			not_empty_json: not a_json_string.is_empty
			not_empty_key: not a_key.is_empty
		do
			if attached parse (a_json_string) as obj then
				Result := obj.real (a_key)
			end
		end

feature -- Path-Based Access (Navigate nested structures)

	path_string (a_json_string: STRING; a_path: STRING): detachable STRING
		note
			description: "Navigate nested JSON structure using dot notation to extract string value"
			detail: "[
					Provides intuitive navigation of deeply nested JSON structures using a simple path syntax.
					Use dots to separate levels: 'user.address.city' navigates three levels deep.
					Returns Void if any part of the path doesn't exist or if the final value isn't a string.
					Eliminates the need for multiple if-attached checks when accessing nested data.
				]"
			examples: "[
					-- Navigate nested structure
					json_text := "{\"user\": {\"address\": {\"city\": \"NYC\", \"state\": \"NY\"}}}"
					city := json.path_string (json_text, "user.address.city")    -- Returns "NYC"
					state := json.path_string (json_text, "user.address.state")  -- Returns "NY"

					-- Path not found returns Void
					country := json.path_string (json_text, "user.address.country")  -- Returns Void

					-- Complex real-world example
					json_text := "{\"company\": {\"employee\": {\"contact\": {\"email\": \"bob@example.com\"}}}}"
					email := json.path_string (json_text, "company.employee.contact.email")  -- Returns "bob@example.com"
				]"
			EIS: "name=Use Case: Path Navigation for Nested Structures",
			 "src=file:///${SYSTEM_PATH}/docs/use-cases/path-navigation.html#use-case-path-navigation",
			 "protocol=uri",
			 "tag=use-case, nested, path, advanced"
		require
			not_empty_json: not a_json_string.is_empty
			not_empty_path: not a_path.is_empty
		do
			if attached parse (a_json_string) as obj then
				Result := navigate_to_string (obj, a_path)
			end
		end

	path_integer (a_json_string: STRING; a_path: STRING): INTEGER
		note
			description: "Navigate nested JSON structure using dot notation to extract integer value"
			detail: "[
					Navigates through multiple levels of JSON objects to retrieve an integer value.
					Uses dot notation for intuitive path specification.
					Returns 0 if the path doesn't exist or the final value isn't a number.
				]"
			examples: "[
					-- Navigate to nested integer
					json_text := "{\"company\": {\"location\": {\"zip\": 10001, \"floor\": 5}}}"
					zip := json.path_integer (json_text, "company.location.zip")      -- Returns 10001
					floor := json.path_integer (json_text, "company.location.floor")  -- Returns 5
				]"
			EIS: "name=Use Case: Path Navigation",
			 "src=file:///${SYSTEM_PATH}/docs/use-cases/path-navigation.html#use-case-path-navigation",
			 "protocol=uri",
			 "tag=use-case, nested, path"
		require
			not_empty_json: not a_json_string.is_empty
			not_empty_path: not a_path.is_empty
		do
			if attached parse (a_json_string) as obj then
				Result := navigate_to_integer (obj, a_path)
			end
		end

	path_boolean (a_json_string: STRING; a_path: STRING): BOOLEAN
		note
			description: "Navigate nested JSON structure using dot notation to extract boolean value"
			detail: "[
					Navigates through nested objects to retrieve a boolean value.
					Perfect for accessing deeply nested configuration flags or settings.
					Returns False if the path doesn't exist or the final value isn't a boolean.
				]"
			examples: "[
					-- Access nested settings
					json_text := "{\"settings\": {\"notifications\": {\"email\": true, \"sms\": false}}}"
					email_enabled := json.path_boolean (json_text, "settings.notifications.email")  -- Returns True
					sms_enabled := json.path_boolean (json_text, "settings.notifications.sms")      -- Returns False
				]"
			EIS: "name=Use Case: Path Navigation",
			 "src=file:///${SYSTEM_PATH}/docs/use-cases/path-navigation.html#use-case-path-navigation",
			 "protocol=uri",
			 "tag=use-case, nested, path"
		require
			not_empty_json: not a_json_string.is_empty
			not_empty_path: not a_path.is_empty
		do
			if attached parse (a_json_string) as obj then
				Result := navigate_to_boolean (obj, a_path)
			end
		end

	path_real (a_json_string: STRING; a_path: STRING): REAL_64
		note
			description: "Navigate nested JSON structure using dot notation to extract real value"
			detail: "[
					Navigates through nested objects to retrieve a floating-point number.
					Useful for extracting metrics, measurements, or calculated values from nested structures.
					Returns 0.0 if the path doesn't exist or the final value isn't a number.
				]"
			examples: "[
					-- Access nested metrics
					json_text := "{\"data\": {\"metrics\": {\"score\": 98.5, \"average\": 85.2}}}"
					score := json.path_real (json_text, "data.metrics.score")      -- Returns 98.5
					average := json.path_real (json_text, "data.metrics.average")  -- Returns 85.2
				]"
			EIS: "name=Use Case: Path Navigation",
			 "src=file:///${SYSTEM_PATH}/docs/use-cases/path-navigation.html#use-case-path-navigation",
			 "protocol=uri",
			 "tag=use-case, nested, path"
		require
			not_empty_json: not a_json_string.is_empty
			not_empty_path: not a_path.is_empty
		do
			if attached parse (a_json_string) as obj then
				Result := navigate_to_real (obj, a_path)
			end
		end

	path_exists (a_json_string: STRING; a_path: STRING): BOOLEAN
		note
			description: "Check if a path exists in nested JSON structure"
			detail: "[
					Validates whether a complete path exists in the JSON structure before accessing it.
					Useful for conditional logic based on the presence of optional fields.
					Returns True only if every level of the path exists and is accessible.
				]"
			examples: "[
					-- Check optional fields
					json_text := "{\"user\": {\"name\": \"Alice\", \"age\": 30}}"
					has_name := json.path_exists (json_text, "user.name")     -- Returns True
					has_email := json.path_exists (json_text, "user.email")   -- Returns False
					
					-- Conditional access
					if json.path_exists (json_text, "user.profile.avatar") then
						avatar := json.path_string (json_text, "user.profile.avatar")
					end
				]"
			EIS: "name=Use Case: Path Navigation - Conditional Access",
			 "src=file:///${SYSTEM_PATH}/docs/use-cases/path-navigation.html#conditional-access",
			 "protocol=uri",
			 "tag=use-case, validation, path"
		require
			not_empty_json: not a_json_string.is_empty
			not_empty_path: not a_path.is_empty
		do
			if attached parse (a_json_string) as obj then
				Result := path_exists_in_object (obj, a_path)
			end
		end

feature -- Building (Fluent Interface)

	build: JSON_BUILDER
		note
			description: "Create a fluent builder for constructing JSON objects programmatically"
			detail: "[
					Returns a JSON_BUILDER that provides a chainable interface for building JSON.
					Each put_* method returns the builder itself, allowing method chaining.
					Call to_string to get the final JSON representation, or build to get the SIMPLE_JSON_OBJECT.
					This is the preferred way to construct JSON programmatically.
				]"
			examples: "[
					-- Build simple JSON
					json_string := json.build
						.put_string ("name", "Alice")
						.put_integer ("age", 30)
						.put_boolean ("active", True)
						.to_string
					-- Results in: {\"name\":\"Alice\",\"age\":30,\"active\":true}
					
					-- Build and get object for further manipulation
					obj := json.build
						.put_string ("status", "pending")
						.put_integer ("count", 0)
						.build
					obj.put_real ("score", 95.5)  -- Continue modifying
				]"
			EIS: "name=Use Case: Building JSON Programmatically",
				 "src=file:///${SYSTEM_PATH}/docs/use-cases/building-json.html#solution-builder",
				 "protocol=uri",
				 "tag=use-case, building, fluent, beginner"
			EIS: "name=Complete Example: API Request Builder",
				 "src=file:///${SYSTEM_PATH}/docs/use-cases/building-json.html#complete-example-api",
				 "protocol=uri",
				 "tag=example, api, building"
		do
			create Result.make
		ensure
			builder_created: attached Result
		end

	object: SIMPLE_JSON_OBJECT
		note
			description: "Create an empty JSON object for manual construction"
			detail: "[
					Creates a new, empty SIMPLE_JSON_OBJECT that can be populated manually.
					Use this when you need full control over object construction or when the builder
					pattern doesn't fit your use case. The object provides put_* methods for adding
					key-value pairs and to_json_string for serialization.
				]"
			examples: "[
					-- Manual object construction
					obj := json.object
					obj.put_string ("name", "Bob")
					obj.put_integer ("age", 25)
					json_string := obj.to_json_string
					
					-- Conditional construction
					obj := json.object
					if include_email then
						obj.put_string ("email", user_email)
					end
				]"
			EIS: "name=Use Case: Building JSON with Object API",
				 "src=file:///${SYSTEM_PATH}/docs/use-cases/building-json.html#solution-object",
				 "protocol=uri",
				 "tag=use-case, building, conditional, intermediate"
			EIS: "name=Pattern: Updating Existing JSON",
				 "src=file:///${SYSTEM_PATH}/docs/use-cases/building-json.html#updating-existing",
				 "protocol=uri",
				 "tag=pattern, modification"
		do
			create Result.make_empty
		ensure
			object_created: attached Result
		end

	array: SIMPLE_JSON_ARRAY
		note
			description: "Create an empty JSON array"
			detail: "[
					Creates a new, empty SIMPLE_JSON_ARRAY for constructing array structures.
					Currently provides read-only access (you can populate it from parsed JSON).
					Future versions may add array building capabilities.
				]"
			examples: "[
					-- Create empty array (typically for future population)
					arr := json.array
					-- Future: arr.add_string(\"value1\")
				]"
		do
			create Result.make_empty
		ensure
			array_created: attached Result
		end

feature -- Query Interface

	query (a_json_string: STRING): JSON_QUERY
		note
			description: "Create a query object for exploring and extracting from JSON"
			detail: "[
					Returns a JSON_QUERY object that provides a clean interface for multiple extractions
					from the same JSON string. Parse once, query many times. Useful when you need to
					extract multiple values from a JSON document and want to avoid repeated parsing.
				]"
			examples: "[
					-- Parse once, query multiple times
					json_text := "{\"name\": \"Charlie\", \"age\": 35, \"active\": true}"
					q := json.query (json_text)
					name := q.string ("name")      -- \"Charlie\"
					age := q.integer ("age")       -- 35
					active := q.boolean ("active") -- True
					
					-- Check existence before extraction
					if q.exists ("email") then
						email := q.string ("email")
					end
				]"
			EIS: "name=Use Case: Query Interface for Multiple Extractions",
				 "src=file:///${SYSTEM_PATH}/docs/use-cases/query-interface.html#use-case-query-interface",
				 "protocol=uri",
				 "tag=use-case, performance, multiple-values, intermediate"
			EIS: "name=Performance Comparison: Query vs One-Liners",
				 "src=file:///${SYSTEM_PATH}/docs/use-cases/query-interface.html#advantages",
				 "protocol=uri",
				 "tag=performance, best-practice"
		require
			not_empty: not a_json_string.is_empty
		do
			create Result.make (a_json_string)
		ensure
			query_created: attached Result
		end

feature -- File Operations

	from_file (a_path: STRING): detachable SIMPLE_JSON_OBJECT
		note
			description: "Load and parse JSON from a file"
			detail: "[
					Reads the entire file, parses it as JSON, and returns the resulting object.
					Returns Void if the file doesn't exist, isn't readable, or contains invalid JSON.
					Handles file I/O errors gracefully - check for Void result to detect problems.
				]"
			examples: "[
					-- Load configuration from file
					config := json.from_file (\"config.json\")
					if attached config as cfg then
						host := cfg.string (\"host\")
						port := cfg.integer (\"port\")
					else
						-- File not found or invalid JSON
					end
				]"
		require
			not_empty_path: not a_path.is_empty
		local
			l_file: PLAIN_TEXT_FILE
			l_content: STRING
		do
			create l_file.make_with_name (a_path)
			if l_file.exists and then l_file.is_readable then
				l_file.open_read
				l_file.read_stream (l_file.count)
				l_content := l_file.last_string
				l_file.close
				Result := parse (l_content)
			end
		end

	to_file (a_json_object: SIMPLE_JSON_OBJECT; a_path: STRING)
		note
			description: "Write JSON object to a file"
			detail: "[
					Serializes the JSON object to a string and writes it to the specified file.
					Creates the file if it doesn't exist, overwrites if it does.
					Useful for saving configuration, persisting data, or exporting results.
				]"
			examples: "[
					-- Save configuration to file
					config := json.object
					config.put_string (\"host\", \"localhost\")
					config.put_integer (\"port\", 8080)
					json.to_file (config, \"config.json\")
					
					-- Export data
					data := json.build
						.put_string (\"timestamp\", current_time)
						.put_integer (\"count\", record_count)
						.build
					json.to_file (data, \"export.json\")
				]"
		require
			not_empty_path: not a_path.is_empty
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (a_path)
			l_file.put_string (a_json_object.to_json_string)
			l_file.close
		end

feature -- Validation

	is_valid (a_json_string: STRING): BOOLEAN
		note
			description: "Quick validation check for JSON syntax"
			detail: "[
					Performs a fast syntax check without full parsing or data extraction.
					Returns True if the string is well-formed JSON, False otherwise.
					Use this before parsing when you need to validate user input or external data.
				]"
			examples: "[
					-- Validate before parsing
					user_input := get_user_input
					if json.is_valid (user_input) then
						obj := json.parse (user_input)
						-- Process valid JSON
					else
						show_error (\"Invalid JSON format\")
					end
					
					-- Quick checks
					json.is_valid (\"{}\")                    -- True (empty object)
					json.is_valid (\"{\"key\": \"value\"}\")  -- True
					json.is_valid (\"{invalid}\")             -- False
				]"
			EIS: "name=Use Case: JSON Validation",
				 "src=file:///${SYSTEM_PATH}/docs/use-cases/validation.html#solution-simple",
				 "protocol=uri",
				 "tag=use-case, validation, security, beginner"
			EIS: "name=When to Validate - Best Practices",
				 "src=file:///${SYSTEM_PATH}/docs/use-cases/validation.html#when-to-validate",
				 "protocol=uri",
				 "tag=best-practice, security"
		require
			not_empty: not a_json_string.is_empty
		do
			Result := internal_parser.is_valid_json (a_json_string)
		end

	validate (a_json_string: STRING): TUPLE [valid: BOOLEAN; error: detachable STRING]
		note
			description: "Validate JSON and get detailed error information"
			detail: "[
					Attempts to parse the JSON and returns both a validity flag and error message.
					The tuple contains: [valid: BOOLEAN, error: detachable STRING]
					If valid is True, error will be Void. If False, error contains diagnostic information.
					Use this when you need to provide detailed feedback about JSON syntax problems.
				]"
			examples: "[
					-- Get detailed validation feedback
					result := json.validate (user_input)
					if result.valid then
						-- Process valid JSON
						obj := json.parse (user_input)
					else
						-- Show specific error to user
						if attached result.error as err then
							log_error (\"JSON parsing failed: \" + err)
						end
					end
				]"
			EIS: "name=Use Case: Detailed Validation with Error Messages",
				 "src=file:///${SYSTEM_PATH}/docs/use-cases/validation.html#solution-detailed",
				 "protocol=uri",
				 "tag=use-case, validation, error-handling"
			EIS: "name=Complete Example: File Upload Validator",
				 "src=file:///${SYSTEM_PATH}/docs/use-cases/validation.html#complete-example",
				 "protocol=uri",
				 "tag=example, validation, real-world"
		require
			not_empty: not a_json_string.is_empty
		local
			l_obj: detachable SIMPLE_JSON_OBJECT
		do
			l_obj := internal_parser.parse (a_json_string)
			Result := [internal_parser.last_parse_successful, internal_parser.last_error_message]
		end

feature -- Full API Access (For complex cases)

	parse (a_json_string: STRING): detachable SIMPLE_JSON_OBJECT
		note
			description: "Parse JSON string and return full object for complex manipulation"
			detail: "[
					The foundation method - all other convenience methods build on this.
					Returns a SIMPLE_JSON_OBJECT that provides complete access to the JSON structure.
					Use this when you need full control, complex manipulation, or when the convenience
					methods don't provide enough flexibility. Returns Void for invalid JSON.
				]"
			examples: "[
					-- Full API access
					obj := json.parse (\"{\"name\": \"Alice\", \"age\": 30}\")
					if attached obj as o then
						-- Read values
						name := o.string (\"name\")
						
						-- Modify object
						o.put_string (\"email\", \"alice@example.com\")
						o.put_boolean (\"verified\", True)
						
						-- Navigate nested structures
						if attached o.object (\"address\") as addr then
							city := addr.string (\"city\")
						end
						
						-- Serialize back to JSON
						json_string := o.to_json_string
					end
				]"
			EIS: "name=Use Case: Error Handling - Parse Failures",
				 "src=file:///${SYSTEM_PATH}/docs/use-cases/error-handling.html#error-scenarios",
				 "protocol=uri",
				 "tag=use-case, error-handling, parsing"
			EIS: "name=Error Handling: Robust API Client Example",
				 "src=file:///${SYSTEM_PATH}/docs/use-cases/error-handling.html#complete-example",
				 "protocol=uri",
				 "tag=example, error-handling, production"
		require
			not_empty: not a_json_string.is_empty
		do
			Result := internal_parser.parse (a_json_string)
		end

	last_error: detachable STRING
		note
			description: "Get the last error message from a parsing operation"
			detail: "[
					Returns the error message from the most recent parse operation, if any.
					Returns Void if the last parse was successful.
					Useful for debugging or logging when parse returns Void.
				]"
			examples: "[
					-- Diagnose parsing failures
					obj := json.parse (user_input)
					if obj = Void then
						if attached json.last_error as err then
							log_error (\"Parse failed: \" + err)
						end
					end
				]"
			EIS: "name=Use Case: Error Handling Patterns",
				 "src=file:///${SYSTEM_PATH}/docs/use-cases/error-handling.html#use-case-error-handling",
				 "protocol=uri",
				 "tag=use-case, error-handling, debugging"
			EIS: "name=Pattern: Parse-Check-Extract",
				 "src=file:///${SYSTEM_PATH}/docs/use-cases/error-handling.html#patterns",
				 "protocol=uri",
				 "tag=pattern, error-handling"
		do
			Result := internal_parser.last_error_message
		end

feature {NONE} -- Path Navigation Implementation

	navigate_to_string (a_object: SIMPLE_JSON_OBJECT; a_path: STRING): detachable STRING
			-- Navigate path and return string value
		local
			l_parts: LINKED_LIST [STRING]
			l_current: detachable SIMPLE_JSON_OBJECT
			l_part: STRING
		do
			l_parts := split_path (a_path)
			l_current := a_object

			from
				l_parts.start
			until
				l_parts.after or l_current = Void
			loop
				l_part := l_parts.item

				if l_parts.islast then
						-- Last element - get value
					Result := l_current.string (l_part)
				else
						-- Navigate deeper
					l_current := l_current.object (l_part)
				end

				l_parts.forth
			end
		end

	navigate_to_integer (a_object: SIMPLE_JSON_OBJECT; a_path: STRING): INTEGER
			-- Navigate path and return integer value
		local
			l_parts: LINKED_LIST [STRING]
			l_current: detachable SIMPLE_JSON_OBJECT
			l_part: STRING
		do
			l_parts := split_path (a_path)
			l_current := a_object

			from
				l_parts.start
			until
				l_parts.after or l_current = Void
			loop
				l_part := l_parts.item

				if l_parts.islast then
					Result := l_current.integer (l_part)
				else
					l_current := l_current.object (l_part)
				end

				l_parts.forth
			end
		end

	navigate_to_boolean (a_object: SIMPLE_JSON_OBJECT; a_path: STRING): BOOLEAN
			-- Navigate path and return boolean value
		local
			l_parts: LINKED_LIST [STRING]
			l_current: detachable SIMPLE_JSON_OBJECT
			l_part: STRING
		do
			l_parts := split_path (a_path)
			l_current := a_object

			from
				l_parts.start
			until
				l_parts.after or l_current = Void
			loop
				l_part := l_parts.item

				if l_parts.islast then
					Result := l_current.boolean (l_part)
				else
					l_current := l_current.object (l_part)
				end

				l_parts.forth
			end
		end

	navigate_to_real (a_object: SIMPLE_JSON_OBJECT; a_path: STRING): REAL_64
			-- Navigate path and return real value
		local
			l_parts: LINKED_LIST [STRING]
			l_current: detachable SIMPLE_JSON_OBJECT
			l_part: STRING
		do
			l_parts := split_path (a_path)
			l_current := a_object

			from
				l_parts.start
			until
				l_parts.after or l_current = Void
			loop
				l_part := l_parts.item

				if l_parts.islast then
					Result := l_current.real (l_part)
				else
					l_current := l_current.object (l_part)
				end

				l_parts.forth
			end
		end

	path_exists_in_object (a_object: SIMPLE_JSON_OBJECT; a_path: STRING): BOOLEAN
			-- Check if path exists in object
		local
			l_parts: LINKED_LIST [STRING]
			l_current: detachable SIMPLE_JSON_OBJECT
			l_part: STRING
		do
			l_parts := split_path (a_path)
			l_current := a_object
			Result := True

			from
				l_parts.start
			until
				l_parts.after or not Result
			loop
				l_part := l_parts.item

				if l_parts.islast then
					if attached l_current as curr then
						Result := curr.has_key (l_part)
					else
						Result := False
					end
				else
					if attached l_current as curr then
						l_current := curr.object (l_part)
						if l_current = Void then
							Result := False
						end
					else
						Result := False
					end
				end

				l_parts.forth
			end
		end

	split_path (a_path: STRING): LINKED_LIST [STRING]
			-- Split path by '.' separator
			-- Example: "user.address.city" -> ["user", "address", "city"]
		local
			l_current: STRING
			i: INTEGER
		do
			create Result.make
			create l_current.make_empty

			from
				i := 1
			until
				i > a_path.count
			loop
				if a_path [i] = '.' then
					if not l_current.is_empty then
						Result.extend (l_current.twin)
						create l_current.make_empty
					end
				else
					l_current.append_character (a_path [i])
				end
				i := i + 1
			end

				-- Add last part
			if not l_current.is_empty then
				Result.extend (l_current)
			end
		ensure
			result_not_void: attached Result
		end

feature {NONE} -- Implementation

	internal_parser: SIMPLE_JSON
			-- Internal parser instance
		once
			create Result
		end

end

note
	description: "Tests for SIMPLE_JSON"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"
	testing: "covers"

class
	LIB_TESTS

inherit
	TEST_SET_BASE

feature -- Test: Parsing

	test_parse_object
			-- Test parsing JSON object.
		note
			testing: "covers/{SIMPLE_JSON}.parse"
		local
			json: SIMPLE_JSON
		do
			create json
			if attached json.parse ("{%"name%": %"Alice%", %"age%": 30}") as v then
				assert_true ("is object", v.is_object)
				assert_integers_equal ("count", 2, v.as_object.count)
			else
				assert_true ("parse succeeded", False)
			end
		end

	test_parse_array
			-- Test parsing JSON array.
		note
			testing: "covers/{SIMPLE_JSON}.parse"
		local
			json: SIMPLE_JSON
		do
			create json
			if attached json.parse ("[1, 2, 3]") as v then
				assert_true ("is array", v.is_array)
				assert_integers_equal ("count", 3, v.as_array.count)
			else
				assert_true ("parse succeeded", False)
			end
		end

	test_parse_string
			-- Test parsing JSON string.
		note
			testing: "covers/{SIMPLE_JSON}.parse"
		local
			json: SIMPLE_JSON
		do
			create json
			if attached json.parse ("%"hello%"") as v then
				assert_true ("is string", v.is_string)
				assert_strings_equal ("value", "hello", v.as_string_32)
			else
				assert_true ("parse succeeded", False)
			end
		end

	test_parse_number
			-- Test parsing JSON number.
		note
			testing: "covers/{SIMPLE_JSON}.parse"
		local
			json: SIMPLE_JSON
		do
			create json
			if attached json.parse ("42") as v then
				assert_true ("is number", v.is_number)
				assert_integers_equal ("value", 42, v.as_integer.to_integer_32)
			else
				assert_true ("parse succeeded", False)
			end
		end

	test_parse_boolean
			-- Test parsing JSON boolean.
		note
			testing: "covers/{SIMPLE_JSON}.parse"
		local
			json: SIMPLE_JSON
		do
			create json
			if attached json.parse ("true") as v then
				assert_true ("is boolean", v.is_boolean)
				assert_true ("value is true", v.as_boolean)
			else
				assert_true ("parse succeeded", False)
			end
		end

	test_parse_null
			-- Test parsing JSON null.
		note
			testing: "covers/{SIMPLE_JSON}.parse"
		local
			json: SIMPLE_JSON
		do
			create json
			if attached json.parse ("null") as v then
				assert_true ("is null", v.is_null)
			else
				assert_true ("parse succeeded", False)
			end
		end

feature -- Test: Generation

	test_to_json_object
			-- Test generating JSON from object.
		note
			testing: "covers/{SIMPLE_JSON_OBJECT}.to_json"
		local
			obj: SIMPLE_JSON_OBJECT
		do
			create obj.make
			obj.put_string ("name", "Bob")
			obj.put_integer ("age", 25)
			assert_string_contains ("has name", obj.to_json, "%"name%"")
			assert_string_contains ("has age", obj.to_json, "%"age%"")
		end

	test_to_json_array
			-- Test generating JSON from array.
		note
			testing: "covers/{SIMPLE_JSON_ARRAY}.to_json"
		local
			arr: SIMPLE_JSON_ARRAY
		do
			create arr.make
			arr.add_integer (1)
			arr.add_integer (2)
			arr.add_integer (3)
			assert_strings_equal ("array json", "[1,2,3]", arr.to_json)
		end

feature -- Test: Object Operations

	test_object_has_key
			-- Test object key checking.
		note
			testing: "covers/{SIMPLE_JSON_OBJECT}.has_key"
		local
			obj: SIMPLE_JSON_OBJECT
		do
			create obj.make
			obj.put_string ("key1", "value1")
			assert_true ("has key1", obj.has_key ("key1"))
			assert_false ("no key2", obj.has_key ("key2"))
		end

	test_object_remove
			-- Test object key removal.
		note
			testing: "covers/{SIMPLE_JSON_OBJECT}.remove"
		local
			obj: SIMPLE_JSON_OBJECT
		do
			create obj.make
			obj.put_string ("key", "value")
			assert_true ("has key", obj.has_key ("key"))
			obj.remove ("key")
			assert_false ("key removed", obj.has_key ("key"))
		end

feature -- Test: Array Operations

	test_array_count
			-- Test array count.
		note
			testing: "covers/{SIMPLE_JSON_ARRAY}.count"
		local
			arr: SIMPLE_JSON_ARRAY
		do
			create arr.make
			assert_integers_equal ("empty", 0, arr.count)
			arr.add_string ("item")
			assert_integers_equal ("one item", 1, arr.count)
		end

	test_array_is_empty
			-- Test array empty check.
		note
			testing: "covers/{SIMPLE_JSON_ARRAY}.is_empty"
		local
			arr: SIMPLE_JSON_ARRAY
		do
			create arr.make
			assert_true ("initially empty", arr.is_empty)
			arr.add_integer (1)
			assert_false ("not empty after add", arr.is_empty)
		end

feature -- Test: Error Handling

	test_parse_invalid_json
			-- Test parsing invalid JSON.
		note
			testing: "covers/{SIMPLE_JSON}.parse"
		local
			json: SIMPLE_JSON
		do
			create json
			assert_void ("invalid json", json.parse ("{invalid}"))
			assert_true ("has error", json.has_error)
		end

	test_parse_empty_string
			-- Test parsing empty string.
		note
			testing: "covers/{SIMPLE_JSON}.parse"
		local
			json: SIMPLE_JSON
		do
			create json
			assert_void ("empty string", json.parse (""))
		end

end

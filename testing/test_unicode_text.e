note
	description: "[
		Independent vectors for Unicode in JSON strings - the round trips
		ejson could not do: characters beyond the BMP (emoji), surrogate-
		pair escapes from ensure_ascii encoders, controls and quotes.
		Expected values are written out by hand from RFC 8259 and the
		Unicode surrogate arithmetic, not read back from the library.
		Backslash is spelled %/92/ so that no tool ever decodes an escape
		that belongs to the JSON text under test.
	]"
	author: "Larry Rix"

class
	TEST_UNICODE_TEXT

inherit
	TEST_SET_BASE

feature -- Tests

	test_astral_round_trip_through_object
			-- U+1F916 (robot), Hebrew and Greek survive put_string / string_item, and serialize / parse.
		local
			o: SIMPLE_JSON_OBJECT
			j: SIMPLE_JSON
			l_text: STRING_32
		do
			l_text := {STRING_32} "%/0x1F916/ %/0x5E9/%/0x5DC/%/0x5D5/%/0x5DD/ %/0x3A7/%/0x3C1/%/0x3B9/%/0x3C3/%/0x3C4/%/0x3CC/%/0x3C2/"
			create o.make
			o.put_string (l_text, {STRING_32} "s").do_nothing
			assert_true ("stored", attached o.string_item ({STRING_32} "s") as s and then s.same_string (l_text))
			assert_true ("first char is one code point", attached o.string_item ({STRING_32} "s") as s2 and then s2.code (1) = 0x1F916)
			create j
			assert_true ("parsed back", attached j.parse_message (o.to_json_string) as v and then v.is_object
				and then attached v.as_object.string_item ({STRING_32} "s") as s3 and then s3.same_string (l_text))
		end

	test_surrogate_pair_escapes_combine
			-- The escape pair d83e dd16 is the one character U+1F916; a lone surrogate is kept as is.
		local
			j: SIMPLE_JSON
		do
			create j
			assert_true ("pair combined", attached j.parse_message ({STRING_32} "{%"s%":%"%/92/ud83e%/92/udd16%"}") as v and then v.is_object
				and then attached v.as_object.string_item ({STRING_32} "s") as s and then s.count = 1 and then s.code (1) = 0x1F916)
			assert_true ("uppercase hex too", attached j.parse_message ({STRING_32} "{%"s%":%"%/92/uD83E%/92/uDD16!%"}") as v2 and then v2.is_object
				and then attached v2.as_object.string_item ({STRING_32} "s") as s2 and then s2.count = 2 and then s2.code (1) = 0x1F916 and then s2 [2] = '!')
			assert_true ("lone high surrogate kept", attached j.parse_message ({STRING_32} "{%"s%":%"%/92/ud83e-%"}") as v3 and then v3.is_object
				and then attached v3.as_object.string_item ({STRING_32} "s") as s3 and then s3.count = 2 and then s3.code (1) = 0xD83E)
		end

	test_escaper_vectors
			-- Hand-computed literals.
		local
			t: SIMPLE_JSON_TEXT
			l_escaped: STRING_8
		do
			create t
			l_escaped := t.escaped ({STRING_32} "a%"b%/92/c%Nd%Te/f")
			assert_true ("controls and quotes", l_escaped.same_string ("a%/92/%"b%/92/%/92/c%/92/nd%/92/te/f"))
			assert_true ("nul is escaped", t.escaped ({STRING_32} "x%Uy").same_string ("x%/92/u0000y"))
			assert_true ("unit separator is escaped", t.escaped ({STRING_32} "%/31/").same_string ("%/92/u001f"))
			assert_true ("robot is raw utf-8 f0 9f a4 96", t.escaped ({STRING_32} "%/0x1F916/").same_string ("%/0xF0/%/0x9F/%/0xA4/%/0x96/"))
			assert_true ("shin is raw utf-8 d7 a9", t.escaped ({STRING_32} "%/0x5E9/").same_string ("%/0xD7/%/0xA9/"))
			assert_true ("U+10000 round trip", t.decoded (t.escaped ({STRING_32} "%/0x10000/")).code (1) = 0x10000)
			assert_true ("U+10FFFF round trip", t.decoded (t.escaped ({STRING_32} "%/0x10FFFF/")).code (1) = 0x10FFFF)
			assert_true ("decoded escapes", t.decoded ("a%/92/%"b%/92/%/92/c%/92//d%/92/nxA").same_string ({STRING_32} "a%"b%/92/c/d%NxA"))
			assert_true ("bad utf-8 lead byte kept as latin-1", t.decoded ("%/0xE9/!").same_string ({STRING_32} "%/0xE9/!"))
		end

	test_array_and_facade_strings
			-- add_string and json_string go through the same escaper.
		local
			a: SIMPLE_JSON_ARRAY
			j: SIMPLE_JSON
			l_text: STRING_32
		do
			l_text := {STRING_32} "%/0x1F916/ ok"
			create a.make
			a.add_string (l_text).do_nothing
			assert_true ("array element", attached a.string_item (1) as s and then s.same_string (l_text))
			create j
			assert_true ("facade value", j.json_string (l_text).as_string_32.same_string (l_text))
			assert_true ("astral key", (create {SIMPLE_JSON_OBJECT}.make).put_integer (1, {STRING_32} "%/0x1F916/").has_key ({STRING_32} "%/0x1F916/"))
		end

end

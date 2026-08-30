note
	description: "[
		JSON string text, encoded and decoded correctly for all of Unicode.

		The underlying ejson library gets two things wrong that this class
		repairs at the boundary, so no SIMPLE_JSON_* class calls ejson's
		string escaper directly any more:

		1. A character beyond the Basic Multilingual Plane (every emoji,
		   e.g. U+1F916) is written by ejson as a five-digit "\u1F916".
		   That is not JSON; ejson's own decoder reads it back as U+1F91
		   followed by the digit 6. Here non-ASCII text goes out as raw
		   UTF-8, which RFC 8259 requires every consumer to accept.
		2. A surrogate-pair escape "\uD83E\uDD16" - what Python's json,
		   older Java and JavaScript's JSON.stringify emit for the same
		   character - is decoded by ejson as two lone surrogates. Here
		   the pair is combined into the one character it encodes.

		Found 2026-08-29 by SIMPLE_JSON_OBJECT.put_string's `value_stored'
		postcondition when a chat message beginning with the robot emoji
		did not survive the round trip.
	]"
	author: "Larry Rix"

class
	SIMPLE_JSON_TEXT

feature -- Conversion

	escaped (a_text: READABLE_STRING_GENERAL): STRING_8
			-- The content of a JSON string literal for `a_text' (no surrounding
			-- quotes): quote, backslash and controls escaped; everything else
			-- as raw UTF-8.
		local
			i, n: INTEGER
			c: NATURAL_32
			l_out: STRING_32
		do
			n := a_text.count
			create l_out.make (n + n // 8)
			from
				i := 1
			until
				i > n
			loop
				c := a_text.code (i)
				if c = 0x22 then
					l_out.append_string_general ("\%"")
				elseif c = 0x5C then
					l_out.append_string_general ("\\")
				elseif c = 0x08 then
					l_out.append_string_general ("\b")
				elseif c = 0x0C then
					l_out.append_string_general ("\f")
				elseif c = 0x0A then
					l_out.append_string_general ("\n")
				elseif c = 0x0D then
					l_out.append_string_general ("\r")
				elseif c = 0x09 then
					l_out.append_string_general ("\t")
				elseif c < 0x20 then
					l_out.append_string_general ("\u00")
					l_out.append_string_general (hex2 (c))
				else
					l_out.append_code (c)
				end
				i := i + 1
			end
			Result := {UTF_CONVERTER}.utf_32_string_to_utf_8_string_8 (l_out)
		ensure
			no_raw_control: across Result as ch all ch.code >= 0x20 end
			valid_utf_8: {UTF_CONVERTER}.is_valid_utf_8_string_8 (Result)
			round_trip: decoded (Result).same_string_general (a_text)
		end

	decoded (a_literal: READABLE_STRING_8): STRING_32
			-- The text a JSON string literal's content `a_literal' denotes:
			-- the standard escapes, "\uXXXX" with surrogate pairs combined,
			-- raw UTF-8 sequences; a byte that is none of these is kept as
			-- Latin-1 rather than lost.
		local
			i, n: INTEGER
			c, c2: NATURAL_32
			ch: CHARACTER_8
		do
			n := a_literal.count
			create Result.make (n)
			from
				i := 1
			until
				i > n
			loop
				ch := a_literal [i]
				c := ch.natural_32_code
				if ch = '\' and i < n then
					inspect a_literal [i + 1]
					when '%"' then
						Result.append_character ('%"')
						i := i + 2
					when '\' then
						Result.append_character ('\')
						i := i + 2
					when '/' then
						Result.append_character ('/')
						i := i + 2
					when 'b' then
						Result.append_character ('%B')
						i := i + 2
					when 'f' then
						Result.append_character ('%F')
						i := i + 2
					when 'n' then
						Result.append_character ('%N')
						i := i + 2
					when 'r' then
						Result.append_character ('%R')
						i := i + 2
					when 't' then
						Result.append_character ('%T')
						i := i + 2
					when 'u' then
						if i + 5 <= n and then is_hex4 (a_literal.substring (i + 2, i + 5)) then
							c := hex_value (a_literal.substring (i + 2, i + 5))
							i := i + 6
							if is_high_surrogate (c) and then i + 5 <= n and then a_literal [i] = '\' and then a_literal [i + 1] = 'u'
								and then is_hex4 (a_literal.substring (i + 2, i + 5))
							then
								c2 := hex_value (a_literal.substring (i + 2, i + 5))
								if is_low_surrogate (c2) then
									c := 0x10000 + ((c - 0xD800) |<< 10) + (c2 - 0xDC00)
									i := i + 6
								end
							end
							Result.append_code (c)
						else
							Result.append_character ('\')
							i := i + 1
						end
					else
						Result.append_character ('\')
						i := i + 1
					end
				elseif c < 0x80 then
					Result.append_character (ch)
					i := i + 1
				elseif c >= 0xC2 and c <= 0xDF and then i + 1 <= n and then is_continuation (a_literal [i + 1]) then
					Result.append_code (((c & 0x1F) |<< 6) | (a_literal.code (i + 1) & 0x3F))
					i := i + 2
				elseif c >= 0xE0 and c <= 0xEF and then i + 2 <= n and then is_continuation (a_literal [i + 1]) and then is_continuation (a_literal [i + 2]) then
					Result.append_code (((c & 0x0F) |<< 12) | ((a_literal.code (i + 1) & 0x3F) |<< 6) | (a_literal.code (i + 2) & 0x3F))
					i := i + 3
				elseif c >= 0xF0 and c <= 0xF4 and then i + 3 <= n and then is_continuation (a_literal [i + 1]) and then is_continuation (a_literal [i + 2])
					and then is_continuation (a_literal [i + 3])
				then
					Result.append_code (((c & 0x07) |<< 18) | ((a_literal.code (i + 1) & 0x3F) |<< 12) | ((a_literal.code (i + 2) & 0x3F) |<< 6) | (a_literal.code (i + 3) & 0x3F))
					i := i + 4
				else
					Result.append_code (c)
					i := i + 1
				end
			end
		ensure
			bounded: Result.count <= a_literal.count
		end

	json_string (a_text: READABLE_STRING_GENERAL): JSON_STRING
			-- `a_text' as an ejson string value, escaped here rather than by ejson.
		do
			create Result.make_from_escaped_json_string (escaped (a_text))
		ensure
			round_trip: unescaped (Result).same_string_general (a_text)
		end

	unescaped (a_json: JSON_STRING): STRING_32
			-- The text `a_json' denotes, with surrogate-pair escapes combined.
		do
			Result := decoded (a_json.item)
		end

feature -- Validation (contract support)

	is_high_surrogate (a_code: NATURAL_32): BOOLEAN
		do
			Result := a_code >= 0xD800 and a_code <= 0xDBFF
		end

	is_low_surrogate (a_code: NATURAL_32): BOOLEAN
		do
			Result := a_code >= 0xDC00 and a_code <= 0xDFFF
		end

	is_continuation (a_byte: CHARACTER_8): BOOLEAN
			-- A UTF-8 continuation byte, 10xxxxxx?
		do
			Result := (a_byte.natural_32_code & 0xC0) = 0x80
		end

	is_hex4 (a_text: READABLE_STRING_8): BOOLEAN
			-- Exactly four hexadecimal digits?
		do
			Result := a_text.count = 4 and then across a_text as ch all is_hex_digit (ch) end
		end

	is_hex_digit (a_char: CHARACTER_8): BOOLEAN
		do
			Result := (a_char >= '0' and a_char <= '9') or (a_char >= 'a' and a_char <= 'f') or (a_char >= 'A' and a_char <= 'F')
		end

	hex_value (a_text: READABLE_STRING_8): NATURAL_32
		require
			hex: across a_text as ch all is_hex_digit (ch) end
			short: a_text.count <= 8
		local
			i: INTEGER
			c: CHARACTER_8
		do
			from
				i := 1
			until
				i > a_text.count
			loop
				c := a_text [i]
				Result := Result |<< 4
				if c >= '0' and c <= '9' then
					Result := Result + (c.natural_32_code - ('0').natural_32_code)
				elseif c >= 'a' and c <= 'f' then
					Result := Result + 10 + (c.natural_32_code - ('a').natural_32_code)
				else
					Result := Result + 10 + (c.natural_32_code - ('A').natural_32_code)
				end
				i := i + 1
			end
		end

	hex2 (a_code: NATURAL_32): STRING_8
			-- Two lowercase hexadecimal digits for a code below 256.
		require
			byte: a_code < 256
		do
			Result := Hex_digits.substring ((a_code |>> 4).to_integer_32 + 1, (a_code |>> 4).to_integer_32 + 1)
				+ Hex_digits.substring ((a_code & 0xF).to_integer_32 + 1, (a_code & 0xF).to_integer_32 + 1)
		ensure
			two: Result.count = 2
		end

feature {NONE} -- Constants

	Hex_digits: STRING_8 = "0123456789abcdef"

end

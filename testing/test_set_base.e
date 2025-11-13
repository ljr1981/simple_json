note
	description: "Base test class with high-level generic assertions"
	testing: "type/manual"

deferred class
	TEST_SET_BASE

inherit
	EQA_TEST_SET
		undefine
			assert
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

feature -- Boolean assertions

	refute (a_tag: READABLE_STRING_GENERAL; a_condition: BOOLEAN)
			-- Assert that `a_condition' is False
		require
			a_tag_not_void: a_tag /= Void
		do
			assert (a_tag, not a_condition)
		end

	assert_true (a_tag: READABLE_STRING_GENERAL; a_condition: BOOLEAN)
			-- Assert that `a_condition' is True
		require
			a_tag_not_void: a_tag /= Void
		do
			assert (a_tag, a_condition)
		end

	assert_false (a_tag: READABLE_STRING_GENERAL; a_condition: BOOLEAN)
			-- Assert that `a_condition' is False
		require
			a_tag_not_void: a_tag /= Void
		do
			assert (a_tag, not a_condition)
		end

feature -- Numeric comparisons (INTEGER)

	assert_greater_than (a_tag: READABLE_STRING_GENERAL; a_value, a_threshold: INTEGER)
			-- Assert that `a_value' > `a_threshold'
		require
			a_tag_not_void: a_tag /= Void
		local
			msg: STRING_32
		do
			create msg.make (50)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected ")
			msg.append_string_general (a_value.out)
			msg.append_string_general (" > ")
			msg.append_string_general (a_threshold.out)
			assert (msg, a_value > a_threshold)
		end

	assert_greater_or_equal (a_tag: READABLE_STRING_GENERAL; a_value, a_threshold: INTEGER)
			-- Assert that `a_value' >= `a_threshold'
		require
			a_tag_not_void: a_tag /= Void
		local
			msg: STRING_32
		do
			create msg.make (50)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected ")
			msg.append_string_general (a_value.out)
			msg.append_string_general (" >= ")
			msg.append_string_general (a_threshold.out)
			assert (msg, a_value >= a_threshold)
		end

	assert_less_than (a_tag: READABLE_STRING_GENERAL; a_value, a_threshold: INTEGER)
			-- Assert that `a_value' < `a_threshold'
		require
			a_tag_not_void: a_tag /= Void
		local
			msg: STRING_32
		do
			create msg.make (50)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected ")
			msg.append_string_general (a_value.out)
			msg.append_string_general (" < ")
			msg.append_string_general (a_threshold.out)
			assert (msg, a_value < a_threshold)
		end

	assert_less_or_equal (a_tag: READABLE_STRING_GENERAL; a_value, a_threshold: INTEGER)
			-- Assert that `a_value' <= `a_threshold'
		require
			a_tag_not_void: a_tag /= Void
		local
			msg: STRING_32
		do
			create msg.make (50)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected ")
			msg.append_string_general (a_value.out)
			msg.append_string_general (" <= ")
			msg.append_string_general (a_threshold.out)
			assert (msg, a_value <= a_threshold)
		end

	assert_in_range (a_tag: READABLE_STRING_GENERAL; a_value, a_min, a_max: INTEGER)
			-- Assert that `a_min' <= `a_value' <= `a_max'
		require
			a_tag_not_void: a_tag /= Void
			valid_range: a_min <= a_max
		local
			msg: STRING_32
		do
			create msg.make (60)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected ")
			msg.append_string_general (a_value.out)
			msg.append_string_general (" in [")
			msg.append_string_general (a_min.out)
			msg.append_string_general ("..")
			msg.append_string_general (a_max.out)
			msg.append_string_general ("]")
			assert (msg, a_value >= a_min and a_value <= a_max)
		end

	assert_positive (a_tag: READABLE_STRING_GENERAL; a_value: INTEGER)
			-- Assert that `a_value' > 0
		require
			a_tag_not_void: a_tag /= Void
		local
			msg: STRING_32
		do
			create msg.make (50)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected positive, got ")
			msg.append_string_general (a_value.out)
			assert (msg, a_value > 0)
		end

	assert_negative (a_tag: READABLE_STRING_GENERAL; a_value: INTEGER)
			-- Assert that `a_value' < 0
		require
			a_tag_not_void: a_tag /= Void
		local
			msg: STRING_32
		do
			create msg.make (50)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected negative, got ")
			msg.append_string_general (a_value.out)
			assert (msg, a_value < 0)
		end

	assert_zero (a_tag: READABLE_STRING_GENERAL; a_value: INTEGER)
			-- Assert that `a_value' = 0
		require
			a_tag_not_void: a_tag /= Void
		local
			msg: STRING_32
		do
			create msg.make (50)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected zero, got ")
			msg.append_string_general (a_value.out)
			assert (msg, a_value = 0)
		end

	assert_non_zero (a_tag: READABLE_STRING_GENERAL; a_value: INTEGER)
			-- Assert that `a_value' /= 0
		require
			a_tag_not_void: a_tag /= Void
		local
			msg: STRING_32
		do
			create msg.make (50)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected non-zero, got ")
			msg.append_string_general (a_value.out)
			assert (msg, a_value /= 0)
		end

feature -- Numeric comparisons (REAL)

	assert_reals_equal (a_tag: READABLE_STRING_GENERAL; a_expected, a_actual, a_epsilon: REAL_64)
			-- Assert that |`a_expected' - `a_actual'| <= `a_epsilon'
		require
			a_tag_not_void: a_tag /= Void
			epsilon_positive: a_epsilon >= 0.0
		local
			msg: STRING_32
		do
			create msg.make (80)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected ")
			msg.append_string_general (a_expected.out)
			msg.append_string_general (" ± ")
			msg.append_string_general (a_epsilon.out)
			msg.append_string_general (", got ")
			msg.append_string_general (a_actual.out)
			assert (msg, (a_expected - a_actual).abs <= a_epsilon)
		end

	assert_real_greater_than (a_tag: READABLE_STRING_GENERAL; a_value, a_threshold: REAL_64)
			-- Assert that `a_value' > `a_threshold'
		require
			a_tag_not_void: a_tag /= Void
		local
			msg: STRING_32
		do
			create msg.make (50)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected ")
			msg.append_string_general (a_value.out)
			msg.append_string_general (" > ")
			msg.append_string_general (a_threshold.out)
			assert (msg, a_value > a_threshold)
		end

	assert_real_less_than (a_tag: READABLE_STRING_GENERAL; a_value, a_threshold: REAL_64)
			-- Assert that `a_value' < `a_threshold'
		require
			a_tag_not_void: a_tag /= Void
		local
			msg: STRING_32
		do
			create msg.make (50)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected ")
			msg.append_string_general (a_value.out)
			msg.append_string_general (" < ")
			msg.append_string_general (a_threshold.out)
			assert (msg, a_value < a_threshold)
		end

	assert_real_in_range (a_tag: READABLE_STRING_GENERAL; a_value, a_min, a_max: REAL_64)
			-- Assert that `a_min' <= `a_value' <= `a_max'
		require
			a_tag_not_void: a_tag /= Void
			valid_range: a_min <= a_max
		local
			msg: STRING_32
		do
			create msg.make (60)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected ")
			msg.append_string_general (a_value.out)
			msg.append_string_general (" in [")
			msg.append_string_general (a_min.out)
			msg.append_string_general ("..")
			msg.append_string_general (a_max.out)
			msg.append_string_general ("]")
			assert (msg, a_value >= a_min and a_value <= a_max)
		end

feature -- String assertions

	assert_string_contains (a_tag: READABLE_STRING_GENERAL; a_string, a_substring: READABLE_STRING_GENERAL)
			-- Assert that `a_string' contains `a_substring'
		require
			a_tag_not_void: a_tag /= Void
			a_string_attached: a_string /= Void
			a_substring_attached: a_substring /= Void
		local
			msg: STRING_32
		do
			create msg.make (60)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected string to contain '")
			msg.append_string_general (a_substring)
			msg.append_character ('%'')
			assert (msg, a_string.has_substring (a_substring))
		end

	assert_string_starts_with (a_tag: READABLE_STRING_GENERAL; a_string, a_prefix: READABLE_STRING_GENERAL)
			-- Assert that `a_string' starts with `a_prefix'
		require
			a_tag_not_void: a_tag /= Void
			a_string_attached: a_string /= Void
			a_prefix_attached: a_prefix /= Void
		local
			msg: STRING_32
		do
			create msg.make (60)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected string to start with '")
			msg.append_string_general (a_prefix)
			msg.append_character ('%'')
			assert (msg, a_string.starts_with (a_prefix))
		end

	assert_string_ends_with (a_tag: READABLE_STRING_GENERAL; a_string, a_suffix: READABLE_STRING_GENERAL)
			-- Assert that `a_string' ends with `a_suffix'
		require
			a_tag_not_void: a_tag /= Void
			a_string_attached: a_string /= Void
			a_suffix_attached: a_suffix /= Void
		local
			msg: STRING_32
		do
			create msg.make (60)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected string to end with '")
			msg.append_string_general (a_suffix)
			msg.append_character ('%'')
			assert (msg, a_string.ends_with (a_suffix))
		end

	assert_string_empty (a_tag: READABLE_STRING_GENERAL; a_string: READABLE_STRING_GENERAL)
			-- Assert that `a_string' is empty
		require
			a_tag_not_void: a_tag /= Void
			a_string_attached: a_string /= Void
		local
			msg: STRING_32
		do
			create msg.make (60)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected empty string, got '")
			msg.append_string_general (a_string)
			msg.append_character ('%'')
			assert (msg, a_string.is_empty)
		end

	assert_string_not_empty (a_tag: READABLE_STRING_GENERAL; a_string: READABLE_STRING_GENERAL)
			-- Assert that `a_string' is not empty
		require
			a_tag_not_void: a_tag /= Void
			a_string_attached: a_string /= Void
		local
			msg: STRING_32
		do
			create msg.make (50)
			msg.append_string_general (a_tag)
			msg.append_string_general (": expected non-empty string")
			assert (msg, not a_string.is_empty)
		end

end

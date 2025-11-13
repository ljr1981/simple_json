note
	description: "Base test class with common assertions"
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

end

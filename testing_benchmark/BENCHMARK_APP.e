note
	description: "Benchmark application for SIMPLE_JSON performance testing"
	date: "$Date$"
	revision: "$Revision$"

class
	BENCHMARK_APP

create
	make

feature -- Initialization

	make
			-- Run benchmark suite
		local
			l_logger: BENCHMARK_LOGGER
		do
			create l_logger.make ("benchmark_results.txt")
			
			l_logger.log_header ("SIMPLE_JSON Performance Benchmarks")
			l_logger.log_separator
			
			print ("Starting SIMPLE_JSON Performance Benchmarks...%N%N")
			
			run_parse_benchmarks (l_logger)
			run_object_benchmarks (l_logger)
			run_query_benchmarks (l_logger)
			run_pretty_print_benchmarks (l_logger)
			
			l_logger.log_separator
			l_logger.log_footer
			l_logger.close
			
			print ("%N%NBenchmark complete! Results saved to: benchmark_results.txt%N")
		end

feature {NONE} -- Parse Benchmarks

	run_parse_benchmarks (a_logger: BENCHMARK_LOGGER)
		do
			a_logger.log_section ("Parse Benchmarks")
			benchmark_parse_small (a_logger)
			benchmark_parse_medium (a_logger)
			benchmark_parse_array (a_logger)
		end

	benchmark_parse_small (a_logger: BENCHMARK_LOGGER)
		local
			l_json: SIMPLE_JSON
			l_text: STRING_32
			l_iterations: INTEGER
			l_result: detachable SIMPLE_JSON_VALUE
			i: INTEGER
		do
			create l_json
			l_text := "{%"name%": %"Alice%", %"age%": 30, %"city%": %"NYC%"}"
			l_iterations := 10000
			
			a_logger.start_benchmark ("Parse Small Object", l_iterations)
			from i := 1 until i > l_iterations loop
				l_result := l_json.parse (l_text)
				i := i + 1
			end
			a_logger.stop_benchmark
		end

	benchmark_parse_medium (a_logger: BENCHMARK_LOGGER)
		local
			l_json: SIMPLE_JSON
			l_text: STRING_32
			l_iterations: INTEGER
			l_result: detachable SIMPLE_JSON_VALUE
			i: INTEGER
		do
			create l_json
			l_text := "{%"name%": %"Alice%", %"age%": 30, %"email%": %"alice@example.com%", " +
			          "%"phone%": %"555-1234%", %"address%": %"123 Main St%", " +
			          "%"city%": %"NYC%", %"zip%": %"10001%", %"country%": %"USA%"}"
			l_iterations := 5000
			
			a_logger.start_benchmark ("Parse Medium Object", l_iterations)
			from i := 1 until i > l_iterations loop
				l_result := l_json.parse (l_text)
				i := i + 1
			end
			a_logger.stop_benchmark
		end

	benchmark_parse_array (a_logger: BENCHMARK_LOGGER)
		local
			l_json: SIMPLE_JSON
			l_text: STRING_32
			l_iterations: INTEGER
			l_result: detachable SIMPLE_JSON_VALUE
			i: INTEGER
		do
			create l_json
			l_text := generate_array_json (100)
			l_iterations := 1000
			
			a_logger.start_benchmark ("Parse Large Array (100 items)", l_iterations)
			from i := 1 until i > l_iterations loop
				l_result := l_json.parse (l_text)
				i := i + 1
			end
			a_logger.stop_benchmark
		end

feature {NONE} -- Object Benchmarks

	run_object_benchmarks (a_logger: BENCHMARK_LOGGER)
		do
			a_logger.log_section ("Object Operation Benchmarks")
			benchmark_key_lookup_same (a_logger)
			benchmark_key_lookup_varied (a_logger)
			benchmark_has_key (a_logger)
			benchmark_fluent_api (a_logger)
		end

	benchmark_key_lookup_same (a_logger: BENCHMARK_LOGGER)
		local
			l_json: SIMPLE_JSON
			l_obj: SIMPLE_JSON_OBJECT
			l_value: detachable SIMPLE_JSON_VALUE
			l_iterations: INTEGER
			i: INTEGER
		do
			create l_json
			if attached l_json.parse ("{%"name%": %"Alice%", %"age%": 30}") as l_parsed then
				l_obj := l_parsed.as_object
				l_iterations := 100000
				
				a_logger.start_benchmark ("Key Lookup (Same Key)", l_iterations)
				from i := 1 until i > l_iterations loop
					l_value := l_obj.item ("name")
					i := i + 1
				end
				a_logger.stop_benchmark
			end
		end

	benchmark_key_lookup_varied (a_logger: BENCHMARK_LOGGER)
		local
			l_json: SIMPLE_JSON
			l_obj: SIMPLE_JSON_OBJECT
			l_value: detachable SIMPLE_JSON_VALUE
			l_iterations: INTEGER
			i: INTEGER
		do
			create l_json
			if attached l_json.parse ("{%"key1%": 1, %"key2%": 2, %"key3%": 3, %"key4%": 4, %"key5%": 5}") as l_parsed then
				l_obj := l_parsed.as_object
				l_iterations := 50000
				
				a_logger.start_benchmark ("Key Lookup (Varied Keys)", l_iterations * 5)
				from i := 1 until i > l_iterations loop
					l_value := l_obj.item ("key1")
					l_value := l_obj.item ("key2")
					l_value := l_obj.item ("key3")
					l_value := l_obj.item ("key4")
					l_value := l_obj.item ("key5")
					i := i + 1
				end
				a_logger.stop_benchmark
			end
		end

	benchmark_has_key (a_logger: BENCHMARK_LOGGER)
		local
			l_json: SIMPLE_JSON
			l_obj: SIMPLE_JSON_OBJECT
			l_result: BOOLEAN
			l_iterations: INTEGER
			i: INTEGER
		do
			create l_json
			if attached l_json.parse ("{%"name%": %"Alice%", %"age%": 30}") as l_parsed then
				l_obj := l_parsed.as_object
				l_iterations := 100000
				
				a_logger.start_benchmark ("has_key Operations", l_iterations * 2)
				from i := 1 until i > l_iterations loop
					l_result := l_obj.has_key ("name")
					l_result := l_obj.has_key ("age")
					i := i + 1
				end
				a_logger.stop_benchmark
			end
		end

	benchmark_fluent_api (a_logger: BENCHMARK_LOGGER)
		local
			l_json: SIMPLE_JSON
			l_obj: SIMPLE_JSON_OBJECT
			l_iterations: INTEGER
			i: INTEGER
		do
			create l_json
			l_iterations := 10000
			
			a_logger.start_benchmark ("Fluent API (Object Building)", l_iterations * 5)
			from i := 1 until i > l_iterations loop
				create l_obj.make
				l_obj
					.put_string ("Alice", "name")
					.put_integer (30, "age")
					.put_string ("NYC", "city")
					.put_boolean (True, "active")
					.put_real (95.5, "score").do_nothing
				i := i + 1
			end
			a_logger.stop_benchmark
		end

feature {NONE} -- Query Benchmarks

	run_query_benchmarks (a_logger: BENCHMARK_LOGGER)
		do
			a_logger.log_section ("Query Operation Benchmarks")
			benchmark_query_same_path (a_logger)
			benchmark_query_varied_paths (a_logger)
		end

	benchmark_query_same_path (a_logger: BENCHMARK_LOGGER)
		local
			l_json: SIMPLE_JSON
			l_doc: detachable SIMPLE_JSON_VALUE
			l_result: detachable STRING_32
			l_iterations: INTEGER
			i: INTEGER
		do
			create l_json
			l_doc := l_json.parse ("{%"person%": {%"name%": %"Alice%"}}")
			l_iterations := 10000
			
			if attached l_doc as al_doc then
				a_logger.start_benchmark ("Query (Same Path)", l_iterations)
				from i := 1 until i > l_iterations loop
					l_result := l_json.query_string (al_doc, "$.person.name")
					i := i + 1
				end
				a_logger.stop_benchmark
			end
		end

	benchmark_query_varied_paths (a_logger: BENCHMARK_LOGGER)
		local
			l_json: SIMPLE_JSON
			l_doc: detachable SIMPLE_JSON_VALUE
			l_result: detachable STRING_32
			l_iterations: INTEGER
			i: INTEGER
		do
			create l_json
			l_doc := l_json.parse ("{%"person%": {%"name%": %"Alice%", " +
				"%"address%": {%"street%": %"123 Main%", %"city%": %"NYC%"}}}")
			l_iterations := 5000
			
			if attached l_doc as al_doc then
				a_logger.start_benchmark ("Query (Varied Paths)", l_iterations * 3)
				from i := 1 until i > l_iterations loop
					l_result := l_json.query_string (al_doc, "$.person.name")
					l_result := l_json.query_string (al_doc, "$.person.address.street")
					l_result := l_json.query_string (al_doc, "$.person.address.city")
					i := i + 1
				end
				a_logger.stop_benchmark
			end
		end

feature {NONE} -- Pretty Print Benchmarks

	run_pretty_print_benchmarks (a_logger: BENCHMARK_LOGGER)
		do
			a_logger.log_section ("Pretty Print Benchmarks")
			benchmark_pretty_print (a_logger)
		end

	benchmark_pretty_print (a_logger: BENCHMARK_LOGGER)
		local
			l_json: SIMPLE_JSON
			l_doc: detachable SIMPLE_JSON_VALUE
			l_result: STRING_32
			l_iterations: INTEGER
			i: INTEGER
		do
			create l_json
			l_doc := l_json.parse (generate_nested_json (3))
			l_iterations := 1000
			
			if attached l_doc as al_doc then
				a_logger.start_benchmark ("Pretty Print (Nested)", l_iterations)
				from i := 1 until i > l_iterations loop
					l_result := al_doc.to_pretty_json
					i := i + 1
				end
				a_logger.stop_benchmark
			end
		end

feature {NONE} -- Utilities

	generate_array_json (a_size: INTEGER): STRING_32
		require
			positive_size: a_size > 0
		local
			i: INTEGER
		do
			create Result.make (a_size * 50)
			Result.append ("[")
			from i := 1 until i > a_size loop
				if i > 1 then
					Result.append (", ")
				end
				Result.append ("{%"id%": ")
				Result.append (i.out)
				Result.append (", %"name%": %"Item ")
				Result.append (i.out)
				Result.append ("%"}")
				i := i + 1
			end
			Result.append ("]")
		ensure
			result_not_empty: not Result.is_empty
		end

	generate_nested_json (a_depth: INTEGER): STRING_32
		require
			positive_depth: a_depth > 0
		local
			i: INTEGER
		do
			create Result.make (100)
			Result.append ("{%"level%": 0")
			from i := 1 until i > a_depth loop
				Result.append (", %"nested")
				Result.append (i.out)
				Result.append ("%": {%"level%": ")
				Result.append (i.out)
				i := i + 1
			end
			from i := 1 until i > a_depth loop
				Result.append ("}")
				i := i + 1
			end
			Result.append ("}")
		ensure
			result_not_empty: not Result.is_empty
		end

end

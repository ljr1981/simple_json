# Simple JSON

A lightweight, easy-to-use JSON parsing and generation library for Eiffel with arbitrary precision decimal support.

AI NOTE: Most code was generated interactively using Claude Sonnet 4.5 with minor mods applied by hand. Additional pushes forward with this library will use the same method.

[![Language](https://img.shields.io/badge/language-Eiffel-blue.svg)](https://www.eiffel.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## Overview

Simple JSON provides a clean, intuitive interface for working with JSON data in Eiffel applications. Whether you need to parse JSON strings, query nested data structures, or build JSON programmatically, Simple JSON offers a straightforward API that follows Eiffel's design principles.

## Key Features

- **🔍 Easy Parsing**: Parse JSON strings with simple, expressive syntax
- **🔎 Path-Based Queries**: Navigate nested JSON structures using intuitive path notation  
- **🗃️ Enhanced Building**: Construct JSON with fluent builder including conditional fields
- **✅ Robust Validation**: Comprehensive error handling and validation
- **🧪 Well-Tested**: Extensive test suite with 100% coverage (151 tests across 11 test classes)
- **📚 Full Documentation**: Complete user guide, API docs, and EIS integration
- **🎯 Type Safety**: Leverages Eiffel's strong typing for safe JSON operations
- **🔢 Precise Numbers**: Support for integers, floating-point, and arbitrary precision decimals
- **🔬 Type Introspection**: Check value types with `is_string`, `is_number`, `is_decimal`, etc.
- **⚡ Conditional Building**: Add fields conditionally with `put_*_if` methods
- **📝 Array Manipulation**: Full CRUD operations (append, insert, remove, clear)
- **🔀 Object Operations**: Merge, clone, rename keys, and more
- **💰 Financial Precision**: SIMPLE_JSON_DECIMAL for exact decimal arithmetic
- **📍 Position Tracking**: Parse errors include line and column numbers for easy debugging

## What's New

### Recently Added (November 2025)

- **Position Tracking**: Parse errors now include exact line and column numbers (e.g., "Error at line 15, column 23: Expected ','") for instant debugging
- **Arbitrary Precision Decimals**: New `SIMPLE_JSON_DECIMAL` class using DECIMAL library for exact decimal representation (no more "3.1400000000000001"!)
- **Type Introspection**: All JSON value types now support `is_string`, `is_number`, `is_integer`, `is_real`, `is_decimal`, `is_boolean`, `is_null`, `is_object`, `is_array` queries
- **Builder Enhancements**: Conditional `put_*_if` methods, merge, remove, rename, clear, and clone operations
- **Array Enhancements**: Full modification support with append, insert, remove, and clear operations
- **Comprehensive Documentation**: New markdown docs with EIS integration for F1 help in EiffelStudio

See [docs/markdown/Part_1_-_Step_2_-_Builder_and_Array_Enhancements.md](docs/markdown/Part_1_-_Step_2_-_Builder_and_Array_Enhancements.md) for details.

## Installation

### Using EiffelStudio

1. Clone the repository:
```bash
git clone https://github.com/ljr1981/simple_json.git
```

2. Add the library to your project's `.ecf` file:
```xml
<library name="simple_json" location="$SIMPLE_JSON\simple_json.ecf"/>
```

3. Set the `SIMPLE_JSON` environment variable to point to your clone location, or use an absolute path.

### Optional: DECIMAL Library

For arbitrary precision decimal support, ensure the DECIMAL library is available in your EiffelStudio installation or project. See [docs/DECIMAL_SUPPORT_GUIDE.md](docs/DECIMAL_SUPPORT_GUIDE.md) for details.

## Quick Start

### Parsing JSON
```eiffel
local
    json: JSON
    name: STRING
    age: INTEGER
do
    create json.make_from_string ("{%"name%": %"Alice%", %"age%": 30}")
    
    if json.is_valid then
        name := json.string_value_at ("name")
        age := json.integer_value_at ("age")
        print ("Name: " + name + ", Age: " + age.out)
    end
end
```

### Error Handling with Position Tracking
```eiffel
local
    json: JSON
do
    create json.make_from_string ("{%"name%": %"Alice%", invalid}")
    
    if not json.is_valid then
        -- Prints: "Error at line 1, column 23: Expected property name, got 'i'"
        print (json.error_message)
    end
end
```

### Using Arbitrary Precision Decimals
```eiffel
local
    price: SIMPLE_JSON_DECIMAL
    json_output: STRING
do
    -- Exact precision - no floating-point errors!
    create price.make_from_string ("19.99")
    json_output := price.to_json_string  -- "19.99" (exact!)
    
    -- Perfect for financial calculations
    print ("Price: $" + json_output)
end
```

### Building JSON with Enhancements
```eiffel
local
    builder: JSON_BUILDER
    json_string: STRING
    has_email: BOOLEAN
    has_phone: BOOLEAN
do
    has_email := True
    has_phone := False
    
    create builder.make
    builder.put_string ("name", "Bob")
           .put_integer ("age", 25)
           .put_string_if (has_email, "email", "bob@example.com")
           .put_string_if (has_phone, "phone", "555-1234")
    
    json_string := builder.to_string
    -- Output: {"name":"Bob","age":25,"email":"bob@example.com"}
end
```

### Working with Arrays
```eiffel
local
    arr: SIMPLE_JSON_ARRAY
do
    create arr.make_empty
    arr.append_string ("Alice")
    arr.append_string ("Bob")
    arr.append_string ("Carol")
    arr.insert_string_at (2, "Betty")  -- Insert between Alice and Bob
    
    -- Result: ["Alice","Betty","Bob","Carol"]
    print ("Count: " + arr.count.out)
end
```

### Type Checking
```eiffel
local
    json: JSON
    value: SIMPLE_JSON_VALUE
do
    create json.make_from_string ("{%"count%": 42}")
    value := json.value_at ("count")
    
    if value.is_integer then
        print ("It's an integer: " + json.integer_value_at ("count").out)
    elseif value.is_string then
        print ("It's a string: " + json.string_value_at ("count"))
    elseif value.is_decimal then
        print ("It's a decimal with arbitrary precision")
    end
end
```

## Core Components

### JSON
The main facade class providing the primary interface for parsing and querying JSON data.

**Key Features:**
- Parse JSON strings
- Query values by path
- Type-safe value extraction
- Validation and error reporting with line/column positions

### JSON_BUILDER
Fluent interface for constructing JSON structures programmatically.

**Key Features:**
- Build objects and arrays
- Add typed fields and elements
- Conditional field addition with `put_*_if`
- Merge, remove, rename operations
- Generate formatted JSON strings
- Clone for template reuse

### SIMPLE_JSON_DECIMAL
Arbitrary precision decimal numbers for financial and scientific applications.

**Key Features:**
- Exact decimal representation (no floating-point errors)
- Financial-grade arithmetic
- IEEE 754R compliant
- Perfect for money, prices, and precise measurements
- See [docs/DECIMAL_SUPPORT_GUIDE.md](docs/DECIMAL_SUPPORT_GUIDE.md)

### SIMPLE_JSON_ARRAY
Dynamic array with full modification support.

**Key Features:**
- Append elements (all types)
- Insert elements at any position
- Remove elements
- Clear array
- Clone for independent copies
- Type-safe element access

### SIMPLE_JSON_OBJECT
Object representation with enhanced operations.

**Key Features:**
- Direct manipulation of JSON structures
- Merge objects
- Rename and remove keys
- Clone for independent copies

### JSON_QUERY
Advanced querying capabilities for complex JSON navigation.

**Key Features:**
- Path-based navigation
- Type checking with introspection
- Existence verification
- Deep object traversal

## Documentation

Comprehensive documentation is available:

- **[Quick Start](docs/quick-start.html)** - Get started quickly
- **[User Guide](docs/user-guide.html)** - Complete usage documentation
- **[DECIMAL Support](docs/DECIMAL_SUPPORT_GUIDE.md)** - Arbitrary precision guide
- **[Use Cases](docs/use-cases/)** - Detailed examples for common scenarios
  - [Building JSON](docs/use-cases/building-json.html)
  - [Error Handling](docs/use-cases/error-handling.html)
  - [Path Navigation](docs/use-cases/path-navigation.html)
  - [Query Interface](docs/use-cases/query-interface.html)
  - [Quick Extraction](docs/use-cases/quick-extraction.html)
  - [Validation](docs/use-cases/validation.html)
- **[Type Introspection Guide](docs/markdown/Part_1_-_Step_1_-_Introspection.md)**
- **[Builder Enhancements](docs/markdown/builder-enhancements.md)**
- **[Array Enhancements](docs/markdown/array-enhancements.md)**

### EIS Integration

All documentation is integrated with EiffelStudio's EIS system. Press F1 on any feature to access context-sensitive help.

## Testing

The library includes a comprehensive test suite with 100% coverage:

- **151 tests** across 11 test classes
- **Path and Integer Tests** (`TEST_JSON_FACADE`)
- **Type Introspection** (`TEST_JSON_TYPE_INTROSPECTION`)
- **Builder Enhancements** (`TEST_JSON_BUILDER_ENHANCEMENTS`)
- **Array Enhancements** (`TEST_JSON_ARRAY_ENHANCEMENTS`)
- **DECIMAL Precision** (`TEST_SIMPLE_JSON_DECIMAL_PRETTY_PRINTING`) ⭐ NEW
- **Basic Parsing** (`TEST_SIMPLE_JSON`)
- **Error Conditions** (`TEST_SIMPLE_JSON_ERRORS`)
- **JSON Generation** (`TEST_SIMPLE_JSON_GENERATION`)
- **Nested Structures** (`TEST_SIMPLE_JSON_NESTED`)
- **Number Formats** (`TEST_SIMPLE_JSON_NUMBERS`)
- **Query Interface** (`TEST_SIMPLE_JSON_QUERIES`)

### Running Tests

1. Open `simple_json.ecf` in EiffelStudio
2. Set the testing configuration as the active target
3. Compile and run tests
4. All 151 tests should pass ✅

## API Reference

### JSON Class

| Method | Description |
|--------|-------------|
| `make_from_string (json_string: STRING)` | Parse JSON from string |
| `is_valid: BOOLEAN` | Check if parsing succeeded |
| `string_value_at (path: STRING): STRING` | Extract string value |
| `integer_value_at (path: STRING): INTEGER` | Extract integer value |
| `real_value_at (path: STRING): REAL` | Extract real number value |
| `boolean_value_at (path: STRING): BOOLEAN` | Extract boolean value |
| `value_at (path: STRING): SIMPLE_JSON_VALUE` | Get value for type checking |
| `has_key (path: STRING): BOOLEAN` | Check if key exists |
| `error_message: STRING` | Get parse error description |

### JSON_BUILDER Class

| Method | Description |
|--------|-------------|
| `put_string (key, value: STRING)` | Add string field |
| `put_integer (key: STRING; value: INTEGER)` | Add integer field |
| `put_real (key: STRING; value: REAL)` | Add real field |
| `put_boolean (key: STRING; value: BOOLEAN)` | Add boolean field |
| `put_string_if (condition: BOOLEAN; key, value: STRING)` | Add string if condition true |
| `put_integer_if (condition: BOOLEAN; key: STRING; value: INTEGER)` | Add integer if condition true |
| `put_boolean_if (condition: BOOLEAN; key: STRING; value: BOOLEAN)` | Add boolean if condition true |
| `put_real_if (condition: BOOLEAN; key: STRING; value: REAL)` | Add real if condition true |
| `merge (other: SIMPLE_JSON_OBJECT)` | Merge another object |
| `remove (key: STRING)` | Remove a key |
| `rename_key (old_key, new_key: STRING)` | Rename a key |
| `clear` | Clear all entries |
| `to_string: STRING` | Generate JSON string |
| `build: SIMPLE_JSON_OBJECT` | Get underlying object |
| `clone_object: SIMPLE_JSON_OBJECT` | Get independent copy |

### SIMPLE_JSON_DECIMAL Class ⭐ NEW

| Method | Description |
|--------|-------------|
| `make_from_string (value: STRING)` | Create from string (recommended) |
| `make_from_integer (value: INTEGER)` | Create from integer |
| `make_from_real (value: REAL_64)` | Create from real (use cautiously) |
| `make_from_decimal (value: DECIMAL)` | Create from existing DECIMAL |
| `decimal_value: DECIMAL` | Get underlying DECIMAL |
| `to_json_string: STRING` | Convert to JSON representation |
| `to_pretty_string (indent: INTEGER): STRING` | Pretty print |
| `is_decimal: BOOLEAN` | Type check (always True) |
| `is_number: BOOLEAN` | Type check (always True) |

### SIMPLE_JSON_ARRAY Class

| Method | Description |
|--------|-------------|
| `append_string (value: STRING)` | Append string to end |
| `append_integer (value: INTEGER)` | Append integer to end |
| `append_real (value: REAL_64)` | Append real to end |
| `append_boolean (value: BOOLEAN)` | Append boolean to end |
| `append_object (value: SIMPLE_JSON_OBJECT)` | Append object to end |
| `append_array (value: SIMPLE_JSON_ARRAY)` | Append array to end |
| `insert_string_at (index: INTEGER; value: STRING)` | Insert string at position |
| `insert_integer_at (index: INTEGER; value: INTEGER)` | Insert integer at position |
| `remove_at (index: INTEGER)` | Remove element at position |
| `clear` | Remove all elements |
| `json_clone: SIMPLE_JSON_ARRAY` | Create independent copy |
| `count: INTEGER` | Number of elements |
| `string_at (index: INTEGER): STRING` | Get string at position |
| `integer_at (index: INTEGER): INTEGER` | Get integer at position |
| `object_at (index: INTEGER): SIMPLE_JSON_OBJECT` | Get object at position |

### SIMPLE_JSON_VALUE Type Checking

| Method | Description |
|--------|-------------|
| `is_string: BOOLEAN` | Is this a string value? |
| `is_number: BOOLEAN` | Is this any numeric value? |
| `is_integer: BOOLEAN` | Is this an integer value? |
| `is_real: BOOLEAN` | Is this a real/decimal value? |
| `is_decimal: BOOLEAN` | Is this an arbitrary precision decimal? ⭐ NEW |
| `is_boolean: BOOLEAN` | Is this a boolean value? |
| `is_null: BOOLEAN` | Is this a null value? |
| `is_object: BOOLEAN` | Is this an object? |
| `is_array: BOOLEAN` | Is this an array? |

## Requirements

- **EiffelStudio**: Version 19.05 or later recommended
- **Platform**: Windows, macOS, Linux
- **Dependencies**: EiffelBase (standard library)
- **Optional**: DECIMAL library (for SIMPLE_JSON_DECIMAL support)

## Design Principles

Simple JSON follows these key principles:

1. **Simplicity First**: API designed for ease of use without sacrificing power
2. **Type Safety**: Leverage Eiffel's type system for compile-time safety
3. **Precision Options**: Choose between fast floating-point or exact decimal arithmetic
4. **Error Clarity**: Clear, actionable error messages with line and column positions
5. **Performance**: Efficient parsing and querying
6. **Testability**: 100% test coverage for reliability
7. **Design by Contract**: Comprehensive preconditions, postconditions, and invariants

## Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Coding Standards

- Follow Eiffel coding conventions
- Add tests for new features (maintain 100% coverage)
- Update documentation as needed
- Ensure all tests pass before submitting PR
- Include Design by Contract assertions

## Roadmap

### Completed ✅
- Position tracking for parse errors (line and column numbers)
- Type introspection methods
- Builder conditional methods
- Builder operations (merge, remove, rename, clear, clone)
- Array modification operations
- Arbitrary precision decimal support (SIMPLE_JSON_DECIMAL)
- Comprehensive documentation with EIS integration

### Future Enhancements 🚀
- [ ] JSON Schema validation
- [ ] Pretty-printing with custom formatting
- [ ] Streaming parser for large files
- [ ] JSON Pointer (RFC 6901) support
- [ ] JSON Patch (RFC 6902) support
- [ ] Performance optimizations
- [ ] Extended Unicode support

## Number Precision Guide

### When to Use REAL_64
- Graphics and game coordinates (speed matters)
- Physics simulations (approximate values OK)
- Statistical calculations
- Performance-critical code

### When to Use SIMPLE_JSON_DECIMAL
- 💰 Financial calculations (invoices, accounting)
- 📊 Scientific measurements (exact precision required)
- 👤 User-facing displays ("3.14" not "3.1400000000000001")
- 🔄 Data interchange (preserve exact decimal values)

See [docs/DECIMAL_SUPPORT_GUIDE.md](docs/DECIMAL_SUPPORT_GUIDE.md) for complete details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Larry Rix** (ljr1981)
- GitHub: [@ljr1981](https://github.com/ljr1981)
- Email: rix.larry@gmail.com

## Acknowledgments

- Built with [EiffelStudio](https://www.eiffel.com/)
- Inspired by the need for simple, elegant JSON handling in Eiffel
- Thanks to the Eiffel community for feedback and support
- AI-assisted development using Claude Sonnet 4.5
- DECIMAL library for arbitrary precision arithmetic

## Support

- **Issues**: Report bugs or request features via [GitHub Issues](https://github.com/ljr1981/simple_json/issues)
- **Discussions**: Join the conversation in [GitHub Discussions](https://github.com/ljr1981/simple_json/discussions)
- **Email**: rix.larry@gmail.com

## Related Projects

Looking for more Eiffel libraries? Check out:
- [Other ljr1981 projects](https://github.com/ljr1981)

---

**Made with ❤️ using Eiffel and AI**
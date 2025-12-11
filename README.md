<p align="center">
  <img src="https://raw.githubusercontent.com/simple-eiffel/claude_eiffel_op_docs/main/artwork/LOGO.png" alt="simple_ library logo" width="400">
</p>

# simple_json

**[Documentation](https://simple-eiffel.github.io/simple_json/)** | **[GitHub](https://github.com/simple-eiffel/simple_json)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Eiffel](https://img.shields.io/badge/Eiffel-25.02-blue.svg)](https://www.eiffel.org/)
[![Design by Contract](https://img.shields.io/badge/DbC-enforced-orange.svg)]()

Modern JSON library for Eiffel with RFC compliance and JSON Schema validation.

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

**Production** - 216 tests passing, 100% coverage

## Overview

SIMPLE_JSON builds on the standard eJSON library to provide modern features: **JSON Schema validation** (Draft 7), **JSON Pointer** (RFC 6901), **JSON Patch** (RFC 6902), **JSON Merge Patch** (RFC 7386), **JSONPath queries**, and streaming for large files.

```eiffel
local
    json: SIMPLE_JSON
do
    create json
    if attached json.parse ('{"users": [{"name": "Alice"}]}') as v then
        print (json.query_string (v, "$.users[0].name"))  -- "Alice"
    end
end
```

## Features

- **JSON Schema Validation** - Draft 7 support (only Eiffel library with this)
- **JSON Pointer** (RFC 6901) - Navigate with "/users/0/name"
- **JSON Patch** (RFC 6902) - add, remove, replace, move, copy, test
- **JSON Merge Patch** (RFC 7386) - Declarative document merging
- **JSONPath Queries** - SQL-like queries: "$.users[*].name"
- **Streaming Parser** - Process gigabyte files with constant memory
- **Full Unicode** - UTF-8/UTF-16 through STRING_32

## Installation

1. Set environment variable:
```bash
export SIMPLE_JSON=/path/to/simple_json
```

2. Add to ECF:
```xml
<library name="simple_json" location="$SIMPLE_JSON/simple_json.ecf"/>
```

## License

MIT License

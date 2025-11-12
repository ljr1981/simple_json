# JSON Builder Enhancements

## Overview

**Implementation Date:** November 12, 2025  
**Status:** Complete  
**Test Coverage:** 100% (15 tests)

The JSON_BUILDER class has been enhanced with powerful new capabilities for conditional building, merging, and key manipulation.

## New Features

### 1. Conditional Building (`*_if` methods)

Add fields only when conditions are met, eliminating verbose if-then blocks in client code.

#### Available Methods

- `put_string_if (condition: BOOLEAN; key: STRING; value: STRING): JSON_BUILDER`
- `put_integer_if (condition: BOOLEAN; key: STRING; value: INTEGER): JSON_BUILDER`
- `put_boolean_if (condition: BOOLEAN; key: STRING; value: BOOLEAN): JSON_BUILDER`
- `put_real_if (condition: BOOLEAN; key: STRING; value: REAL_64): JSON_BUILDER`

#### Usage Examples

**Before** (without conditional methods):
```eiffel
create builder.make
if user.has_email then
    builder.put_string ("email", user.email)
end
if user.age > 0 then
    builder.put_integer ("age", user.age)
end
if user.is_verified then
    builder.put_boolean ("verified", True)
end
```

**After** (with conditional methods):
```eiffel
create builder.make
builder.put_string_if (user.has_email, "email", user.email)
       .put_integer_if (user.age > 0, "age", user.age)
       .put_boolean_if (user.is_verified, "verified", True)
```

#### Real-World Example: API Request Builder

```eiffel
create builder.make
builder.put_string ("endpoint", "/api/users")
       .put_string ("method", "POST")
       .put_string_if (has_auth_token, "token", auth_token)
       .put_integer_if (timeout > 0, "timeout", timeout)
       .put_boolean_if (use_cache, "cache", True)

json_request := builder.to_string
```

### 2. Merge Operations

Combine multiple JSON objects efficiently.

#### Method

```eiffel
merge (other: SIMPLE_JSON_OBJECT): JSON_BUILDER
    -- Merge another object into this builder
    -- Existing keys will be overwritten by values from other
```

#### Usage Example

```eiffel
-- Create base configuration
create base_config.make_empty
base_config.put_string ("env", "production")
base_config.put_integer ("port", 8080)

-- Create custom overrides
create overrides.make_empty
overrides.put_integer ("port", 3000)  -- Override port
overrides.put_string ("host", "localhost")  -- Add new field

-- Merge them
create builder.make_from_object (base_config)
builder.merge (overrides)

-- Result: {"env":"production","port":3000,"host":"localhost"}
```

### 3. Key Management

#### Remove Keys

```eiffel
remove (key: STRING): JSON_BUILDER
    -- Remove key from object (fluent interface)
```

Example:
```eiffel
create builder.make
builder.put_string ("name", "Alice")
       .put_string ("temp_id", "12345")
       .put_integer ("age", 30)
       .remove ("temp_id")  -- Remove temporary field

-- Result: {"name":"Alice","age":30}
```

#### Rename Keys

```eiffel
rename_key (old_key: STRING; new_key: STRING): JSON_BUILDER
    -- Rename a key (fluent interface)
```

Example:
```eiffel
create builder.make
builder.put_string ("user_name", "Bob")
       .put_integer ("user_age", 25)
       .rename_key ("user_name", "name")
       .rename_key ("user_age", "age")

-- Result: {"name":"Bob","age":25}
```

### 4. Clear Operation

```eiffel
clear: JSON_BUILDER
    -- Clear all entries from the builder
```

Example:
```eiffel
create builder.make
builder.put_string ("temp1", "value1")
       .put_string ("temp2", "value2")
       .clear  -- Start fresh
       .put_string ("final", "value")

-- Result: {"final":"value"}
```

### 5. Clone Operation

```eiffel
clone_object: SIMPLE_JSON_OBJECT
    -- Get an independent copy of the underlying JSON object
```

Example:
```eiffel
create builder.make
builder.put_string ("name", "Alice")
       .put_integer ("age", 30)

template := builder.clone_object  -- Independent copy

-- Modify builder without affecting template
builder.put_string ("name", "Bob")
       .put_integer ("age", 25)

-- template still has: {"name":"Alice","age":30}
-- builder now has: {"name":"Bob","age":25}
```

## Complete API Reference

### Conditional Building
- `put_string_if (condition: BOOLEAN; key: STRING; value: STRING): JSON_BUILDER`
- `put_integer_if (condition: BOOLEAN; key: STRING; value: INTEGER): JSON_BUILDER`
- `put_boolean_if (condition: BOOLEAN; key: STRING; value: BOOLEAN): JSON_BUILDER`
- `put_real_if (condition: BOOLEAN; key: STRING; value: REAL_64): JSON_BUILDER`

### Operations
- `merge (other: SIMPLE_JSON_OBJECT): JSON_BUILDER`
- `remove (key: STRING): JSON_BUILDER`
- `rename_key (old_key: STRING; new_key: STRING): JSON_BUILDER`
- `clear: JSON_BUILDER`

### Output
- `to_string: STRING` — Convert to JSON string
- `build: SIMPLE_JSON_OBJECT` — Get the underlying JSON object
- `clone_object: SIMPLE_JSON_OBJECT` — Get an independent copy

## Design Patterns

### Pattern 1: Configuration Builder with Defaults

```eiffel
create builder.make
builder.put_string ("env", "production")
       .put_integer ("port", 8080)
       .put_boolean ("logging", True)
       .put_string_if (has_custom_host, "host", custom_host)
       .put_integer_if (has_custom_port, "port", custom_port)
```

### Pattern 2: Template-Based Object Creation

```eiffel
-- Create template
create template_builder.make
template_builder.put_string ("version", "1.0")
                .put_boolean ("active", True)
                
template := template_builder.clone_object

-- Use template for multiple instances
from users.start
until users.after
loop
    create builder.make_from_object (template.json_clone)
    builder.put_string ("id", users.item.id)
           .put_string ("name", users.item.name)
    
    send_to_api (builder.to_string)
    users.forth
end
```

### Pattern 3: Incremental Object Construction

```eiffel
create builder.make

-- Add required fields
builder.put_string ("type", "user")
       .put_string ("id", generate_id)

-- Add optional fields based on user data
builder.put_string_if (user.has_email, "email", user.email)
       .put_string_if (user.has_phone, "phone", user.phone)
       .put_string_if (user.has_address, "address", user.address)

-- Add computed fields
builder.put_integer ("age", compute_age (user.birth_date))
       .put_boolean ("is_adult", compute_age (user.birth_date) >= 18)
```

## Performance Considerations

1. **Conditional Methods**: Zero overhead when condition is False — no object creation, no key insertion
2. **Merge**: O(n) where n is the number of keys in the merged object
3. **Remove**: O(n) where n is the number of keys in the object
4. **Rename**: O(n) where n is the number of keys in the object
5. **Clone**: Creates deep copy — O(n) where n is the total size of JSON structure

## Test Coverage

All features are comprehensively tested in `TEST_JSON_BUILDER_ENHANCEMENTS`:

- ✅ Conditional string addition (true/false conditions)
- ✅ Conditional integer addition
- ✅ Conditional boolean addition
- ✅ Conditional real addition
- ✅ Merge operations with overlapping/non-overlapping keys
- ✅ Remove operations
- ✅ Rename operations
- ✅ Clear operations
- ✅ Clone independence verification
- ✅ Fluent interface chaining
- ✅ Complex workflow integration

**Test File:** `test_json_builder_enhancements.e`  
**Test Count:** 15 tests  
**Coverage:** 100%

## Design by Contract

All methods include comprehensive preconditions, postconditions, and invariants:

### Preconditions
- Keys must not be empty
- Referenced objects must be valid (attached)
- Indexes must be valid for operations

### Postconditions
- All methods return `Current` for fluent chaining
- Key operations are verified (has_key, removed, renamed)
- Count changes are verified for clear operations

### Invariants
- Builder always has a valid JSON object (`attached json_object`)

## Migration Guide

### From Old Style to Conditional Methods

**Old Code:**
```eiffel
if condition1 then
    builder.put_string ("field1", value1)
end
if condition2 then
    builder.put_integer ("field2", value2)
end
```

**New Code:**
```eiffel
builder.put_string_if (condition1, "field1", value1)
       .put_integer_if (condition2, "field2", value2)
```

### Benefits of New Style
- ✅ More concise and readable
- ✅ Maintains fluent interface flow
- ✅ Self-documenting code
- ✅ Easier to test and maintain
- ✅ Better for inline construction

## See Also

- [JSON_BUILDER API Reference](../api/json_builder.html)
- [Building JSON Use Cases](../use-cases/building-json.html)
- [Quick Start Guide](../quick-start.html)
- [Array Enhancements](array-enhancements.md)

---

**Last Updated:** November 12, 2025  
**Author:** Larry Rix (ljr1981)

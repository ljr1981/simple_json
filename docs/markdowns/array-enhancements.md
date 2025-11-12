# JSON Array Enhancements

## Overview

**Implementation Date:** November 12, 2025  
**Status:** Complete  
**Test Coverage:** 100% (12 tests)

The SIMPLE_JSON_ARRAY class has been enhanced with comprehensive modification operations including append, insert, remove, and clear capabilities.

## New Features

### 1. Append Operations

Add elements to the end of arrays.

#### Available Methods

- `append_string (value: STRING)`
- `append_integer (value: INTEGER)`
- `append_real (value: REAL_64)`
- `append_boolean (value: BOOLEAN)`
- `append_object (value: SIMPLE_JSON_OBJECT)`
- `append_array (value: SIMPLE_JSON_ARRAY)`

#### Usage Example

```eiffel
local
    arr: SIMPLE_JSON_ARRAY
do
    create arr.make_empty
    
    arr.append_string ("apple")
    arr.append_string ("banana")
    arr.append_string ("cherry")
    
    -- Result: ["apple","banana","cherry"]
    -- Count: 3
end
```

#### Real-World Example: Building a Task List

```eiffel
local
    tasks: SIMPLE_JSON_ARRAY
    task1, task2: SIMPLE_JSON_OBJECT
    builder: JSON_BUILDER
do
    -- Create individual tasks
    create builder.make
    builder.put_string ("title", "Write documentation")
           .put_boolean ("completed", True)
    task1 := builder.clone_object
    
    create builder.make
    builder.put_string ("title", "Review code")
           .put_boolean ("completed", False)
    task2 := builder.clone_object
    
    -- Build task array
    create tasks.make_empty
    tasks.append_object (task1)
    tasks.append_object (task2)
    
    -- Result: [
    --   {"title":"Write documentation","completed":true},
    --   {"title":"Review code","completed":false}
    -- ]
end
```

### 2. Insert Operations

Insert elements at specific positions.

#### Available Methods

- `insert_string_at (index: INTEGER; value: STRING)`
- `insert_integer_at (index: INTEGER; value: INTEGER)`

#### Usage Example

```eiffel
local
    arr: SIMPLE_JSON_ARRAY
do
    create arr.make_empty
    
    arr.append_string ("first")
    arr.append_string ("third")
    
    -- Insert between first and third
    arr.insert_string_at (2, "second")
    
    -- Result: ["first","second","third"]
end
```

**Note:** Elements at and after the insertion index are shifted right.

#### Preconditions

- Index must be >= 1
- Index must be <= count + 1 (can insert at end)

### 3. Remove Operations

Remove individual elements or clear entire array.

#### Remove Single Element

```eiffel
remove_at (index: INTEGER)
    -- Remove element at index (1-based)
```

Example:
```eiffel
local
    arr: SIMPLE_JSON_ARRAY
do
    create arr.make_empty
    
    arr.append_string ("keep")
    arr.append_string ("remove")
    arr.append_string ("keep")
    
    arr.remove_at (2)  -- Remove "remove"
    
    -- Result: ["keep","keep"]
end
```

**Note:** Elements after the removed element are shifted left.

#### Clear All Elements

```eiffel
clear
    -- Remove all elements from array
```

Example:
```eiffel
local
    arr: SIMPLE_JSON_ARRAY
do
    create arr.make_empty
    
    arr.append_string ("temp1")
    arr.append_string ("temp2")
    arr.append_string ("temp3")
    
    arr.clear  -- Remove all
    
    -- Result: []
    -- Count: 0
    assert ("is_empty", arr.is_empty)
end
```

### 4. Clone Operation

Create independent copies of arrays.

```eiffel
json_clone: SIMPLE_JSON_ARRAY
    -- Create an independent copy of this array
```

Example:
```eiffel
local
    original, copy: SIMPLE_JSON_ARRAY
do
    create original.make_empty
    original.append_string ("Alice")
    original.append_integer (30)
    
    copy := original.json_clone
    
    -- Modify copy without affecting original
    copy.append_string ("Bob")
    
    -- original.count = 2
    -- copy.count = 3
end
```

## Complete API Reference

### Modification - Append
- `append_string (value: STRING)`
- `append_integer (value: INTEGER)`
- `append_real (value: REAL_64)`
- `append_boolean (value: BOOLEAN)`
- `append_object (value: SIMPLE_JSON_OBJECT)`
- `append_array (value: SIMPLE_JSON_ARRAY)`

### Modification - Insert
- `insert_string_at (index: INTEGER; value: STRING)`
- `insert_integer_at (index: INTEGER; value: INTEGER)`

### Modification - Remove
- `remove_at (index: INTEGER)`
- `clear`

### Operations
- `json_clone: SIMPLE_JSON_ARRAY`

### Status Report
- `count: INTEGER` — Number of elements
- `is_empty: BOOLEAN` — Is array empty?
- `valid_index (index: INTEGER): BOOLEAN` — Is index valid?

### Access
- `string_at (index: INTEGER): detachable STRING`
- `integer_at (index: INTEGER): INTEGER`
- `real_at (index: INTEGER): REAL_64`
- `boolean_at (index: INTEGER): BOOLEAN`
- `object_at (index: INTEGER): detachable SIMPLE_JSON_OBJECT`
- `array_at (index: INTEGER): detachable SIMPLE_JSON_ARRAY`

## Design Patterns

### Pattern 1: Dynamic List Building

```eiffel
local
    items: SIMPLE_JSON_ARRAY
    item: SIMPLE_JSON_OBJECT
do
    create items.make_empty
    
    from data_source.start
    until data_source.after
    loop
        create item.make_empty
        item.put_string ("id", data_source.item.id)
        item.put_string ("name", data_source.item.name)
        
        items.append_object (item)
        
        data_source.forth
    end
end
```

### Pattern 2: Filtered Array Construction

```eiffel
local
    original, filtered: SIMPLE_JSON_ARRAY
    i: INTEGER
do
    -- Start with original array
    create original.make_from_json (source_array)
    
    -- Build filtered version
    create filtered.make_empty
    
    from i := 1
    until i > original.count
    loop
        if should_include (original.integer_at (i)) then
            filtered.append_integer (original.integer_at (i))
        end
        i := i + 1
    end
end
```

### Pattern 3: Array Transformation

```eiffel
local
    input, output: SIMPLE_JSON_ARRAY
    i: INTEGER
    transformed: INTEGER
do
    -- Transform each element
    create output.make_empty
    
    from i := 1
    until i > input.count
    loop
        transformed := transform_function (input.integer_at (i))
        output.append_integer (transformed)
        i := i + 1
    end
end
```

### Pattern 4: Insertion Sort Example

```eiffel
local
    sorted: SIMPLE_JSON_ARRAY
    value: INTEGER
    insert_pos: INTEGER
do
    create sorted.make_empty
    
    from unsorted.start
    until unsorted.after
    loop
        value := unsorted.item
        insert_pos := find_insert_position (sorted, value)
        
        sorted.insert_integer_at (insert_pos, value)
        
        unsorted.forth
    end
end
```

## Indexing Note

**Important:** All SIMPLE_JSON_ARRAY operations use 1-based indexing, consistent with Eiffel conventions.

- First element is at index 1
- Last element is at index `count`
- Valid indices: 1 to `count`
- For insert operations: 1 to `count + 1` (can insert at end)

Example:
```eiffel
create arr.make_empty
arr.append_string ("A")  -- index 1
arr.append_string ("B")  -- index 2
arr.append_string ("C")  -- index 3

-- arr.string_at (1) = "A"
-- arr.string_at (3) = "C"
-- arr.count = 3
```

## Performance Considerations

1. **Append Operations**: O(1) — constant time addition to end
2. **Insert Operations**: O(n) — requires rebuilding array
3. **Remove Operations**: O(n) — requires rebuilding array
4. **Clear**: O(1) — creates new empty array
5. **Clone**: O(n) — creates deep copy via serialization

### Performance Tips

- Prefer append over insert when order doesn't matter
- Batch removes by collecting indices and removing in reverse order
- Use clear when removing all elements rather than individual removes

## Test Coverage

All features are comprehensively tested in `TEST_JSON_ARRAY_ENHANCEMENTS`:

- ✅ Append operations (all types)
- ✅ Insert operations at various positions
- ✅ Remove operations
- ✅ Clear operation
- ✅ Clone independence verification
- ✅ Index boundary conditions
- ✅ Empty array handling
- ✅ Count verification after modifications

**Test File:** `test_json_array_enhancements.e`  
**Test Count:** 12 tests  
**Coverage:** 100%

## Design by Contract

All methods include comprehensive preconditions, postconditions, and invariants:

### Preconditions
- Indices must be valid for the operation
- Objects and arrays must be attached (valid)

### Postconditions
- Count increases after append/insert
- Count decreases after remove
- Count becomes 0 after clear
- is_empty is true after clear
- Clones are independent objects

### Invariants
- Array always has valid underlying JSON array (`attached json_array`)

## Common Use Cases

### Use Case 1: Building Response Arrays

```eiffel
-- Build array of error messages
create errors.make_empty

if validation_failed then
    errors.append_string ("Invalid email format")
end

if password_weak then
    errors.append_string ("Password too weak")
end

if age_invalid then
    errors.append_string ("Age must be 18 or older")
end

-- Return: ["Invalid email format", "Password too weak", "Age must be 18 or older"]
```

### Use Case 2: Processing Queue

```eiffel
-- Process items in order
from
until queue.is_empty
loop
    process_item (queue.string_at (1))
    queue.remove_at (1)  -- Remove processed item
end
```

### Use Case 3: Building Nested Structures

```eiffel
-- Create user with array of roles
create user_builder.make
user_builder.put_string ("username", "alice")

create roles.make_empty
roles.append_string ("admin")
roles.append_string ("editor")
roles.append_string ("viewer")

user_builder.put_array ("roles", roles)

-- Result: {"username":"alice","roles":["admin","editor","viewer"]}
```

## Error Handling

### Invalid Index

Accessing invalid indices results in default values:

```eiffel
create arr.make_empty
arr.append_string ("test")

-- Valid: arr.string_at (1) returns "test"
-- Invalid: arr.string_at (5) returns Void (for references)
-- Invalid: arr.integer_at (5) returns 0 (for integers)
```

### Precondition Violations

Operations with preconditions will fail if violated:

```eiffel
create arr.make_empty
arr.append_string ("A")
arr.append_string ("B")

-- This violates precondition: valid_index (3) is False
-- arr.remove_at (3)  -- Would cause precondition violation
```

## See Also

- [SIMPLE_JSON_ARRAY API Reference](../api/simple_json_array.html)
- [Builder Enhancements](builder-enhancements.md)
- [Quick Start Guide](../quick-start.html)
- [Type Introspection](../Part_1_-_Step_1_-_Introspection.md)

---

**Last Updated:** November 12, 2025  
**Author:** Larry Rix (ljr1981)

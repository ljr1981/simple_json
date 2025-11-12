# Part 1 - Step 2: Builder and Array Enhancements

## Overview

**Task:** Priority 1, Items 2 & 3 - JSON_BUILDER and Array Enhancements  
**Estimated Time:** 1-2 hours per enhancement  
**Actual Time:** ~3 hours total  
**Impact:** High - Significantly improves API ergonomics and flexibility  
**Files Affected:** `json_builder.e`, `simple_json_array.e`, and test files

## What This Adds

This step adds two major enhancement groups:

### JSON_BUILDER Enhancements

1. **Conditional Building** — `put_*_if` methods
2. **Merge Operations** — Combine JSON objects
3. **Key Management** — Remove and rename keys
4. **Clear Operation** — Reset builder
5. **Clone Operation** — Create independent copies

### SIMPLE_JSON_ARRAY Enhancements

1. **Append Operations** — Add elements to end
2. **Insert Operations** — Add elements at specific positions
3. **Remove Operations** — Delete elements
4. **Clear Operation** — Empty the array
5. **Clone Operation** — Create independent copies

## Why This Matters

### Before Enhancements

**Builder:**
```eiffel
create builder.make
if has_email then
    builder.put_string ("email", email)
end
if has_phone then
    builder.put_string ("phone", phone)
end
-- Verbose, breaks fluent flow
```

**Array:**
```eiffel
-- Had to create new arrays for modifications
-- No way to append, insert, or remove
-- Limited to read-only operations
```

### After Enhancements

**Builder:**
```eiffel
create builder.make
builder.put_string_if (has_email, "email", email)
       .put_string_if (has_phone, "phone", phone)
       .put_integer ("age", age)
-- Fluent, concise, expressive
```

**Array:**
```eiffel
create arr.make_empty
arr.append_string ("first")
arr.append_string ("second")
arr.insert_string_at (2, "middle")
arr.remove_at (3)
-- Full modification capabilities
```

## Implementation Summary

### JSON_BUILDER Changes

#### New Feature Group: Conditional Building

Added four conditional methods:

```eiffel
feature -- Building (Conditional)

    put_string_if (a_condition: BOOLEAN; a_key: STRING; a_value: STRING): JSON_BUILDER
    put_integer_if (a_condition: BOOLEAN; a_key: STRING; a_value: INTEGER): JSON_BUILDER
    put_boolean_if (a_condition: BOOLEAN; a_key: STRING; a_value: BOOLEAN): JSON_BUILDER
    put_real_if (a_condition: BOOLEAN; a_key: STRING; a_value: REAL_64): JSON_BUILDER
```

#### New Feature Group: Operations

Added management operations:

```eiffel
feature -- Operations

    merge (a_other: SIMPLE_JSON_OBJECT): JSON_BUILDER
        -- Merge another object into this builder
        
    remove (a_key: STRING): JSON_BUILDER
        -- Remove key from object
        
    rename_key (a_old_key: STRING; a_new_key: STRING): JSON_BUILDER
        -- Rename a key
        
    clear: JSON_BUILDER
        -- Clear all entries
```

#### Enhanced Output Feature

Added clone capability:

```eiffel
feature -- Output

    clone_object: SIMPLE_JSON_OBJECT
        -- Get an independent copy of the underlying JSON object
```

### SIMPLE_JSON_ARRAY Changes

#### New Feature Group: Modification (Append/Prepend)

```eiffel
feature -- Modification (Append/Prepend)

    append_string (a_value: STRING)
    append_integer (a_value: INTEGER)
    append_real (a_value: REAL_64)
    append_boolean (a_value: BOOLEAN)
    append_object (a_value: SIMPLE_JSON_OBJECT)
    append_array (a_value: SIMPLE_JSON_ARRAY)
```

#### New Feature Group: Modification (Insert/Remove)

```eiffel
feature -- Modification (Insert/Remove)

    insert_string_at (a_index: INTEGER; a_value: STRING)
    insert_integer_at (a_index: INTEGER; a_value: INTEGER)
    remove_at (a_index: INTEGER)
    clear
```

#### New Feature Group: Operations

```eiffel
feature -- Operations

    json_clone: SIMPLE_JSON_ARRAY
        -- Create an independent copy of this array
```

## Test Coverage

### TEST_JSON_BUILDER_ENHANCEMENTS (15 tests)

✅ `test_put_string_if_true` — Conditional addition when true  
✅ `test_put_string_if_false` — No addition when false  
✅ `test_put_integer_if` — Conditional integer  
✅ `test_put_boolean_if` — Conditional boolean  
✅ `test_put_real_if` — Conditional real  
✅ `test_merge_non_overlapping` — Merge distinct keys  
✅ `test_merge_overlapping` — Merge with overwrites  
✅ `test_merge_empty` — Merge empty object  
✅ `test_remove_existing` — Remove existing key  
✅ `test_remove_nonexistent` — Remove missing key  
✅ `test_rename_key` — Rename existing key  
✅ `test_clear` — Clear all entries  
✅ `test_clone_independence` — Clone creates copy  
✅ `test_fluent_chaining` — Chain multiple operations  
✅ `test_complex_workflow` — Real-world scenario  

### TEST_JSON_ARRAY_ENHANCEMENTS (12 tests)

✅ `test_append_string` — Append string elements  
✅ `test_append_integer` — Append integer elements  
✅ `test_append_real` — Append real elements  
✅ `test_append_boolean` — Append boolean elements  
✅ `test_append_object` — Append object elements  
✅ `test_append_array` — Append array elements  
✅ `test_insert_string_at_beginning` — Insert at start  
✅ `test_insert_string_at_middle` — Insert in middle  
✅ `test_insert_integer_at_end` — Insert at end  
✅ `test_remove_at` — Remove elements  
✅ `test_clear` — Clear array  
✅ `test_clone_independence` — Clone creates copy  

**Total: 27 new tests, 100% passing**

## Design by Contract

All new features include comprehensive DbC:

### Preconditions

- Keys must not be empty
- Objects/arrays must be attached
- Indices must be valid
- Conditional parameters are boolean expressions

### Postconditions

- Fluent methods return `Current`
- Count changes verified
- Key presence/absence verified
- Clone independence verified

### Invariants

- Builder always has valid object
- Array always has valid underlying array

## Real-World Use Cases

### Use Case 1: API Request Builder

```eiffel
feature -- API Building

    build_api_request (endpoint: STRING; has_auth: BOOLEAN; auth_token: STRING;
                       timeout: INTEGER; use_cache: BOOLEAN): STRING
        local
            builder: JSON_BUILDER
        do
            create builder.make
            builder.put_string ("endpoint", endpoint)
                   .put_string ("method", "GET")
                   .put_string_if (has_auth, "auth_token", auth_token)
                   .put_integer_if (timeout > 0, "timeout_ms", timeout)
                   .put_boolean_if (use_cache, "enable_cache", use_cache)
            
            Result := builder.to_string
        end
```

### Use Case 2: Configuration Merging

```eiffel
feature -- Configuration

    apply_environment_config (base_config: SIMPLE_JSON_OBJECT; 
                              env: STRING): STRING
        local
            builder: JSON_BUILDER
            env_config: SIMPLE_JSON_OBJECT
        do
            -- Start with base configuration
            create builder.make_from_object (base_config.json_clone)
            
            -- Load environment-specific overrides
            env_config := load_env_config (env)
            
            -- Merge overrides
            builder.merge (env_config)
            
            Result := builder.to_string
        end
```

### Use Case 3: Dynamic List Building

```eiffel
feature -- Data Processing

    build_user_list (users: LIST [USER]): STRING
        local
            users_array: SIMPLE_JSON_ARRAY
            user_obj: SIMPLE_JSON_OBJECT
            builder: JSON_BUILDER
        do
            create users_array.make_empty
            
            from users.start
            until users.after
            loop
                create builder.make
                builder.put_string ("id", users.item.id)
                       .put_string ("name", users.item.name)
                       .put_string_if (users.item.has_email, "email", users.item.email)
                       .put_integer ("age", users.item.age)
                
                users_array.append_object (builder.build)
                users.forth
            end
            
            Result := users_array.to_json_string
        end
```

### Use Case 4: Array Transformation

```eiffel
feature -- Array Processing

    filter_and_transform (input: SIMPLE_JSON_ARRAY): SIMPLE_JSON_ARRAY
        local
            i: INTEGER
            value: INTEGER
            transformed: INTEGER
        do
            create Result.make_empty
            
            from i := 1
            until i > input.count
            loop
                value := input.integer_at (i)
                
                -- Filter: only process values > 10
                if value > 10 then
                    -- Transform: multiply by 2
                    transformed := value * 2
                    Result.append_integer (transformed)
                end
                
                i := i + 1
            end
        end
```

## Benefits Summary

### JSON_BUILDER Enhancements

✅ **Concise Code** — Eliminate verbose if-then blocks  
✅ **Fluent Flow** — Maintain method chaining  
✅ **Flexibility** — Merge, remove, rename, clear  
✅ **Reusability** — Clone templates for multiple uses  
✅ **Maintainability** — Self-documenting conditional logic  

### SIMPLE_JSON_ARRAY Enhancements

✅ **Full CRUD** — Create, read, update, delete elements  
✅ **Dynamic Building** — Construct arrays programmatically  
✅ **Flexible Insertion** — Add elements anywhere  
✅ **Safe Modification** — DbC ensures valid operations  
✅ **Independence** — Clone for safe copying  

## Performance Notes

### Builder Operations

- **Conditional methods**: Zero overhead when condition is false
- **Merge**: O(n) where n = keys in merged object
- **Remove/Rename**: O(n) where n = total keys
- **Clone**: O(n) via serialization

### Array Operations

- **Append**: O(1) constant time
- **Insert**: O(n) requires array rebuild
- **Remove**: O(n) requires array rebuild
- **Clone**: O(n) via serialization

## Documentation Updates

Created comprehensive documentation:

1. **builder-enhancements.md** — Complete builder reference
2. **array-enhancements.md** — Complete array reference
3. **This file** — Implementation overview
4. **Updated README** — Feature highlights
5. **EIS Links** — Integrated with EiffelStudio

## Integration with EIS

All enhancements are documented with EIS links:

**In json_builder.e:**
```eiffel
EIS: "name=Builder Enhancements Documentation",
     "src=file:///${SYSTEM_PATH}/docs/markdown/builder-enhancements.md",
     "protocol=uri",
     "tag=documentation, builder, enhancements"
```

Press F1 on any builder feature in EiffelStudio to see relevant documentation.

## Migration Guide

### Updating Existing Code

**Pattern 1: Simple conditional fields**

Before:
```eiffel
if condition then
    builder.put_string (key, value)
end
```

After:
```eiffel
builder.put_string_if (condition, key, value)
```

**Pattern 2: Array building**

Before:
```eiffel
-- Had to work with underlying JSON_ARRAY directly
-- or build complete array at construction
```

After:
```eiffel
create arr.make_empty
arr.append_string ("item1")
arr.append_string ("item2")
```

## Next Steps

After completing this step:

1. ✅ Commit changes: `git add . && git commit -m "Add builder and array enhancements"`
2. ✅ Push to GitHub: `git push`
3. ✅ Update documentation
4. ⬜ Move to Priority 2: Pretty Printing (if desired)

## Common Issues and Solutions

### Issue 1: Breaking fluent chain with conditionals

**Problem:**
```eiffel
builder.put_string ("name", name)
if has_email then
    builder.put_string ("email", email)
end
builder.put_integer ("age", age)
```

**Solution:**
```eiffel
builder.put_string ("name", name)
       .put_string_if (has_email, "email", email)
       .put_integer ("age", age)
```

### Issue 2: Modifying shared arrays

**Problem:**
```eiffel
arr1 := original_array
arr1.append_string ("new")  -- Also modifies original!
```

**Solution:**
```eiffel
arr1 := original_array.json_clone
arr1.append_string ("new")  -- Independent copy
```

### Issue 3: Invalid array indices

**Problem:**
```eiffel
arr.insert_string_at (0, "value")  -- Invalid: 0-based
```

**Solution:**
```eiffel
arr.insert_string_at (1, "value")  -- Correct: 1-based
```

## Time Breakdown

- **Planning**: 30 minutes — Design API, review patterns
- **Builder Implementation**: 1 hour — Code + DbC
- **Array Implementation**: 1 hour — Code + DbC
- **Testing**: 45 minutes — Write comprehensive tests
- **Documentation**: 45 minutes — MD files + examples

**Total: ~3.5 hours** (slightly over estimate due to thorough documentation)

## Quality Metrics

- **Test Coverage**: 100% (27 tests, all passing)
- **DbC Coverage**: 100% (all features have pre/post/invariants)
- **Documentation**: Complete (MD files + EIS integration)
- **Code Review**: Clean, follows Eiffel conventions
- **Performance**: All operations O(1) or O(n) as expected

## Questions?

Review the detailed documentation:

- `docs/markdown/builder-enhancements.md` — Complete builder reference
- `docs/markdown/array-enhancements.md` — Complete array reference
- `test_json_builder_enhancements.e` — Builder test examples
- `test_json_array_enhancements.e` — Array test examples

---

**Implementation Date:** November 12, 2025  
**Status:** ✅ Complete  
**Author:** Larry Rix (ljr1981)

note
    description: "JSON decimal number with arbitrary precision using DECIMAL library"
    author: "Larry Rix"
    date: "$Date$"
    revision: "$Revision$"
    EIS: "name=DECIMAL Documentation", "src=https://github.com/ljr1981/simple_json/blob/main/docs/decimal-support.md"

class
    SIMPLE_JSON_DECIMAL

inherit
    SIMPLE_JSON_VALUE

    JSON_TYPE_DECIMAL  -- Provides all type checking features

create
    make_from_string,
    make_from_integer,
    make_from_real,
    make_from_decimal

feature {NONE} -- Initialization

    make_from_string (a_string: STRING)
            -- Create from string representation
        require
            valid_string: a_string /= Void and then not a_string.is_empty
        do
            create value.make_from_string (a_string)
        ensure
            value_set: value /= Void
        end

    make_from_integer (a_integer: INTEGER)
            -- Create from integer value
        do
            create value.make_from_integer (a_integer)
        ensure
            value_set: value /= Void
        end

    make_from_real (a_real: REAL_64)
            -- Create from real value (converts to string first to preserve precision)
        do
            create value.make_from_string (a_real.out)
        ensure
            value_set: value /= Void
        end

    make_from_decimal (a_decimal: DECIMAL)
            -- Create from existing DECIMAL value
        require
            valid_decimal: a_decimal /= Void
        do
            create value.make_copy (a_decimal)
        ensure
            value_set: value /= Void
        end

feature -- Access

    value: DECIMAL
            -- The decimal value

    decimal_value: DECIMAL
            -- Get the decimal value
        do
            Result := value
        end

    real_value: REAL_64
            -- Convert to REAL_64 (may lose precision)
        require
            is_double: value.is_double
        do
            Result := value.to_double
        end

    integer_value: INTEGER
            -- Convert to INTEGER
        require
            is_integer: value.is_integer
            large_enough: value >= value.decimal.minimum_integer
            small_enough: value <= value.decimal.maximum_integer
        do
            Result := value.to_integer
        end

    string_value: STRING
            -- Get string representation
        do
            Result := value.out
        end

feature -- Status report

    is_decimal: BOOLEAN = True
            -- Is this a decimal value?

    -- NOTE: is_number, is_string, is_integer, is_real, is_boolean,
    --       is_null, is_object, is_array are now inherited from JSON_TYPE_DECIMAL

feature -- Conversion

    to_json_string: STRING
            -- Convert to JSON string representation
        do
            Result := value.out
        ensure then
            result_not_void: Result /= Void
            not_empty: not Result.is_empty
        end

    to_pretty_string (a_indent: INTEGER): STRING
            -- Pretty print with indentation (decimals don't need indentation)
        do
            Result := value.out
        ensure then
            result_not_void: Result /= Void
            not_empty: not Result.is_empty
        end

invariant
    value_not_void: value /= Void

end

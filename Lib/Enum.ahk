; A base class for enums
; Enums must only contain static properties where each property has a different value
class _Enum extends _Object
{
    ; Get the value of the enum that is associated with the given name
    ; name: The name of the enum value as string
    ; Returns the value assigned to the name if it exists, null() otherwise
    GetValue(name)
    {
        Return ObjHasKey(this, name) ? this[name] : null()
    }

    ; Find the name of the enum value that has the given value
    ; value: The value to find the enum name for
    ; Returns the name of the enum property where the value is the same as the given, null() if value not found
    GetName(value)
    {
        For name, item in this
        {
            If (value = item)
            {
                Return name
            }
        }
        Return null()
    }

    ; Determines if any enum property has the given value
    ; value: The value to check
    ValidValue(value)
    {
        Return this.GetName(value) != null()
    }

    ; Returns a linar array of all enum names
    Names()
    {
        result := []

        For name, _ in this
        {
            result.Add(name)
        }

        Return result
    }

    ; Returns a linar array of all enum values
    Values()
    {
        result := []

        For each, value in this
        {
            result.Add(value)
        }

        Return result
    }

    ; An iterator where key is the enum name and value is the enum value
    _NewEnum()
    {
        Return new _Enum._iterator(this)
    }

    class _iterator extends DefaultIterator
    {
        __New(_enumClass_)
        {
            this._enum := ObjNewEnum(_enumClass_)
        }

        Next(ByRef k, ByRef v)
        {
            While (this._enum.Next(_k, _v))
            {
                If _k in __Class,__New,__Delete,_NewEnum
                {
                    Continue
                }
                If (IsFunc(_v))
                {
                    Continue
                }
                k := _k
                v := _v
                Return true
            }
            Return false
        }
    }
}

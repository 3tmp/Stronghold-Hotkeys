; Apply "native" support, redefines Array() to add custom ArrayList base object
Array(params*)
{
    ; Since params is already an array of the parameters, just give it a
    ; new base object and return it. Using this method, ArrayList.__New()
    ; is not called and any instance variables are not initialized.
    params.base := ArrayList
    Return params
}

; Gives access to several array methods.
; Only supports linear arrays
class ArrayList extends _Object
{
    ; Adds the item to the list
    Add(item)
    {
        this.Push(item)
    }

    ; Removes the item and returns it on success
    Remove(item)
    {
        index := this.IndexOf(item)
        If (index != null())
        {
            Return ObjRemoveAt(this, index)
        }
        Return null()
    }

    ; Removes the item at the given position and returns it
    RemoveAt(index)
    {
        If (!this.HasKey(index))
        {
            throw Exception("The index is out of bounds.")
        }
        Return ObjRemoveAt(this, index)
    }

    ; Inserts the item at the given position
    InsertAt(index, item)
    {
        ObjInsert(this, index, item)
    }

    ; Returns the size of the list
    Size()
    {
        Return this.Count()
    }

    ; Return true if the list is empty
    IsEmpty()
    {
        Return this.Count() == 0
    }

    ; Returns the item at the given index. Index must exist
    Get(index)
    {
        If (!this.HasKey(index))
        {
            throw Exception("The index is out of bounds.")
        }
        Return this[index]
    }

    ; Sets the new value at the given index. Index must exist
    Set(index, value)
    {
        If (!this.HasKey(index))
        {
            throw Exception("The index is out of bounds.")
        }
        oldValue := this[index]
        this[index] := value
        Return oldValue
    }

    ; Clears the list
    Clear()
    {
        ; Removes only integer keys
        ObjDelete(this, this.MinIndex(), this.MaxIndex())

        ; Any non integer keys found
        If (!this.IsEmpty())
        {
            objs := {}
            , firstStr := true
            , first := ""
            , last := ""
            For key in this
            {
                ; Necessary, because ObjDelete cannot be used with objects as keys when using two params
                If (IsObject(key))
                {
                    objs.Push(key)
                }
                Else
                {
                    If (firstStr)
                    {
                        first := key
                        firstStr := false
                    }
                    last := key
                }
            }

            If (first == last)
            {
                ObjDelete(this, first)
            }
            Else
            {
                ObjDelete(this, first, last)
            }

            ; Delete all objects
            For each, obj in objs
            {
                ObjDelete(this, obj)
            }
        }
    }

    ; Returns a shallow copy
    Copy()
    {
        Return ObjClone(this)
    }

    ; Returns a linear array that contains all items from this and removes all holes in the array (if any)
    ToArray()
    {
        list := []
        list.SetCapacity(this.Size())
        For each, item in this
        {
            list.Push(item)
        }
        Return list
    }

    ; Returns an iterator where key is an incrementing number (starting from 1)
    ; that indicates the position of the value in the list (1 means first item)
    _NewEnum()
    {
        Return ObjNewEnum(this)
    }

    ; Returns true if the given item is in the array
    Contains(item, fromIndex := 0)
    {
        Return this.IndexOf(item, fromIndex) != null()
    }

    ; Returns a new array that only contains the filtered items
    Filter(callback)
    {
        ; Check for correct callback ("Func" or "BoundFunc")
        If (!TypeOf(callback, "Func"))
        {
            throw Exception("Callback is not of type Func or BoundFunc")
        }

        result := []
        ; As some items will be removed, start with a capacity of half the original size
        result.SetCapacity(this.Size() / 2)
        For each, item in this
        {
            If (%callback%(item))
            {
                result.Push(item)
            }
        }

        Return result
    }

    ; Calls the callback for every item in the list
    Foreach(callback)
    {
        ; Check for correct callback ("Func" or "BoundFunc")
        If (!TypeOf(callback, "Func"))
        {
            throw Exception("Callback is not of type Func or BoundFunc")
        }

        For each, item in this
        {
            %callback%(item)
        }
        Return this
    }

    ; Returns the first index at which a given item can be found in the (linear) array, or null() if it is not present.
    ; Specify a negative number to start from the back (eg. len: 10, from: -1 -> start from 9 -> only index 9 and 10 get checked)
    ; If fromIndex > length, null gets returned
    IndexOf(item, fromIndex := 0)
    {
        len := this.Length()

        If (fromIndex > 0)
        {
            ; Include starting index going forward
            start := fromIndex - 1
        }
        Else If (fromIndex < 0)
        {
            ; Count backwards from end
            start := len + fromIndex
        }
        Else
        {
            start := fromIndex
        }

        Loop, % len - start
        {
            If (this[start + A_Index] == item)
            {
                Return start + A_Index
            }
        }

        Return null()
    }

    ; Returns a new array that contains all values modified by the callback func
    Map(callback)
    {
        ; Check for correct callback ("Func" or "BoundFunc")
        If (!TypeOf(callback, "Func"))
        {
            throw Exception("Callback is not of type Func or BoundFunc")
        }

        result := []
        result.SetCapacity(this.Size())
        For each, item in this
        {
            result.Push(%callback%(item))
        }

        Return result
    }
}
; The base class that all other classes inherit
class _Object
{
    ; Determines if two objects are equal
    ; obj: The object to check
    ; Returns true if they are equal, false otherwise
    Equals(obj)
    {
        Return this == obj
    }

    ; Creates a string representation of the object
    ; Returns a string that displays the object
    ToString()
    {
        Return this.__Class "@" &this
    }
}
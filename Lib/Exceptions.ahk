; Gets thrown when the called method is not yet implemented
class NotImplementedException extends Exception
{
}

; As AutoHotkey does not natively support Interfaces, they are implemented
; as normal classes and methods that throw this exception when called
class IsInterfaceException extends Exception
{
}

; Gets thrown when the passed parameter is of a type that the method does not support
class UnsupportedTypeException extends Exception
{
    __New(ByRef message, expectedType)
    {
        this._depth := 1
        this._expectedType := IsObject(expectedType) ? ClassName(expectedType) : expectedType
        base.__New(message)
    }

    ; The name of the expected type as string
    ExpectedType[]
    {
        Get
        {
            Return this._expectedType
        }
    }
}

; Gets thrown when the passed callback is not of type "Func" or "BoundFunc"
class InvalidCallbackException extends Exception
{
}

; Gets thrown when the passed parameter is too big or too low
class OutOfBoundsException extends Exception
{
    __New(ByRef message, index)
    {
        this._depth := 1
        this._index := index
        base.__New(message)
    }

    ; The invalid index
    Index[]
    {
        Get
        {
            Return this._index
        }
    }
}

; Gets thrown when a parameter contains invalid data
class IllegalArgumentException extends Exception
{
}

; Gets thrown when the language identifer or language string does not exist
class InvalidLanguageCodeException extends Exception
{
    __New(ByRef message, invalidLcid)
    {
        this._depth := 1
        this._invalidLcid := invalidLcid
        base.__New(message)
    }

    InvalidLcid[]
    {
        Get
        {
            Return this._invalidLcid
        }
    }
}

; Gets thrown when some problems with a Hotkey occured
class HotkeyException extends Exception
{
    __New(ByRef message, errorCode)
    {
        this._depth := 1
        this._errorCode := errorCode
        base.__New(message)
    }

    ErrorCode[]
    {
        Get
        {
            Return this._errorCode
        }
    }
}
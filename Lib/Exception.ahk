; The base Exception class. If a deriving exception class implements a custom constructor, it has to set a property
; called "_depth" to the inheritance depth (MyEx extends Exception -> set depth to 1, MyEx2 extends MyEx -> set depth to 2)
; A deriving class has to implement a constructor and immediately call the base class constructor
; Can directly be used instead of the AutoHotkey Exception() function
class Exception
{
    __New(ByRef message := "")
    {
        this._stack := this._genCallStack(this._depth ? this._depth + 1 : 1)
        top := this._stack[1]

        this.Message := message
        , this.Line := top.Line
        , this.File := top.File
        , this.Func := this.What := top.Func
        , this.Extra := ClassName(this)
        , this.NextFunc := top.NextFunc
    }

    ; Public properties

    ; The error message as string
    ; - Message

    ; The line number where the exception was thrown
    ; - Line

    ; The fullpath of the file where the exception was thrown
    ; - File

    ; The function/method that was currenty being executed. Empty if in auto execute section or if a hotkey thread is executed
    ; - Func

    ; Returns the call stack at the point of creation of the exception
    ; - CallStack

    ; Returns the call stack at the point of creation of the exception (objects of type Exception.StackItem)
    CallStack[]
    {
        Get
        {
            Return this._stack.Copy()
        }
    }

    ToString()
    {
        Return ClassName(this) ": " this.Message "`n" this._stackToStr()
    }

    _stackToStr()
    {
        result := ""
        For each, item in this._stack
        {
            result .= (A_Index == 1 ? "" : "`n") "  " item.ToString()
        }
        Return result
    }

    ; Private helper

    ; Generate the callstack
    ; offset: The offset of the stack, e.g. 1 -> skip the latest func call
    ; Returns an array of all func calls
    _genCallStack(offset)
    {
        s := []
        While (!((ex := Exception("", -(A_Index + offset))).What < 0))
        {
            s.Push({"Func": ex.What, "File": ex.File, "Line": ex.Line, "base": Exception.StackItem})
        }

        lastFunc := ""
        size := s.Length()
        ; As the Exception function does not return correct function names, this fixes it
        ; It returns the function that is about to be called, rather than the one that is currently called
        Loop % size
        {
            item := s[size - A_Index + 1]
            , item.NextFunc := item.Func
            , item.Func := lastFunc
            , lastFunc := item.NextFunc
        }

        ; The bottom of the callstack is now the item with the highest index
        ; It is possible that this item has no function name as it can get raised in the AutoExecuteSection or inside of a Hotkey
        s[size].Func := s[size].Func ? s[size].Func : (A_ThisHotkey ? A_ThisHotkey "::" : "AutoExecuteSection")

        Return s
    }

    ; For performance and simplicity this class does not get created via constructor, but via {"base": Exception.StackItem}
    class StackItem
    {
        ; Public properties

        ; Name of the function
        ; - Func

        ; The file name where the function is
        ; - File

        ; The line number of the function call
        ; - Line

        ; The name of the function that is about to be executed
        ; - NextFunc

        ToString()
        {
            Return "at " this.Func " in " this.File ":line " this.Line
        }
    }
}
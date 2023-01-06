; A wrapper class for SetTimer
class RecurrenceTimer extends _Object
{
    __New(callback, time := "On", once := false, priority := "")
    {
        If (!TypeOf(callback, "Func"))
        {
            throw new InvalidCallbackException("Invalid callback given")
        }
        this._callback := callback
        this._time := Abs(time)
        this._once := once
        this._prio := priority
    }

    __Delete()
    {
        SetTimer(this._callback, "Delete")
    }

    ; Start the timer
    Start()
    {
        ; Don't make _once an integer value with 1, or -1 and multiply it with _time in case _time is 0 and _once is true
        SetTimer(this._callback, (this._once ? "-" : "") this._time, this._prio)
    }

    ; Stop the timer
    Stop()
    {
        SetTimer(this._callback, "Off")
    }

    ; Creates a new timer and directly starts it
    StartNew(callback, time := "On", once := false, priority := "")
    {
        result := new RecurrenceTimer(callback, time, once, priority)
        result.Start()
        Return result
    }
}
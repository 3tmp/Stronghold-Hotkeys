; A class that wraps the OnExit() function. As soon as the object gets destroyed, it stops listening
class OnExitListener
{
    __New(callback)
    {
        If (!TypeOf(callback, "Func"))
        {
            throw Exception("Callback is not of type Func or BoundFunc")
        }
        this._callback := callback
        OnExit(this._callback, 1)
    }

    __Delete()
    {
        OnExit(this._callback, 0)
        this._callback := ""
    }
}
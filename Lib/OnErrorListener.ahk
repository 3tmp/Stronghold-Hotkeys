; A class that wraps the OnError() function. As soon as the object gets destroyed, it stops listening
class OnErrorListener extends _Object
{
    __New(callback)
    {
        If (!TypeOf(callback, "Func"))
        {
            throw new InvalidCallbackException("Callback is not of type Func or BoundFunc")
        }
        this._callback := callback
        OnError(this._callback, 1)
    }

    __Delete()
    {
        OnError(this._callback, 0)
        this._callback := ""
    }
}
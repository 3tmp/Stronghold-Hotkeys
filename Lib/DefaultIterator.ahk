; Can be used as a custom iterator that loops through a linear array
class DefaultIterator
{
    __New(list)
    {
        this._list := list
        this._i := 1
        this._len := list.Length()
    }

    Next(ByRef k, ByRef v)
    {
        k := this._i++
        v := this._list[k]
        Return k <= this._len
    }

    _NewEnum()
    {
        Return this
    }
}
; All classes that implement this interface are immutable
class ISettingsModel extends _Object
{
    Default()
    {
        throw Exception("Cannot call a method on an Interface")
    }

    FromIniString(str)
    {
        throw Exception("Cannot call a method on an Interface")
    }

    ToIniString()
    {
        throw Exception("Cannot call a method on an Interface")
    }
}
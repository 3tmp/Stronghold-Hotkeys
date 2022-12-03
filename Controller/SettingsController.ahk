class SettingsController
{
    __New(model)
    {
        If (!InstanceOf(model, SettingsModel))
        {
            throw Exception("Model has a wrong type")
        }
    }
}
; Determines the name of the class
; cls: The object to get the class name for
; Returns The name of the given class
ClassName(cls)
{
    Return cls.__Class
}

; Determines the type of the given variable
; var: The variable to check
; assert: Optional. A string for comparing the result to (cases sensitive)
; Returns The data type of the given variable if assert is left empty
;         true or false if assert is present
;         Returns values: "Object", "Func", "ComObject", "BoundFunc", "RegExMatchObject"
;                         "FileObject", "EnumeratorObject", "Property", "String", "Float", "Integer"
TypeOf(var, assert := "")
{
    static matchObj  := NumGet(&(m, RegExMatch("", "O)", m)))
         , boundFunc := NumGet(&(f := Func("Func").Bind()))
         , fileObj   := NumGet(&(f := FileOpen("*", "w")))
         , enumObj   := NumGet(&(e := ObjNewEnum({})))

    If (IsObject(var))
    {
        result := ObjGetCapacity(var) != "" ? "Object"
               :  IsFunc(var)               ? "Func"
               :  ComObjType(var) != ""     ? "ComObject"
               :  NumGet(&var) == boundFunc ? "BoundFunc"
               :  NumGet(&var) == matchObj  ? "RegExMatchObject"
               :  NumGet(&var) == fileObj   ? "FileObject"
               :  NumGet(&var) == enumObj   ? "EnumeratorObject"
               :                              "Property"
    }
    Else
    {
        result := ObjGetCapacity({1: var}, 1) != "" ? "String" : (InStr(var, ".", 1) ? "Float" : "Integer")
    }

    Return assert ? InStr(result, assert, 1) : result
}

; Determines if the object is an instance of the class
; obj: The object to check
; cls: The class to check against
; Returns true if the object is an instance of the given class
InstanceOf(obj, cls)
{
    base := obj
    Loop
    {
        If (base.__Class == cls.__Class)
        {
            Return true
        }
        base := base.base
    } Until !base
    Return false
}
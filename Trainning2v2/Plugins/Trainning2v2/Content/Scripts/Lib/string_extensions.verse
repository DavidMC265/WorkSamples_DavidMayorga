<# EXTENSIONS
    Truncates a float depending on their selected decimals

#Special characters that works on strings: •‣★◀▶▼▲△▷▽◁†‗‗⁙⁘⁂⁜✴ #>

<# ToString (Number:float, Decimals:int):
    Extensión que convierte un número flotante en una cadena de texto con un número específico de decimales. #>

ToString<public>(Number:float, Decimals:int)<transacts>:string=
    var Str:string = ToString(Number)
    if:
        DotIndex := Str.Find['.']
        StopIndex := if (Decimals > 0) then Min(DotIndex+Decimals+1,Str.Length) else DotIndex
        newArray :string = Str.Slice[0, StopIndex]
    then:
        return newArray
    return Str 

<#IntOptionalToString (MaybeNumber:?int):
    Extensión que convierte un número entero opcional en una cadena de texto, o en "false" si el número es nulo.#>

IntOptionalToString<public>(MaybeNumber:?int)<transacts>:string=
    if(Number:=MaybeNumber?):
        return "{Number}"
    else:
        return "false"

<# LogicToString (Logic:?int):
    Extensión que convierte un número logico en una cadena de texto "true" o en "false". #>
LogicToString<public>(Logic:logic)<transacts>:string=
    if(Logic?):
        return "true"
    else:
        return "false"


StringToMessage<public><localizes>(String : string) : message = "{String}"



AbbreviateNumber<public>(value:float) : string = {
    if (value >= 1000000000.0) {
        return ToTruncatedString(value / 1000000000.0, 2) + "B"
    } else if (value >= 1000000.0) {
        return ToTruncatedString(value / 1000000.0, 2) + "M"
    } else if (value >= 1000.0) {
        return ToTruncatedString(value / 1000.0, 2) + "K"
    } else {
        return ToTruncatedString(value, 0)
    }
}

ToTruncatedString(Number:float, Decimals:int):[]char=
    var Str:[]char = ToString(Number)
    if:
        DotIndex := Str.Find['.']
        StopIndex := if (Decimals > 0) then Min(DotIndex+Decimals+1,Str.Length) else DotIndex
        if (StrT := Str.Slice[0, StopIndex]) {
            set Str = StrT
        }
    return Str


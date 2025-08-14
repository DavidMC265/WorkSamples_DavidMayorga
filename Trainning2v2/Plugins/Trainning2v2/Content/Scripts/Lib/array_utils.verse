<# SlicePlayTimeRewards:
    Esta función toma un arreglo de un tipo genérico (puede ser cualquiera), un índice inicial (Start) y un índice final (End),
    y devuelve un nuevo arreglo que contiene únicamente los elementos desde Start (incluido) hasta End (excluido).#>
        
SliceArray(Array: []t, Start: int, End: int where t:type) : []t =
    if: # Validate indices to prevent errors
        Start < 0 or
        End > Array.Length or
        Start >= End
    then:
        return array{} # Return an empty array if indices are invalid

    var Result : []t = array{} # Initialize the result array
    for (Index := Start..End-1):
        if (Value := Array[Index]):
            set Result += array{Value}
    return Result # Return the sliced array
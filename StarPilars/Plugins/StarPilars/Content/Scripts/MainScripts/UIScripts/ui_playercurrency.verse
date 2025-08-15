using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { Lib }


ui_playercurrency<public> := class(base_ui):

    BackgroundImg : texture_block = texture_block{ DefaultImage := UI_Bounty.Boton_dorado }
    CurrencyIconImg : texture_block = texture_block{ DefaultImage := UI_Bounty.STWMONEDA }
    CurrencyAmountText : text_block = text_block{ DefaultTextColor := NamedColors.Yellow }

    CurrencyAmountMessage<private><localizes>(Value : float): message = "{Value}"

    CreateCanvas<override>():void=
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{ Minimum := vector2{ X:= 0.0, Y:= 0.5}, Maximum := vector2{X:= 0.0, Y:= 0.5} }
                    Offsets := margin{ Left := 200.676117, Top := 215.332489, Right := 361.352234, Bottom := 271.746033 }
                    Alignment := vector2{ X:= 0.5, Y:= 0.5 }
                    ZOrder := 0
                    SizeToContent := false
                    Widget := BackgroundImg
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.0, Y:= 0.5}, Maximum := vector2{X:= 0.0, Y:= 0.5} }
                    Offsets := margin{ Left := 102.282280, Top := 216.258270, Right := 164.564560, Bottom := 137.597595 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := false
                    Widget := CurrencyIconImg
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.0, Y:= 0.5}, Maximum := vector2{X:= 0.0, Y:= 0.5} }
                    Offsets := margin{ Left := 236.778275, Top := 215.622498, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{ X:= 0.5, Y:= 0.5 }
                    ZOrder := 2
                    SizeToContent := true
                    Widget := CurrencyAmountText


    SetValues<public>(BackgroundColor : color): void =
        if(PlayerData := MaybePlayerData?):
            BackgroundImg.SetTint(BackgroundColor)
            PlayerData.LoadSaveDataForPlayer()
            PlayerCurrency := PlayerData.GetCurrency()
            #Print("Player Currency is {PlayerCurrency}")
            CurrencyAmountText.SetText(StringToMessage( AbbreviateNumber( (PlayerCurrency) * 1.0) ))


    UpdateCurrency<public>(Value : float): void =
        CurrencyAmountText.SetText(StringToMessage( AbbreviateNumber( (Value) * 1.0) ) )



using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }



ui_weaponselectiontimer<public> := class(base_ui):

    TextForUIInfo<localizes>(Text : string) : message = "{Text}"

    WeaponSelectionText : text_block = text_block{DefaultTextColor := NamedColors.Yellow}
    WeaponSelectionTimerText : text_block = text_block{DefaultTextColor := NamedColors.Yellow}
    WeaponSelectionTextBackground : texture_block = texture_block{ DefaultImage := CustomProps.UI_Background }


    var WeaponSelectionTimerSeconds : int = 30
    WeaponSelectionStringText : string = "Choose your Weapons:"
    

    CreateCanvas<override>():void=
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.0}, Maximum := vector2{X:= 0.5, Y:= 0.0} }
                    Offsets := margin{Left := -40.960938, Top := 148.000000, Right := 165.000000, Bottom := 41.000000}
                    Alignment := vector2{ X:= 0.5, Y:= 0.0 }
                    ZOrder := 1
                    SizeToContent := true
                    Widget := WeaponSelectionText

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.0}, Maximum := vector2{X:= 0.5, Y:= 0.0} }
                    Offsets := margin{Left := 167.058578, Top := 148.000000, Right := 165.000000, Bottom := 41.000000}
                    Alignment := vector2{X:= 0.5, Y:= 0.0}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := WeaponSelectionTimerText
                
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.0}, Maximum := vector2{X:= 0.5, Y:= 0.0} }
                    Offsets := margin{Left := -12.482452, Top := 178.970963, Right := 616.916931, Bottom := 183.943954}
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 0
                    SizeToContent := false
                    Widget := WeaponSelectionTextBackground



    ShowWeaponSelectionCountdownUI<public>(): void =
        WeaponSelectionText.SetText(TextForUIInfo("{WeaponSelectionStringText}"))
        WeaponSelectionTimerText.SetText(TextForUIInfo("{WeaponSelectionTimerSeconds}"))

        spawn{ StartWeaponSelectionCountdown() }
                
                
    StartWeaponSelectionCountdown()<suspends>: void =
        if(PlayerData := MaybePlayerData?, EventMediator := PlayerData.EventMediator):
            loop:
                Sleep(1.0)
                if(EventMediator.WeaponSelectionTerminateCountdown = true):
                    PlayerData.HideWeaponSelectionTimerUI()
                    break

                set WeaponSelectionTimerSeconds -= 1
                WeaponSelectionTimerText.SetText(TextForUIInfo("{WeaponSelectionTimerSeconds}"))

                if(WeaponSelectionTimerSeconds <= 0):
                    WeaponSelectionTimerText.SetText(TextForUIInfo("{WeaponSelectionTimerSeconds}"))
                    EventMediator.EmitOnWeaponSelectionTimerCompleted()

                    PlayerData.HideWeaponSelectionTimerUI()
                    break

        else:
            Print(
                "Player Data not retrieved correctly from UI_GameStartClock StartCountdown function!", 
                ?Duration := 1.0, 
                ?Color := NamedColors.Red
            )
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }


ui_roundstartcountdown<public> := class(base_ui):

    TextForUIInfo<localizes>(Text : string) : message = "{Text}"

    RoundStartsInText : text_block = text_block{DefaultTextColor := NamedColors.Yellow}
    TimeBeforeRoundStartText : text_block = text_block{DefaultTextColor := NamedColors.Yellow}
    RoundStarsInTextBackground : texture_block = texture_block{ DefaultImage := CustomProps.UI_Background }


    var TimeBeforeRoundStart : int = 3
    TimeBeforeRoundStartString : string = "Round Starts in:"    

    CreateCanvas<override>():void=
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.0}, Maximum := vector2{X:= 0.5, Y:= 0.0} }
                    Offsets := margin{Left := -40.674477, Top := 172.353683, Right := 100.000000, Bottom := 30.000000}
                    Alignment := vector2{ X:= 0.5, Y:= 0.5 }
                    ZOrder := 1
                    SizeToContent := true
                    Widget := RoundStartsInText

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.0}, Maximum := vector2{X:= 0.5, Y:= 0.0} }
                    Offsets := margin{Left := 111.809334, Top := 172.645645, Right := 165.000000, Bottom := 41.000000}
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := TimeBeforeRoundStartText

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.0}, Maximum := vector2{X:= 0.5, Y:= 0.0} }
                    Offsets := margin{Left := -12.482452, Top := 178.970963, Right := 616.916931, Bottom := 183.943954}
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 0
                    SizeToContent := false
                    Widget := RoundStarsInTextBackground


    ShowRoundStartCountdown<public>(): void =
        RoundStartsInText.SetText(TextForUIInfo("{TimeBeforeRoundStartString}"))
        TimeBeforeRoundStartText.SetText(TextForUIInfo("{TimeBeforeRoundStart}"))

        set TimeBeforeRoundStart = 3

        spawn{ StartWeaponSelectionCountdown() }


    StartWeaponSelectionCountdown()<suspends>: void =
        if(PlayerData := MaybePlayerData?, EventMediator := PlayerData.EventMediator):
            loop:
                Sleep(1.0)

                set TimeBeforeRoundStart -= 1
                TimeBeforeRoundStartText.SetText(TextForUIInfo("{TimeBeforeRoundStart}"))

                if(TimeBeforeRoundStart <= 0):
                    TimeBeforeRoundStartText.SetText(TextForUIInfo("{TimeBeforeRoundStart}"))
                    EventMediator.EmitOnRoundStartTimerCountdownCompleted()
                    set TimeBeforeRoundStart = 3

                    PlayerData.HideRoundStartCountdoownUI()
                    break

        else:
            Print(
                "Player Data not retrieved correctly from UI_GameStartClock StartCountdown function!", 
                ?Duration := 1.0, 
                ?Color := NamedColors.Red
            )
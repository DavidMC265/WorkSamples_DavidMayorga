using { /Verse.org/Colors }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Simulation }
using { /Fortnite.com/UI }



ui_gamestartclock<public> := class(base_ui):

    TextForUIInfo<localizes>(Text : string) : message = "{Text}"

    GameStartsInText : text_block = text_block{DefaultTextColor := NamedColors.Yellow}
    TimeBeforeGameStartText : text_block = text_block{DefaultTextColor := NamedColors.Yellow}
    GameStarsInTextBackground : texture_block = texture_block{ DefaultImage := CustomProps.UI_Background }

    TopBoxLine : color_block = color_block{ DefaultColor := NamedColors.Yellow }
    BottomBoxLine : color_block = color_block{ DefaultColor := NamedColors.Yellow }
    LeftBoxLine : color_block = color_block{ DefaultColor := NamedColors.Yellow }
    RightBoxLine : color_block = color_block{ DefaultColor := NamedColors.Yellow }


    var TimeCurrentSeconds : int = 0
    

    CreateCanvas<override>():void=
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.0}, Maximum := vector2{X:= 0.5, Y:= 0.0} }
                    Offsets := margin{Left := -40.674477, Top := 172.353683, Right := 100.000000, Bottom := 30.000000}
                    Alignment := vector2{ X:= 0.5, Y:= 0.5 }
                    ZOrder := 1
                    SizeToContent := true
                    Widget := GameStartsInText

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.0}, Maximum := vector2{X:= 0.5, Y:= 0.0} }
                    Offsets := margin{Left := 111.809334, Top := 172.645645, Right := 165.000000, Bottom := 41.000000}
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := TimeBeforeGameStartText

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.0}, Maximum := vector2{X:= 0.5, Y:= 0.0} }
                    Offsets := margin{Left := -12.482452, Top := 178.970963, Right := 616.916931, Bottom := 183.943954}
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 0
                    SizeToContent := false
                    Widget := GameStarsInTextBackground


    ShowCountdownUI<public>(Seconds : int, GameStartsString : string): void =
        GameStartsInText.SetText(TextForUIInfo("{GameStartsString}"))
        TimeBeforeGameStartText.SetText(TextForUIInfo("{Seconds}"))

        spawn{ StartCountdown(Seconds) }


    StartCountdown(Seconds : int)<suspends>: void =
        if(PlayerData := MaybePlayerData?):
            set TimeCurrentSeconds = Seconds
            loop:
                Sleep(1.0)
                set TimeCurrentSeconds -= 1
                TimeBeforeGameStartText.SetText(TextForUIInfo("{TimeCurrentSeconds}"))

                if(TimeCurrentSeconds <= 0):
                    TimeBeforeGameStartText.SetText(TextForUIInfo("{TimeCurrentSeconds}"))
                    EventMediator := PlayerData.EventMediator
                    EventMediator.EmitOnGameStartClockFinished()

                    PlayerData.HideGameStartClockUI()
                    break

        else:
            Print(
                "Player Data not retrieved correctly from UI_GameStartClock StartCountdown function!", 
                ?Duration := 1.0, 
                ?Color := NamedColors.Red
            )

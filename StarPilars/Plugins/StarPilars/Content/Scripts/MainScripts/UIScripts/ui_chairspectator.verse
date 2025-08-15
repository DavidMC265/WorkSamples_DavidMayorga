using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { Lib }


ui_chairspectator<public> := class(base_ui):

    BackgroundImg : texture_block = texture_block{ DefaultImage := UI_Pillars.RestZoneBg }

    TitleText : text_block = text_block { DefaultTextColor := NamedColors.White }
    TimerMinutes_Text : text_block = text_block { DefaultTextColor := NamedColors.Yellow }
    Division_Text : text_block = text_block { DefaultTextColor := NamedColors.Yellow }
    TimerSeconds_Text : text_block = text_block { DefaultTextColor := NamedColors.Yellow }

    var IsPlayerSeated : logic = false


    CreateCanvas<override>():void=
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{ Minimum := vector2{ X:= 0.5, Y:= 1.0 }, Maximum := vector2{ X:= 0.5, Y:= 1.0 } }
                    Offsets := margin{ Left := -4.000000, Top := -192.000000, Right := 450.000000, Bottom := 250.000000 }
                    Alignment := vector2{ X:= 0.5, Y:= 0.5 }
                    ZOrder := 0
                    SizeToContent := false
                    Widget := MainOverlay()


    MainOverlay(): overlay =
        MyOverlay : overlay = overlay:
            Slots := array:
                overlay_slot:
                    Widget := BackgroundImg
                    HorizontalAlignment := horizontal_alignment.Fill
                    VerticalAlignment := vertical_alignment.Fill
                    Padding := margin{ Left := 0.0, Top := 0.0, Right := 0.0, Bottom := 0.0 }
                overlay_slot:
                    Widget := TextsStackBox()
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin{ Left := 0.0, Top := 50.0, Right := 0.0, Bottom := 0.0 }

        return MyOverlay


    TextsStackBox(): stack_box =
        TitleText.SetText( StringToMessage ("Earn XP for every 15\nseconds you spectate") )

        StackBox : stack_box = stack_box:
            Orientation := orientation.Vertical

            Slots := array:
                stack_box_slot:
                    Widget := TitleText
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Fill
                    Padding := margin { Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                stack_box_slot:
                    Widget := TimerTextsStackBox()
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding := margin { Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
        
        return StackBox


    TimerTextsStackBox(): stack_box =
        TimerMinutes_Text.SetText( StringToMessage ("00") )
        Division_Text.SetText( StringToMessage(":") )
        TimerSeconds_Text.SetText( StringToMessage ("00") )

        StackBox : stack_box = stack_box:
            Orientation := orientation.Horizontal

            Slots := array:
                stack_box_slot:
                    Widget := TimerMinutes_Text
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding := margin { Top := 15.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                stack_box_slot:
                    Widget := Division_Text
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding := margin { Top := 15.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                stack_box_slot:
                    Widget := TimerSeconds_Text
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding := margin { Top := 15.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }


    StartTimerIncrease<public>()<suspends>: void =
        TimerMinutes_Text.SetText( StringToMessage ("00") )
        Division_Text.SetText( StringToMessage(":") )
        TimerSeconds_Text.SetText( StringToMessage ("00") )
        
        set IsPlayerSeated = true

        var SecondsCounter : int = 0
        var MinutesCounter : int = 0

        loop:
            Sleep(1.0)
            if(IsPlayerSeated = false):
                break

            if(SecondsCounter = 15 or SecondsCounter = 30 or SecondsCounter = 45 or SecondsCounter = 60):
                if:
                    GameManager := MaybeGameManager?, 
                    AccoladeManager := GameManager.MaybeAccoladeManager?
                    Agent := MaybeAgent?
                then:
                    AccoladeManager.GrantChairSpectatorAccolade(Agent)

                    
            if(SecondsCounter = 60):
                set SecondsCounter = 0
                set MinutesCounter += 1
                
                if(SecondsCounter < 10):
                    TimerMinutes_Text.SetText( StringToMessage ("0{MinutesCounter}") )
                else:
                    TimerMinutes_Text.SetText( StringToMessage ("{MinutesCounter}") )


            set SecondsCounter += 1

            if(SecondsCounter < 10):
                TimerSeconds_Text.SetText( StringToMessage ("0{SecondsCounter}") )
            else:
                TimerSeconds_Text.SetText( StringToMessage ("{SecondsCounter}") )


    StopTimerIncrease<public>(): void=
        set IsPlayerSeated = false

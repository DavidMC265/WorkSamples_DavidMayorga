using { /Verse.org/Colors }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Simulation }
using { /Fortnite.com/UI }


ui_teamselection<public> := class(base_ui):

    TextForUIInfo<localizes>(Text : string) : message = "{Text}"

    ChooseATeamText : text_block = text_block{DefaultTextColor := NamedColors.White}
    ChooseATeamBackground : texture_block = texture_block{ DefaultImage := CustomProps.PaintStainImg }

    ChooseATeamString : string = "Choose a Team"
    ChoosenTeam1Text : string = "Team Choosen: 1"
    ChoosenTeam2Text : string = "Team Choosen: 2"

    CurrentTeam1Text : string = "Current Team: 1"
    CurrentTeam2Text : string = "Current Team: 2"


    CreateCanvas<override>():void=
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.0}, Maximum := vector2{X:= 0.5, Y:= 0.0} }
                    Offsets := margin{Left := 17.658234, Top := 47.585037, Right := 429.238342, Bottom := 119.170074}
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 0
                    SizeToContent := false
                    Widget := ChooseATeamBackground

                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.0}, Maximum := vector2{X:= 0.5, Y:= 0.0} }
                    Offsets := margin{Left := -115.000000, Top := 44.270271, Right := 165.000000, Bottom := 41.000000}
                    Alignment := vector2{X:= 0.0, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := ChooseATeamText

        ChooseATeamText.SetText(TextForUIInfo("{ChooseATeamString}"))


    OnTeam1Choosen<public>(): void =
        Canvas.RemoveWidget(ChooseATeamText)

        ChooseATeamText.SetTextColor(NamedColors.Blue)
        ChooseATeamText.SetText(TextForUIInfo("{ChoosenTeam1Text}"))

        Canvas.AddWidget(canvas_slot:
            Anchors := anchors { Minimum := vector2{ X := 0.5, Y := 0.0 }, Maximum := vector2{ X := 0.5, Y := 0.0 } }
            Offsets := margin{Left :=  -128.960938, Top := 44.270271, Right:= 165.000000, Bottom:= 41.000000}
            Alignment := vector2{X := 0.0, Y := 0.5}
            SizeToContent := true
            ZOrder := 2
            Widget := ChooseATeamText
        )

    OnTeam2Choosen<public>(): void =
        Canvas.RemoveWidget(ChooseATeamText)

        ChooseATeamText.SetTextColor(NamedColors.Red)
        ChooseATeamText.SetText(TextForUIInfo("{ChoosenTeam2Text}"))

        Canvas.AddWidget(canvas_slot:
            Anchors := anchors { Minimum := vector2{ X := 0.5, Y := 0.0 }, Maximum := vector2{ X := 0.5, Y := 0.0 } }
            Offsets := margin{Left :=  -128.960938, Top := 44.270271, Right:= 165.000000, Bottom:= 41.000000}
            Alignment := vector2{X := 0.0, Y := 0.5}
            SizeToContent := true
            ZOrder := 2
            Widget := ChooseATeamText
        )

    # RePositionTeamChoosenUI<public>(TeamNumber : int): void =
    #     Canvas.RemoveWidget(ChooseATeamImage)
    #     Canvas.RemoveWidget(ChooseATeamText)

    #     case(TeamNumber):
    #         0 =>
    #             ChooseATeamText.SetTextColor(NamedColors.Blue)
    #             ChooseATeamText.SetText(TextForUIInfo("{CurrentTeam1Text}"))

    #             ChooseATeamImage.SetImage(AssetsImgs.RestZoneBg)

    #         1 =>
    #             ChooseATeamText.SetTextColor(NamedColors.Red)
    #             ChooseATeamText.SetText(TextForUIInfo("{CurrentTeam2Text}"))

    #             ChooseATeamImage.SetImage(AssetsImgs.RestZoneBg)

    #         _=>
    #             Print(
    #                 "No valid team number was passed from the player data to be shown in the ream selection UI", 
    #                 ?Duration := 5.0, 
    #                 ?Color := NamedColors.Red
    #             )
    #             return

    #     Canvas.AddWidget(
    #         canvas_slot:
    #             Anchors := anchors { Minimum := vector2{ X := 1.0, Y := 0.0 }, Maximum := vector2{ X := 1.0, Y := 0.0 } }
    #             Offsets := margin{Left :=  -188.872772, Top := 148.163025, Right:= 165.000000, Bottom:= 41.000000}
    #             Alignment := vector2{X := 0.5, Y := 0.5}
    #             SizeToContent := true
    #             ZOrder := 2
    #             Widget := ChooseATeamText
    #     )

        # Canvas.AddWidget(
        #     canvas_slot:
        #         Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
        #         Offsets := margin{Left := 607.039062, Top := -387.495483, Right := 335.735687, Bottom := 130.090088}
        #         Alignment := vector2{X:= 0.0, Y:= 0.5}
        #         ZOrder := 1
        #         SizeToContent := false
        #         Widget := ChooseATeamImage
        # )









            
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }

ui_scoreboard<public> := class(base_ui):

    TextForUIInfo<localizes>(Text : string) : message = "{Text}"

    Team1ScoreText : text_block = text_block{}
    Team2ScoreText : text_block = text_block{}


    CreateCanvas<override>():void=
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.0}, Maximum := vector2{X:= 0.5, Y:= 0.0} }
                    Offsets := margin{Left := 6.948975, Top := 123.387421, Right := 559.819824, Bottom := 574.774841}
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 0
                    SizeToContent := false
                    Widget := texture_block{ DefaultImage := CustomProps.UI_ScoreBackground }
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.0}, Maximum := vector2{X:= 0.5, Y:= 0.0} }
                    Offsets := margin{Left := 4.145668, Top := 92.570572, Right := 165.000000, Bottom := 41.000000}
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := text_block{ DefaultText := TextForUIInfo("Rounds"), DefaultTextColor := NamedColors.Yellow }
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.0}, Maximum := vector2{X:= 0.5, Y:= 0.0} }
                    Offsets := margin{Left := -169.950424, Top := 92.120117, Right := 165.000000, Bottom := 41.000000}
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 2
                    SizeToContent := true
                    Widget := Team1ScoreText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.0}, Maximum := vector2{X:= 0.5, Y:= 0.0} }
                    Offsets := margin{Left := 178.049576, Top := 92.120117, Right := 165.000000, Bottom := 41.000000}
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 2
                    SizeToContent := true
                    Widget := Team2ScoreText

    SetScores<public>(Team1Score : int, Team2Score : int): void =
        Team2ScoreText.SetText(TextForUIInfo("{Team1Score}"))
        Team1ScoreText.SetText(TextForUIInfo("{Team2Score}"))

    UpdateTeam1Score<public>(CurrentScore : int): void =
        Team1ScoreText.SetText(TextForUIInfo("{CurrentScore}"))

    UpdateTeam2Score<public>(CurrentScore : int): void =
        Team2ScoreText.SetText(TextForUIInfo("{CurrentScore}"))


        



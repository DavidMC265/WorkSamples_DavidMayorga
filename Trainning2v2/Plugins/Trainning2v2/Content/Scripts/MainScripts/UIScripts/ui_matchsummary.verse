using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { RoundSystem }


ui_matchsummary<public> := class(base_ui):

    TextForUIInfo<localizes>(Text : string) : message = "{Text}"
    PlayerNameToMessage<localizes>(Player : player): message = "{Player}"

    SummaryBackgroundImg : texture_block = texture_block{ DefaultImage := CustomProps.UI_Background }
    MatchSummaryTitleText: text_block = text_block{ DefaultTextColor := NamedColors.Yellow }
    EliminationsTitle : text_block = text_block{ DefaultTextColor := NamedColors.White }
    EliminationsIconImg : texture_block = texture_block {DefaultImage := CustomProps.SkullEmojiWhiteImg }
    HighestKillstreakTitle : text_block = text_block{ DefaultTextColor := NamedColors.White }
    HighestKillstreakIconImg : texture_block = texture_block {DefaultImage := CustomProps.TargetEmojiWhiteImg }
    AssistsTitle : text_block = text_block{ DefaultTextColor := NamedColors.White }
    AssistsIconImg : texture_block = texture_block{ DefaultImage := CustomProps.AssistsIconImg }

    FirstPlaceNumberText : text_block = text_block{ DefaultTextColor := NamedColors.White }
    SecondPlaceNumberText : text_block = text_block{ DefaultTextColor := NamedColors.White }
    ThirdPlaceNumberText : text_block = text_block{ DefaultTextColor := NamedColors.White }
    FourthPlaceNumberText : text_block = text_block{ DefaultTextColor := NamedColors.White }

    FirstPlacePlayerNameText : text_block = text_block{ DefaultTextColor := NamedColors.White }
    SecondPlacePlayerNameText : text_block = text_block{ DefaultTextColor := NamedColors.White }
    ThirdPlacePlayerNameText : text_block = text_block{ DefaultTextColor := NamedColors.White }
    FourthPlacePlayerNameText : text_block = text_block{ DefaultTextColor := NamedColors.White }

    FirstPlacePlayerEliminationsText : text_block = text_block{ DefaultTextColor := NamedColors.White }
    SecondPlacePlayerEliminationsText : text_block = text_block{ DefaultTextColor := NamedColors.White }
    ThirdPlacePlayerEliminationsText : text_block = text_block{ DefaultTextColor := NamedColors.White }
    FourthPlacePlayerEliminationsText : text_block = text_block{ DefaultTextColor := NamedColors.White }

    FirstPlacePlayerKillstreakText : text_block = text_block{ DefaultTextColor := NamedColors.White }
    SecondPlacePlayerKillstreakText : text_block = text_block{ DefaultTextColor := NamedColors.White }
    ThirdPlacePlayerKillstreakText : text_block = text_block{ DefaultTextColor := NamedColors.White }
    FourthPlacePlayerKillstreakText : text_block = text_block{ DefaultTextColor := NamedColors.White }

    FirstPlacePlayerAssistsText : text_block = text_block{ DefaultTextColor := NamedColors.White }
    SecondPlacePlayerAssistsText : text_block = text_block{ DefaultTextColor := NamedColors.White }
    ThirdPlacePlayerAssistsText : text_block = text_block{ DefaultTextColor := NamedColors.White }
    FourthPlacePlayerAssistsText : text_block = text_block{ DefaultTextColor := NamedColors.White }

    FirstPlacePlayerRankImg : texture_block = texture_block{ DefaultImage := CustomProps.Unranked }
    SecondPlacePlayerRankImg : texture_block = texture_block{ DefaultImage := CustomProps.Unranked }
    ThirdPlacePlayerRankImg : texture_block = texture_block{ DefaultImage := CustomProps.Unranked }
    FourthPlacePlayerRankImg : texture_block = texture_block{ DefaultImage := CustomProps.Unranked }



    CreateCanvas<override>():void=
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{Left := 4.000000, Top := -540.000000, Right := 1920.000000, Bottom := 1080.000000}
                    Alignment := vector2{X:= 0.5, Y:= 0.0}
                    ZOrder := 0
                    SizeToContent := false
                    Widget := SummaryBackgroundImg
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{Left := 22.500000, Top := -195.500000, Right := 165.000000, Bottom := 41.000000}
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := MatchSummaryTitleText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{Left := -57.099998, Top := -119.599998, Right := 165.000000, Bottom := 41.000000}
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := EliminationsTitle
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := 62.666664, Top := -119.333336, Right := 37.333332, Bottom := 33.333332 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := EliminationsIconImg
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := 246.500000, Top := -115.666664, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := HighestKillstreakTitle
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := 410.666656, Top := -115.333336, Right := 37.333332, Bottom := 33.333332 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := HighestKillstreakIconImg
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := 532.596130, Top := -115.666664, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := AssistsTitle
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := 615.899414, Top := -118.055542, Right := 49.720718, Bottom := 44.969967 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := AssistsIconImg
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := -536.982788, Top := -59.500000, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := FirstPlaceNumberText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := -536.982788, Top := -11.500000, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := SecondPlaceNumberText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := -536.982788, Top := 44.500000, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := ThirdPlaceNumberText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := -536.982788, Top := 100.500000, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := FourthPlaceNumberText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := -377.145630, Top := -59.500000, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := FirstPlacePlayerNameText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := -377.145630, Top := -7.500000, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := SecondPlacePlayerNameText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := -377.145630, Top := 48.500000, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := ThirdPlacePlayerNameText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := -377.145630, Top := 104.500000, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := FourthPlacePlayerNameText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := -40.642853, Top := -64.000000, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := FirstPlacePlayerEliminationsText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := -40.642853, Top := -11.500000, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := SecondPlacePlayerEliminationsText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := -40.642853, Top := 44.500000, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := ThirdPlacePlayerEliminationsText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := -40.642853, Top := 96.363632, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := FourthPlacePlayerEliminationsText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := 231.357147, Top := -67.714287, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := FirstPlacePlayerKillstreakText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := 231.357147, Top := -19.555555, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := SecondPlacePlayerKillstreakText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := 231.357147, Top := 36.444443, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := ThirdPlacePlayerKillstreakText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := 231.357147, Top := 88.444443, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := FourthPlacePlayerKillstreakText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := 538.546082, Top := -67.714287, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := FirstPlacePlayerAssistsText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := 538.364075, Top := -19.555555, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := SecondPlacePlayerAssistsText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := 538.295837, Top := 36.444443, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := ThirdPlacePlayerAssistsText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := 538.238098, Top := 88.444443, Right := 165.000000, Bottom := 41.000000 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := FourthPlacePlayerAssistsText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := -202.444443, Top := -59.333336, Right := 43.111111, Bottom := 41.333332 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := false
                    Widget := FirstPlacePlayerRankImg
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := -202.444443, Top := -3.333334, Right := 43.111111, Bottom := 41.333332 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := false
                    Widget := SecondPlacePlayerRankImg
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := -202.444443, Top := 52.666664, Right := 43.111111, Bottom := 41.333332 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := false
                    Widget := ThirdPlacePlayerRankImg
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := -202.444443, Top := 108.666664, Right := 43.111111, Bottom := 41.333332 }
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := false
                    Widget := FourthPlacePlayerRankImg
    

        MatchSummaryTitleText.SetText(StringToMessage("Match Summary"))
        EliminationsTitle.SetText(StringToMessage("Eliminations"))
        AssistsTitle.SetText(StringToMessage("Assists"))
        HighestKillstreakTitle.SetText(StringToMessage("HighestKillstreak"))


    SetSummaryValues<public>(MatchSummaryInfo : match_summary_info): void =
            #Player 1
        if:
            Player1 := MatchSummaryInfo.FirstPlaceMaybePlayer?
            Player1Eliminations := MatchSummaryInfo.FirstPlacePlayerMaybeEliminations?
            Player1Killstreak := MatchSummaryInfo.FirstPlacePlayerMaybeHighestKillstreak?
            Player1Assists := MatchSummaryInfo.FirstPlacePlayerMaybeHighestAssists?
            Player1Rank := MatchSummaryInfo.FirstPlaceMaybePlayerRank?
            MaybePlayerRankIconTexture := GetPlayerRankIconTexture(Player1Rank)
            PlayerRankIconTexture := MaybePlayerRankIconTexture?
            MaybePlayer1Team := MatchSummaryInfo.MaybeFirstPlacePlayerTeam?
            MaybePlayerTeamColor := GetPlayerTeamColor(MaybePlayer1Team)
            PlayerTeamColor := MaybePlayerTeamColor?
        then:
            FirstPlaceNumberText.SetText(TextForUIInfo("{1}"))
            FirstPlacePlayerNameText.SetText(PlayerNameToMessage(Player1))
            # FirstPlacePlayerNameText.SetTextColor(PlayerTeamColor)
            FirstPlacePlayerEliminationsText.SetText(TextForUIInfo("{Player1Eliminations}"))
            FirstPlacePlayerKillstreakText.SetText(TextForUIInfo("{Player1Killstreak}"))
            FirstPlacePlayerAssistsText.SetText(TextForUIInfo("{Player1Assists}"))
            FirstPlacePlayerRankImg.SetImage(PlayerRankIconTexture)
        else:
            FirstPlacePlayerRankImg.SetVisibility(widget_visibility.Hidden)
            Print("Failed Somewhwereeee to set the third playeerrrrr", ?Duration := 7.0, ?Color := NamedColors.Red)
            
            #Player 2
        if:
            Player2 := MatchSummaryInfo.SecondPlaceMaybePlayer?
            Player2Eliminations := MatchSummaryInfo.SecondPlacePlayerMaybeEliminations?
            Player2Killstreak := MatchSummaryInfo.SecondPlacePlayerMaybeHighestKillstreak?
            Player2Assists := MatchSummaryInfo.SecondPlacePlayerMaybeHighestAssists?
            Player2Rank := MatchSummaryInfo.SecondPlaceMaybePlayerRank?
            MaybePlayerRankIconTexture := GetPlayerRankIconTexture(Player2Rank)
            PlayerRankIconTexture := MaybePlayerRankIconTexture?
            MaybePlayer2Team := MatchSummaryInfo.MaybeSecondPlacePlayerTeam?
            MaybePlayerTeamColor := GetPlayerTeamColor(MaybePlayer2Team)
            PlayerTeamColor := MaybePlayerTeamColor?
        then:
            SecondPlaceNumberText.SetText(TextForUIInfo("{2}"))
            SecondPlacePlayerNameText.SetText(PlayerNameToMessage(Player2))
            # SecondPlacePlayerNameText.SetTextColor(PlayerTeamColor)
            SecondPlacePlayerEliminationsText.SetText(TextForUIInfo("{Player2Eliminations}"))
            SecondPlacePlayerKillstreakText.SetText(TextForUIInfo("{Player2Killstreak}"))
            SecondPlacePlayerAssistsText.SetText(TextForUIInfo("{Player2Assists}"))
            SecondPlacePlayerRankImg.SetImage(PlayerRankIconTexture)
        else:
            SecondPlacePlayerRankImg.SetVisibility(widget_visibility.Hidden)
            Print("Failed Somewhwereeee to set the third playeerrrrr", ?Duration := 7.0, ?Color := NamedColors.Red)

            #Player 3
        if:
            Player3 := MatchSummaryInfo.ThirdPlaceMaybePlayer?
            Player3Eliminations := MatchSummaryInfo.ThirdPlacePlayerMaybeEliminations?
            Player3Killstreak := MatchSummaryInfo.ThirdPlacePlayerMaybeHighestKillstreak?
            Player3Assists := MatchSummaryInfo.ThirdPlacePlayerMaybeHighestAssists?
            Player3Rank := MatchSummaryInfo.ThirdPlaceMaybePlayerRank?
            MaybePlayerRankIconTexture := GetPlayerRankIconTexture(Player3Rank)
            PlayerRankIconTexture := MaybePlayerRankIconTexture?
            MaybePlayer3Team := MatchSummaryInfo.MaybeThirdPlacePlayerTeam?
            MaybePlayerTeamColor := GetPlayerTeamColor(MaybePlayer3Team)
            PlayerTeamColor := MaybePlayerTeamColor?
        then:
            ThirdPlaceNumberText.SetText(TextForUIInfo("{3}"))
            ThirdPlacePlayerNameText.SetText(PlayerNameToMessage(Player3))
            # SecondPlacePlayerNameText.SetTextColor(PlayerTeamColor)
            ThirdPlacePlayerEliminationsText.SetText(TextForUIInfo("{Player3Eliminations}"))
            ThirdPlacePlayerKillstreakText.SetText(TextForUIInfo("{Player3Killstreak}"))
            ThirdPlacePlayerAssistsText.SetText(TextForUIInfo("{Player3Assists}"))
            ThirdPlacePlayerRankImg.SetImage(PlayerRankIconTexture)
        else:
            ThirdPlacePlayerRankImg.SetVisibility(widget_visibility.Hidden)
            Print("Failed Somewhwereeee to set the third playeerrrrr", ?Duration := 7.0, ?Color := NamedColors.Red)

            #Player 4
        if:
            Player4 := MatchSummaryInfo.FourthPlaceMaybePlayer?
            Player4Eliminations := MatchSummaryInfo.FourthPlacePlayerMaybeEliminations?
            Player4Killstreak := MatchSummaryInfo.FourthPlacePlayerMaybeHighestKillstreak?
            Player4Assists := MatchSummaryInfo.FourthPlacePlayerMaybeHighestAssists?
            Player4Rank := MatchSummaryInfo.FourthPlaceMaybePlayerRank?
            MaybePlayerRankIconTexture := GetPlayerRankIconTexture(Player4Rank)
            PlayerRankIconTexture := MaybePlayerRankIconTexture?
            MaybePlayer4Team := MatchSummaryInfo.MaybeFourthPlacePlayerTeam?
            MaybePlayerTeamColor := GetPlayerTeamColor(MaybePlayer4Team)
            PlayerTeamColor := MaybePlayerTeamColor?
        then:
            FourthPlaceNumberText.SetText(TextForUIInfo("{4}"))
            FourthPlacePlayerNameText.SetText(PlayerNameToMessage(Player4))
            # SecondPlacePlayerNameText.SetTextColor(PlayerTeamColor)
            FourthPlacePlayerEliminationsText.SetText(TextForUIInfo("{Player4Eliminations}"))
            FourthPlacePlayerKillstreakText.SetText(TextForUIInfo("{Player4Killstreak}"))
            FourthPlacePlayerAssistsText.SetText(TextForUIInfo("{Player4Assists}"))
            FourthPlacePlayerRankImg.SetImage(PlayerRankIconTexture)
        else:
            FourthPlacePlayerRankImg.SetVisibility(widget_visibility.Hidden)
            Print("Failed Somewhwereeee to set the fourth playeerrrrr", ?Duration := 7.0, ?Color := NamedColors.Red)


    
    GetPlayerRankIconTexture(PlayerRank : int)<transacts>: ?texture=
        var MaybeRankTexture : ?texture = false

        case(PlayerRank):
            0 => 
                set MaybeRankTexture = option{CustomProps.Unranked}
            1 =>
                set MaybeRankTexture = option{CustomProps.Bronze_Initiate}
            2 =>
                set MaybeRankTexture = option{CustomProps.Silver_Adept}
            3 =>
                set MaybeRankTexture = option{CustomProps.Gold_Master}
            4 =>
                set MaybeRankTexture = option{CustomProps.Platinum_Elite}
            5 =>
                set MaybeRankTexture = option{CustomProps.Diamond_Legend}
            _=>
                Print(
                    "Player Rank index invalid from ui_matchsummary so Icon texture image cannot be set!!", 
                    ?Duration := 7.0, 
                    ?Color := NamedColors.Red
                )

        return MaybeRankTexture

    
    GetPlayerTeamColor(PlayerTeamNumber : int)<transacts>: ?color=
        var MaybePlayerTeamColor : ?color = false

        case(PlayerTeamNumber):
            0 =>
                set MaybePlayerTeamColor = option{ NamedColors.LightBlue }
            1 =>
                set MaybePlayerTeamColor = option{ NamedColors.Red }
            _ =>
                Print(
                    "Player team number index from Player Data is invalid from ui_matchsummary so Player Team Color cannot be set!!", 
                    ?Duration := 7.0, 
                    ?Color := NamedColors.Red
                )

        return MaybePlayerTeamColor
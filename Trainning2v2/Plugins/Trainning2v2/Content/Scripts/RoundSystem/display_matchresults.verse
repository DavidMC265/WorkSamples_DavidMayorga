using { /Fortnite.com }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { Lobby }
using { MainScripts }


match_summary_info<public> := class():
    var FirstPlaceMaybePlayer<public> : ?player = false
    var SecondPlaceMaybePlayer<public> : ?player = false
    var ThirdPlaceMaybePlayer<public> : ?player = false
    var FourthPlaceMaybePlayer<public> : ?player = false
    
    var FirstPlacePlayerMaybeEliminations<public> : ?int = false
    var SecondPlacePlayerMaybeEliminations<public> : ? int = false
    var ThirdPlacePlayerMaybeEliminations<public> : ?int = false
    var FourthPlacePlayerMaybeEliminations<public> : ?int = false

    var FirstPlacePlayerMaybeHighestKillstreak<public> : ?int = false
    var SecondPlacePlayerMaybeHighestKillstreak<public>  : ? int = false
    var ThirdPlacePlayerMaybeHighestKillstreak<public>  : ?int = false
    var FourthPlacePlayerMaybeHighestKillstreak<public>  : ?int = false

    var FirstPlacePlayerMaybeHighestAssists<public> : ?int = false
    var SecondPlacePlayerMaybeHighestAssists<public>  : ? int = false
    var ThirdPlacePlayerMaybeHighestAssists<public>  : ?int = false
    var FourthPlacePlayerMaybeHighestAssists<public>  : ?int = false

    var FirstPlaceMaybePlayerRank<public> : ?int = false
    var SecondPlaceMaybePlayerRank<public>: ? int = false
    var ThirdPlaceMaybePlayerRank<public>: ?int = false
    var FourthPlaceMaybePlayerRank<public>: ?int = false

    var MaybeFirstPlacePlayerTeam<public>: ?int = false
    var MaybeSecondPlacePlayerTeam<public>: ?int = false
    var MaybeThirdPlacePlayerTeam<public>: ?int = false
    var MaybeFourthPlacePlayerTeam<public>: ?int = false


MatchResultsDependencies<localizes>:message = "Dependency Injection"
MatchResultDevices<localizes>:message = "Devices"


display_matchresults := class(creative_device):

    #Dependencies
    @editable: 
        Categories := array{ MatchResultsDependencies }
    var MaybeDependencyInjector : ?dependency_injector = false

    var MaybeGameManager: ?game_manager = false
    var MaybeEventMediator : ?event_mediator = false
    var MaybePregameLobby : ?pregame_lobby = false
    var MaybeQuestManager : ?quest_manager = false

    #Dependencies
    @editable: 
        Categories := array{ MatchResultDevices }
    EndGameDevice<private> : end_game_device = end_game_device{}

    @editable: 
        Categories := array{ MatchResultDevices }
    StartingTeamSelectorDevice<private>: class_and_team_selector_device = class_and_team_selector_device{}

    var EliminationsCurrentGamePlayers<private>: []int = array{}

    PlayerNameToMessage<localizes><private>(Player : player): message = "{Player}"


    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        if(EventMediator := MaybeEventMediator?):
            EventMediator.OnGameEnds.Await()

            Sleep(7.5)

            SortMatchPlayersStats()

    
    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeEventMediator = DependencyInjector.GetEventMediator()
            set MaybePregameLobby = DependencyInjector.GetPreGameLobby()
            set MaybeQuestManager = DependencyInjector.GetQuestManager()
        else:
            Print(
                "Dependency Injector not available from Round Start manager",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )


    SortMatchPlayersStats(): void =
        if(EventMediator := MaybeEventMediator?):
            EventMediator.EmitOnPlayersAreSentToPodium()

        # AllPlayers := GetPlayspace().GetPlayers()
        # for(Player : AllPlayers):
        #     if(GameManager := MaybeGameManager?):
        #         MaybePlayerData := GameManager.GetMaybePlayerData(Player)
        #         if(PlayerData := MaybePlayerData?):
        #             PlayerData.HideScoreboardUI()
        #             CurrentGameEliminationsPlayer := PlayerData.GetCurrentGameEliminations()
        #             set EliminationsCurrentGamePlayers += array{ CurrentGameEliminationsPlayer }
            

        if(PregameLobby := MaybePregameLobby?):
            for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                if(GameManager := MaybeGameManager?):
                    MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)
                    if(PlayerData := MaybePlayerData?):
                        PlayerData.HideScoreboardUI()
                        CurrentGameEliminationsPlayer := PlayerData.GetCurrentGameEliminations()
                        set EliminationsCurrentGamePlayers += array{ CurrentGameEliminationsPlayer }


        set EliminationsCurrentGamePlayers = SortGameElimnationsForPlayers(EliminationsCurrentGamePlayers)

        var MaybePlayer1 : ?player = false
        var MaybePlayer2 : ?player = false
        var MaybePlayer3 : ?player = false
        var MaybePlayer4 : ?player = false

        var MaybePlayer1HighestKillstreak : ?int = false
        var MaybePlayer2HighestKillstreak : ?int = false
        var MaybePlayer3HighestKillstreak : ?int = false
        var MaybePlayer4HighestKillstreak : ?int = false

        var MaybePlayer1Assists : ?int = false
        var MaybePlayer2Assists : ?int = false
        var MaybePlayer3Assists : ?int = false
        var MaybePlayer4Assists : ?int = false

        var MaybePlayer1Rank : ?int = false
        var MaybePlayer2Rank : ?int = false
        var MaybePlayer3Rank : ?int = false
        var MaybePlayer4Rank : ?int = false

        var MaybePlayer1Team : ?int = false
        var MaybePlayer2Team : ?int = false
        var MaybePlayer3Team : ?int = false
        var MaybePlayer4Team : ?int = false

        var FisrtPlaceTaken : logic = false
        var SecondPlaceTaken : logic = false
        var ThirdPlaceTaken : logic = false
        var FourthPlaceTaken : logic = false



        case(EliminationsCurrentGamePlayers.Length):
            0 =>
                Print(
                    "EliminationsCurrentGamePlayers Array is 0, so its invalid", 
                    ?Duration := 5.0, 
                    ?Color := NamedColors.Red
                )

            1 =>
                #Print(
                    #"EliminationsCurrentGamePlayers Array is 0, so its invalid", 
                    #?Duration := 5.0, 
                    #?Color := NamedColors.Red
                #)
                if:
                    FirstPlaceEliminations := EliminationsCurrentGamePlayers[0]
                then:
                    if(GameManager := MaybeGameManager?, PregameLobby := MaybePregameLobby?):
                        for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                            MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)

                            if(PlayerData := MaybePlayerData?):
                                FinalCurrentGameEliminationsPlayer := PlayerData.GetCurrentGameEliminations()
                                FinalCurrentGameHighesKillstreakPlayer := PlayerData.GetCurrentGameHighestKillstreak()
                                FinalCurrentGameAssistsPlayer := PlayerData.GetCurrentGameAssists()
                                CurrentPlayerRank := PlayerData.GetPlayerRank()
                                PlayerTeamNumber := PlayerData.GetTeamNumber()

                                if(FinalCurrentGameEliminationsPlayer = FirstPlaceEliminations and FisrtPlaceTaken = false and PlayerData.HasSummaryPlacement = false):
                                    set MaybePlayer1 = option{ CurrentGamePlayer }
                                    set MaybePlayer1HighestKillstreak = option{ FinalCurrentGameHighesKillstreakPlayer }
                                    set MaybePlayer1Assists = option{ FinalCurrentGameAssistsPlayer }
                                    set MaybePlayer1Rank = option{ CurrentPlayerRank }
                                    set MaybePlayer1Team = option{ PlayerTeamNumber }
                                    set FisrtPlaceTaken = true
                                    set PlayerData.HasSummaryPlacement = true
                                    CheckIfPlayerHasStandingsQuest(CurrentGamePlayer)


                        var MatchSummaryInfo : match_summary_info = match_summary_info{
                                    #Player 1
                            FirstPlaceMaybePlayer := MaybePlayer1,
                            FirstPlacePlayerMaybeEliminations := option{ FirstPlaceEliminations },
                            FirstPlacePlayerMaybeHighestKillstreak := MaybePlayer1HighestKillstreak,
                            FirstPlacePlayerMaybeHighestAssists := MaybePlayer1Assists,
                            FirstPlaceMaybePlayerRank := MaybePlayer1Rank,
                            MaybeFirstPlacePlayerTeam := MaybePlayer1Team
                        }

                        for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                            MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)

                            if(PlayerData := MaybePlayerData?):
                                PlayerData.ShowMatchSummaryUI(MatchSummaryInfo)

            4 =>
                #THIS LOGIC CURRENTLY MAY NOT WORK WITH JOINED IN PLAYERSSSSS 
                if:
                    FirstPlaceEliminations := EliminationsCurrentGamePlayers[0]
                    SecondPlaceEliminations := EliminationsCurrentGamePlayers[1]
                    ThirdPlaceEliminations := EliminationsCurrentGamePlayers[2]
                    FourthPlaceEliminations := EliminationsCurrentGamePlayers[3]
                then:
                    if(GameManager := MaybeGameManager?, PregameLobby := MaybePregameLobby?):
                        for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                            MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)

                            if(PlayerData := MaybePlayerData?):
                                FinalCurrentGameEliminationsPlayer := PlayerData.GetCurrentGameEliminations()
                                FinalCurrentGameHighesKillstreakPlayer := PlayerData.GetCurrentGameHighestKillstreak()
                                FinalCurrentGameAssistsPlayer := PlayerData.GetCurrentGameAssists()
                                CurrentPlayerRank := PlayerData.GetPlayerRank()
                                PlayerTeamNumber := PlayerData.GetTeamNumber()

                                if(FinalCurrentGameEliminationsPlayer = FirstPlaceEliminations and FisrtPlaceTaken = false and PlayerData.HasSummaryPlacement = false):
                                    set MaybePlayer1 = option{ CurrentGamePlayer }
                                    set MaybePlayer1HighestKillstreak = option{ FinalCurrentGameHighesKillstreakPlayer }
                                    set MaybePlayer1Assists = option{ FinalCurrentGameAssistsPlayer }
                                    set MaybePlayer1Rank = option{ CurrentPlayerRank }
                                    set MaybePlayer1Team = option{ PlayerTeamNumber }
                                    set FisrtPlaceTaken = true
                                    set PlayerData.HasSummaryPlacement = true
                                    CheckIfPlayerHasStandingsQuest(CurrentGamePlayer)

                                    #Print("Player that was assigned to First Place is: ", ?Duration := 10.0, ?Color := NamedColors.Orange)
                                    #Print(PlayerNameToMessage(CurrentGamePlayer), ?Duration := 10.0, ?Color := NamedColors.Orange)
                                    
                                if(FinalCurrentGameEliminationsPlayer = SecondPlaceEliminations and SecondPlaceTaken = false and PlayerData.HasSummaryPlacement = false):
                                    set MaybePlayer2 = option{ CurrentGamePlayer }
                                    set MaybePlayer2HighestKillstreak = option{ FinalCurrentGameHighesKillstreakPlayer }
                                    set MaybePlayer2Assists = option{ FinalCurrentGameAssistsPlayer }
                                    set MaybePlayer2Rank = option{ CurrentPlayerRank }
                                    set MaybePlayer2Team = option{ PlayerTeamNumber }
                                    set SecondPlaceTaken = true
                                    set PlayerData.HasSummaryPlacement = true
                                    CheckIfPlayerHasStandingsQuest(CurrentGamePlayer)

                                    #Print("Player that was assigned to Second Place is: ", ?Duration := 10.0, ?Color := NamedColors.Orange)
                                    #Print(PlayerNameToMessage(CurrentGamePlayer), ?Duration := 10.0, ?Color := NamedColors.Orange)

                                if(FinalCurrentGameEliminationsPlayer = ThirdPlaceEliminations and ThirdPlaceTaken = false and PlayerData.HasSummaryPlacement = false):
                                    set MaybePlayer3 = option{ CurrentGamePlayer }
                                    set MaybePlayer3HighestKillstreak = option{ FinalCurrentGameHighesKillstreakPlayer }
                                    set MaybePlayer3Assists = option{ FinalCurrentGameAssistsPlayer }
                                    set MaybePlayer3Rank = option{ CurrentPlayerRank }
                                    set MaybePlayer3Team = option{ PlayerTeamNumber }
                                    set ThirdPlaceTaken = true
                                    set PlayerData.HasSummaryPlacement = true
                                    CheckIfPlayerHasStandingsQuest(CurrentGamePlayer)

                                    #Print("Player that was assigned to Third Place is: ", ?Duration := 10.0, ?Color := NamedColors.Orange)
                                    #Print(PlayerNameToMessage(CurrentGamePlayer), ?Duration := 10.0, ?Color := NamedColors.Orange)

                                if(FinalCurrentGameEliminationsPlayer = FourthPlaceEliminations and FourthPlaceTaken = false and PlayerData.HasSummaryPlacement = false):
                                    set MaybePlayer4 = option{ CurrentGamePlayer }
                                    set MaybePlayer4HighestKillstreak = option{ FinalCurrentGameHighesKillstreakPlayer }
                                    set MaybePlayer4Assists = option{ FinalCurrentGameAssistsPlayer }
                                    set MaybePlayer4Rank = option{ CurrentPlayerRank }
                                    set MaybePlayer4Team = option{ PlayerTeamNumber }
                                    set FourthPlaceTaken = true
                                    set PlayerData.HasSummaryPlacement = true

                                    #Print("Player that was assigned to Fourth Place is: ", ?Duration := 10.0, ?Color := NamedColors.Orange)
                                    #Print(PlayerNameToMessage(CurrentGamePlayer), ?Duration := 10.0, ?Color := NamedColors.Orange)


                        var MatchSummaryInfo : match_summary_info = match_summary_info{
                                    #Player 1
                            FirstPlaceMaybePlayer := MaybePlayer1,
                            FirstPlacePlayerMaybeEliminations := option{ FirstPlaceEliminations },
                            FirstPlacePlayerMaybeHighestKillstreak := MaybePlayer1HighestKillstreak,
                            FirstPlacePlayerMaybeHighestAssists := MaybePlayer1Assists,
                            FirstPlaceMaybePlayerRank := MaybePlayer1Rank,
                            MaybeFirstPlacePlayerTeam := MaybePlayer1Team, 
                                    #Player 2
                            SecondPlaceMaybePlayer := MaybePlayer2,
                            SecondPlacePlayerMaybeEliminations := option{ SecondPlaceEliminations },
                            SecondPlacePlayerMaybeHighestKillstreak := MaybePlayer2HighestKillstreak,
                            SecondPlacePlayerMaybeHighestAssists := MaybePlayer2Assists,
                            SecondPlaceMaybePlayerRank := MaybePlayer2Rank,
                            MaybeSecondPlacePlayerTeam := MaybePlayer2Team, 
                                    #Player 3
                            ThirdPlaceMaybePlayer := MaybePlayer3,
                            ThirdPlacePlayerMaybeEliminations := option{ ThirdPlaceEliminations },
                            ThirdPlacePlayerMaybeHighestKillstreak := MaybePlayer3HighestKillstreak,
                            ThirdPlacePlayerMaybeHighestAssists := MaybePlayer3Assists,
                            ThirdPlaceMaybePlayerRank := MaybePlayer3Rank,
                            MaybeThirdPlacePlayerTeam := MaybePlayer3Team,

                                #Player 3
                            FourthPlaceMaybePlayer := MaybePlayer4,
                            FourthPlacePlayerMaybeEliminations := option{ FourthPlaceEliminations },
                            FourthPlacePlayerMaybeHighestKillstreak := MaybePlayer4HighestKillstreak,
                            FourthPlacePlayerMaybeHighestAssists := MaybePlayer4Assists,
                            FourthPlaceMaybePlayerRank := MaybePlayer4Rank,
                            MaybeFourthPlacePlayerTeam := MaybePlayer4Team
                        }

                        for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                            MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)

                            if(PlayerData := MaybePlayerData?):
                                PlayerData.ShowMatchSummaryUI(MatchSummaryInfo)
            2 =>
                if:
                    FirstPlaceEliminations := EliminationsCurrentGamePlayers[0]
                    SecondPlaceEliminations := EliminationsCurrentGamePlayers[1]
                then:
                    if(GameManager := MaybeGameManager?, PregameLobby := MaybePregameLobby?):
                        for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                            MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)

                            if(PlayerData := MaybePlayerData?):
                                FinalCurrentGameEliminationsPlayer := PlayerData.GetCurrentGameEliminations()
                                FinalCurrentGameHighesKillstreakPlayer := PlayerData.GetCurrentGameHighestKillstreak()
                                FinalCurrentGameAssistsPlayer := PlayerData.GetCurrentGameAssists()
                                CurrentPlayerRank := PlayerData.GetPlayerRank()
                                PlayerTeamNumber := PlayerData.GetTeamNumber()

                                if(FinalCurrentGameEliminationsPlayer = FirstPlaceEliminations and FisrtPlaceTaken = false and PlayerData.HasSummaryPlacement = false):
                                    set MaybePlayer1 = option{ CurrentGamePlayer }
                                    set MaybePlayer1HighestKillstreak = option{ FinalCurrentGameHighesKillstreakPlayer}
                                    set MaybePlayer1Assists = option{ FinalCurrentGameAssistsPlayer }
                                    set MaybePlayer1Rank = option{ CurrentPlayerRank }
                                    set MaybePlayer1Team = option{ PlayerTeamNumber }
                                    set FisrtPlaceTaken = true
                                    set PlayerData.HasSummaryPlacement = true
                                    CheckIfPlayerHasStandingsQuest(CurrentGamePlayer)

                                    #Print("Player that was assigned to First Place is: ", ?Duration := 10.0, ?Color := NamedColors.Orange)
                                    #Print(PlayerNameToMessage(CurrentGamePlayer), ?Duration := 10.0, ?Color := NamedColors.Orange)

                                if(FinalCurrentGameEliminationsPlayer = SecondPlaceEliminations and SecondPlaceTaken = false and PlayerData.HasSummaryPlacement = false):
                                    set MaybePlayer2 = option{ CurrentGamePlayer }
                                    set MaybePlayer2HighestKillstreak = option{ FinalCurrentGameHighesKillstreakPlayer }
                                    set MaybePlayer2Assists = option{ FinalCurrentGameAssistsPlayer }
                                    set MaybePlayer2Rank = option{ CurrentPlayerRank }
                                    set MaybePlayer2Team = option{ PlayerTeamNumber }
                                    set SecondPlaceTaken = true
                                    set PlayerData.HasSummaryPlacement = true
                                    CheckIfPlayerHasStandingsQuest(CurrentGamePlayer)

                                    #Print("Player that was assigned to Second Place is: ", ?Duration := 10.0, ?Color := NamedColors.Orange)
                                    #Print(PlayerNameToMessage(CurrentGamePlayer), ?Duration := 10.0, ?Color := NamedColors.Orange)

                                    
                        var MatchSummaryInfo : match_summary_info = match_summary_info{
                                    #Player 1
                            FirstPlaceMaybePlayer := MaybePlayer1,
                            FirstPlacePlayerMaybeEliminations := option{ FirstPlaceEliminations },
                            FirstPlacePlayerMaybeHighestKillstreak := MaybePlayer1HighestKillstreak,
                            FirstPlacePlayerMaybeHighestAssists := MaybePlayer1Assists,
                            FirstPlaceMaybePlayerRank := MaybePlayer1Rank,
                            MaybeFirstPlacePlayerTeam := MaybePlayer1Team, 
                                    #Player 2
                            SecondPlaceMaybePlayer := MaybePlayer2,
                            SecondPlacePlayerMaybeEliminations := option{ SecondPlaceEliminations },
                            SecondPlacePlayerMaybeHighestKillstreak := MaybePlayer2HighestKillstreak,
                            SecondPlacePlayerMaybeHighestAssists := MaybePlayer2Assists,
                            SecondPlaceMaybePlayerRank := MaybePlayer2Rank,
                            MaybeSecondPlacePlayerTeam := MaybePlayer2Team
                        }

                        for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                            MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)

                            if(PlayerData := MaybePlayerData?):
                                PlayerData.ShowMatchSummaryUI(MatchSummaryInfo)

            3 =>
                if:
                    FirstPlaceEliminations := EliminationsCurrentGamePlayers[0]
                    SecondPlaceEliminations := EliminationsCurrentGamePlayers[1]
                    ThirdPlaceEliminations := EliminationsCurrentGamePlayers[2]
                then:
                    if(GameManager := MaybeGameManager?, PregameLobby := MaybePregameLobby?):
                        for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                            MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)

                            if(PlayerData := MaybePlayerData?):
                                FinalCurrentGameEliminationsPlayer := PlayerData.GetCurrentGameEliminations()
                                FinalCurrentGameHighesKillstreakPlayer := PlayerData.GetCurrentGameHighestKillstreak()
                                FinalCurrentGameAssistsPlayer := PlayerData.GetCurrentGameAssists()
                                CurrentPlayerRank := PlayerData.GetPlayerRank()
                                PlayerTeamNumber := PlayerData.GetTeamNumber()

                                if(FinalCurrentGameEliminationsPlayer = FirstPlaceEliminations and FisrtPlaceTaken = false and PlayerData.HasSummaryPlacement = false):
                                    set MaybePlayer1 = option{ CurrentGamePlayer }
                                    set MaybePlayer1HighestKillstreak = option{ FinalCurrentGameHighesKillstreakPlayer }
                                    set MaybePlayer1Assists = option{ FinalCurrentGameAssistsPlayer }
                                    set MaybePlayer1Rank = option{ CurrentPlayerRank }
                                    set MaybePlayer1Team = option{ PlayerTeamNumber }
                                    set FisrtPlaceTaken = true
                                    set PlayerData.HasSummaryPlacement = true
                                    CheckIfPlayerHasStandingsQuest(CurrentGamePlayer)

                                    #Print("Player that was assigned to First Place is: ", ?Duration := 10.0, ?Color := NamedColors.Orange)
                                    #Print(PlayerNameToMessage(CurrentGamePlayer), ?Duration := 10.0, ?Color := NamedColors.Orange)
                                    
                                if(FinalCurrentGameEliminationsPlayer = SecondPlaceEliminations and SecondPlaceTaken = false and PlayerData.HasSummaryPlacement = false):
                                    set MaybePlayer2 = option{ CurrentGamePlayer }
                                    set MaybePlayer2HighestKillstreak = option{ FinalCurrentGameHighesKillstreakPlayer }
                                    set MaybePlayer2Assists = option{ FinalCurrentGameAssistsPlayer }
                                    set MaybePlayer2Rank = option{ CurrentPlayerRank }
                                    set MaybePlayer2Team = option{ PlayerTeamNumber }
                                    set SecondPlaceTaken = true
                                    set PlayerData.HasSummaryPlacement = true
                                    CheckIfPlayerHasStandingsQuest(CurrentGamePlayer)

                                    #Print("Player that was assigned to Second Place is: ", ?Duration := 10.0, ?Color := NamedColors.Orange)
                                    #Print(PlayerNameToMessage(CurrentGamePlayer), ?Duration := 10.0, ?Color := NamedColors.Orange)

                                if(FinalCurrentGameEliminationsPlayer = ThirdPlaceEliminations and ThirdPlaceTaken = false and PlayerData.HasSummaryPlacement = false):
                                    set MaybePlayer3 = option{ CurrentGamePlayer }
                                    set MaybePlayer3HighestKillstreak = option{ FinalCurrentGameHighesKillstreakPlayer }
                                    set MaybePlayer3Assists = option{ FinalCurrentGameAssistsPlayer }
                                    set MaybePlayer3Rank = option{ CurrentPlayerRank }
                                    set MaybePlayer3Team = option{ PlayerTeamNumber }
                                    set ThirdPlaceTaken = true
                                    set PlayerData.HasSummaryPlacement = true
                                    CheckIfPlayerHasStandingsQuest(CurrentGamePlayer)

                                    #Print("Player that was assigned to Third Place is: ", ?Duration := 10.0, ?Color := NamedColors.Orange)
                                    #Print(PlayerNameToMessage(CurrentGamePlayer), ?Duration := 10.0, ?Color := NamedColors.Orange)


                        var MatchSummaryInfo : match_summary_info = match_summary_info{
                                    #Player 1
                            FirstPlaceMaybePlayer := MaybePlayer1,
                            FirstPlacePlayerMaybeEliminations := option{ FirstPlaceEliminations },
                            FirstPlacePlayerMaybeHighestKillstreak := MaybePlayer1HighestKillstreak,
                            FirstPlacePlayerMaybeHighestAssists := MaybePlayer1Assists,
                            FirstPlaceMaybePlayerRank := MaybePlayer1Rank,
                            MaybeFirstPlacePlayerTeam := MaybePlayer1Team, 
                                    #Player 2
                            SecondPlaceMaybePlayer := MaybePlayer2,
                            SecondPlacePlayerMaybeEliminations := option{ SecondPlaceEliminations },
                            SecondPlacePlayerMaybeHighestKillstreak := MaybePlayer2HighestKillstreak,
                            SecondPlacePlayerMaybeHighestAssists := MaybePlayer2Assists,
                            SecondPlaceMaybePlayerRank := MaybePlayer2Rank,
                            MaybeSecondPlacePlayerTeam := MaybePlayer2Team, 
                                    #Player 3
                            ThirdPlaceMaybePlayer := MaybePlayer3,
                            ThirdPlacePlayerMaybeEliminations := option{ ThirdPlaceEliminations },
                            ThirdPlacePlayerMaybeHighestKillstreak := MaybePlayer3HighestKillstreak,
                            ThirdPlacePlayerMaybeHighestAssists := MaybePlayer3Assists,
                            ThirdPlaceMaybePlayerRank := MaybePlayer3Rank,
                            MaybeThirdPlacePlayerTeam := MaybePlayer3Team 
                        }

                        for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                            MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)

                            if(PlayerData := MaybePlayerData?):
                                PlayerData.ShowMatchSummaryUI(MatchSummaryInfo)
            _=>
                Print(
                    "EliminationsCurrentGamePlayers Array is greater than 3, so its invalid", 
                    ?Duration := 5.0, 
                    ?Color := NamedColors.Red
                )

        spawn{ EndRound() }
        
                
    SortGameElimnationsForPlayers(UnsortedScore : []int) :[]int= 
        var SortedArray : []int = UnsortedScore
        for(I := 0..SortedArray.Length-1):
            for(J := 0..SortedArray.Length - I - 2):
                if(E1 := SortedArray[J],  E2 := SortedArray[J+1]):
                    if(E1 < E2):
                        if:
                            set SortedArray[J] = E2
                            set SortedArray[J+1] = E1              
        return SortedArray



    CheckIfPlayerHasStandingsQuest(Player : player): void =
        if(GameManager := MaybeGameManager?, QuestManager := MaybeQuestManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Player)
            if(PlayerData := MaybePlayerData?):
                CurrentQuest := PlayerData.GetCurrentQuest()
                if(CurrentQuest = EQuests.Top3Standings):
                    QuestManager.IncrementValueTop3StandingsQuest(Player)


    EndRound()<suspends>: void =
        Sleep(10.0)
        
        StartingTeamSelectorDevice.Enable()

        AllPlayers := GetPlayspace().GetPlayers()
        for(Player : AllPlayers):
            StartingTeamSelectorDevice.ChangeTeamAndClass(Player)
            
            Print(
                "Switched players team to the default team from the round summary standing script!!!", 
                ?Duration :=10.0, 
                ?Color := NamedColors.Red
            )

        # Only getting all the players since RoundSettingsDevice.EndRound requires and Agent
        if(Player := AllPlayers[0]):
            EndGameDevice.Activate(Player)
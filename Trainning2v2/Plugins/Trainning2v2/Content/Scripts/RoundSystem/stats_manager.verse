using { /Verse.org/Colors }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { MainScripts }
using { Lib }

stats_manager := class(creative_device):

    @editable
    MaybeDependencyInjector : ?dependency_injector = false
    
    # var MaybeGameManager: ?game_manager = false
    # var MaybeRoundStartManager : ?round_start_manager = false
    
    # OnBegin<override>()<suspends>:void=
    #     SetupDependencies()

    #     Print("Stats Manager Device is alive and ready!!!!", ?Duration := 10.0, ?Color := NamedColors.LightGreen)

    #     AllPlayers := GetPlayspace().GetPlayers()
    #     for(Player : AllPlayers):
    #         RegisterPlayer(Player)

    #     GetPlayspace().PlayerAddedEvent().Subscribe(RegisterPlayer)


    # OnPlayerJoinsGame(Agent : agent): void =
    #     RegisterPlayer(Agent)

    # RegisterPlayer(Agent : agent): void = 
    #     if(FortCharacter := Agent.GetFortCharacter[]):
    #         FortCharacter.EliminatedEvent().Subscribe(OnPlayerEliminated)


    # OnPlayerEliminated(Result : elimination_result): void =
    #     Print(
    #         "Player eliminated called!!!!!", 
    #         ?Duration := 10.0, 
    #         ?Color := NamedColors.Red
    #     )

    #     Eliminator := Result.EliminatingCharacter
    #     Eliminated := Result.EliminatedCharacter

    #     if(GameManager := MaybeGameManager?):
    #         if:
    #             EliminatedAgent := Eliminated.GetAgent[]
    #         then:
    #             MaybePlayeEliminatedData := GameManager.GetMaybePlayerData(EliminatedAgent)
    #             if(PlayerDataEliminated := MaybePlayeEliminatedData?):
    #                 PlayerDataEliminated.SetPlayerDeaths(1)
    #                 PlayerDataEliminated.SaveDataForPlayer()
                    
    #                 PlayerTeamNumber := PlayerDataEliminated.GetTeamNumber()

    #                 if(PlayerTeamNumber = 0, RoundStartManager := MaybeRoundStartManager?):
    #                     if(Player := RoundStartManager.Team1Players.Find[EliminatedAgent], NewArray := RoundStartManager.Team1Players.RemoveElement[Player]):
    #                         set RoundStartManager.Team1Players = NewArray
    #                         if(RoundStartManager.Team1Players.Length = 0):
    #                             # PlayerName := Message1(EliminatedAgent)
    #                             Print(
    #                                 "Team 1 length is 0! Detecting from player!!!!!", ?Duration := 10.0, ?Color := NamedColors.Yellow)
    #                             OnTeam2Wins()
    #                             # Print(
    #                             #     "All team members from team 1 have been eliminated, ending the current round", 
    #                             #     ?Duration := 5.0, 
    #                             #     ?Color := NamedColors.Red
    #                             # )
    #                             spawn { OnRoundEnds() }

    #                 else if(PlayerTeamNumber = 1, RoundStartManager := MaybeRoundStartManager?):
    #                     if(Player := RoundStartManager.Team2Players.Find[EliminatedAgent], NewArray := RoundStartManager.Team2Players.RemoveElement[Player]):
    #                         set RoundStartManager.Team2Players = NewArray
    #                         if(RoundStartManager.Team2Players.Length = 0):
    #                             Print(
    #                                 "Team 2 length is 0! Detecting from player!!!!!", ?Duration := 10.0, ?Color := NamedColors.Yellow)
    #                             OnTeam1Wins()
    #                             # Print(
    #                             #     "All team members from team 2 have been eliminated, ending the current round", 
    #                             #     ?Duration := 5.0, 
    #                             #     ?Color := NamedColors.Blue
    #                             # )
    #                             spawn{ OnRoundEnds() }

    #                 if(RoundStartManager := MaybeRoundStartManager?):
    #                     Print(
    #                         "{RoundStartManager.Team1Players.Length}!!!!!", 
    #                         ?Duration := 10.0, 
    #                         ?Color := NamedColors.Red
    #                     )
    #                     Print(
    #                         "{RoundStartManager.Team2Players.Length}!!!!!", 
    #                         ?Duration := 10.0, 
    #                         ?Color := NamedColors.Red
    #                     )

    #         if:
    #             FCEliminatingCharacter := Result.EliminatingCharacter?
    #             EliminatorAgent := FCEliminatingCharacter.GetAgent[]
    #         then:
    #             MaybePlayeEliminatorData := GameManager.GetMaybePlayerData(EliminatorAgent)
    #             if(PlayerDataEliminator := MaybePlayeEliminatorData?):
    #                 # Print(
    #                 #     "Calling this function to Add a death to the player!!", 
    #                 #     ?Duration := 5.0, 
    #                 #     ?Color := NamedColors.Purple
    #                 # )
    #                 PlayerDataEliminator.SetPlayerKills(1)
    #                 PlayerDataEliminator.SetPlayerPrestige(2)
    #                 PlayerDataEliminator.SaveDataForPlayer()


    # AwaitElimination(FortCharacter : fort_character)<suspends> : void=
    #     FortCharacter.EliminatedEvent().Await()
    #     if(Agent := FortCharacter.GetAgent[]):
    #      RankManager.CalculatePlayerRank(Agent)
        
    # SetupDependencies():void=
    #     if:
    #         DependencyInjector := MaybeDependencyInjector?
    #     then:
    #         set MaybeGameManager = DependencyInjector.GetGameManager()
    #         set MaybeRoundStartManager = DependencyInjector.GetRoundStartManager()
    #     else:
    #         Print(
    #             "Dependency Injector not available",
    #             ?Duration := 4.0,
    #             ?Color := NamedColors.Red
    #         )

    # OnTeam1Wins(): void =
    #     Print(
    #         "This part of the code has been executed!!!!!", ?Duration := 10.0, ?Color := NamedColors.LightBlue)
    #     Print(
    #         "Team 1 has won!!", ?Duration := 10.0, ?Color := NamedColors.LightBlue)
    #     # When Team 1 wins
    #     if(RoundStartManager := MaybeRoundStartManager?):
    #         #AwardTeamWinningPlayers(Team1Players) Optional Array or index
    #         AwardTeamWinningPlayers(RoundStartManager.Team1Players)
    #         RoundStartManager.UpdateTeam1ScoreAfterWin()

    #     # for(Team2Player : RoundStartManager.Team2Players):
    #     #     if(RoundStartManager := MaybeRoundStartManager?):
    #     #         RoundStartManager.RoundLossHUDMessage.Show(Team2Player)

    # OnTeam2Wins(): void =
    #     # When Team 2 wins
    #         #AwardTeamWinningPlayers(Team2Players) Optional Array or index
    #     Print(
    #         "This part of the code has been executed!!!!!", ?Duration := 10.0, ?Color := NamedColors.Red)
    #     Print(
    #         "Team 2 has won!!", 
    #         ?Duration := 10.0, ?Color := NamedColors.Red)

    #     if(RoundStartManager := MaybeRoundStartManager?):
    #         AwardTeamWinningPlayers(RoundStartManager.Team2Players)
    #         RoundStartManager.UpdateTeam2ScoreAfterWin()

    #     # for(Team1Player : Team1Players):
    #     #     if(RoundStartManager := MaybeRoundStartManager?):
    #     #         RoundStartManager.RoundLossHUDMessage.Show(Team1Player)


    # # Set prestige to winner team
    # AwardTeamWinningPlayers(WinnerTeam : []player):void=
    # #   WinnerTeam = 
    #     for(Player : WinnerTeam):
    #         if(GameManager := MaybeGameManager?, RoundStartManager := MaybeRoundStartManager?):
    #             RoundStartManager.RoundWinHUDMessage.Show(Player)
    #             MaybePlayerData := GameManager.GetMaybePlayerData(Player)
    #             if:
    #                 PlayerData := MaybePlayerData?
    #             then:
    #                 PlayerData.SetPlayerPrestige(5)
    #                 PlayerData.SaveDataForPlayer() 
    #                 # Print(
    #                 #     "Prestige updated after round winnn!!", 
    #                 #     ?Duration := 8.0, 
    #                 #     ?Color := NamedColors.Purple
    #                 # )

    # OnRoundEnds()<suspends>: void =
    #     Print(
    #         "Calling OnRound Ends!!!!!", ?Duration := 10.0, ?Color := NamedColors.Yellow)
    #     # Print(
    #     #     "Round has ended!!!", 
    #     #     ?Duration := 5.0, 
    #     #     ?Color := NamedColors.LightGreen
    #     # )

    #     AllPlayers := GetPlayspace().GetPlayers()
    #     TeamCollection := GetPlayspace().GetTeamCollection()

    #     var NewPlayersTeam1 : []player = array {}
    #     var NewPlayersTeam2 : []player = array {}

    #     if(RoundStartManager := MaybeRoundStartManager?):
    #         for(Player : AllPlayers): 
    #             if(PlayersTeam := TeamCollection.GetTeam[Player]):
    #                 if(PlayersTeam = 0):
    #                     if(PlayerTeam1 := RoundStartManager.Team1Players.Find[Player]){}
    #                     else: 
    #                         set RoundStartManager.Team1Players += array{ Player }
    #                 else if(PlayersTeam = 1):
    #                     if(PlayerTeam2 := RoundStartManager.Team2Players.Find[Player]){}
    #                     else:
    #                         set RoundStartManager.Team2Players += array{ Player }


    #     if(RoundStartManager := MaybeRoundStartManager?):
    #         set RoundStartManager.Team1Players = NewPlayersTeam1
    #         set RoundStartManager.Team2Players = NewPlayersTeam1
    #         Print(
    #             "{RoundStartManager.Team1Players.Length}!!!!!", 
    #             ?Duration := 10.0, 
    #             ?Color := NamedColors.Orange
    #         )
    #         Print(
    #             "{RoundStartManager.Team2Players.Length}!!!!!", 
    #             ?Duration := 10.0, 
    #             ?Color := NamedColors.Orange
    #         )


    #     Sleep(3.0) #This will be the round win UI animation duration before the next round timer wins 

    #     if(RoundStartManager := MaybeRoundStartManager?):
    #         # Print(
    #         #     "Yessss Round Start Manager valid from round zone!!", 
    #         #     ?Duration := 10.0, 
    #         #     ?Color := NamedColors.LightGreen
    #         # )
    #         RoundStartManager.PickNextRoundZone()
    #     else:
    #         Print(
    #             "Round Start Manager is not valid from round zone!!", 
    #             ?Duration := 10.0, 
    #             ?Color := NamedColors.Red
    #         )
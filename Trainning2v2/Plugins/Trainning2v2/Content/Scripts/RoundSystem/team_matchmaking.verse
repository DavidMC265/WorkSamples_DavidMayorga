using { /Fortnite.com }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { Lobby }
using { MainScripts }


Dependencies_TeamMatchmaking<localizes>:message = "Dependencies"
Devices_TeamMatchmaking<localizes>:message = "Devices"

team_matchmaking := class(creative_device):

        #Dependencies
    @editable:
        Categories := array{ Dependencies_TeamMatchmaking }
    MaybeDependencyInjector<private> : ?dependency_injector = false
    
    var MaybeEventMediator<private> : ?event_mediator = false
    var MaybeGameManager<private> : ?game_manager = false
    var MaybeRoundStartManager<private> : ?round_start_manager = false
    var MaybePregameLobby<private> : ?pregame_lobby = false

        #Devices
    @editable:
        Categories := array{ Devices_TeamMatchmaking }
    Team1ClassSelectorDevice<private>: class_and_team_selector_device = class_and_team_selector_device{}

    @editable:
        Categories := array{ Devices_TeamMatchmaking }
    Team2ClassSelectorDevice<private>: class_and_team_selector_device = class_and_team_selector_device{}

    @editable:
        Categories := array{ Devices_TeamMatchmaking }
    PopUpDialog<private> : popup_dialog_device = popup_dialog_device{}

    @editable:
        Categories := array{ Devices_TeamMatchmaking }
    PopUpDialog1Player<private> : popup_dialog_device = popup_dialog_device{}

    @editable:
        Categories := array{ Devices_TeamMatchmaking }
    PopUpDialog1PlayerToOtherPlayers<private> : popup_dialog_device = popup_dialog_device{}

    @editable:
        Categories := array{ Devices_TeamMatchmaking}
    EndGameDevice<private>: end_game_device = end_game_device{}


    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerLeaves)

        AwaitFirstRoundStarted()


    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeEventMediator = DependencyInjector.GetEventMediator()
            set MaybeRoundStartManager = DependencyInjector.GetRoundStartManager()
            set MaybePregameLobby = DependencyInjector.GetPreGameLobby()
        else:
            Print(
                "Dependency Injector not available from Round Start manager",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )

    AwaitFirstRoundStarted()<suspends>: void =
        if(EventMediator := MaybeEventMediator?):
            EventMediator.OnRoundTimerStartCompleted.Await()
            

            #For now we're not going to check if there is one or two player left due to the NPCs implementation
            #CheckIfTwoPlayersInGame() 

            #CheckIfOnePlayersInGame()

            spawn { AwaitFirstRoundStarted() }


    CheckIfTwoPlayersInGame()<suspends>: void =

        Sleep(1.0)

        TeamCollection := GetPlayspace().GetTeamCollection()
        TeamArray := TeamCollection.GetTeams()

        if(PregameLobby := MaybePregameLobby?):
            if(PregameLobby.CurrentGamePlayers.Length = 2):
                for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                    if(Player1 := PregameLobby.CurrentGamePlayers[0], Player2 := PregameLobby.CurrentGamePlayers[1]):
                        if (Player1Team := TeamCollection.GetTeam[Player1], Player2Team := TeamCollection.GetTeam[Player2]):
                            if(Player1Team = Player2Team):
                                for (TeamNumber->Team : TeamArray):
                                    if(Player1Team = Team and Player2Team = Team):
                                        PopUpDialog.Show(Player1)
                                        PopUpDialog.Show(Player2)

                                        if:
                                            FortCharacter1 := Player1.GetFortCharacter[]
                                            FortCharacter2 := Player1.GetFortCharacter[]
                                        then:
                                            FortCharacter1.PutInStasis(stasis_args{AllowTurning := true, AllowFalling := true})


                                        SwitchRandomPlayerToOtherTeam(TeamNumber, Player1, Player2)

                                        Sleep(5.0)

                                        PopUpDialog.Hide(Player1)
                                        PopUpDialog.Hide(Player2)

                                        if(RoundStartManager := MaybeRoundStartManager?):
                                            if(CurrentDeviceZone := RoundStartManager.CurrentZoneDevice?, CurrentDeviceZone.CancelZoneEventSubscriptions[]):
                                                CurrentDeviceZone.DestoyZoneStorm()
                                                RoundStartManager.PickNextRoundZone()


    CheckIfOnePlayersInGame()<suspends>:void =
        TeamCollection := GetPlayspace().GetTeamCollection()
        TeamArray := TeamCollection.GetTeams()

        if:
            PreGameLobby := MaybePregameLobby?
            PreGameLobby.CurrentGamePlayers.Length = 1, 
            Player1 := PreGameLobby.CurrentGamePlayers[0]
        then:
            PopUpDialog1Player.Show(Player1)

            var AllPlayersInGame : []player = GetPlayspace().GetPlayers()

            if:
                Player := AllPlayersInGame.Find[Player1]
                NewArray := AllPlayersInGame.RemoveElement[Player]
                set AllPlayersInGame = NewArray 
            then:

                for(PlayerInGame : AllPlayersInGame):
                    PopUpDialog1PlayerToOtherPlayers.Show(PlayerInGame)

                Sleep(5.0)
                #EndGameDevice.Activate(Player1)



    SwitchRandomPlayerToOtherTeam(TeamNumber : int, Player1 : player, Player2 : player): void =
        case(TeamNumber):
            0 => 
                RandomIndex := GetRandomInt(0, 1)
                if(RandomIndex = 0):
                    SwitchRandomPlayerToTeam2(Player1)
                else:
                    SwitchRandomPlayerToTeam2(Player2)

            1 => 
                RandomIndex := GetRandomInt(0, 1)
                    if(RandomIndex = 0):
                        SwitchRandomPlayerToTeam1(Player1)
                    else:
                        SwitchRandomPlayerToTeam1(Player2)
            _=> 
                Print(
                    "Team index is not valid, team is {TeamNumber}!!!", 
                    ?Duration := 15.0, 
                    ?Color := NamedColors.Red
                )



    OnPlayerLeaves(Agent : agent): void =
        spawn{ CheckIfTwoPlayersInGame() }
        spawn { CheckIfOnePlayersInGame() }


    SwitchRandomPlayerToTeam2(Player : player): void = 
        Team2ClassSelectorDevice.ChangeTeamAndClass(Player)

        TeamCollection := GetPlayspace().GetTeamCollection()
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Player)
            PlayerData := MaybePlayerData?
            PregameLobby := MaybePregameLobby?
        
        then:
            if (AgentsTeam := TeamCollection.GetTeam[Player]):
                TeamArray := TeamCollection.GetTeams()
                for (TeamNumber->Team : TeamArray):
                    if (AgentsTeam = Team):
                        PlayerData.SetTeamNumber(TeamNumber)

            PregameLobby.RemovePlayerFromTeam1Players(Player)
            PregameLobby.AddPlayerToTeam2Players(Player)

                        

    SwitchRandomPlayerToTeam1(Player : player): void = 
        Team1ClassSelectorDevice.ChangeTeamAndClass(Player)

        TeamCollection := GetPlayspace().GetTeamCollection()
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Player)
            PlayerData := MaybePlayerData?
            PregameLobby := MaybePregameLobby?
        
        then:
            if (AgentsTeam := TeamCollection.GetTeam[Player]):
                TeamArray := TeamCollection.GetTeams()
                for (TeamNumber->Team : TeamArray):
                    if (AgentsTeam = Team):
                        PlayerData.SetTeamNumber(TeamNumber)

            PregameLobby.RemovePlayerFromTeam2Players(Player)
            PregameLobby.AddPlayerToTeam1Players(Player)



    
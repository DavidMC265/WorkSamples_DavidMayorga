using { /Fortnite.com }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { Lib }
using { MainScripts }
using { RoundSystem }

DependenciesLobby<localizes>:message = "DependenciesLobby"
Config<localizes>:message = "Configuration"
InteractionLobby<localizes>:message = "Interaction Configuration"
Team1<localizes>:message = "Team 1 Devices"
Team2<localizes>:message = "Team 2 Devices"
WeaponSelectionArea<localizes>:message = "Weapon Selection Area"
UIPregameLobby<localizes>:message = "UI"
PlayerRanksLobby<localizes>: message = "Player Ranks"

pregame_lobby<public> := class(creative_device):
    
        #DependencyInjector
    @editable: 
        Categories := array{ DependenciesLobby }
    var MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeGameManager<private>: ?game_manager = false
    var MaybeEventMediator<private>: ?event_mediator = false
    var MaybePracticeArea<private>: ?practice_area = false
    var MaybeRoundStartManager<private>: ?round_start_manager = false
    var MaybeJoinInProgressManager<private>: ?joininprogress_manager = false
    var MaybeMainRankManager<private>: ?main_rank_manager = false

        #Config
    @editable_slider(int):
        Categories := array{Config}
        MinValue := option{ 45 }
        MaxValue := option { 120 }
    TimeBeforeGameStart<private> : int = 60

        #UI
    @editable:
        Categories := array{ UIPregameLobby }
    ChooseATeamDialog<private> : popup_dialog_device =  popup_dialog_device{}

    @editable:
        Categories := array{ UIPregameLobby }
    SelectATeamTracker<private> : tracker_device = tracker_device{}

        #Player Ranks
    @editable:
        Categories := array{ PlayerRanksLobby }
    PlayerReferenceRankPropIcon1<private> : creative_prop = creative_prop{}

    @editable:
        Categories := array{ PlayerRanksLobby }
    PlayerReferenceRankPropIcon2<private> : creative_prop = creative_prop{}

    @editable:
        Categories := array{ PlayerRanksLobby }
    PlayerReferenceRankPropIcon3<private> : creative_prop = creative_prop{}

    @editable:
        Categories := array{ PlayerRanksLobby }
    PlayerReferenceRankPropIcon4<private> : creative_prop = creative_prop{}

        #PregameLobby Devices
    @editable: 
        Categories := array{ InteractionLobby }
    SkyVolume<private> : volume_device = volume_device{}

    @editable:
        Categories := array{ InteractionLobby }
    RoundSettingdDevice<private>: round_settings_device = round_settings_device{}
    
    @editable: 
        Categories := array{ InteractionLobby }
    CurrentGameHUDMessage<private> : hud_message_device = hud_message_device{}

    @editable: 
        Categories := array{ InteractionLobby }
    CBTrigger<private> : trigger_device = trigger_device{}

    @editable:
        Categories := array{ InteractionLobby }
    OtherLobbyPortalDevice<private> : matchmaking_portal_device = matchmaking_portal_device{}

    @editable:
        Categories := array{InteractionLobby}
    StartingGamePlayerSpawners<private> : []player_spawner_device = array{}

    @editable:
        Categories := array{ InteractionLobby }
    TeamSelectorCoverWalls<private> : []prop_manipulator_device = array{}
    
    @editable:
        Categories := array{ InteractionLobby }
    WoodItemGranter<private> : item_granter_device = item_granter_device{}

    @editable:
        Categories := array{Team1}
    BeaconTeam1<private> : beacon_device = beacon_device{}

    @editable:
        Categories := array{Team2}
    BeaconTeam2<private> : beacon_device = beacon_device{}

    @editable:
        Categories := array{Team1}
    Team1PlayerCounter<private> : player_counter_device = player_counter_device{}

    @editable:
        Categories := array{Team2}
    Team2PlayerCounter : player_counter_device = player_counter_device{}

    @editable:
        Categories := array{Team1}
    Team1PlayerCounterBarrier<private> : barrier_device = barrier_device{}

    @editable:
        Categories := array{Team2}
    Team2PlayerCounterBarrier<private> : barrier_device = barrier_device{}

    @editable:
        Categories := array{ InteractionLobby }
    StartingTeamSelectorDevice<private> : class_and_team_selector_device = class_and_team_selector_device{}

    @editable:
        Categories := array{Team1}
    Team1SelectorDevice<private> : class_and_team_selector_device = class_and_team_selector_device{}

    @editable:
        Categories := array{Team2}
    Team2SelectorDevice<private> : class_and_team_selector_device = class_and_team_selector_device{}

    @editable:
        Categories := array{Team1}
    PlayerReference1Team1<private> : player_reference_device = player_reference_device{}

    @editable:
        Categories := array{Team1}
    PlayerReference2Team1<private> : player_reference_device = player_reference_device{}

    var Team1PlayerReferences<private> : []player_reference_device = array{}

    @editable:
        Categories := array{Team2}
    PlayerReference1Team2<private> : player_reference_device = player_reference_device{}

    @editable:
        Categories := array{Team2}
    PlayerReference2Team2<private> : player_reference_device = player_reference_device{}

    var Team2PlayerReferences<private> : []player_reference_device = array{}

        #Teleporters / Teleporting Props

    @editable:
        Categories := array{InteractionLobby}
    TeleporterDevice<private> : teleporter_device = teleporter_device{}

    @editable:
        Categories := array { InteractionLobby }
    LobbyToPracticeZoneTeleporter<private> : teleporter_device = teleporter_device{}

    @editable:
        Categories := array{ InteractionLobby }
    TeleporterAfterTeamSelection<private> : teleporter_device = teleporter_device{}

    @editable:
        Categories := array{ InteractionLobby }
    LobbyTeleportinPLayersForPlayersJoied : creative_prop = creative_prop{}


        #WeaponSelection Area Devices
    @editable:
        Categories := array{WeaponSelectionArea}
    Team1TeleportertingProp1WeaponSelectionArea<private> : creative_prop = creative_prop{}

    @editable:
        Categories := array{WeaponSelectionArea}
    Team1TeleportertingProp2WeaponSelectionArea<private> : creative_prop = creative_prop{}

    @editable:
        Categories := array{WeaponSelectionArea}
    Team2TeleportertingProp1WeaponSelectionArea<private> : creative_prop = creative_prop{}

    @editable:
        Categories := array{WeaponSelectionArea}
    Team2TeleportertingProp2WeaponSelectionArea<private> : creative_prop = creative_prop{}

    var Team1TeleportertingPropsWeaponSelectionArea<private>: []creative_prop = array{}
    var Team2TeleportertingPropsWeaponSelectionArea<private> : []creative_prop = array{}


    GameStartsInString<private> : string = "Game Starts in: "
    var UpdatedTimeBeforeStart<private> : int = 0

    var IsTeam1Ready<private> : logic = false
    var IsTeam2Ready<private> : logic = false

    var Team1Players<public> : []player = array{}
    var Team2Players<public> : []player = array{}


    var bGameStarted<public>: logic = false
    var bHasStartingGameTimerStarted<private> : logic = false
    var bHasStartingGameTimerFinished<private> : logic = false

    var<private> CurrentGamePlayers<public> : []player = array{}

    var AssignedTeamsToPlayers<private> : event() = event(){}


    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        set UpdatedTimeBeforeStart = TimeBeforeGameStart

        Team1PlayerCounter.CountSucceedsEvent.Subscribe(OnPlayerCounterSucceedsTeam1)
        Team2PlayerCounter.CountSucceedsEvent.Subscribe(OnPlayerCounterSucceedsTeam2)

        SkyVolume.AgentEntersEvent.Subscribe(OnPlayerTouchesSkyVolume)

        Team1PlayerCounter.CountedEvent.Subscribe(OnPlayerSelectsTeam1)
        Team2PlayerCounter.CountedEvent.Subscribe(OnPlayerSelectsTeam2)

        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerLeaves)

        PlayerReferenceRankPropIcon1.Hide()
        PlayerReferenceRankPropIcon2.Hide()
        PlayerReferenceRankPropIcon3.Hide()
        PlayerReferenceRankPropIcon4.Hide()

        RoundSettingdDevice.EnableMatchmaking()

        PouplateArrays()

        Team1PlayerCounter.Disable()
        Team1PlayerCounter.Disable()

        for(Team1PlayerReference : Team1PlayerReferences):
            Team1PlayerReference.Disable()

        for(Team2PlayerReference : Team2PlayerReferences):
            Team2PlayerReference.Disable()


        AllPlayers := GetPlayspace().GetPlayers()
        for(Player : AllPlayers):
            RefillShieldAndChooseTeam(Player)
            SwitchPlayerToInitialTeam(Player)


        for(PlayerSpawner : StartingGamePlayerSpawners):
            PlayerSpawner.SpawnedEvent.Subscribe(SwitchPlayerToInitialTeam)


        Sleep(0.5)
            #This could be causing the unexpected team switch bug 
        Team1PlayerCounter.Enable()
        Team1PlayerCounter.Enable()

        
        for(Team1PlayerReference : Team1PlayerReferences):
            Team1PlayerReference.Enable()

        for(Team2PlayerReference : Team2PlayerReferences):
            Team2PlayerReference.Enable()


        for(Player : AllPlayers):
            ShowUIToPlayer(Player)

        Sleep(0.5)
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerJoinsWorld)

            #Async Functions
        spawn{ UpdateAndSyncTimeBeforeGame() }
        spawn{ HasGameStarted() }
        spawn{ AwaitGameStartClockToSFinish() }
        spawn{ TeleportPlayersToWeaponSelectionArea() } 



    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeEventMediator = DependencyInjector.GetEventMediator()
            set MaybePracticeArea = DependencyInjector.GetPracticeArea()
            set MaybeRoundStartManager = DependencyInjector.GetRoundStartManager()
            set MaybeJoinInProgressManager = DependencyInjector.GetJoinInProgressManager()
            set MaybeMainRankManager = DependencyInjector.GetMainRankManager()
        else:
            Print(
                "Dependency Injector not available",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )

            
    OnPlayerTouchesSkyVolume(Agent : agent): void =
        Print(
            "A PLAYER HAS TOUCHED THE SKY VOLUMEEEEEEEE",
            ?Duration := 9.0,
            ?Color := NamedColors.Purple
        )
        TeleporterAfterTeamSelection.Enable()
        TeleporterAfterTeamSelection.Teleport(Agent)



    SwitchPlayerToInitialTeam(Agent : agent): void = 
        StartingTeamSelectorDevice.ChangeTeamAndClass(Agent)
        WoodItemGranter.GrantItem(Agent)

        # CheckIfMoreThanOnePlayerIsInGame()


    AwaitGameStartClockToSFinish()<suspends>: void = 
        if:
            PracticeArea := MaybePracticeArea?
            GameManager := MaybeGameManager?
            EventMediator := MaybeEventMediator?
        then:

            EventMediator.OnGameStartClockFinished.Await()


            set bHasStartingGameTimerFinished = true

            RoundSettingdDevice.DisableMatchmaking()
            
            TeleporterAfterTeamSelection.Disable()
            CBTrigger.Trigger()
    
    
            StartingTeamSelectorDevice.Disable()
            BeaconTeam1.Disable()
            BeaconTeam2.Disable()
            SelectATeamTracker.RemoveFromAll()
            
    
            for(Spawner : StartingGamePlayerSpawners):
                Spawner.Disable()

            for(Team1PlayerReference : Team1PlayerReferences):
                Team1PlayerReference.Disable()
    
            for(Team2PlayerReference : Team1PlayerReferences):
                Team2PlayerReference.Disable()
    
            Team1PlayerCounter.Disable()
            Team2PlayerCounter.Disable()
    
    
            OtherLobbyPortalDevice.Disable()
    
            for(TeamSelectorCoverWall : TeamSelectorCoverWalls):
                TeamSelectorCoverWall.ShowProps()


            # LobbyToPracticeZoneTeleporter.Disable()
            # LobbyToPracticeZoneTeleporter.DeactivateLinkToTarget()

            PracticeArea.AllowAccessFromWeaponSelectionArea()

            AllPlayers := GetPlayspace().GetPlayers()

            for(Player : AllPlayers):
                    #Add all players to the CurrentGamePlayers Array
                AddPlayerToCurrentGamePlayers(Player)
                ChooseATeamDialog.Hide(Player)

            
            for(CurrentGamePlayer : CurrentGamePlayers):
                PracticeArea.AwardPracticeTime(CurrentGamePlayer)
                PracticeArea.ClearPlayerInventory(CurrentGamePlayer)
                # PracticeArea.RemoveNPCEliminationsTracker(CurrentGamePlayer)

                MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)
                if(PlayerData := MaybePlayerData?):
                    PlayerData.RePositionTeamSelectionUI()
                    PlayerData.HideGameStartClockUI()


            EventMediator.EmitFirstRoundStarted()
            Print("First Round Emited!!", ?Color := NamedColors.LightGreen, ?Duration := 7.0)

            Sleep(2.0)
                
            EventMediator.EmitFirstRoundStarted()
            Print("First Round Emited Againnn!!", ?Color := NamedColors.Yellow, ?Duration := 7.0)


        spawn{ AssignRandomTeamToUnassignedPlayers() }



    UpdateAndSyncTimeBeforeGame()<suspends>: void =
        loop:
            if(bHasStartingGameTimerFinished = true):
                break

            Sleep(1.0)
            set UpdatedTimeBeforeStart -= 1


    OnPlayerJoinsWorld(Agent : agent): void =
        if(Player := player[Agent]):
            RefillShieldAndChooseTeam(Player)

        if(bHasStartingGameTimerFinished = true):
            CurrentGameHUDMessage.Show(Agent)
            spawn{ TeleportPlayerToLobby(Agent) }
            if:
                JoinInProgressManager := MaybeJoinInProgressManager?
                RoundStartManager := MaybeRoundStartManager?
            then:
                JoinInProgressManager.TeamSelectionButtonMapIndicator.ActivateObjectivePulse(Agent)
                RoundStartManager.ShowUpdatedScoreboardUIToPlayer(Agent)
            return 

        else:
            spawn{ ShowUIToPlayer(Agent) }


    TeleportPlayerToLobby(Agent : agent)<suspends>: void=
        Print("Teleported Player to lobby after they joined the game")

        TransformLoc := LobbyTeleportinPLayersForPlayersJoied.GetTransform()
        TranslationLoc := TransformLoc.Translation

        DestinationLoc := vector3{ X:= TranslationLoc.X, Y:= TranslationLoc.Y, Z:= TranslationLoc.Z + 150.0 }

        Sleep(1.5)

        if:
            Player := player[Agent]
            FortCharacter := Player.GetFortCharacter[]
            FortCharacter.TeleportTo[DestinationLoc, IdentityRotation()]
        then:
            #Do nothing, the player was teleported to the lobby after joining the game


    ShowUIToPlayer(Agent : agent)<suspends>: void =
        Sleep(1.0)
        if:
            Player := player[Agent]
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Player)
            PlayerData := MaybePlayerData?

        then:
            PlayerData.ShowTeamSelectionUI()

            if(bHasStartingGameTimerStarted = true):
                PlayerData.ShowGameStartClockUI(UpdatedTimeBeforeStart,GameStartsInString)
                # SelectATeamTracker.Assign(Player)
                ChooseATeamDialog.Show(Player)

            else:
                PlayerData.ShowGameStartClockUI(TimeBeforeGameStart,GameStartsInString)
                set bHasStartingGameTimerStarted = true
                # SelectATeamTracker.Assign(Player)
                ChooseATeamDialog.Show(Player)


    PouplateArrays(): void = 
        set Team1PlayerReferences += array{ PlayerReference1Team1, PlayerReference2Team1 }
        set Team2PlayerReferences += array{ PlayerReference1Team2, PlayerReference2Team2 }


    OnPlayerLeaves(Agent : agent): void =
        if(Player := player[Agent]):
            RemovePlayerFromCurrentGamePlayers(Player)
            RemovePlayerFromTeam1Players(Player)
            RemovePlayerFromTeam2Players(Player)


    AddPlayerToCurrentGamePlayers<public>(Player : player): void =
        set CurrentGamePlayers += array{ Player }

    
    RemovePlayerFromCurrentGamePlayers<public>(Player : player): void =
        if:
            CurrentGamePlayer := CurrentGamePlayers.Find[Player],
            NewArray := CurrentGamePlayers.RemoveElement[CurrentGamePlayer]
        then:
            set CurrentGamePlayers = NewArray


    AddPlayerToTeam1Players<public>(Player : player): void =
        set Team1Players += array{ Player }


    AddPlayerToTeam2Players<public>(Player : player): void =
        set Team2Players += array{ Player }


    RemovePlayerFromTeam1Players<public>(Player : player): void =
        if:
            Team1Player := Team1Players.Find[Player],
            NewArray := Team1Players.RemoveElement[Team1Player]
        then:
            set Team1Players = NewArray


    RemovePlayerFromTeam2Players<public>(Player : player): void =
        if:
            Team1Player := Team2Players.Find[Player],
            NewArray := Team2Players.RemoveElement[Team1Player]
        then:
            set Team2Players = NewArray
            
    

    CheckIfMoreThanOnePlayerIsInGame(): void =
        AllPlayers := GetPlayspace().GetPlayers()
        if(AllPlayers.Length > 1):
            Print(
                "There is more than one player isnide of the game, timer for waiting for other players can now begin!!", 
                ?Duration := 5.0, 
                ?Color := NamedColors.Orange
            )
 

    TeleportPlayerToPracticeZone(Agent : agent): void = 
        if(PracticeArea := MaybePracticeArea?):
            PracticeArea.TeleportToPracticeZone(Agent)


    RefillShieldAndChooseTeam(Player : player): void =
        if(FortCharacter := Player.GetFortCharacter[]):
            Team1PlayerCounterBarrier.AddToIgnoreList(Player)
            Team2PlayerCounterBarrier.AddToIgnoreList(Player)
            FortCharacter.SetShield(100.0)


    AssignRandomTeamToUnassignedPlayers()<suspends> :void =
        AllPlayers := GetPlayspace().GetPlayers()

        TeamCollection := GetPlayspace().GetTeamCollection()
        TeamArray := TeamCollection.GetTeams()
    

        if(GameManager := MaybeGameManager?):
            if(Player1 := AllPlayers[0], MaybePlayerData1 := GameManager.GetMaybePlayerData(Player1), PlayerData1 := MaybePlayerData1?):
                if(PlayerData1.HasSelectedTeam= false):
                    SelectRandomTeam(Player1)
                    
                Sleep(0.5)

            if(Player2 := AllPlayers[1], MaybePlayerData2 := GameManager.GetMaybePlayerData(Player2), PlayerData2 := MaybePlayerData2?):
                if(PlayerData2.HasSelectedTeam = false):
                    SelectRandomTeam(Player2)
            
                Sleep(0.5)

            if(Player3 := AllPlayers[2], MaybePlayerData3 := GameManager.GetMaybePlayerData(Player3), PlayerData3 := MaybePlayerData3?):
                if(PlayerData3.HasSelectedTeam = false):
                    SelectRandomTeam(Player3)

                Sleep(0.5)

            if(Player4 := AllPlayers[3], MaybePlayerData4 := GameManager.GetMaybePlayerData(Player4), PlayerData4 := MaybePlayerData4?):
                if(PlayerData4.HasSelectedTeam = false):
                    SelectRandomTeam(Player4)

            AssignedTeamsToPlayers.Signal()



    SelectRandomTeam(Player : player): void =
        var RandomIndexTeam : ?int = false

        if(Team1Players.Length >= 2):
            set RandomIndexTeam = option{1} 
        else:
            set RandomIndexTeam = option{0}


        if(Index := RandomIndexTeam?, Index = 0, IsTeam1Ready = false):
            Team1PlayerCounter.Register(Player)
            Team1SelectorDevice.ChangeTeamAndClass(Player)

            AddPlayerToTeam1Players(Player)

            TeamCollection := GetPlayspace().GetTeamCollection()
            if:
                GameManager := MaybeGameManager?
                MaybePlayerData := GameManager.GetMaybePlayerData(Player)
                PlayerData := MaybePlayerData?
            
            then:
                if(AgentsTeam := TeamCollection.GetTeam[Player]):
                    TeamArray := TeamCollection.GetTeams()
                    for (TeamNumber->Team : TeamArray):
                        if (AgentsTeam = Team):
                            PlayerData.SetTeamNumber(TeamNumber)

                set PlayerData.HasSelectedTeam = true
                PlayerData.UpdateTeamSelectionUITeam1()                

            Team1PlayerCounterBarrier.RemoveFromIgnoreList(Player)
            Team2PlayerCounterBarrier.RemoveFromIgnoreList(Player)
            return

        else if(Index := RandomIndexTeam?, Index = 1, IsTeam2Ready = false):
            Team2PlayerCounter.Register(Player)
            Team2SelectorDevice.ChangeTeamAndClass(Player)

            AddPlayerToTeam2Players(Player)

            TeamCollection := GetPlayspace().GetTeamCollection()
            if:
                GameManager := MaybeGameManager?
                MaybePlayerData := GameManager.GetMaybePlayerData(Player)
                PlayerData := MaybePlayerData?
            
            then:
                if(AgentsTeam := TeamCollection.GetTeam[Player]):
                    TeamArray := TeamCollection.GetTeams()
                    for (TeamNumber->Team : TeamArray):
                        if (AgentsTeam = Team):
                            PlayerData.SetTeamNumber(TeamNumber)

                set PlayerData.HasSelectedTeam = true
                PlayerData.UpdateTeamSelectionUITeam2()
                
            Team1PlayerCounterBarrier.RemoveFromIgnoreList(Player)
            Team2PlayerCounterBarrier.RemoveFromIgnoreList(Player)
            return

        # else:
        #     Print(
        #         "Weent through this else because the random team choosen is already full??", 
        #         ?Duration := 5.0, 
        #         ?Color := NamedColors.Yellow
        #     )
        #     SelectRandomTeam(Player)


    OnPlayerCounterSucceedsTeam1(): void = 
        set IsTeam1Ready = true
        Team1PlayerCounter.Disable()
        BeaconTeam1.Disable()


    OnPlayerCounterSucceedsTeam2(): void = 
        set IsTeam2Ready = true
        Team2PlayerCounter.Disable()
        BeaconTeam2.Disable()


    OnPlayerSelectsTeam1(Agent : agent): void =
        if(Player := player[Agent]):
            AddPlayerToTeam1Players(Player)

        WoodItemGranter.GrantItem(Agent)
        SelectATeamTracker.Remove(Agent)

        Team1PlayerCounterBarrier.RemoveFromIgnoreList(Agent)
        Team2PlayerCounterBarrier.RemoveFromIgnoreList(Agent)

        AssignTeamInPlayerData(Agent)

        RandomInt := GetRandomInt(0, Team1PlayerReferences.Length - 1)

        if(RandomPlayerReference := Team1PlayerReferences[RandomInt]):
            RandomPlayerReference.Register(Agent)
            if(RandomInt = 0):
                ShowPlayerRankIcon(Agent, PlayerReferenceRankPropIcon1)
            if(RandomInt = 1):
                ShowPlayerRankIcon(Agent, PlayerReferenceRankPropIcon2)

            if(NewArray := Team1PlayerReferences.RemoveElement[RandomInt]):
                set Team1PlayerReferences = NewArray

        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)

            if(PlayerData := MaybePlayerData?):
                set PlayerData.HasSelectedTeam = true
                PlayerData.UpdateTeamSelectionUITeam1()

        TeleporterAfterTeamSelection.Teleport(Agent)


    OnPlayerSelectsTeam2(Agent : agent): void =
        if(Player := player[Agent]):
            AddPlayerToTeam2Players(Player)

        WoodItemGranter.GrantItem(Agent)
        SelectATeamTracker.Remove(Agent)

        Team1PlayerCounterBarrier.RemoveFromIgnoreList(Agent)
        Team2PlayerCounterBarrier.RemoveFromIgnoreList(Agent)

        AssignTeamInPlayerData(Agent)

        RandomInt := GetRandomInt(0, Team2PlayerReferences.Length - 1)

        if(RandomPlayerReference := Team2PlayerReferences[RandomInt]):
            RandomPlayerReference.Register(Agent)
            if(RandomInt = 0):
                ShowPlayerRankIcon(Agent, PlayerReferenceRankPropIcon3)
            if(RandomInt = 1):
                ShowPlayerRankIcon(Agent, PlayerReferenceRankPropIcon4)

            if(NewArray := Team2PlayerReferences.RemoveElement[RandomInt]):
                set Team2PlayerReferences = NewArray
        
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)

            if(PlayerData := MaybePlayerData?):
                set PlayerData.HasSelectedTeam = true
                PlayerData.UpdateTeamSelectionUITeam2()

        TeleporterAfterTeamSelection.Teleport(Agent)


    ShowPlayerRankIcon(Agent : agent, RankIconCreativeProp : creative_prop): void=
        if(GameManager := MaybeGameManager?, MainRankManager := MaybeMainRankManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            var MaybeRankMat : ?material = false

            if(PlayerData := MaybePlayerData?):
                CurrentPlayerRank := PlayerData.GetPlayerRank()

                case(CurrentPlayerRank):
                    0 =>
                        set MaybeRankMat = MainRankManager.UnrankedIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.Show()
                            RankIconCreativeProp.SetMaterial(RankMat)
                    1 =>
                        set MaybeRankMat = MainRankManager.BronzeIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.Show()
                            RankIconCreativeProp.SetMaterial(RankMat)
                    2 =>
                        set MaybeRankMat = MainRankManager.SilverIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.Show()
                            RankIconCreativeProp.SetMaterial(RankMat)
                    3 =>
                        set MaybeRankMat = MainRankManager.GoldIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.Show()
                            RankIconCreativeProp.SetMaterial(RankMat)
                    4 =>
                        set MaybeRankMat = MainRankManager.PlatinumIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.Show()
                            RankIconCreativeProp.SetMaterial(RankMat)
                    5 =>
                        set MaybeRankMat = MainRankManager.DiamondIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.Show()
                            RankIconCreativeProp.SetMaterial(RankMat)
                    _=>
                        Print(
                            "Rank Index passed in to set the PlayerReference RankIcon Image is invalid!", 
                            ?Duration := 8.0, 
                            ?Color := NamedColors.Red
                        )


    AssignTeamInPlayerData(Agent : agent): void =
        TeamCollection := GetPlayspace().GetTeamCollection()
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        
        then:
            if (AgentsTeam := TeamCollection.GetTeam[Agent]):
                TeamArray := TeamCollection.GetTeams()
                for (TeamNumber->Team : TeamArray):
                    if (AgentsTeam = Team):
                        PlayerData.SetTeamNumber(TeamNumber)
            
        # TeleporterDevice.Teleport(Agent)
        
    
    OnButtonPressed(Agent : agent): void =
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)

            if(PlayerData := MaybePlayerData?):
                # Print("Team number for player inside of his player data is: {PlayerData.TeamNumber}")

        TeamCollection := GetPlayspace().GetTeamCollection()

        if (AgentsTeam := TeamCollection.GetTeam[Agent]):
            TeamArray := TeamCollection.GetTeams()
            for (TeamNumber->Team : TeamArray):
                if (AgentsTeam = Team):
                    Print("{TeamNumber}")

    
    HasGameStarted()<suspends>: void =
        if(EventMediator := MaybeEventMediator?):
            EventMediator.OnRoundStarted.Await()
            
            set bGameStarted = true


    TeleportPlayersToWeaponSelectionArea()<suspends>: void =
        AssignedTeamsToPlayers.Await()

        #Might this change something?????
        set Team1TeleportertingPropsWeaponSelectionArea = array { Team1TeleportertingProp1WeaponSelectionArea, Team1TeleportertingProp2WeaponSelectionArea }
        set Team2TeleportertingPropsWeaponSelectionArea = array { Team2TeleportertingProp1WeaponSelectionArea, Team2TeleportertingProp2WeaponSelectionArea }

        if(GameManager := MaybeGameManager?):
            for(CurrentGamePlayer : CurrentGamePlayers):
                MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)
                if(PlayerData := MaybePlayerData?, FortCharacter := CurrentGamePlayer.GetFortCharacter[]):
                    PlayerTeamNumber := PlayerData.GetTeamNumber()
                    
                    if(PlayerTeamNumber = 0):
                        RandomIndex := GetRandomInt(0, Team1TeleportertingPropsWeaponSelectionArea.Length -1)
                        if(TeleportingProp := Team1TeleportertingPropsWeaponSelectionArea[RandomIndex], NewArray := Team1TeleportertingPropsWeaponSelectionArea.RemoveElement[RandomIndex]):
                            set Team1TeleportertingPropsWeaponSelectionArea = NewArray
                            DestinationTrans := TeleportingProp.GetTransform()
                            DestinationLoc := DestinationTrans.Translation

                            DestinationProp := vector3{ X:= DestinationLoc.X, Y:= DestinationLoc.Y, Z:= DestinationLoc.Z + 150.0 }

                            if(FortCharacter.TeleportTo[DestinationProp, DestinationTrans.Rotation]){}

                            else:
                                Print(
                                    "Failed To Teleport player to weapon Selection Area!", 
                                    ?Duration := 10.0, 
                                    ?Color := NamedColors.Red
                                )


                    if(PlayerTeamNumber = 1):
                        RandomIndex := GetRandomInt(0, Team2TeleportertingPropsWeaponSelectionArea.Length -1)
                        if(TeleportingProp := Team2TeleportertingPropsWeaponSelectionArea[RandomIndex], NewArray := Team2TeleportertingPropsWeaponSelectionArea.RemoveElement[RandomIndex]):
                            set Team2TeleportertingPropsWeaponSelectionArea = NewArray
                            DestinationTrans := TeleportingProp.GetTransform()
                            DestinationLoc := DestinationTrans.Translation

                            DestinationProp := vector3{ X:= DestinationLoc.X, Y:= DestinationLoc.Y, Z:= DestinationLoc.Z + 150.0 }

                            if(FortCharacter.TeleportTo[DestinationProp, DestinationTrans.Rotation]){}
                            
                            else:
                                Print(
                                    "Failed To Teleport player to weapon Selection Area!!", 
                                    ?Duration := 10.0, 
                                    ?Color := NamedColors.Red
                                )


            

        




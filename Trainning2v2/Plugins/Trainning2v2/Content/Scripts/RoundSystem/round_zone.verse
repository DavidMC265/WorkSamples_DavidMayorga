using { /Fortnite.com }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/FortPlayerUtilities }
using { /Fortnite.com/Game }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { Lobby }
using { MainScripts }

DependecyInjector_RoundZone<localizes>:message = "Dependency Injector"
ConfigurationDevices_RoundZone<localizes>:message = "Configuration Devices"
Team1Devices_RoundZone<localizes>:message = "Team 1 Teleporting Props"
Team2Devices_RoundZone<localizes>:message = "Team 2 Teleporting Props"
PlayerSpawnersAndTriggers_RoundZone<localizes>: message = "Player Spawners And Triggers"
NPCSpawners_RoundZone<localizes>: message = "NPCs Spawners"


round_zone := class(creative_device):

    @editable       Identifier<public> : int = 0

        #DependencyInjector
    @editable:
        Categories:= array{ DependecyInjector_RoundZone }
    var MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeGameManagerRoundZone<private>: ?game_manager = false
    var MaybeInventoryManager<private>: ?inventory_manager = false
    var MaybeRoundStartManager<private> : ?round_start_manager = false
    var MaybeEventMediator<private> : ?event_mediator = false
    var MaybeMainRankManager<private> : ?main_rank_manager = false
    var MaybePregameLobby<private> : ?pregame_lobby = false
    var MaybeHatGranter<private> : ?hat_rank_granter = false
    var MaybeQuestManager<private>: ?quest_manager = false


    @editable:
        Categories := array{ ConfigurationDevices_RoundZone }
    StormDevice<private> : basic_storm_controller_device = basic_storm_controller_device{}

    @editable:
        Categories := array{ ConfigurationDevices_RoundZone }
    StartingStormDevice<private> : basic_storm_controller_device = basic_storm_controller_device{}

    @editable:
        Categories := array{ ConfigurationDevices_RoundZone }
    DownButNotOutDevice<private> : down_but_not_out_device = down_but_not_out_device{}

    @editable:
        Categories := array{ ConfigurationDevices_RoundZone }
    MutatorZone<private> : mutator_zone_device = mutator_zone_device{}

    @editable:
        Categories := array{ ConfigurationDevices_RoundZone }
    RoundBarrier<private> : barrier_device = barrier_device{}

    @editable:
        Categories := array{ Team1Devices_RoundZone }
    Team1TeleportingProp1<private> : creative_prop = creative_prop{}

    @editable:
        Categories := array{ Team1Devices_RoundZone }
    Team1TeleportingProp2<private> : creative_prop = creative_prop{}

    var Team1TeleportertingProps<private> : []creative_prop = array{}

    @editable:
        Categories := array{ Team2Devices_RoundZone }
    Team2TeleportingProp1<private> : creative_prop = creative_prop{}

    @editable:
        Categories := array{ Team2Devices_RoundZone }
    Team2TeleportingProp2<private> : creative_prop = creative_prop{}

    var Team2TeleportertingProps<private> : []creative_prop = array{}

    #Player spawners and Triggers
    @editable:
        Categories := array{ PlayerSpawnersAndTriggers_RoundZone }
    Team1PlayerSpawners<private> : []player_spawner_device = array{}

    @editable:
        Categories := array{ PlayerSpawnersAndTriggers_RoundZone }
    Team2PlayerSpawners<private> : []player_spawner_device = array{}

    @editable:
        Categories := array{ PlayerSpawnersAndTriggers_RoundZone }
    Trigger_Team1PlayerSpawner1<private> : trigger_device = trigger_device{}

    @editable:
        Categories := array{ PlayerSpawnersAndTriggers_RoundZone }
    Trigger_Team1PlayerSpawner2<private> : trigger_device = trigger_device{}

    @editable:
        Categories := array{ PlayerSpawnersAndTriggers_RoundZone }
    Trigger_Team2PlayerSpawner1<private> : trigger_device = trigger_device{}

    @editable:
        Categories := array{ PlayerSpawnersAndTriggers_RoundZone }
    Trigger_Team2PlayerSpawner2<private> : trigger_device = trigger_device{}

    @editable:
        Categories := array{ PlayerSpawnersAndTriggers_RoundZone }
    Barriers_Team1PlayerSpawners<private> : []barrier_device = array{}

    @editable:
        Categories := array{ PlayerSpawnersAndTriggers_RoundZone }
    Barriers_Team2PlayerSpawners<private>: []barrier_device = array{}

    #NPC Spawners
    @editable:
        Categories := array{NPCSpawners_RoundZone}
    Team1NPCSpawners<private> : []npc_spawner_device = array{}

    @editable:
        Categories := array{NPCSpawners_RoundZone}
    Team2NPCSpawners<private> : []npc_spawner_device = array{}

    EmptyMaybeAgent<private> : ?agent = false #Used to Despawn all the NPCs at the end of the round

    var Team1Agents<private> : []agent = array{}
    var Team2Agents<private> : []agent = array{}

    Message1<localizes> (Agent : agent): message = "{Agent}"


    var AgentsWhoDamagedThisAgent<private> : [agent][]agent = map{}
    PlayerNameMessage<localizes><private> (Agent : agent): message = "{Agent}"


    var PlayerEliminatedChangeSubscription<private>: [agent]?cancelable = map{ }
    var PlayerAssistsSubscription<private>: [agent]?cancelable = map{ }

    var bTeam1Win<private> : logic = false
    var bTeam2Win<private> : logic = false


    OnBegin<override>()<suspends>:void=     
        SetupDependencies()   
        PopulateArrays()

        for(Team1PlayerSpawner : Team1PlayerSpawners):
            Team1PlayerSpawner.SpawnedEvent.Subscribe(OnPlayerSpawnsInRoundZoneSpawnPad)

        for(Team2PlayerSpawner : Team2PlayerSpawners):
            Team2PlayerSpawner.SpawnedEvent.Subscribe(OnPlayerSpawnsInRoundZoneSpawnPad)

        for(Barriers_Team1PlayerSpawner : Barriers_Team1PlayerSpawners):
            Barriers_Team1PlayerSpawner.Disable()

        for(Barriers_Team2PlayerSpawner : Barriers_Team2PlayerSpawners):
            Barriers_Team2PlayerSpawner.Disable()

        for(Team1NPCSpawner : Team1NPCSpawners):
            Team1NPCSpawner.SpawnedEvent.Subscribe(AssignToTeam1NPC)
            Team1NPCSpawner.EliminatedEvent.Subscribe(ONNPCEliminated)

        for(Team2NPCSpawner : Team2NPCSpawners):
            Team2NPCSpawner.SpawnedEvent.Subscribe(AssignToTeam2NPC)
            Team2NPCSpawner.EliminatedEvent.Subscribe(ONNPCEliminated)


        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerLeaves)


    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeRoundStartManager = DependencyInjector.GetRoundStartManager()
            set MaybeEventMediator = DependencyInjector.GetEventMediator()
            set MaybeMainRankManager = DependencyInjector.GetMainRankManager()
            set MaybeInventoryManager = DependencyInjector.GetInventoryManager()
            set MaybePregameLobby = DependencyInjector.GetPreGameLobby()
            set MaybeHatGranter = DependencyInjector.GetHatGranter()
            set MaybeQuestManager = DependencyInjector.GetQuestManager()
        else:
            Print(
                "Dependency Injector not available from Round Start manager",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )


    OnPlayerSpawnsInRoundZoneSpawnPad(Agent : agent): void =
        if(Player := player[Agent], FortCharacter := Player.GetFortCharacter[]):
            FortCharacter.SetShield(100.0)
    

    OnPlayerLeaves(Agent : agent): void =
        if:
            RoundStartManager := MaybeRoundStartManager?
            GameManager := MaybeGameManagerRoundZone?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            if:
                CurrentRoundZoneDevice := RoundStartManager.CurrentZoneDevice?
                CurrentRoundZoneDevice.Identifier = Identifier
            then:
                PlayerTeamNumber := PlayerData.GetTeamNumber()
                CheckPlayerTeamAndRemove(PlayerTeamNumber, Agent)

            
    PopulateArrays(): void = 
        set Team1TeleportertingProps = array { }
        set Team2TeleportertingProps = array { }

        set Team1TeleportertingProps = array { Team1TeleportingProp1, Team1TeleportingProp2 }
        set Team2TeleportertingProps = array { Team2TeleportingProp1, Team2TeleportingProp2 }

        for(Team1PlayerSpawner : Team1PlayerSpawners):
            Team1PlayerSpawner.Disable()

        for(Team2PlayerSpawner : Team2PlayerSpawners):
            Team2PlayerSpawner.Disable()


    TelportPlayersToZone(MaybeGameManager : ?game_manager, RoundBeginTimer : timer_device): void =  
        StartingStormDevice.GenerateStorm()

        for(Team1PlayerSpawner : Team1PlayerSpawners):
            Team1PlayerSpawner.Enable()

        for(Team2PlayerSpawner : Team2PlayerSpawners):
            Team2PlayerSpawner.Enable()

        set MaybeGameManagerRoundZone = MaybeGameManager

        # Print(
        #     "Round Zone selected is {Identifier}", 
        #     ?Duration := 8.0, 
        #     ?Color := NamedColors.Yellow
        # )

        if(GameManager := MaybeGameManagerRoundZone?, PregameLobby := MaybePregameLobby?):
            for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)
                AgentPlayer : agent = CurrentGamePlayer

                if(PlayerData := MaybePlayerData?):
                    PlayerData.HideTeamSelectionUI()
                    PlayerTeamNumber := PlayerData.GetTeamNumber()

                    if(PlayerTeamNumber = 0):
                        set Team1Agents += array{ AgentPlayer }

                    if(PlayerTeamNumber = 1):
                        set Team2Agents += array{ AgentPlayer }
                    
                    else if (PlayerTeamNumber <> 0 and PlayerTeamNumber <> 1):
                        Print(
                            "Player Team number is out of bounds it has to be either 0 or 1!", 
                            ?Duration:= 5.0, 
                            ?Color := NamedColors.Red
                        )

                    spawn{ FillEmptyTeamsSpots() }


                    #Print(
                        #"Team 1 total Players are: {Team1Players.Length}",
                        #?Duration := 10.0,
                        #?Color := NamedColors.Pink
                    #)

                    #Print(
                        #"Team 2 total Players are: {Team2Players.Length}",
                        #?Duration := 10.0,
                        #?Color := NamedColors.Pink
                    #)


            AssignTeleportingLocations()
            spawn { DelayBeforeRoundCountdown(RoundBeginTimer) }


    FillEmptyTeamsSpots()<suspends>: void =
        Sleep(0.5)
    
        if(Team1Agents.Length = 0):
            # Print(
            #     "About to Spawn 2 NPCs of team 1!",
            #     ?Duration := 10.0,
            #     ?Color := NamedColors.Yellow
            # )
            for(Team1NPCSpawner : Team1NPCSpawners):
                Team1NPCSpawner.Spawn()
                #Print(
                    #"Team 1 NPC Spawneddd",
                    #?Duration := 10.0,
                    #?Color := NamedColors.Yellow
                #)

        if(Team1Agents.Length = 1):
            # Print(
            #     "About to Spawn 2 NPCs of team 1!",
            #     ?Duration := 10.0,
            #     ?Color := NamedColors.Yellow
            # )
            if(Team1NPCSpawner := Team1NPCSpawners[0]):   
                Team1NPCSpawner.Spawn()
                # Print(
                #     "Team 1 NPC Spawneddd",
                #     ?Duration := 10.0,
                #     ?Color := NamedColors.Yellow
                # )

        if(Team2Agents.Length = 0):
            # Print(
            #     "About to Spawn 2 NPCs of team 2!",
            #     ?Duration := 10.0,
            #     ?Color := NamedColors.Yellow
            # )
            for(Team2NPCSpawner : Team2NPCSpawners):
                Team2NPCSpawner.Spawn()
                # Print(
                #     "Team 2 NPC Spawneddd",
                #     ?Duration := 10.0,
                #     ?Color := NamedColors.Yellow
                # )

        if(Team2Agents.Length = 1):
            # Print(
            #     "About to Spawn 2 NPCs of team 2!",
            #     ?Duration := 10.0,
            #     ?Color := NamedColors.Yellow
            # )
            if(Team2NPCSpawner := Team2NPCSpawners[0]):   
                Team2NPCSpawner.Spawn()
                # Print(
                #     "Team 2 NPC Spawneddd",
                #     ?Duration := 10.0,
                #     ?Color := NamedColors.Yellow
                # )

    AssignToTeam1NPC(NPCAgent : agent): void =
        set Team1Agents += array{ NPCAgent }

        # Print(
        #     "New length of Team1 Agents is {Team1Agents.Length}",
        #     ?Duration := 10.0,
        #     ?Color := NamedColors.Yellow
        # )

    AssignToTeam2NPC(NPCAgent : agent): void =
        set Team2Agents += array{ NPCAgent }

        # Print(
        #     "New length of Team2 Agents is {Team2Agents.Length}",
        #     ?Duration := 10.0,
        #     ?Color := NamedColors.Yellow
        # )



    DelayBeforeRoundCountdown(RoundBeginTimer : timer_device)<suspends>: void =
        Sleep(5.0)
        BeginRoundCountdown(RoundBeginTimer)


    AssignTeleportingLocations(): void=
        if(Agent1Team1 := Team1Agents[0], TeleportingPropPlayer1Team1 := Team1TeleportertingProps[0]):
            spawn{ TeleportPlayer(Agent1Team1, TeleportingPropPlayer1Team1, Trigger_Team1PlayerSpawner1) }

        if(Agent2Team1 := Team1Agents[1],TeleportingPropPlayer2Team1 := Team1TeleportertingProps[1]):
             spawn { TeleportPlayer(Agent2Team1, TeleportingPropPlayer2Team1, Trigger_Team1PlayerSpawner2) }

        if(Agent1Team2 := Team2Agents[0], TeleportingPropPlayer1Team2 := Team2TeleportertingProps[0]):
            spawn { TeleportPlayer(Agent1Team2, TeleportingPropPlayer1Team2, Trigger_Team2PlayerSpawner1) }

        if(Agent2Team2 := Team2Agents[1], TeleportingPropPlayer2Team2 := Team2TeleportertingProps[1]):
            spawn { TeleportPlayer(Agent2Team2, TeleportingPropPlayer2Team2, Trigger_Team2PlayerSpawner2) }
        

    TeleportPlayer(PlayerAgent : agent, TeamTeleporteringProp : creative_prop, TriggerPlayerSpawner : trigger_device)<suspends>: void =
        TransformLoc := TeamTeleporteringProp.GetTransform()
        TranslationLoc := TransformLoc.Translation

        DestinationLoc := vector3{ X:= TranslationLoc.X, Y:= TranslationLoc.Y, Z:= TranslationLoc.Z + 150.0 }

        if:
            FortCharacter := PlayerAgent.GetFortCharacter[], 
            FortCharacter.TeleportTo[DestinationLoc, TransformLoc.Rotation]
            #Agent := FortCharacter.GetAgent[]

        then:
            if(InventoryManager := MaybeInventoryManager?, hatGranter:= MaybeHatGranter?):
                spawn{ InventoryManager.GrantLoadoutOnRoundStart(PlayerAgent) }
                hatGranter.GrantHat(PlayerAgent)
            else:
                Print(
                    "Inventory manager not valid", 
                    ?Duration:= 5.0, 
                    ?Color := NamedColors.Red
                    )
    
        else:
            PlayerAgent.Respawn(DestinationLoc, TransformLoc.Rotation)

            Sleep(1.5)
            TriggerPlayerSpawner.Trigger(PlayerAgent)
            Sleep(1.5)

            if (hatGranter:= MaybeHatGranter?):
                hatGranter.GrantHat(PlayerAgent)


            if(InventoryManager := MaybeInventoryManager?):
                spawn{ InventoryManager.GrantLoadoutOnRoundStart(PlayerAgent) }
            else:
                Print(
                    "Inventory manager not valid", 
                    ?Duration:= 5.0, 
                    ?Color := NamedColors.Red
                    )

        if(FortCharacter := PlayerAgent.GetFortCharacter[]):
            FortCharacter.ReleaseFromStasis()
            FortCharacter.SetShield(100.0)
            FortCharacter.SetHealth(100.0)


    BeginRoundCountdown(RoundBeginTimer : timer_device): void=
        if:
            RoundStartManager := MaybeRoundStartManager?,
            PregmaeLobby := MaybePregameLobby?
            GameManager := MaybeGameManagerRoundZone?
        then:
            spawn { BeginRound() }
            spawn { RoundStartManager.PlayRoundCountdownSoundCues() }

            for(CurrentGamePlayer : PregmaeLobby.CurrentGamePlayers):
                MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)
                if(PlayerData := MaybePlayerData?):
                    PlayerData.ShowRoundStartCountdownUI()


    BeginRound()<suspends>: void =
        if(EventMediator := MaybeEventMediator?):
            EventMediator.OnRoundStartTimerCountdownCompleted.Await()

            StartingStormDevice.DestroyStorm()
            StormDevice.GenerateStorm()

            MutatorZone.Disable()

            for(Team1TeleportertingProp : Team1TeleportertingProps):
                Team1TeleportertingProp.Hide()

            for(Team2TeleportertingProp : Team2TeleportertingProps):
                Team2TeleportertingProp.Hide()

            for(Barrier_Team1PlayerSpawners : Barriers_Team1PlayerSpawners):
                Barrier_Team1PlayerSpawners.Disable()

            for(Barrier_Team2PlayerSpawners : Barriers_Team2PlayerSpawners):
                Barrier_Team2PlayerSpawners.Disable()
        

            RoundBarrier.Disable()

            if(PregameLobby := MaybePregameLobby?):
                for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                    if(FortCharacter := CurrentGamePlayer.GetFortCharacter[]):
                        FortCharacter.ReleaseFromStasis()

                    SubscribePlayerToEliminatedSubscription(CurrentGamePlayer)

            spawn{ SignalRoundTimerStarted() }



    SubscribePlayerToEliminatedSubscription<public>(Agent : agent): void =
        if(ExistingInformation := PlayerEliminatedChangeSubscription[Agent]?){}
        if(ExistingAsInformation := PlayerAssistsSubscription[Agent]?){}


        if(FortCharacter := Agent.GetFortCharacter[]):

            Temp: cancelable = FortCharacter.EliminatedEvent().Subscribe(OnPlayerEliminated)
            if(set PlayerEliminatedChangeSubscription[Agent] = option{ Temp }){}
            else:
                Print(
                    "Falieddddddddd hereeeeee", 
                    ?Duration:= 7.0, 
                    ?Color := NamedColors.Red
                )


            if(set AgentsWhoDamagedThisAgent[Agent] = array {}){}
            else:
                Print(
                    "Falieddddddddd hereeeeee", 
                    ?Duration:= 7.0, 
                    ?Color := NamedColors.Red
                )

            TempAs : cancelable = FortCharacter.DamagedEvent().Subscribe(HandlePlayerHit)
            if(set PlayerAssistsSubscription[Agent] = option{ TempAs }){}

            else:
                Print(
                    "Coulnt se the PlayerAssistsSubscription[Agent]  map to the variable", 
                    ?Duration:= 7.0, 
                    ?Color := NamedColors.Red
                )


    SignalRoundTimerStarted()<suspends>: void =
        Sleep(5.0) #Wait 5 seconds before sending signal to check if there are only two or less players inside of the game
        
        if(EventMediator := MaybeEventMediator?):
            EventMediator.EmitOnRoundTimerStartCompleted()

        for(Team1PlayerSpawner : Team1PlayerSpawners):
            Team1PlayerSpawner.Disable()

        for(Team2PlayerSpawner : Team2PlayerSpawners):
            Team2PlayerSpawner.Disable()


    ONNPCEliminated(Result : device_ai_interaction_result): void =
        ResultTarget := Result.Target
        ResultSource := Result.Source

        if(NPCAgent := ResultTarget?):
            if:
                Team1NPCAgent := Team1Agents.Find[NPCAgent]
                NewArray := Team1Agents.RemoveElement[Team1NPCAgent]
            then:
                set Team1Agents = NewArray
                #Print("Team1Agents array updated!!")
                if(Team1Agents.Length = 0):
                    OnTeam2Wins()
                    spawn { OnRoundEnds() }

            if:
                Team2NPCAgent := Team2Agents.Find[NPCAgent]
                NewArray := Team2Agents.RemoveElement[Team2NPCAgent]
            then:
                set Team2Agents = NewArray
                #Print("Team2Agents array updated!!")
                if(Team2Agents.Length = 0):
                    OnTeam1Wins()
                    spawn { OnRoundEnds() }

        if(AgentEliminator := ResultSource?):
            HandlePlayerElimination(AgentEliminator)

            

    OnPlayerEliminated(Result : elimination_result): void =
        Eliminator := Result.EliminatingCharacter
        Eliminated := Result.EliminatedCharacter

        if(GameManager := MaybeGameManagerRoundZone?, RoundStartManager := MaybeRoundStartManager?):
            if:
                EliminatedAgent := Eliminated.GetAgent[]
            then:
                    #Eliminated Player
                MaybePlayeEliminatedData := GameManager.GetMaybePlayerData(EliminatedAgent)
                if:
                    PlayerDataEliminated := MaybePlayeEliminatedData?, 
                    EventMediator := MaybeEventMediator?
                then:
                    PlayerDataEliminated.SetPlayerDeaths(1)
                    PlayerDataEliminated.SaveDataForPlayer()

                    EventMediator.EmitAgentEvent(EventMediator.OnDeathXP, EliminatedAgent)

                    CurrentGameKillstreak := PlayerDataEliminated.GetCurrentGameKillstreak()
                    HighestKillstreak := PlayerDataEliminated.GetCurrentGameHighestKillstreak()

                    if(CurrentGameKillstreak > HighestKillstreak):
                        PlayerDataEliminated.UpdateCurrentGameHighestKillstreak(CurrentGameKillstreak)

                    PlayerDataEliminated.ResetCurrentGameKillstreak()
                    SetAuraVFX(EliminatedAgent)

                    
                    PlayerTeamNumber := PlayerDataEliminated.GetTeamNumber()

                    CheckPlayerTeamAndRemove(PlayerTeamNumber, EliminatedAgent)


                #Eliminator Player
            if:
                FCEliminatingCharacter := Result.EliminatingCharacter?
                EliminatorAgent := FCEliminatingCharacter.GetAgent[]
                EliminatedAgent := Eliminated.GetAgent[]
                EliminatorAgent <> EliminatedAgent ###NEED TO VERIFYYYY
            then:
                MaybePlayeEliminatorData := GameManager.GetMaybePlayerData(EliminatorAgent)
                MaybePlayeEliminatedData := GameManager.GetMaybePlayerData(EliminatedAgent)

                if:
                    PlayerDataEliminator := MaybePlayeEliminatorData?, 
                    PlayerDataEliminated := MaybePlayeEliminatedData?
                then:
                    HandlePlayerElimination(EliminatorAgent)

                    TeamIndexPlayerEliminated := PlayerDataEliminated.GetTeamNumber()
                    GrantAssistToOtherPlayers(EliminatedAgent, EliminatorAgent, TeamIndexPlayerEliminated)


    HandlePlayerElimination(Agent : agent): void=
        if:
            GameManager := MaybeGameManagerRoundZone?
            MainRankManager := MaybeMainRankManager?
            EventMediator := MaybeEventMediator?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
            QuestManager := MaybeQuestManager?
        then:
            PlayerData.SetPlayerKills(1)
            PlayerData.SetPlayerPrestige(5)
            PlayerData.SetCurrentGameEliminations(1)
            MainRankManager.CalculatePlayerRank(Agent)
            PlayerData.SaveDataForPlayer()

            EventMediator.EmitAgentEvent(EventMediator.OnKillXP, Agent)

            #Check if player Current Quest requires Player Eliminations
            CurrentPlayerQuest := PlayerData.GetCurrentQuest()
            if(CurrentPlayerQuest = EQuests.HatEliminations and PlayerData.hasHat = true):
                QuestManager.IncrementValueHatQuest(Agent)

            PlayerData.SetCurrentGameKillstreak(1)

            CurrentGameKillstreak := PlayerData.GetCurrentGameKillstreak()
            HighestKillstreak := PlayerData.GetCurrentGameHighestKillstreak()

            if(CurrentGameKillstreak > HighestKillstreak):
                PlayerData.UpdateCurrentGameHighestKillstreak(CurrentGameKillstreak)

            SetAuraVFX(Agent)


    GrantAssistToOtherPlayers(EliminatedAgent : agent, EliminatorAgent : agent, TeamIndexPlayerEliminated : int): void =
        if:
            CurrentArrayOfPlayers := AgentsWhoDamagedThisAgent[EliminatedAgent]
            EliminatorAgentIndex := AgentsWhoDamagedThisAgent[EliminatedAgent].Find[EliminatorAgent]
            GameManager := MaybeGameManagerRoundZone?
        then:
            if:
                NewArray := CurrentArrayOfPlayers.RemoveElement[EliminatorAgentIndex]
                set AgentsWhoDamagedThisAgent[EliminatedAgent] = NewArray
            then:
                if:
                    UpdatedArrayOfPlayers := AgentsWhoDamagedThisAgent[EliminatedAgent]
                then:
                    for(AssistingPlayer : UpdatedArrayOfPlayers):
                        MaybePlayerData := GameManager.GetMaybePlayerData(AssistingPlayer)
                        if:
                            PlayerData := MaybePlayerData?
                            AssistingPlayerCurrentTeamNumber := PlayerData.GetTeamNumber()
                            AssistingPlayerCurrentTeamNumber <> TeamIndexPlayerEliminated
                        then:
                            PlayerData.SetPlayerAssists(1)
                            PlayerData.SetCurrentGameAssists(1)
                            Print(PlayerNameMessage(AssistingPlayer))


        
    CheckPlayerTeamAndRemove(PlayerTeamNumber : int, Agent : agent): void =
        if(PlayerTeamNumber = 0):
            if(Player := Team1Agents.Find[Agent], NewArray := Team1Agents.RemoveElement[Player]):
                set Team1Agents = NewArray
                if(Team1Agents.Length = 0):
                    OnTeam2Wins()
                    spawn { OnRoundEnds() }

        else if(PlayerTeamNumber = 1):
            if(Player := Team2Agents.Find[Agent], NewArray := Team2Agents.RemoveElement[Player]):
                set Team2Agents = NewArray
                if(Team2Agents.Length = 0):
                    OnTeam1Wins()
                    spawn{ OnRoundEnds() }



    HandlePlayerHit(DamageResult : damage_result): void = 
        Target := DamageResult.Target
        if: 
            GameManager := MaybeGameManagerRoundZone?
            TargetFortCharacter := fort_character[Target]
            TargetAgent := TargetFortCharacter.GetAgent[]
            MaybePlayerDamagedData := GameManager.GetMaybePlayerData(TargetAgent)
            PlayerDamagedData := MaybePlayerDamagedData?
            Instigator := DamageResult.Instigator?
            InstigatorAgent := Instigator.GetInstigatorAgent[]
            MaybePlayerInstigatorData := GameManager.GetMaybePlayerData(InstigatorAgent)
            PlayerInstigatorData := MaybePlayerDamagedData?
            TargetAgent <> InstigatorAgent
        then:
            if(CurrentArrayOfPlayers := AgentsWhoDamagedThisAgent[TargetAgent]):

                if(AgentsWhoDamagedThisAgent[TargetAgent].Find[InstigatorAgent]):
                    return

                else:
                    if(set AgentsWhoDamagedThisAgent[TargetAgent] += array{InstigatorAgent}){}


            
    SetAuraVFX(Agent : agent):void=
        if:
            GameManager := MaybeGameManagerRoundZone?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?

        then:
            CurrentGameKillstreak := PlayerData.GetCurrentGameKillstreak()
            #Select corresponding auras on killstreaks
            SelectAuraVFX(Agent, CurrentGameKillstreak, 3, PlayerData.BlueVFX, PlayerData.BlueAuraMessage)
            SelectAuraVFX(Agent, CurrentGameKillstreak, 6, PlayerData.RedVFX, PlayerData.RedAuraMessage)
            SelectAuraVFX(Agent, CurrentGameKillstreak, 9, PlayerData.GoldenVFX, PlayerData.GoldenAuraMessage)
            SelectAuraVFX(Agent, CurrentGameKillstreak, 12, PlayerData.DarkVFX, PlayerData.DarkAuraMessage)


    SelectAuraVFX(Agent : agent, CurrentGameKillstreak: int, Killstreak : int, MaybeAuraVFX : ?visual_effect_powerup_device, MaybeMessage : ?hud_message_device):void=
        if:
            CurrentGameKillstreak = Killstreak
            AuraVFX := MaybeAuraVFX?
            Message := MaybeMessage?
        then:
            AuraVFX.Pickup(Agent)
            Message.Show(Agent)


        CheckIfPlayerHasKillstreakQuest(Agent, CurrentGameKillstreak)


    CheckIfPlayerHasKillstreakQuest(Agent : agent , CurrentGameKillstreak: int): void =
            #Check if player has the Wild Spray Quest Assigned
        if:
            GameManager := MaybeGameManagerRoundZone?
            QuestManager := MaybeQuestManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            CurrentPlayerQuest := PlayerData.GetCurrentQuest()
            if(CurrentGameKillstreak = 3 and CurrentPlayerQuest = EQuests.ReachWildSpray):
                QuestManager.IncrementValueReachWildSprayQuest(Agent)


    OnTeam1Wins(): void =
        AwardTeamWinningPlayers(1)
        set bTeam1Win = true

        if(RoundStartManager := MaybeRoundStartManager?):
            RoundStartManager.UpdateTeam1ScoreAfterWin()


    OnTeam2Wins(): void =
        AwardTeamWinningPlayers(2)
        set bTeam2Win = true

        if(RoundStartManager := MaybeRoundStartManager?):
            RoundStartManager.UpdateTeam2ScoreAfterWin()



    # Set prestige to winner team
    AwardTeamWinningPlayers(WinningTeam : int):void=
        if:
            PregameLobby := MaybePregameLobby?
            GameManager := MaybeGameManagerRoundZone?
            RoundStartManager := MaybeRoundStartManager?
            EventMediator := MaybeEventMediator?
            MainRankManager := MaybeMainRankManager?
        then:
            if(WinningTeam = 1):
                for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                    if:
                        MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)
                        PlayerData := MaybePlayerData?
                        TeamNumber := PlayerData.TeamNumber
                        TeamNumber = 0
                    then:
                        PlayerData.SetPlayerPrestige(10)
                        MainRankManager.CalculatePlayerRank(CurrentGamePlayer)
                        PlayerData.SaveDataForPlayer()
                        EventMediator.EmitAgentEvent(EventMediator.OnRoundWinXP, CurrentGamePlayer)

            if(WinningTeam = 2):
                for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                    if:
                        MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)
                        PlayerData := MaybePlayerData?
                        TeamNumber := PlayerData.TeamNumber
                        TeamNumber = 1
                    then:
                        PlayerData.SetPlayerPrestige(10)
                        MainRankManager.CalculatePlayerRank(CurrentGamePlayer)
                        PlayerData.SaveDataForPlayer()
                        EventMediator.EmitAgentEvent(EventMediator.OnRoundWinXP, CurrentGamePlayer)

            else if(WinningTeam <> 1 and WinningTeam <> 2):
                Print(
                    "Team Players number to Award after team win is not 1 or 2 so its invalid from round_zone!!", 
                    ?Duration := 15.0, 
                    ?Color := NamedColors.Red
                )


    OnRoundEnds()<suspends>: void =
        if(CancelZoneEventSubscriptions[]){}
        else:
            Print(
                "FAILED TO CANCEL SUBSCRIPTIONS FROM ROUND_ZONE IN THE FUNCTION OnRoundEnds()!!!", 
                ?Duration := 15.0, 
                ?Color := NamedColors.Red
            )

        Sleep(2.0)

        ShowRoundEndingUIToPlayers()

        for(Team1NPCSpawner : Team1NPCSpawners):
            Team1NPCSpawner.DespawnAll(EmptyMaybeAgent)

        for(Team2NPCSpawner : Team2NPCSpawners):
            Team2NPCSpawner.DespawnAll(EmptyMaybeAgent)

        DestoyZoneStorm()
        MutatorZone.Enable()

        if(PregameLobby := MaybePregameLobby?, GameManager := MaybeGameManagerRoundZone?, QuestManager := MaybeQuestManager?):
            for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                DownButNotOutDevice.Revive(CurrentGamePlayer)
                    
                if(FortCharacter := CurrentGamePlayer.GetFortCharacter[]):
                    FortCharacter.PutInStasis( stasis_args{ AllowEmotes := true, AllowFalling := true } )

                MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)
                if(PlayerData := MaybePlayerData?):
                    CurrentPlayerQuest := PlayerData.GetCurrentQuest()
                    if(CurrentPlayerQuest = EQuests.CompleteRounds):
                        QuestManager.IncrementValueCompleteRoundsQuest(CurrentGamePlayer)


        StartingStormDevice.GenerateStorm()

        Sleep(2.0) #This will be the round win UI animation duration before the next round timer wins 

        StartingStormDevice.DestroyStorm()

        if(RoundStartManager := MaybeRoundStartManager?):
    
            RoundStartManager.PickNextRoundZone()

        else:
            Print(
                "Round Start Manager is not valid from round zone!!", 
                ?Duration := 10.0, 
                ?Color := NamedColors.Red
            )


    CancelZoneEventSubscriptions()<decides><transacts>: void =
        # TimerSubscription := ControlChangeSubscriptionTimer?
        # TimerSubscription.Cancel()

        PregameLobby := MaybePregameLobby?

        for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
            Subscription := PlayerEliminatedChangeSubscription[CurrentGamePlayer]?
            Subscription.Cancel()

            SubscriptionAs := PlayerAssistsSubscription[CurrentGamePlayer]?
            SubscriptionAs.Cancel()

            set PlayerEliminatedChangeSubscription[CurrentGamePlayer] = false
            set PlayerAssistsSubscription[CurrentGamePlayer] = false


    ShowRoundEndingUIToPlayers(): void =
        if:
            GameManager := MaybeGameManagerRoundZone?
            PregameLobby := MaybePregameLobby?
            RoundStartManager := MaybeRoundStartManager?
            EventMediator := MaybeEventMediator?

        then:
            if(bTeam1Win = true):
                for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                    MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)
                    if(PlayerData := MaybePlayerData?):
                        PlayerTeamNumber := PlayerData.GetTeamNumber()
                        if(PlayerTeamNumber = 1):
                            RoundStartManager.RoundLossHUDMessage.Show(CurrentGamePlayer)
                            EventMediator.EmitAgentEvent(EventMediator.OnRoundLoseXP, CurrentGamePlayer)
                        else if(PlayerTeamNumber = 0):
                            RoundStartManager.RoundWinHUDMessage.Show(CurrentGamePlayer)
        

            else if(bTeam2Win = true):
                for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                    MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)
                    if(PlayerData := MaybePlayerData?):
                        PlayerTeamNumber := PlayerData.GetTeamNumber()
                        if(PlayerTeamNumber = 0):
                            RoundStartManager.RoundLossHUDMessage.Show(CurrentGamePlayer)
                            EventMediator.EmitAgentEvent(EventMediator.OnRoundLoseXP, CurrentGamePlayer)
                        else if(PlayerTeamNumber = 1):
                            RoundStartManager.RoundWinHUDMessage.Show(CurrentGamePlayer)


    DestoyZoneStorm(): void =
        StormDevice.DestroyStorm()








            











    


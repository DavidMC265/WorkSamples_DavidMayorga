using { MainScripts }
using { /Fortnite.com }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }

PracticeArea_Devices<localizes>:message = "Devices" 
PracticeArea_DependecyInjector<localizes>:message = "Dependency Injector"
PracticeArea_Accolades<localizes>:message = "Accolades"
PracticeArea_UI<localizes>:message = "UI"
PracticeArea_NPCs<localizes>:message = "NPCs"


practice_area<public> := class(creative_device):
    
        #Dependency Injector
    @editable: 
        Categories := array{ PracticeArea_DependecyInjector }
    var MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeGameManager<private>: ?game_manager = false
    var MaybeEventMediator<private> : ?event_mediator = false
    var MaybePreGameLobby<private> : ?pregame_lobby = false
    var MaybeQuestManager<private>: ?quest_manager = false

        #Teleporters / Teleporting Props
    @editable:
        Categories := array{ PracticeArea_Devices }
    PracticeZoneTeleporter<private> : teleporter_device = teleporter_device{}

    @editable:
        Categories := array{ PracticeArea_Devices }
    LobbyZoneTeleporter<private> : teleporter_device = teleporter_device{}

    @editable:
        Categories := array{ PracticeArea_Devices }
    LobbyTeleportingProp<private> : creative_prop = creative_prop{}

    @editable:
        Categories := array{ PracticeArea_Devices }
    WeaponSelectionZoneTeleporter<private> : teleporter_device = teleporter_device{}

    @editable:
        Categories := array{ PracticeArea_Devices }
    PracticeZoneFromWeaponSelectionTeleporter<private>: teleporter_device = teleporter_device{}

        #Explosive Devices
    @editable:
        Categories := array{ PracticeArea_Devices } 
    Explosives<private> : []explosive_device = array{}

        #Mutator Zones
    @editable:
        Categories := array{ PracticeArea_Devices }
    PracticeRiflesMutatorZone<private> : mutator_zone_device = mutator_zone_device{}

    @editable:
        Categories := array{ PracticeArea_Devices }
    PracticeFullAreaMutatorZone<private> : mutator_zone_device = mutator_zone_device{}

        #Waepon Zone Pickups
    @editable:
        Categories := array{ PracticeArea_Devices }
    PracticeAreaWeaponsRemover<private> : item_remover_device = item_remover_device{}

        #NPCs
    @editable:
        Categories := array{ PracticeArea_NPCs }
    NPCSpawners<private> : []guard_spawner_device = array{}

        #XP / Awards
    @editable:
        Categories := array{ PracticeArea_Accolades }
    var PracticeTimer<private> : float = 0.0


    var PlayerTimerMap<private> : [agent]float = map{}
    var PlayerBreakTimer<private> : [agent]logic = map{}
    

    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        GetPlayspace().PlayerAddedEvent().Subscribe(AddPlayer)
        PracticeZoneTeleporter.TeleportedEvent.Subscribe(OnPLayerEntersZone)
        # LobbyZoneTeleporter.TeleportedEvent.Subscribe(OnPlayerLeavesPracticeZone)
        PracticeZoneTeleporter.EnterEvent.Subscribe(AwardPracticeTime)

        for(NPCSpawner : NPCSpawners):
            NPCSpawner.EliminatedEvent.Subscribe(ONNPCEliminated)

        
        PracticeZoneTeleporter.Enable()
        PracticeRiflesMutatorZone.Disable()
        LobbyTeleportingProp.Hide()
        # WeaponSelectionZoneTeleporter.Disable()
        PracticeZoneFromWeaponSelectionTeleporter.Disable()


            #Get All the players and Initiate their XP Award time in zone map values
        AllPlayers := GetPlayspace().GetPlayers()
        for(Player :AllPlayers):
            AddPlayer(Player)

            #Get the First Player and pass as Explosives Instigator for constructions
        # if(Player := AllPlayers[0]):
        #     spawn{ ClearPlayersConstruction(Player) }


    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeEventMediator = DependencyInjector.GetEventMediator()
            set MaybePreGameLobby = DependencyInjector.GetPreGameLobby()
            set MaybeQuestManager = DependencyInjector.GetQuestManager()
        else:
            Print(
                "Dependency Injector not available",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )

    AddPlayer<private>(Agent:agent):void=
        if(set PlayerTimerMap[Agent] = 0.0){}
        if(set PlayerBreakTimer[Agent] = false){}
                          

    AllowAccessFromWeaponSelectionArea(): void =
        # WeaponSelectionZoneTeleporter.Enable()
        PracticeZoneFromWeaponSelectionTeleporter.Enable()


    DisableAccessFromWeaponSelectionArea(): void =
        WeaponSelectionZoneTeleporter.Disable()


    TeleportToPracticeZone(Agent : agent): void =
        PracticeZoneTeleporter.Teleport(Agent)
        

    AwardPracticeTime(Agent : agent): void =
        if(Value := PlayerBreakTimer[Agent], Value = false):
            if(set PlayerBreakTimer[Agent] = true){}
            
            # Award the player if they have practiced for practice timer duration
        if(EventMediator := MaybeEventMediator?, PlayerTimerMap[Agent] >= PracticeTimer):
            EventMediator.EmitAgentEvent(EventMediator.OnPracticeXP, Agent)

           
    InitTimer(Agent : agent)<suspends>: void=
            # Check if the player has already started the timer
        if(PlayerBreakTimer[Agent] = true){return}

        loop:
            
            if(Value := PlayerBreakTimer[Agent], Value = true):
                if(set PlayerBreakTimer[Agent] = false){}

                if(set PlayerTimerMap[Agent] = 0.0):
                    break

            Sleep(1.0)
            if(set PlayerTimerMap[Agent] += 1.0):
                
            if(PlayerTime := PlayerTimerMap[Agent]){}


    OnPLayerEntersZone(Agent : agent): void =
        if(Player := player[Agent]):
            spawn{ InitTimer(Agent) }


    ONNPCEliminated(Result : device_ai_interaction_result): void =
        if(SourceAgent := Result.Source?):
            if(Player := player[SourceAgent]):
                    #Check the current player quest requires NPC Eliminations
                if(GameManager := MaybeGameManager?, QuestManager := MaybeQuestManager?):
                    MaybePlayerData := GameManager.GetMaybePlayerData(Player)
                    if(PlayerData := MaybePlayerData?):
                        CurrentPlayerQuest := PlayerData.GetCurrentQuest()
                        if(CurrentPlayerQuest = EQuests.NPCEliminations):
                            QuestManager.IncrementValueNPCsQuest(Player)
                            Print("Calling IncrementValueNPCsQuest from practice area!!")
                


    ClearPlayerInventory(Agent : agent): void =
        PracticeAreaWeaponsRemover.Remove(Agent)



using { /Fortnite.com }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }



EQuests<public>:= enum<persistable>{ None, NPCEliminations , CompleteRounds, RifleEliminations, HatEliminations, ReachWildSpray, Top3Standings}


(Quest : EQuests).GetQuestName<public>(): string =
    case (Quest):
        EQuests.None => "None"
        EQuests.NPCEliminations => "NPC Eliminations"
        EQuests.CompleteRounds => "Complete Rounds"
        EQuests.RifleEliminations=> "Rifle Eliminations"
        EQuests.HatEliminations => "Hat Eliminations"
        EQuests.ReachWildSpray=> "Wild Spray"
        EQuests.Top3Standings => "Top 3 Standings"


Quest_DependecyInjector<localizes>:message = "Dependency Injector"
Quest_Devices<localizes>:message = "Devices"
Quest_Config<localizes>:message = "Configuration" 
Quest_1<localizes>:message = "Quest 1"
Quest_2<localizes>:message = "Quest 2"
Quest_3<localizes>:message = "Quest 3"
Quest_4<localizes>:message = "Quest 4"
Quest_5<localizes>:message = "Quest 5"
Quest_6<localizes>:message = "Quest 6"
Quest_Accolades<localizes>:message = "Accolades"
Quest_UI<localizes>:message = "UI"


quest_manager<public> := class(creative_device):    

        #Dependency Injector
    @editable: 
        Categories := array{ Quest_DependecyInjector }
    var MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeGameManager<private>: ?game_manager = false
    var MaybeEventMediator<private> : ?event_mediator = false

    @editable_slider(float):
        Categories := array{ Quest_Config },
        MinValue := option{ 2.0 },
        MaxValue := option{ 5.0}
    TimeBeforeNextQuestTrackerShows<private> : float = 2.0

        #Devices
    @editable:
        Categories := array{ Quest_Devices }
    QuestsAnaliticsDevice<private> : analytics_device = analytics_device{}

    @editable:
        Categories := array{ Quest_Devices }
    CompleteAllQuestsAccolade<private>: accolades_device = accolades_device{}

        #Quest 1
    @editable:
        Categories := array{ Quest_1 }
    NPCEliminationsTracker<private> : tracker_device = tracker_device{}
    
    @editable:
        Categories := array{ Quest_1 }
    NPCsEliminatedQuestAccolade<private> : accolades_device = accolades_device{}

    @editable_slider(int):
        Categories := array{ Quest_1 }
        MinValue := option{ 5 }
        MaxValue := option{ 10 }
    NPCEliminationsRequired<private> : int = 10

    #Quest 2
    @editable:
        Categories := array{ Quest_2 }
    CompleteRoundsTracker<private> : tracker_device = tracker_device{}
    
    @editable:
        Categories := array{ Quest_2 }
    CompleteRoundsQuestAccolade<private> : accolades_device = accolades_device{}

    @editable_slider(int):
        Categories := array{ Quest_2 }
        MinValue := option{ 3 }
        MaxValue := option{ 8 }
    RoundsToComplete<private> : int = 5

        #Quest 3
    @editable:
        Categories := array{ Quest_3 }
    RifleEliminationsTracker<private> : tracker_device = tracker_device{}
    
    @editable:
        Categories := array{ Quest_3 }
    RifleEliminatedQuestAccolade<private> : accolades_device = accolades_device{}

    @editable_slider(int):
        Categories := array{ Quest_3 }
        MinValue := option{ 5 }
        MaxValue := option{ 10 }
    RifleEliminationsRequired<private> : int = 5

        #Quest 4
    @editable:
        Categories := array{ Quest_4 }
    HatEliminationsTracker<private> : tracker_device = tracker_device{}
    
    @editable:
        Categories := array{ Quest_4 }
    HatEliminatedQuestAccolade<private> : accolades_device = accolades_device{}

    @editable_slider(int):
        Categories := array{ Quest_4 }
        MinValue := option{ 3 }
        MaxValue := option{ 5 }
    HatEliminationsRequired<private> : int = 3

        #Quest 5
    @editable:
        Categories := array{ Quest_5 }
    ReachWildSprayTracker<private> : tracker_device = tracker_device{}
    
    @editable:
        Categories := array{ Quest_5 }
    ReachWildSprayQuestAccolade<private> : accolades_device = accolades_device{}

    @editable_slider(int):
        Categories := array{ Quest_5 }
        MinValue := option{ 1 }
        MaxValue := option{ 2 }
    WilsSprayKillstreakReachedRequired<private> : int = 1

    #Quest 6
    @editable:
        Categories := array{ Quest_6 }
    Top3StandingsTracker<private> : tracker_device = tracker_device{}
    
    @editable:
        Categories := array{ Quest_6 }
    Top3StandingsQuestAccolade<private> : accolades_device = accolades_device{}

    @editable_slider(int):
        Categories := array{ Quest_6 }
        MinValue := option{ 1 }
        MaxValue := option{ 2 }
    Top3StandingsRequired<private> : int = 1


    var StartingGamePlayers<private> : []player = array{}


    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        NPCEliminationsTracker.CompleteEvent.Subscribe(OnNPCsEliminationsTrackerCompleted)
        NPCEliminationsTracker.SetTarget(NPCEliminationsRequired)
        
        CompleteRoundsTracker.CompleteEvent.Subscribe(OnCompleteRoundsTrackerCompleted)
        CompleteRoundsTracker.SetTarget(RoundsToComplete)

        RifleEliminationsTracker.CompleteEvent.Subscribe(OnRifleEliminationsTrackerCompleted)
        RifleEliminationsTracker.SetTarget(RifleEliminationsRequired)

        HatEliminationsTracker.CompleteEvent.Subscribe(OnHatEliminationsTrackerCompleted)
        HatEliminationsTracker.SetTarget(HatEliminationsRequired)

        ReachWildSprayTracker.CompleteEvent.Subscribe(OnReachWildSprayTrackerCompleted)
        ReachWildSprayTracker.SetTarget(WilsSprayKillstreakReachedRequired)

        Top3StandingsTracker.CompleteEvent.Subscribe(OnTop3StandingsTrackerCompleted)
        Top3StandingsTracker.SetTarget(Top3StandingsRequired)


        Sleep(1.0)
        AllPlayers := GetPlayspace().GetPlayers()
        for(Player : AllPlayers):
            set StartingGamePlayers += array{ Player }
            AssignCurrentQuestPlayer(Player)

        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerJoinsGame)
 

    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeEventMediator = DependencyInjector.GetEventMediator()
        else:
            Print(
                "Dependency Injector not available",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )


    OnPlayerJoinsGame(Agent : agent): void =
        if(Player := player[Agent]):
            if(StartingGamePlayer := StartingGamePlayers.Find[Player]):
                return
            AssignCurrentQuestPlayer(Player)


    AssignCurrentQuestPlayer(Player : player): void =
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Player)
            if(PlayerData := MaybePlayerData?):
                CurrentPlayerQuest := PlayerData.GetCurrentQuest()
                Print("Current Player Quest is : {CurrentPlayerQuest.GetQuestName()}")

                if(CurrentPlayerQuest = EQuests.None):
                    AssignNextQuestToPlayer(Player)
                    AssignQuestNPCs(Player)
                    return
                    

                case (CurrentPlayerQuest):
                    EQuests.NPCEliminations => AssignQuestNPCs(Player)

                    EQuests.CompleteRounds => AssignCompleteRoundsQuest(Player)

                    EQuests.RifleEliminations => AssignRifleEliminationsQuest(Player)

                    EQuests.HatEliminations => AssignHatQuest(Player)

                    EQuests.ReachWildSpray => AssignWReachildSprayQuest(Player)

                    EQuests.Top3Standings => AssignTop3StandingsQuestQuest(Player)

                    _=> 
                        Print(
                            "Current Player quest is invalid", 
                            ?Duration := 7.0, 
                            ?Color := NamedColors.Red
                        )
            

    AssignNextQuestToPlayer(Player : player): void =
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Player)
            if(PlayerData := MaybePlayerData?):
                CurrentPlayerQuest := PlayerData.GetCurrentQuest()

                case (CurrentPlayerQuest):
                    EQuests.None =>
                        PlayerData.SetCurrentQuest(EQuests.NPCEliminations)
                        #PlayerData.SetCurrentQuest(EQuests.CompleteRounds)
                        AssignCurrentQuestPlayer(Player)

                    EQuests.NPCEliminations =>
                        PlayerData.SetCurrentQuest(EQuests.CompleteRounds)
                        AssignCurrentQuestPlayer(Player)

                    EQuests.CompleteRounds =>
                        PlayerData.SetCurrentQuest(EQuests.RifleEliminations)
                        AssignCurrentQuestPlayer(Player)

                    EQuests.RifleEliminations =>
                        PlayerData.SetCurrentQuest(EQuests.HatEliminations)
                        AssignCurrentQuestPlayer(Player)

                    EQuests.HatEliminations =>
                        PlayerData.SetCurrentQuest(EQuests.ReachWildSpray)
                        AssignCurrentQuestPlayer(Player)

                    EQuests.ReachWildSpray =>
                        PlayerData.SetCurrentQuest(EQuests.Top3Standings)
                        AssignCurrentQuestPlayer(Player)
                    
                    EQuests.Top3Standings =>
                        CompleteAllQuestsAccolade.Award(Player)
            


    StartNextQuestTimer(Player : player)<suspends>: void =
        Sleep(TimeBeforeNextQuestTrackerShows)

        AssignNextQuestToPlayer(Player)


        #Quest 1
    AssignQuestNPCs(Player : player): void =
        NPCEliminationsTracker.Load(Player)
        NPCEliminationsTracker.Assign(Player)

        spawn{ RemoveNPCsQuestTrackerOnGameStart(Player ) }


    RemoveNPCsQuestTrackerOnGameStart(Player : player)<suspends>: void =
        if(EventMediator := MaybeEventMediator?):
            EventMediator.OnRoundIsReadyToStart.Await()

            NPCEliminationsTracker.Remove(Player)


    IncrementValueNPCsQuest<public>(Player : player): void =
        NPCEliminationsTracker.Increment(Player)
        Print("Incremented NPC Quest value for the player")


    OnNPCsEliminationsTrackerCompleted(Agent : agent): void =
        NPCsEliminatedQuestAccolade.Award(Agent)
        QuestsAnaliticsDevice.Submit(Agent)

        if(Player := player[Agent]):
            spawn{ StartNextQuestTimer(Player) }


            #Quest 2
    AssignCompleteRoundsQuest(Player : player): void =
        CompleteRoundsTracker.Load(Player)
        CompleteRoundsTracker.Assign(Player)


    IncrementValueCompleteRoundsQuest<public>(Agent : agent): void =
        CompleteRoundsTracker.Increment(Agent)


    OnCompleteRoundsTrackerCompleted(Agent : agent): void =
        CompleteRoundsQuestAccolade.Award(Agent)
        QuestsAnaliticsDevice.Submit(Agent)

        if(Player := player[Agent]):
            spawn{ StartNextQuestTimer(Player) }


            #Quest 3 
    AssignRifleEliminationsQuest(Player : player): void =
        RifleEliminationsTracker.Load(Player)
        RifleEliminationsTracker.Assign(Player)


    IncrementValueRifleEliminationsQuest<public>(Agent : agent): void =
        RifleEliminationsTracker.Increment(Agent)


    OnRifleEliminationsTrackerCompleted(Agent : agent): void =
        RifleEliminatedQuestAccolade.Award(Agent)
        QuestsAnaliticsDevice.Submit(Agent)

        if(Player := player[Agent]):
            spawn{ StartNextQuestTimer(Player) }


        #Quest 4
    AssignHatQuest(Player : player): void =
        HatEliminationsTracker.Load(Player)
        HatEliminationsTracker.Assign(Player)


    IncrementValueHatQuest<public>(Agent : agent): void =
        HatEliminationsTracker.Increment(Agent)


    OnHatEliminationsTrackerCompleted(Agent : agent): void =
        HatEliminatedQuestAccolade.Award(Agent)
        QuestsAnaliticsDevice.Submit(Agent)

        if(Player := player[Agent]):
            spawn{ StartNextQuestTimer(Player) }


        #Quest 5
    AssignWReachildSprayQuest(Player : player): void =
        ReachWildSprayTracker.Load(Player)
        ReachWildSprayTracker.Assign(Player)


    IncrementValueReachWildSprayQuest<public>(Agent : agent): void =
        ReachWildSprayTracker.Increment(Agent)


    OnReachWildSprayTrackerCompleted(Agent : agent): void =
        ReachWildSprayQuestAccolade.Award(Agent)
        QuestsAnaliticsDevice.Submit(Agent)

        if(Player := player[Agent]):
            spawn{ StartNextQuestTimer(Player) }


        #Quest 6
    AssignTop3StandingsQuestQuest(Player : player): void =
        Top3StandingsTracker.Load(Player)
        Top3StandingsTracker.Assign(Player)


    IncrementValueTop3StandingsQuest<public>(Agent : agent): void =
        Top3StandingsTracker.Increment(Agent)


    OnTop3StandingsTrackerCompleted(Agent : agent): void =
        Top3StandingsQuestAccolade.Award(Agent)
        QuestsAnaliticsDevice.Submit(Agent)

        if(Player := player[Agent]):
            spawn{ StartNextQuestTimer(Player) }



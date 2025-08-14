using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using {/Verse.org/Colors}
using { MainScripts}


accolade_granter := class(creative_device):

    @editable
    MaybeDependencyInjector : ?dependency_injector = false

    @editable:
    PracticeReward: accolades_device = accolades_device{}
    
    @editable:
    KillReward: accolades_device = accolades_device{}

    @editable:
    DeathReward: accolades_device = accolades_device{}

    @editable:
    RankUpReward: accolades_device = accolades_device{}
    
    @editable:
    RoundWinReward: accolades_device = accolades_device{}

    @editable:
    RoundLoseReward: accolades_device = accolades_device{}

    @editable:
    MatchWonReward: accolades_device = accolades_device{}

    @editable:
    MatchLoseReward: accolades_device = accolades_device{}

    @editable:
    PlaytimeReward: accolades_device = accolades_device{}

    var MaybeEventMediator : ?event_mediator = false


    OnBegin<override>()<suspends>:void=
        SetupDependencies()
        spawn{HandleKillXP()}
        spawn{HandleDeathXP()}
        spawn{HandleRankXP()}
        spawn{HandleRoundWinXP()}
        spawn{HandleRoundLoseXP()}
        spawn{HandlePracticeXP()}
        spawn{HandleMatchWonXP()}
        spawn{HandleMatchLoseXP()}
        # spawn{HandlePlaytimeXP()}

    HandleKillXP()<suspends>:void=
        if(EventMediator := MaybeEventMediator?):
            loop:
                Sleep(0.0)
                Agent:agent = EventMediator.OnKillXP.Await()
                KillReward.Award(Agent)

    HandleDeathXP()<suspends>:void=
        if(EventMediator := MaybeEventMediator?):
            loop:
                Sleep(0.0)
                Agent:agent = EventMediator.OnDeathXP.Await()
                DeathReward.Award(Agent)

    HandleRankXP()<suspends>:void=
        if(EventMediator := MaybeEventMediator?):
            loop:
                Sleep(0.0)
                Agent:agent = EventMediator.OnRankUpXP.Await()
                RankUpReward.Award(Agent)

    HandleRoundWinXP()<suspends>:void=
        if(EventMediator := MaybeEventMediator?):
            loop:
                Sleep(0.0)
                Agent:agent = EventMediator.OnRoundWinXP.Await()
                RoundWinReward.Award(Agent)

    HandleRoundLoseXP()<suspends>:void=
        if(EventMediator := MaybeEventMediator?):
            loop:
                Sleep(0.0)
                Agent:agent = EventMediator.OnRoundLoseXP.Await()
                RoundLoseReward.Award(Agent)

    HandlePracticeXP()<suspends>:void=
        if(EventMediator := MaybeEventMediator?):
            loop:
                Sleep(0.0)
                Agent:agent = EventMediator.OnPracticeXP.Await()
                PracticeReward.Award(Agent)

    HandleMatchWonXP()<suspends>:void=
        if(EventMediator := MaybeEventMediator?):
            loop:
                Sleep(0.0)
                Agent:agent = EventMediator.OnWonMatchXP.Await()
                RoundLoseReward.Award(Agent)

    HandleMatchLoseXP()<suspends>:void=
        if(EventMediator := MaybeEventMediator?):
            loop:
                Sleep(0.0)
                Agent:agent = EventMediator.OnLoseMatchXP.Await()
                RoundLoseReward.Award(Agent)

    # HandlePlaytimeXP()<suspends>:void=
    #         loop:
    #             Sleep(300.0)
    #             for(Agent:GetPlayspace().GetPlayers()):
    #                 PlaytimeReward.Award(Agent)
                
    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeEventMediator = DependencyInjector.GetEventMediator()
        else:
            Print(
                "Dependency Injector not available",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )
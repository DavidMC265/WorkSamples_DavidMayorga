using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { MainScripts }

spectating_chair_tag<public> := class(tag):

spectatingchair_xp := class(creative_device):

        #Dependencies
    @editable:
        Categories := array{ Bounty_Hunting_DependecyInjector }
    var MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeGameManager<private> : ?game_manager = false


    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        TaggedItems := FindCreativeObjectsWithTag(spectating_chair_tag{})
        for:
            TaggedItem : TaggedItems
            ChairDevice := chair_device[TaggedItem]
        do:
            ChairDevice.SeatedEvent.Subscribe(OnAgentSitsOnChair)
            ChairDevice.ExitedEvent.Subscribe(OnAgentExitsChair)
            #Print("Chair Subscribed")


    SetupDependencies():void = 
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
        else:
            Print(
                "Dependency Injector not available from bounty_hunting script",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )


    OnAgentSitsOnChair(Agent : agent): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            PlayerData.ShowChairSpectatorUI()


    OnAgentExitsChair(Agent : agent): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            PlayerData.HideChairSpectatorUI()
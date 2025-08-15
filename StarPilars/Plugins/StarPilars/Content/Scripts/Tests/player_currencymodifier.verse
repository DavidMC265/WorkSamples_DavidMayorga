using { /Fortnite.com }
using { /Fortnite.com/Devices }
using { Lib }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { MainScripts }


collectible_credits_tag := class(tag){}

Dependencies_CurerncyModifier<localizes>:message = "Dependency Injector"
Config_CurerncyModifier<localizes>:message = "Config"
Awards_CurrencyModifier<localizes>:message = "Awards"
Devices_CurerncyModifier<localizes>:message = "Devices"

player_currencymodifier<public> := class(creative_device):

        # Dependencies
    @editable:
        Categories := array{ Dependencies_CurerncyModifier }
    MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeGameManager<private> : ?game_manager = false
    var MaybeAccoladeManager<private>: ?accolade_manager = false

        # Configuration
    @editable:
        Categories := array{ Config_CurerncyModifier }
    CurrencyBackgroundImgColorOP<public> : ?color = false

    @editable:
        Categories := array{ Config_CurerncyModifier }
    MinPickupCurrencyAmount<private>: float = 5.0

    @editable:
        Categories := array{ Config_CurerncyModifier }
    MaxPickupCurrencyAmount<private>: float = 20.0

    @editable_slider(float):
        Categories := array{ Config_CurerncyModifier }
        MinValue := option{ 5.0 }
        MaxValue := option{ 15.0}
    PickupRespawningTime<private>: float = 10.0

    @editable:
        Categories := array{ Config_CurerncyModifier }
    var Yaw : float = 180.0

    @editable:
        Categories := array{ Config_CurerncyModifier }
    var Speed : float = 3.0

        #Awards
    @editable:
        Categories := array{ Awards_CurrencyModifier }
    MinEliminationCurrencyAmount<private>: float = 30.0

    @editable:
        Categories := array{ Awards_CurrencyModifier }
    MaxEliminationCurrencyAmount<private>: float = 50.0

    @editable:
        Categories := array{ Awards_CurrencyModifier }
    MinGameWonCurrencyAmount<private>: float = 50.0

    @editable:
        Categories := array{ Awards_CurrencyModifier }
    MaxGameWonCurrencyAmount<private>: float = 70.0

        #Devices
    @editable:
        Categories := array{ Devices_CurerncyModifier }
    IncrementCurrencyButtons<private> : []button_device = array{}

    @editable:
        Categories := array{ Devices_CurerncyModifier }
    IncrementCurrencyAmount<private> : float = 0.0

    @editable:
        Categories := array{ Devices_CurerncyModifier }
    DecrementCurrencyButton<private> : button_device = button_device{}

    @editable:
        Categories := array{ Devices_CurerncyModifier }
    DecrementCurrencyAmount<private> : float = 0.0


    IncrementCurrencyAmountMessage<private><localizes>(Value : float): message = " Increment Currency by: {Value}"
    DecrementCurrencyAmountMessage<private><localizes>(Value : float): message = " Decrement Currency by: {Value}"



    OnBegin<override>()<suspends>:void=
        SetupDependencies()
        for(IncrementCurrencyButton : IncrementCurrencyButtons):
            IncrementCurrencyButton.SetInteractionText( IncrementCurrencyAmountMessage(IncrementCurrencyAmount) )
            IncrementCurrencyButton.InteractedWithEvent.Subscribe(OnIncrementCurrencyButtonPressed)

        DecrementCurrencyButton.SetInteractionText( DecrementCurrencyAmountMessage(DecrementCurrencyAmount) )

        DecrementCurrencyButton.InteractedWithEvent.Subscribe(OnDecrementCurrencyButtonPressed)

        Sleep(1.5)
        AllPlayers := GetPlayspace().GetPlayers()
        for(Player : AllPlayers):
            ShowUIToPlayer(Player)

        GetPlayspace().PlayerAddedEvent().Subscribe(ShowUIToPlayer)


        TaggedItems := FindCreativeObjectsWithTag(collectible_credits_tag{})
        for:
            TaggedItem : TaggedItems
            CollectibleObject := collectible_object_device[TaggedItem]
        do:
            CollectibleObject.CollectedEvent.SubscribeAgent(OnPlayerCollectsCreditsPickup, CollectibleObject)


    SetupDependencies(): void =
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeAccoladeManager = DependencyInjector.GetAccoladeManager()
        else:
            Print(
                "Dependency Injector is invalid from player_currencymodifier", 
                ?Color := NamedColors.Red, 
                ?Duration := 7.0
            )

    ShowUIToPlayer(Player : player): void =
        spawn { ShowPlayerCurrency(Player) } 


    ShowPlayerCurrency(Player : player)<suspends>: void =
        Sleep(2.0)
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Player)
            PlayerData := MaybePlayerData?
            CurrencyBackgroundImgColor := CurrencyBackgroundImgColorOP?
        then:
            PlayerData.ShowPlayerCurrencyUI(CurrencyBackgroundImgColor)

    
    OnIncrementCurrencyButtonPressed(Agent : agent): void =
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            if(PlayerData := MaybePlayerData?):
                PlayerData.IncrementCurrency(IncrementCurrencyAmount)


    OnDecrementCurrencyButtonPressed(Agent : agent): void =
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            if(PlayerData := MaybePlayerData?):
                PlayerData.DecrementCurrency(DecrementCurrencyAmount)


    OnPlayerCollectsCreditsPickup(Agent : agent, CollectibleObject : collectible_object_device): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
            AccoladeManager := MaybeAccoladeManager?
            RandomCurrencyAmount := GetRandomFloat(MinPickupCurrencyAmount, MaxPickupCurrencyAmount)
        then:
            PlayerData.IncrementCurrency(RandomCurrencyAmount)
            AccoladeManager.GrantCurrencyPickupAccolade(Agent)
            spawn { RespawnCollectibleObject(CollectibleObject) }


    RespawnCollectibleObject(CollectibleObject : collectible_object_device)<suspends>: void =
        Sleep(PickupRespawningTime)
        CollectibleObject.RespawnForAll()

    
    AwardAgentElimination<public>(AgentToAward : agent): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(AgentToAward)
            PlayerData := MaybePlayerData?
            AccoladeManager := MaybeAccoladeManager?
        then:
            RandomCurrencyAmount := GetRandomFloat(MinEliminationCurrencyAmount, MaxEliminationCurrencyAmount)
            PlayerData.IncrementCurrency(RandomCurrencyAmount)
            AccoladeManager.GrantEliminationAccolade(AgentToAward)

    
    AwardAgentGameWon<public>(AgentToAward : agent): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(AgentToAward)
            PlayerData := MaybePlayerData?
            AccoladeManager := MaybeAccoladeManager?
        then:
            RandomCurrencyAmount := GetRandomFloat(MinGameWonCurrencyAmount, MaxGameWonCurrencyAmount)
            PlayerData.IncrementCurrency(RandomCurrencyAmount)
            AccoladeManager.GrantGameWonAccolade(AgentToAward)
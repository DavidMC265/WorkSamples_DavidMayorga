using { /Fortnite.com/Devices }
using { Lib }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using { /Verse.org/Colors/NamedColors }
using { /Verse.org/Simulation }
using { MainScripts }





Dependencies_AuraVFXs<localizes>:message = "Dependency Injector"
Config_AuraVFXs<localizes>:message = "Config"
Devices_AuraVFXs<localizes>:message = "Devices"


aura_vfxs := class(creative_device):

        #Dependencies
    @editable:
        Categories := array{ Lobby_Controller_DependecyInjector }
    var MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeEventMediator<private> : ?event_mediator = false
    var MaybeGameManager<private>: ?game_manager = false

        #Devices

    @editable:
        Categories := array { Devices_AuraVFXs }
    ClearAurasTrigger<private>: trigger_device = trigger_device{}

    @editable:
        Categories := array { Devices_AuraVFXs }
    RemoveAuraForPlayer_Button<private>: button_device = button_device{}

    @editable:
        Categories := array{ Devices_AuraVFXs }
    Blue_AuraVFX<private>: visual_effect_powerup_device = visual_effect_powerup_device{}

    @editable:
        Categories := array{ Devices_AuraVFXs }
    Blue_AuraButton<private>: button_device = button_device{}

    @editable:
        Categories := array{ Devices_AuraVFXs }
    Red_AuraVFX<private>: visual_effect_powerup_device = visual_effect_powerup_device{}

    @editable:
        Categories := array{ Devices_AuraVFXs }
    Red_AuraButton<private>: button_device = button_device{}

    @editable:
        Categories := array{ Devices_AuraVFXs }
    Golden_AuraVFX<private>: visual_effect_powerup_device = visual_effect_powerup_device{}

    @editable:
        Categories := array{ Devices_AuraVFXs }
    Golden_AuraButton<private>: button_device = button_device{}

    @editable:
        Categories := array{ Devices_AuraVFXs }
    Dark_AuraVFX<private>: visual_effect_powerup_device = visual_effect_powerup_device{}

    @editable:
        Categories := array{ Devices_AuraVFXs }
    Dark_AuraButton<private>: button_device = button_device{}

    var VFXPowerups<private>: []visual_effect_powerup_device = array{}


    OnBegin<override>()<suspends>:void=
        SetupDepedencies()

        set VFXPowerups = array{ Blue_AuraVFX, Red_AuraVFX, Golden_AuraVFX, Dark_AuraVFX }

        Blue_AuraButton.InteractedWithEvent.SubscribeAgent(OnAuraVFXPressed, 0)
        Red_AuraButton.InteractedWithEvent.SubscribeAgent(OnAuraVFXPressed, 1)
        Golden_AuraButton.InteractedWithEvent.SubscribeAgent(OnAuraVFXPressed, 2)
        Dark_AuraButton.InteractedWithEvent.SubscribeAgent(OnAuraVFXPressed, 3)

        RemoveAuraForPlayer_Button.InteractedWithEvent.Subscribe(RemoveAuraForPlayer)

        #spawn:
            #AwaitGameStart()


    SetupDepedencies(): void =
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeEventMediator = DependencyInjector.GetEventMediator()
            set MaybeGameManager = DependencyInjector.GetGameManager()
        else:
            Print(
                "Dependency Injector not available from lobby_controller script",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )


    OnAuraVFXPressed(Agent : agent, Number : int): void =
        case(Number):
            0 => Blue_AuraVFX.Pickup(Agent)
            1 => Red_AuraVFX.Pickup(Agent)
            2 => Golden_AuraVFX.Pickup(Agent)
            3 => Dark_AuraVFX.Pickup(Agent)
            _=>
                Print(
                    "Aura Number is not valid from aura vfxs", 
                    ?Duration := 7.0, 
                    ?Color := NamedColors.Red
                )

    AwaitGameStart()<suspends>:void =
        if(EventMediator := MaybeEventMediator?):
            EventMediator.OnGameStarted.Await()
            
            RemoveAuraFromPlayers()


    RemoveAuraFromPlayers(): void =
        AllPlayers := GetPlayspace().GetPlayers()
        for:
            Player : AllPlayers
            VFXPowerup : VFXPowerups
            VFXPowerup.HasEffect[Player]
        do:
            ClearAurasTrigger.Trigger(Player)


    RemoveAuraForPlayer(Agent : agent): void =
        ClearAurasTrigger.Trigger(Agent)



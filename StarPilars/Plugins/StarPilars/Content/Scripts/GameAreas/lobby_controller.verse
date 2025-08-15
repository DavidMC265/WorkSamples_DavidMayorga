using { /Fortnite.com/Devices }
using { /Fortnite.com/FortPlayerUtilities }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { MainScripts }



Lobby_Controller_DependecyInjector<localizes>:message = "Dependency Injector"
Lobby_Controller_Devices<localizes>:message = "Devices"
Lobby_Controller_Config<localizes>:message = "Configuration"
Lobby_Controller_Props<localizes>:message = "Props" 
Lobby_Controller_SpectatorModeProps<localizes>: message = "Spectator Mode Props"


lobby_controller<public> := class(creative_device):

        #Dependencies
    @editable:
        Categories := array{ Lobby_Controller_DependecyInjector }
    var MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeEventMediator<private> : ?event_mediator = false
    var MaybeGameManager<private>: ?game_manager = false

        #Devices
    @editable:
        Categories := array{ Lobby_Controller_Devices }
    GameStartTimer<private> : timer_device = timer_device{}

    @editable:
        Categories := array { Lobby_Controller_Devices }
    ChangingBoothTrigger<private>: trigger_device = trigger_device{}

        #Spectator Mode Props
    @editable:
        Categories := array{ Lobby_Controller_SpectatorModeProps }
    LobbySpectatorModeRespawningProp<private>: creative_prop = creative_prop{}

    @editable:
        Categories := array{ Lobby_Controller_SpectatorModeProps }
    LobbySpectatorModeRespawningPropLocation<private> : vector3 = vector3{}

    @editable
    StrormController<private> : basic_storm_controller_device = basic_storm_controller_device{}

    var LobbySpecatorModePropInfo<public>: ?tuple(vector3, creative_prop) = false

        #Props
    @editable
    CurrencyIconBackgroundColor : ?color = false
    

    var StartingGamePlayers<private> : []player = array{}
    var bHasGameStarted<private> : logic = false


    OnBegin<override>()<suspends>:void=
        SetupDepedencies()

        set StartingGamePlayers = GetPlayspace().GetPlayers()
        
        GameStartTimer.SuccessEvent.Subscribe(OnGameStartTimerCompleted)
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerJoinsGame)

        set LobbySpecatorModePropInfo = option{ (LobbySpectatorModeRespawningPropLocation, LobbySpectatorModeRespawningProp)}
        LobbySpectatorModeRespawningProp.Hide()

        
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


    OnPlayerJoinsGame(Agent : agent): void=
        if(bHasGameStarted = false, Player := player[Agent]):
            set StartingGamePlayers += array{ Player }


    OnGameStartTimerCompleted(MaybeAgent : ?agent): void =
        spawn:
            HandleGameStart()


    HandleGameStart()<suspends>: void =
        if(EventMediator := MaybeEventMediator?):
            ChangingBoothTrigger.Trigger()
            Sleep(1.5)
            #Check if players is spectating the game (This a join in progress player which means they will spawn next round and wont be counted in the Starting players)
            for(PlayerIndex -> StartingGamePlayer : StartingGamePlayers):
                if:
                    StartingGamePlayer.IsSpectator[]
                    NewArray := StartingGamePlayers.RemoveElement[PlayerIndex]
                then:
                    set StartingGamePlayers = NewArray
                    
            EventMediator.EmitOnGameStarted(StartingGamePlayers)
            StrormController.GenerateStorm()
            set bHasGameStarted = true






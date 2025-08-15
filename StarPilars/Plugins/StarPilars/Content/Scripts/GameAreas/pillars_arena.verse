using { /Fortnite.com }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { Scripts }
using { Lib }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { MainScripts }


# pillars_arena_floor_volume_devices_tag<public> := class(tag):

Pillars_Arena_DependecyInjector<localizes>:message = "Dependency Injector"
Pillars_Arena_Devices<localizes>:message = "Devices"
Pillars_Arena_Config<localizes>:message = "Configuration" 
Pillars_Arena_PickupsAndItems<localizes>:message = "Pickups/Items"
Pillars_Arena_SpectatorMode<localizes>:message = "Spectator Mode"
Pillars_Arena_Floors<localizes>:message = "Volume Floors"

pillars_arena<public> := class(creative_device):

    #Dependencies
    @editable:
        Categories := array{ Lobby_Controller_DependecyInjector }
    var MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeGameManager<private> : ?game_manager = false
    var MaybeEventMediator<private> : ?event_mediator = false
    var MaybeLobbyController<private>: ?lobby_controller = false
    var MaybePillarsManager<private>: ?pillars_manager = false

        #Devices
    @editable:
        Categories := array{ Pillars_Arena_Devices }
    var ArenaTeleporters<private> : []teleporter_device = array{}

    @editable:
        Categories := array{ Pillars_Arena_Devices }
    var ArenaBarriers<public>: []barrier_device = array{}

    @editable:
        Categories := array{ Pillars_Arena_Devices}
    RancorNPCSpawner<private> : npc_spawner_device = npc_spawner_device{}

        #Pickups/Items


        #Spectator Mode
    @editable:
        Categories := array{ Pillars_Arena_SpectatorMode}
    BalconySpecatorRespawning_CreativeProp1<private> : creative_prop = creative_prop{}

    @editable:
        Categories := array{ Pillars_Arena_SpectatorMode}
    BalconySpecatorRespawning_CreativePropLocation1<private> : vector3 = vector3{}

    @editable:
        Categories := array{ Pillars_Arena_SpectatorMode}
    BalconySpecatorRespawning_CreativeProp2<private> : creative_prop = creative_prop{}

    @editable:
        Categories := array{ Pillars_Arena_SpectatorMode}
    BalconySpecatorRespawning_CreativePropLocation2<private> : vector3 = vector3{}

    @editable:
        Categories := array{ Pillars_Arena_SpectatorMode}
    BalconySpecatorRespawning_CreativeProp3<private> : creative_prop = creative_prop{}

    @editable:
        Categories := array{ Pillars_Arena_SpectatorMode}
    BalconySpecatorRespawning_CreativePropLocation3<private> : vector3 = vector3{}

    @editable:
        Categories := array{ Pillars_Arena_SpectatorMode}
    BalconySpectatorModeButton<private> : button_device = button_device{}



    var RespawningBalconyProps<private> : []creative_prop = array{}
    var RespawningBalconyPropsPositions<private>: []vector3 = array{}


        #Volume Floors
    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FixedPointFloorCamera1<private>: gameplay_camera_fixed_point_device = gameplay_camera_fixed_point_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FixedPointFloorCamera2<private>: gameplay_camera_fixed_point_device = gameplay_camera_fixed_point_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FixedPointFloorCamera3<private>: gameplay_camera_fixed_point_device = gameplay_camera_fixed_point_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FixedPointFloorCamera4<private>: gameplay_camera_fixed_point_device = gameplay_camera_fixed_point_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FixedPointFloorCamera5<private>: gameplay_camera_fixed_point_device = gameplay_camera_fixed_point_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FixedPointFloorCamera6<private>: gameplay_camera_fixed_point_device = gameplay_camera_fixed_point_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FixedPointFloorCamera7<private>: gameplay_camera_fixed_point_device = gameplay_camera_fixed_point_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FixedPointFloorCamera8<private>: gameplay_camera_fixed_point_device = gameplay_camera_fixed_point_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FixedPointFloorCamera9<private>: gameplay_camera_fixed_point_device = gameplay_camera_fixed_point_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FixedPointFloorCamera10<private>: gameplay_camera_fixed_point_device = gameplay_camera_fixed_point_device{}


    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FloorVolumeDevice1<private>: volume_device = volume_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FloorVolumeDevice2_1<private>: volume_device = volume_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FloorVolumeDevice2_2<private>: volume_device = volume_device{}
    
    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FloorVolumeDevice3_1<private>: volume_device = volume_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FloorVolumeDevice3_2<private>: volume_device = volume_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FloorVolumeDevice4_1<private>: volume_device = volume_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FloorVolumeDevice4_2<private>: volume_device = volume_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FloorVolumeDevice5_1<private>: volume_device = volume_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FloorVolumeDevice6_1<private>: volume_device = volume_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FloorVolumeDevice7_1<private>: volume_device = volume_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FloorVolumeDevice8_1<private>: volume_device = volume_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FloorVolumeDevice8_2<private>: volume_device = volume_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FloorVolumeDevice9_1<private>: volume_device = volume_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FloorVolumeDevice10_1<private>: volume_device = volume_device{}

    @editable:
        Categories := array{ Pillars_Arena_Floors }
    FloorVolumeDevice10_2<private>: volume_device = volume_device{}


    OnBegin<override>()<suspends>:void=
        SetupDepedencies()

        BalconySpectatorModeButton.InteractedWithEvent.Subscribe(OnBalconySpectatorModeButtonPressed)

        set RespawningBalconyProps = array{ 
            BalconySpecatorRespawning_CreativeProp1,
            BalconySpecatorRespawning_CreativeProp2,
            BalconySpecatorRespawning_CreativeProp3
        }

        set RespawningBalconyPropsPositions = array{
            BalconySpecatorRespawning_CreativePropLocation1,
            BalconySpecatorRespawning_CreativePropLocation2,
            BalconySpecatorRespawning_CreativePropLocation3
        }

        for(RespawningBalconyProp : RespawningBalconyProps):
            RespawningBalconyProp.Hide()

        FloorVolumeDevice1.AgentEntersEvent.SubscribeAgent(OnPlayerTouchesArenaFloor, 1)
        FloorVolumeDevice2_1.AgentEntersEvent.SubscribeAgent(OnPlayerTouchesArenaFloor, 2)
        FloorVolumeDevice2_2.AgentEntersEvent.SubscribeAgent(OnPlayerTouchesArenaFloor, 2)
        FloorVolumeDevice3_1.AgentEntersEvent.SubscribeAgent(OnPlayerTouchesArenaFloor, 3)
        FloorVolumeDevice3_2.AgentEntersEvent.SubscribeAgent(OnPlayerTouchesArenaFloor, 3)
        FloorVolumeDevice4_1.AgentEntersEvent.SubscribeAgent(OnPlayerTouchesArenaFloor, 4)
        FloorVolumeDevice4_2.AgentEntersEvent.SubscribeAgent(OnPlayerTouchesArenaFloor, 4)
        FloorVolumeDevice5_1.AgentEntersEvent.SubscribeAgent(OnPlayerTouchesArenaFloor, 5)
        FloorVolumeDevice6_1.AgentEntersEvent.SubscribeAgent(OnPlayerTouchesArenaFloor, 6)
        FloorVolumeDevice7_1.AgentEntersEvent.SubscribeAgent(OnPlayerTouchesArenaFloor, 7)
        FloorVolumeDevice8_1.AgentEntersEvent.SubscribeAgent(OnPlayerTouchesArenaFloor, 8)
        FloorVolumeDevice8_2.AgentEntersEvent.SubscribeAgent(OnPlayerTouchesArenaFloor, 8)
        FloorVolumeDevice9_1.AgentEntersEvent.SubscribeAgent(OnPlayerTouchesArenaFloor, 9)
        FloorVolumeDevice10_1.AgentEntersEvent.SubscribeAgent(OnPlayerTouchesArenaFloor, 10)


        Sleep(3.0)
        RancorNPCSpawner.Spawn()


    SetupDepedencies(): void =
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeEventMediator = DependencyInjector.GetEventMediator()
            set MaybeLobbyController = DependencyInjector.GetLobbyController()
            set MaybePillarsManager = DependencyInjector.GetPillarsManager()
        else:
            Print(
                "Dependency Injector not available from lobby_controller script",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )
    

    TeleportPlayersToArena<public>(CurrentGamePlayers : []player): void =
        for(CurrentGamePlayer : CurrentGamePlayers):
            RandomIndex := GetRandomInt(0, ArenaTeleporters.Length - 1)
            if:
                TeleporterAssigned := ArenaTeleporters[RandomIndex]
                NewArray := ArenaTeleporters.RemoveElement[RandomIndex]
                PillarsManager := MaybePillarsManager?
            then:
                set ArenaTeleporters = NewArray
                TeleporterAssigned.Teleport(CurrentGamePlayer)
                PillarsManager.GameBeginsInTimer.Start(CurrentGamePlayer)
                spawn{ PillarsManager.PlayRoundCountdownSoundCues() }
                #spawn{ PillarsManager.StartItemTimerForPlayer(CurrentGamePlayer) }


    OnPlayerTouchesArenaFloor(Agent : agent, FloorNumber :int): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
            FortCharacter := Agent.GetFortCharacter[]
        then:
            FortCharacter.PutInStasis( stasis_args{ AllowFalling := true } )

            case(FloorNumber):
                1 => 
                    FixedPointFloorCamera1.AddTo(Agent)
                2 =>
                    FixedPointFloorCamera2.AddTo(Agent)
                3 =>
                    FixedPointFloorCamera3.AddTo(Agent)
                4 =>
                    FixedPointFloorCamera4.AddTo(Agent)
                5 =>
                    FixedPointFloorCamera5.AddTo(Agent)
                6 =>
                    FixedPointFloorCamera6.AddTo(Agent)
                7 =>
                    FixedPointFloorCamera7.AddTo(Agent)
                8 =>
                    FixedPointFloorCamera8.AddTo(Agent)
                9 =>
                    FixedPointFloorCamera9.AddTo(Agent)
                10 =>
                    FixedPointFloorCamera10.AddTo(Agent)
                _=>
                    Print(
                        "Floor number received is invaliddd", 
                        ?Duration := 7.0, 
                        ?Color := NamedColors.Red
                    )


    ShowSpectatorModeUI<public>(Player : player)<suspends> : void =
        Sleep(2.0)        
        if:
            GameManager := MaybeGameManager?, 
            EventMediator := MaybeEventMediator?,
            LobbyController := MaybeLobbyController?
        then:
            MaybePlayerData := GameManager.GetMaybePlayerData(Player)
            if(PlayerData := MaybePlayerData?):

                RandomInt := GetRandomInt(0, RespawningBalconyPropsPositions.Length - 1)
                var RespawningPropLocation : vector3 = vector3{}

                if(RandomRespawningPropLocation := RespawningBalconyPropsPositions[RandomInt]):
                    set RespawningPropLocation = RandomRespawningPropLocation

                    var MaybeRespawningPropInfoIn : ?tuple(vector3, creative_prop) = false

                        #Passing any BalconySpecatorRespawning_CreativeProp since all rotations for all props are the same
                    set MaybeRespawningPropInfoIn = option{ RespawningPropLocation, BalconySpecatorRespawning_CreativeProp1 } 

                    PlayerData.ShowSpectatorModeUI( 
                        MaybeEventMediator, 
                        LobbyController.LobbySpecatorModePropInfo, 
                        MaybeRespawningPropInfoIn 
                    )


    OnBalconySpectatorModeButtonPressed(Agent : agent): void =
        if:
            Player := player[Agent]
            FortCharacter := Player.GetFortCharacter[]
        then:
            spawn{ ShowSpectatorModeUI(Player) }
            FortCharacter.Damage(1000.0)



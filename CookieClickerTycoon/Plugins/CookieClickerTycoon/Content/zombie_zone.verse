using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/UI }

wave_countdown_timer := class:
    var RemainingTime : float = 0.0
    var Canvas : canvas = canvas{}
    RemainingTimeWidget : text_block = text_block{DefaultTextColor := NamedColors.White}
    RemainingTimeText<localizes>(CurrentRemainingTime : int) : message = "{CurrentRemainingTime}"
    MaybePlayerUI : ?player_ui = false
    TimerTickPeriod : float = 1.0 # The timer "precision": how often, in seconds, it ticks.
    TimeUntilNextWaveWidget : text_block = text_block{DefaultTextColor := NamedColors.White} 
    StringToMessage<localizes>(String : string) : message = "{String}"

    CountdownEndedEvent : event() = event(){}

    block:
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors:
                        Minimum := vector2{X := 0.5, Y := 0.05}
                        Maximum := vector2{X := 0.5, Y := 0.05}
                    Alignment := vector2{X := 0.5, Y := 0.0}
                    Offsets := margin{Left := 0.000000, Top := 100.000000, Right := 0.000000, Bottom:= 0.000000}
                    SizeToContent := true
                    ZOrder := 2
                    Widget := RemainingTimeWidget
                canvas_slot:
                    Anchors := anchors:
                        Minimum := vector2{X := 0.5, Y := 0.05}
                        Maximum := vector2{X := 0.5, Y := 0.05}
                    Alignment := vector2{X := 0.5, Y := 0.0}
                    Offsets := margin{Left := 0.000000, Top := 50.000000, Right := 0.000000, Bottom:= 0.000000}
                    SizeToContent := true
                    ZOrder := 2
                    Widget := TimeUntilNextWaveWidget

    StartCountdown() : void =
        if (PlayerUI := MaybePlayerUI?):
            PlayerUI.AddWidget(Canvas)
            UpdateUI()
            TimeUntilNextWaveWidget.SetText(StringToMessage("Time Until Next Wave Begins"))
            spawn {RunCountdown()}

    UpdateUI() : void =
        if (IntTime := Int[RemainingTime]):
            RemainingTimeWidget.SetText(RemainingTimeText(IntTime))

    RunCountdown()<suspends> : void =
        loop:
            Sleep(TimerTickPeriod) 
            set RemainingTime -= TimerTickPeriod
           
            UpdateUI()
           
            if (RemainingTime <= 0.0):
                if (PlayerUI := MaybePlayerUI?):
                    PlayerUI.RemoveWidget(Canvas)
                    CountdownEndedEvent.Signal()
                break

Teleporters_Editables := struct<concrete>:
    @editable IslandToZombieTP: teleporter_device = teleporter_device{}
    @editable ZombieToIslandTP : teleporter_device = teleporter_device{}
    @editable WinningZonePortal : teleporter_device = teleporter_device{}

CreatureSpawners_Editables := struct<concrete>:
        #Wave 1
    @editable ZombieSpawner1Wave1 : creature_spawner_device = creature_spawner_device{}
    @editable ZombieSpawner2Wave1 : creature_spawner_device = creature_spawner_device{}
        #Wave 2
    @editable ZombieSpawner1Wave2 : creature_spawner_device = creature_spawner_device{}
    @editable ZombieSpawner2Wave2 : creature_spawner_device = creature_spawner_device{}
        #Wave 3
    @editable ZombieSpawner1Wave3 : creature_spawner_device = creature_spawner_device{}
    @editable ZombieSpawner2Wave3 : creature_spawner_device = creature_spawner_device{}
        #Wave 4
    @editable ZombieSpawner1Wave4 : creature_spawner_device = creature_spawner_device{}
    @editable ZombieSpawner2Wave4 : creature_spawner_device = creature_spawner_device{}
        #Wave 5
    @editable ZombieSpawner1Wave5 : creature_spawner_device = creature_spawner_device{}
    @editable ZombieSpawner2Wave5 : creature_spawner_device = creature_spawner_device{} 

TrackerDevices_Editables := struct<concrete>:

    @editable EliminationsForWave1Tracker : tracker_device = tracker_device{}
    @editable EliminationsForWave2Tracker : tracker_device = tracker_device{}
    @editable EliminationsForWave3Tracker : tracker_device = tracker_device{}
    @editable EliminationsForWave4Tracker : tracker_device = tracker_device{}
    @editable EliminationsForWave5Tracker : tracker_device = tracker_device{}


zombie_zone := class(creative_device):

    #Managers
    @editable GameManager : game_manager = game_manager{}
    @editable UIManagerInst : UIManager = UIManager{}

    #Teleporters
    @editable Teleporters : Teleporters_Editables = Teleporters_Editables{}

    #CreatureSpawners
    @editable CreatureSpawners : CreatureSpawners_Editables = CreatureSpawners_Editables{}

    #Trackers
    @editable TrackerDevices : TrackerDevices_Editables = TrackerDevices_Editables{}
    @editable WaveCountTracker : tracker_device = tracker_device{}
    @editable WaveTargetEliminationsTracker : tracker_device = tracker_device{}

    @editable ZombieToIslandTPBarrier : barrier_device = barrier_device{}

    #Item Granters
    @editable WeaponGranter : item_granter_device = item_granter_device{}
    @editable CookieClickerWeaponGranter : item_granter_device = item_granter_device{}

    @editable ZombieToIslandTPProps : prop_manipulator_device = prop_manipulator_device{}

    #Zombie Island
    @editable ZombieZonePlayerCheckpoint : player_checkpoint_device = player_checkpoint_device{}
    @editable ZonePlayerDetector : trigger_device = trigger_device{}
    
    #UI Configuration
    var WaveCountdownTimer : wave_countdown_timer = wave_countdown_timer{}
    @editable var InitialCountdownWaveTime : float = 30.0
    var MaybeAgent : ?agent = false

    #Wave Configuration
    @editable var StartingWave : int = 1
    @editable var WaveEliminationsRequired : int = 10
    var CurrentWave : int = 0
    var CurrentEliminations: int = 0
    var CurrentPlayerHealth : float = 0.0
    @editable var HealthGrantOnElimination : float = 5.0 

    @editable var CookiesAwardedPerKillWave1 : int = 25
    @editable var CookiesAwardedPerKillWave2 : int = 30
    @editable var CookiesAwardedPerKillWave3 : int = 40
    @editable var CookiesAwardedPerKillWave4 : int = 55
    @editable var CookiesAwardedPerKillWave5 : int = 70

    #Player Win
    @editable PlayerCompletedWavesDialogue : popup_dialog_device = popup_dialog_device{}

    OnBegin<override>()<suspends>:void=
        set CurrentWave = StartingWave

        ZombieToIslandTPBarrier.Disable()
        Teleporters.WinningZonePortal.Disable()

        AllPlayers := GetPlayspace().GetPlayers()
        for(Agent : AllPlayers, TeamPlayer := player[Agent], FortCharacter := TeamPlayer.GetFortCharacter[]):
            FortCharacter.EliminatedEvent().Subscribe(OnPlayerEliminated)

        var ZombieSpawners : []creature_spawner_device = array{
            CreatureSpawners.ZombieSpawner1Wave1, CreatureSpawners.ZombieSpawner2Wave1,
            CreatureSpawners.ZombieSpawner1Wave2, CreatureSpawners.ZombieSpawner2Wave2,
            CreatureSpawners.ZombieSpawner1Wave3, CreatureSpawners.ZombieSpawner2Wave3,
            CreatureSpawners.ZombieSpawner1Wave4, CreatureSpawners.ZombieSpawner2Wave4,
            CreatureSpawners.ZombieSpawner1Wave5, CreatureSpawners.ZombieSpawner2Wave5
        }

        for(Zombie : ZombieSpawners):
            Zombie.EliminatedEvent.Subscribe(OnZombieEliminated)

        PlayerCompletedWavesDialogue.RespondingButtonEvent.Subscribe(OnPlayerExitsZoneAfterWin)

            #Handle Player Enter & Exit Zone
        Teleporters.IslandToZombieTP.EnterEvent.Subscribe(TeleportPlayerToZone)
        Teleporters.ZombieToIslandTP.EnterEvent.Subscribe(TeleportPlayerOutOfZone)
        Teleporters.ZombieToIslandTP.TeleportedEvent.Subscribe(OnPlayerTeleportedToZone)
        ZonePlayerDetector.TriggeredEvent.Subscribe(AssignWaveZombies)
 
    TeleportPlayerToZone(Agent : agent): void =
        if(Player := player[Agent]):
            Teleporters.ZombieToIslandTP.Teleport(Agent)

    TeleportPlayerOutOfZone(Agent: agent): void =
        if(Player := player[Agent]):
            Teleporters.IslandToZombieTP.Teleport(Agent)
            CookieClickerWeaponGranter.GrantItem(Agent)

    OnPlayerTeleportedToZone(Agent : agent): void =
        ZombieZonePlayerCheckpoint.Register(Agent)
        WeaponGranter.GrantItem(Agent)

    AddWaveCountdownTimerUI(): void = 
        if:
            FirstPlayer := Self.GetPlayspace().GetPlayers()[0]
            PlayerUI := GetPlayerUI[player[FirstPlayer]]
        then:
            set WaveCountdownTimer = wave_countdown_timer{MaybePlayerUI := option{PlayerUI}, RemainingTime := InitialCountdownWaveTime}
            WaveCountdownTimer.StartCountdown()

    HandleTimerCompletion(Agent : ?agent)<suspends>:void = 
        WaveCountdownTimer.CountdownEndedEvent.Await()
        
        if(Player := player[Agent?]):
            AssignWaveZombies(Agent)

    AssignWaveZombies(Agent : ?agent): void = 
        if(Player := player[Agent?]):
            case(CurrentWave):
                1=> 
                    TrackerDevices.EliminationsForWave1Tracker.Assign(Player)
                    TrackerDevices.EliminationsForWave1Tracker.SetTarget(WaveEliminationsRequired)
                    SpawnWaveZombies(CreatureSpawners.ZombieSpawner1Wave1, CreatureSpawners.ZombieSpawner2Wave1)
                2=>
                    TrackerDevices.EliminationsForWave2Tracker.Assign(Player)
                    TrackerDevices.EliminationsForWave2Tracker.SetTarget(WaveEliminationsRequired)
                    SpawnWaveZombies(CreatureSpawners.ZombieSpawner1Wave2, CreatureSpawners.ZombieSpawner2Wave2)
                3=> 
                    TrackerDevices.EliminationsForWave3Tracker.Assign(Player)
                    TrackerDevices.EliminationsForWave3Tracker.SetTarget(WaveEliminationsRequired)
                    SpawnWaveZombies(CreatureSpawners.ZombieSpawner1Wave3, CreatureSpawners.ZombieSpawner2Wave3)
                4 =>
                    TrackerDevices.EliminationsForWave4Tracker.Assign(Player)
                    TrackerDevices.EliminationsForWave4Tracker.SetTarget(WaveEliminationsRequired)
                    SpawnWaveZombies(CreatureSpawners.ZombieSpawner1Wave4, CreatureSpawners.ZombieSpawner2Wave4)
                5 =>
                    TrackerDevices.EliminationsForWave5Tracker.Assign(Player)
                    TrackerDevices.EliminationsForWave5Tracker.SetTarget(WaveEliminationsRequired)
                    SpawnWaveZombies(CreatureSpawners.ZombieSpawner1Wave5, CreatureSpawners.ZombieSpawner2Wave5)
                _=> 
                    Print(
                        "Current Wave Number is out of bounds!", 
                        ?Duration := 2.0, 
                        ?Color := NamedColors.Red
                        )

    SpawnWaveZombies(ZombieSpawner1 : creature_spawner_device, ZombieSpawner2 : creature_spawner_device): void =
        ZombieSpawner1.Enable()
        ZombieSpawner2.Enable()

    OnPlayerEliminated(Result : elimination_result): void = 
        FC := Result.EliminatedCharacter 
        if(Agent := FC.GetAgent[]):
            if(Value : int = Floor(GameManager.CurrentCookieCount / 2)):
                set GameManager.CurrentCookieCount = Value

    OnZombieEliminated(Result : device_ai_interaction_result): void = 
        if(Agent := Result.Source?, Player := player[Agent], FortCharacter:=Player.GetFortCharacter[]):
            set CurrentEliminations += 1
            set MaybeAgent = option {Agent}
            if(FortCharacter.GetHealth() < 100.0):
                set CurrentPlayerHealth = FortCharacter.GetHealth() + HealthGrantOnElimination
                FortCharacter.SetHealth(CurrentPlayerHealth)

            case(CurrentWave):
                1 => 
                    set GameManager.CurrentCookieCount += CookiesAwardedPerKillWave1
                    TrackerDevices.EliminationsForWave1Tracker.Increment(Player)
                    spawn { UIManagerInst.UpdateCookiesToAddText(Player, CookiesAwardedPerKillWave1) }
                    if(CurrentEliminations >= WaveEliminationsRequired):
                        HandleWaveCompletion(
                            MaybeAgent, 
                            CreatureSpawners.ZombieSpawner1Wave1, 
                            CreatureSpawners.ZombieSpawner2Wave1
                        )
                        AddWaveCountdownTimerUI()
                        spawn { HandleTimerCompletion(MaybeAgent) }
                2 => 
                    set GameManager.CurrentCookieCount += CookiesAwardedPerKillWave2
                    TrackerDevices.EliminationsForWave2Tracker.Increment(Player)
                    spawn { UIManagerInst.UpdateCookiesToAddText(Player, CookiesAwardedPerKillWave2) }
                    if(CurrentEliminations >= WaveEliminationsRequired):
                        HandleWaveCompletion(
                            MaybeAgent, 
                            CreatureSpawners.ZombieSpawner1Wave2, 
                            CreatureSpawners.ZombieSpawner2Wave2
                        )  
                        AddWaveCountdownTimerUI()
                        spawn { HandleTimerCompletion(MaybeAgent) }
                3=> 
                    set GameManager.CurrentCookieCount += CookiesAwardedPerKillWave3
                    TrackerDevices.EliminationsForWave3Tracker.Increment(Player)
                    spawn { UIManagerInst.UpdateCookiesToAddText(Player, CookiesAwardedPerKillWave3) }
                    if(CurrentEliminations >= WaveEliminationsRequired):
                        HandleWaveCompletion(
                            MaybeAgent, 
                            CreatureSpawners.ZombieSpawner1Wave3, 
                            CreatureSpawners.ZombieSpawner2Wave3 
                        )
                        AddWaveCountdownTimerUI()
                        spawn { HandleTimerCompletion(MaybeAgent) }
                4 =>
                    set GameManager.CurrentCookieCount += CookiesAwardedPerKillWave4
                    TrackerDevices.EliminationsForWave4Tracker.Increment(Player)
                    spawn { UIManagerInst.UpdateCookiesToAddText(Player, CookiesAwardedPerKillWave4) }
                    if(CurrentEliminations >= WaveEliminationsRequired):
                        HandleWaveCompletion(
                            MaybeAgent, 
                            CreatureSpawners.ZombieSpawner1Wave4, 
                            CreatureSpawners.ZombieSpawner2Wave4
                        )
                        AddWaveCountdownTimerUI()
                        spawn { HandleTimerCompletion(MaybeAgent) }
                5=>
                    set GameManager.CurrentCookieCount += CookiesAwardedPerKillWave5
                    TrackerDevices.EliminationsForWave5Tracker.Increment(Player)
                    spawn { UIManagerInst.UpdateCookiesToAddText(Player, CookiesAwardedPerKillWave5) }
                    if(CurrentEliminations >= WaveEliminationsRequired):
                        WaveCountTracker.Increment(Player)
                        OnFinalWaveCompleted(
                            Player, 
                            CreatureSpawners.ZombieSpawner1Wave5, 
                            CreatureSpawners.ZombieSpawner2Wave5
                        )
                _=> 
                    Print(
                        "Current Wave index is out of bounds!!", 
                        ?Duration := 5.0, 
                        ?Color := NamedColors.Red
                    )
        
    HandleWaveCompletion(Agent : ?agent, ZombieSpawner1 : creature_spawner_device, ZombieSpawner2 : creature_spawner_device): void =
            #Handle Eliminations Tracker
        if(Player := player[Agent?]):
            WaveTargetEliminationsTracker.ClearPersistence(Player)
            WaveCountTracker.Increment(Player)
        set CurrentWave += 1
        set CurrentEliminations = 0
        ZombieSpawner1.Disable()
        ZombieSpawner1.EliminateCreatures()
        ZombieSpawner2.Disable()
        ZombieSpawner2.EliminateCreatures()
            #Timer UI
        AddWaveCountdownTimerUI()
        spawn { HandleTimerCompletion(Agent) }
        # UIManagerInst.OpenOrCloseZombieZoneUI(Player)

    HandlePlayerWin(Player : player): void = 
        CreatureSpawners.ZombieSpawner1Wave5.EliminateCreatures()
        CreatureSpawners.ZombieSpawner2Wave5.EliminateCreatures()
        CreatureSpawners.ZombieSpawner1Wave5.Disable()
        CreatureSpawners.ZombieSpawner1Wave5.Disable()

    OnPlayerExitsZoneAfterWin(Agent : agent, index : int): void = 
        Teleporters.WinningZonePortal.Enable()
        Teleporters.WinningZonePortal.Teleport(Agent)
        Teleporters.ZombieToIslandTP.Disable()
        ZombieToIslandTPBarrier.Enable()
        ZombieToIslandTPProps.ShowProps()
        CookieClickerWeaponGranter.GrantItem(Agent)

    OnFinalWaveCompleted(Player : player, ZombieSpawner1 : creature_spawner_device, ZombieSpawner2 : creature_spawner_device): void = 
        PlayerCompletedWavesDialogue.Show(Player)
        ZombieSpawner1.Disable()
        ZombieSpawner1.EliminateCreatures()
        ZombieSpawner2.Disable()
        ZombieSpawner2.EliminateCreatures()

        



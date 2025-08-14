using { /Fortnite.com }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation }
using { MainScripts }



audio_gamemusic_test := class(creative_device):

    @editable
    MaybeDependencyInjector : ?dependency_injector = false

    var MaybeGameManager : ?game_manager = false

    @editable
    MusicPlayer : audio_player_device = audio_player_device{}

    @editable:
    ToggleAudioButton : button_device = button_device{}

    @editable:
    PlayerSpawners : []player_spawner_device = array{}


    OnBegin<override>()<suspends>:void=
        SetupDependencies()
        ToggleAudioButton.InteractedWithEvent.Subscribe(OnToggleAudioButtonPressed)

        for(PlayerSpawner : PlayerSpawners):
            PlayerSpawner.SpawnedEvent.Subscribe(OnPlayerSpawned)


    SetupDependencies(): void =
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
        else:
            Print("Depdendecy injector was not assigned in the edito for this device")


    OnPlayerSpawned(Agent : agent): void =
        Print("A player has spawned!")
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
            IsMusicPlayingPlayer := PlayerData.GetIsMusicPlayingPlayer()
            IsMusicPlayingPlayer = false
        then:
            MusicPlayer.Play(Agent)
            PlayerData.SetIsMusicPlayingPlayer(true)


    OnToggleAudioButtonPressed(Agent : agent): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
            IsMusicPlayingPlayer := PlayerData.GetIsMusicPlayingPlayer()
        then:
            if(IsMusicPlayingPlayer = true):
                MusicPlayer.Stop(Agent)
                PlayerData.SetIsMusicPlayingPlayer(false)
                Print("Toggled music OFF")
            else:
                MusicPlayer.Play(Agent)
                PlayerData.SetIsMusicPlayingPlayer(true)
                Print("Toggled music ON")
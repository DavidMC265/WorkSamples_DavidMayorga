using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { MainScripts }

ToggleMusic_Device := class(creative_device):

    @editable
    MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeGameManager<private> : ?game_manager = false

    @editable
    AudioMusicPlayer<private> : audio_player_device = audio_player_device{}
    @editable
    ButtonAudioPlayerToggle<private> : button_device = button_device{}
    @editable
    PlayerSpawns<private> : []player_spawner_device = array{}


        # This variable was replaced beacuse it isnt individual 
        # for each player, therefore the variable from
        # player data is being used
    #var Toggle:logic=false
    

    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        for (Index := 0..PlayerSpawns.Length - 1, PlayerSpawn:=PlayerSpawns[Index]):
            PlayerSpawn.SpawnedEvent.Subscribe(OnPlayerSpawned)

        ButtonAudioPlayerToggle.InteractedWithEvent.Subscribe(ToggleMusic)


    SetupDependencies(): void =
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
        else:
            Print("Depdendecy injector was not assigned in the edito for this device")


    ToggleMusic(Agent : agent):void=
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
            IsMusicPlayingPlayer := PlayerData.GetIsMusicPlayingPlayer()
        then:
                #If IsMusicPlayingPlayer variable is true, play the audio and set the variable to false
            if(IsMusicPlayingPlayer = true):
                AudioMusicPlayer.Stop(Agent)
                PlayerData.SetIsMusicPlayingPlayer(false)
                #Print("Toggled music OFF")

                #If IsMusicPlayingPlayer variable is false, play the audio and set the variable to true
            else:
                AudioMusicPlayer.Play(Agent)
                PlayerData.SetIsMusicPlayingPlayer(true)
                #Print("Toggled music ON")
        

    OnPlayerSpawned(Agent : agent):void=
            #If IsMusicPlayingPlayer variable is false, play the audio and set the variable to true on Spawned
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
            IsMusicPlayingPlayer := PlayerData.GetIsMusicPlayingPlayer()
            IsMusicPlayingPlayer = false
        then:
            AudioMusicPlayer.Play(Agent)
            PlayerData.SetIsMusicPlayingPlayer(true)

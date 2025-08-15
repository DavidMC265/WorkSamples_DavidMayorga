using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { MainScripts }


Toggle_Music_DependecyInjector<localizes>:message = "Dependency Injector"
Toggle_Music_Devices<localizes>:message = "Devices"
Toggle_Music_Config<localizes>:message = "Configuration" 


toggle_music := class(creative_device):

        # Dependencies
    @editable:
        Categories := array{ Toggle_Music_DependecyInjector }
    MaybeDependencyInjector<private>: ?dependency_injector = false

    var MaybeGameManager<private>: ?game_manager = false

        # Devices
    @editable:
        Categories := array { Toggle_Music_Devices }
    AudioMusicPlayer<private> : audio_player_device = audio_player_device{}

    @editable:
        Categories := array { Toggle_Music_Devices }
    ButtonAudioPlayerToggle<private> : button_device = button_device{}

    
    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        ButtonAudioPlayerToggle.InteractedWithEvent.Subscribe(ToggleMusic)

        Sleep(1.0)
        AllPlayers := GetPlayspace().GetPlayers()
        for(Player : AllPlayers):
            PlayMusicForPlayerStart(Player)

        GetPlayspace().PlayerAddedEvent().Subscribe(PlayMusicForPlayerStart)


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
        

    PlayMusicForPlayerStart(Agent : agent):void=
            #If IsMusicPlayingPlayer variable is false, play the audio and set the variable to true on Spawned
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
            IsMusicPlayingPlayer := PlayerData.GetIsMusicPlayingPlayer()
            IsMusicPlayingPlayer = false
        then:
            AudioMusicPlayer.Play(Agent)
            #Print("Music Playing for player", ?Duration := 7.0, ?Color := NamedColors.Orange)
            PlayerData.SetIsMusicPlayingPlayer(true)



using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }


countdowm_soundcue_test := class(creative_device):

    @editable       ButtonTest : button_device = button_device{}
    @editable       SoundCueSecond1 : audio_player_device = audio_player_device{}
    @editable       SoundCueSecond2 : audio_player_device = audio_player_device{}
    @editable       SoundCueSecond3 : audio_player_device = audio_player_device{}
    @editable       SoundCueCompletion : audio_player_device = audio_player_device{}

    var PlayedCounter : int = 0

    OnBegin<override>()<suspends>:void=
        ButtonTest.InteractedWithEvent.Subscribe(OnButtonPressed)

    OnButtonPressed(Agent : agent): void = 
        spawn { PlaySounds() }

    PlaySounds()<suspends>: void =
        loop:
            if(PlayedCounter = 3):
                set PlayedCounter = 0 
                SoundCueCompletion.Play()
                break
            if(PlayedCounter = 1):
                SoundCueSecond2.Play()
            if(PlayedCounter = 2):
                SoundCueSecond3.Play()

            SoundCueSecond1.Play()
            Print("Seconds sound played!!!")
            set PlayedCounter += 1
            Sleep(1.0)



    
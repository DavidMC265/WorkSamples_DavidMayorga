using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { MainScripts }
using { Tests }


Dependencies_TimePlayed<localizes>:message = "Dependency Injector"
Config_TimePlayed<localizes>:message = "Config"
Devices_TimePlayed<localizes>:message = "Devices"
HUDMessages_TimePlayed<localizes>:message = "HUD Messages"

timeplayed_reward := class(creative_device):
        #Dependencies
    @editable:
        Categories := array{ Dependencies_TimePlayed }
    MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeGameManager<private> : ?game_manager = false
    var MaybeAccoladeManager<private>: ?accolade_manager = false

        #Configuration
    @editable:
        Categories := array{ Config_TimePlayed }
    StartingMinutes<private>: int = 0

    @editable:
        Categories := array{ Config_TimePlayed }
    StartingSeconds<private>: int = 30

        #HUD Messages
    @editable:
        Categories := array{ HUDMessages_TimePlayed }
    TimePlayed_HUDMessages<private>: []hud_message_device = array{}

    @editable       MapValuesButton : button_device = button_device{}


    var HudMessagesIndexMap<private>: [int]logic = map{}
    

    StringToMessage<localizes>(String : string): message = "{String}"


    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        MapValuesButton.InteractedWithEvent.Subscribe(OnMapValuesButtonPressed)

        for:
            Index -> TimePlayed_HUDMessage : TimePlayed_HUDMessages
            set HudMessagesIndexMap[Index] = false
        do:
            #Do nothing, just assigned the value of the index inside of the map to false


        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerJoinsGame)
        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerLeavesGame)

        AllPlayers := GetPlayspace().GetPlayers()
        for(Player : AllPlayers):
            FindAvailableHUDMesage(Player)


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


    OnMapValuesButtonPressed(Agent : agent): void =
        for(Key ->Value : HudMessagesIndexMap):
            if(Value = false):
                Print("{Key}")
                Print (
                    "This HUD Message is available to show to the player!!!", 
                    ?Duration := 7.0, 
                    ?Color := NamedColors.Orange
                )
            else:
                Print (
                    "This HUD Message is not available to show to the player!!!", 
                    ?Duration := 7.0, 
                    ?Color := NamedColors.Red
                )
 

    OnPlayerJoinsGame(Agent : agent): void =
        spawn{ FindAvailableHUDMesage(Agent) }


    OnPlayerLeavesGame(Agent : agent): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            MinutesPlayedHUDIndex := PlayerData.GetMinutesPlayedHUDIndex()
            for(Index -> TimePlayed_HUDMessage : TimePlayed_HUDMessages, Index = MinutesPlayedHUDIndex):
                if(set HudMessagesIndexMap[Index] = false){}


    FindAvailableHUDMesage(Agent : agent)<suspends>: void =
        Sleep(2.0)
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            for:
                Index -> TimePlayed_HUDMessage : TimePlayed_HUDMessages
                HudMessagesIndexMap[Index] = false
            do:
                if(set HudMessagesIndexMap[Index] = true):
                    PlayerData.SetMinutesPlayedHUDIndex(Index)
                    spawn{ UpdatePlayTime(Agent, TimePlayed_HUDMessage) }
                    return


    UpdatePlayTime(Agent : agent, HUDMessage : hud_message_device)<suspends>: void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            var MinutesPlayedPlayer : int = StartingMinutes
            var SecondsPlayedPlayer : int = StartingSeconds

            HUDMessage.SetText(StringToMessage("0{MinutesPlayedPlayer}:{SecondsPlayedPlayer}"))
            HUDMessage.Show(Agent)

            loop:
                Sleep(1.0)
                set SecondsPlayedPlayer -= 1
            
                if(SecondsPlayedPlayer <= 0):
                    if(MinutesPlayedPlayer <= 0):
                        HUDMessage.SetText(StringToMessage("0{MinutesPlayedPlayer}:0{SecondsPlayedPlayer}"))
                        HUDMessage.Show(Agent)
                        if(AccoladeManager := MaybeAccoladeManager?):
                            AccoladeManager.GrantTimePlayedAccolade(Agent)
                            UpdatePlayTime(Agent, HUDMessage)
                            break
                    else:
                        set MinutesPlayedPlayer -= 1
                        set SecondsPlayedPlayer = 59

                if(SecondsPlayedPlayer < 10):
                    HUDMessage.SetText(StringToMessage("0{MinutesPlayedPlayer}:0{SecondsPlayedPlayer}"))
                    HUDMessage.Show(Agent)
                else:
                    HUDMessage.SetText(StringToMessage("0{MinutesPlayedPlayer}:{SecondsPlayedPlayer}"))
                    HUDMessage.Show(Agent)


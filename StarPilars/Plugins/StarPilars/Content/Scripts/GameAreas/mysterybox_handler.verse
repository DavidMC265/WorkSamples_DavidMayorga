using { /Fortnite.com }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { Lib }
using { MainScripts }
using { Tests }


Dependencies_MysteryBox<localizes>:message = "Dependency Injector"
Config_MysteryBox<localizes>:message = "Config"
Percentages_MysteryBox<localizes>:message = "Percentages"
Devices_MysteryBox<localizes>:message = "Devices"
HUDMessages_MysteryBox<localizes>:message = "HUD Messages"

mysterybox_handler := class(creative_device):

        #Dependencies
    @editable:
        Categories := array{ Dependencies_MysteryBox }
    MaybeDependencyInjector<private>: ?dependency_injector = false

    var MaybeGameManager<private>: ?game_manager = false
    var MaybeAccoladeManager<private>: ?accolade_manager = false
    var MaybeQuestManager<public>: ?quest_manager = false

        #Configuration
    @editable:
        Categories := array{ Config_MysteryBox }
    MinCurrencyToAward<private>: float = 300.0  

    @editable:
        Categories := array{ Config_MysteryBox }
    MaxCurrencyToAward<private>: float = 500.0 

        #Percentages
    @editable_slider(int):
        Categories := array{ Percentages_MysteryBox }
        MinValue := option{ 1 }
        MaxValue := option{ 100 }
    Currency_Percentage<private>: int = 30

    @editable_slider(int):
        Categories := array{ Percentages_MysteryBox }
        MinValue := option{ 1 }
        MaxValue := option{ 100 }
    XP_Percentage<private>: int = 30

    @editable_slider(int):
        Categories := array{ Percentages_MysteryBox }
        MinValue := option{ 1 }
        MaxValue := option{ 100 }
    DamageAmplifierPowerup_Percentage<private>: int = 20

    @editable_slider(int):
        Categories := array{ Percentages_MysteryBox }
        MinValue := option{ 1 }
        MaxValue := option{ 100 }
    DoubleCurrencyMultiplier_Percentage<private>: int = 20

        #Devices
    @editable:
        Categories := array{ Devices_MysteryBox }
    OpenMysteryBox_Button<private>: button_device = button_device{}

    @editable:
        Categories := array{ Devices_MysteryBox }
    DamageAmplifierPowerup<private>: damage_amplifier_powerup_device = damage_amplifier_powerup_device{}

    @editable:
        Categories := array{ Devices_MysteryBox }
    MysteryBoxOpened_AudioPlayer<private>: audio_player_device = audio_player_device{}

    @editable:
        Categories := array{ Devices_MysteryBox }
    MysteryBoxOpened_Cinematic<private>: cinematic_sequence_device = cinematic_sequence_device{}

    @editable:
        Categories := array{ Devices_MysteryBox }
    PercentagesBillboard<private>: billboard_device = billboard_device{}

        #HUD Messages
    @editable:
        Categories := array{ HUDMessages_MysteryBox }
    AlreadyOpenedBox_HUDMessage<private>: hud_message_device = hud_message_device{}

    @editable:
        Categories := array{ HUDMessages_MysteryBox }
    GrantCurrency_HUDMessage<private>: hud_message_device = hud_message_device{}

    @editable:
        Categories := array{ HUDMessages_MysteryBox }
    GrantXP_HUDMessage<private>: hud_message_device = hud_message_device{}

    @editable:
        Categories := array{ HUDMessages_MysteryBox }
    DamageAmplifierPowerup_HUDMessage<private>: hud_message_device = hud_message_device{}

    @editable:
        Categories := array{ HUDMessages_MysteryBox }
    DoubleCurrencyMultiplier_HUDMessage<private>: hud_message_device = hud_message_device{}


    var OpendedBoxStatePlayerMap<private> : [agent]logic = map{}


    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        PercentagesTotal : int = Currency_Percentage + XP_Percentage + DamageAmplifierPowerup_Percentage #+ DoubleCurrencyMultiplier_Percentage
        if(PercentagesTotal < 100 or PercentagesTotal > 100):
            Print(
                "The Percentages Total sum of all rewards does not equal 100!", 
                ?Duration := 7.0, 
                ?Color := NamedColors.Red
            )
            OpenMysteryBox_Button.Disable()
            return

        OpenMysteryBox_Button.InteractedWithEvent.Subscribe(OnOpenMysteryBoxButtonPressed)

        AllPlayers := GetPlayspace().GetPlayers()
        for(Player : AllPlayers):
            AddAgentToBoxMap(Player)
        
        GetPlayspace().PlayerAddedEvent().Subscribe(AddAgentToBoxMap)

        Sleep(1.0)
        PercentagesBillboard.SetText(
            PlayerAcceptsBountyBillboardText(
                Currency_Percentage, 
                XP_Percentage, 
                DamageAmplifierPowerup_Percentage, 
                DoubleCurrencyMultiplier_Percentage 
            ) )
    
    
    SetupDependencies(): void =
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeAccoladeManager = DependencyInjector.GetAccoladeManager()
            set MaybeQuestManager = DependencyInjector.GetQuestManager()
        else:
            Print(
                "Couldnt set dependencies from mysterybox_handler!", 
                ?Duration := 5.0, 
                ?Color := NamedColors.Red
            )


    PlayerAcceptsBountyBillboardText<localizes>(CurrencyPercentageVal : int, XPPercentageVal : int,  DamageAmplifierPowerupVal : int, DoubleCurrencyMultiplierVal : int) : message =
        "Credits : {CurrencyPercentageVal}%\nXP : {XPPercentageVal}%\nDamage Powerup : {DamageAmplifierPowerupVal}%"


    AddAgentToBoxMap(Agent : agent): void =
        if:
            set OpendedBoxStatePlayerMap[Agent] = false
        then:
            #Do nothing, just added the player to the map


    OnOpenMysteryBoxButtonPressed(Agent : agent): void =
        #Check if player has already opened the Mystery box for the current round
        if(OpendedBoxStatePlayerMap[Agent] = true):
            AlreadyOpenedBox_HUDMessage.Show(Agent)
            return
        
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
            AccoladeManager := MaybeAccoladeManager?
            set OpendedBoxStatePlayerMap[Agent] = true
        then:
            #When the player has not opened the Mystery Box
            RandomInt := GetRandomInt(0, 100)

            #Percentages are:
                # 30% Currency
                # 30% XP
                # 20% Damage Amplifier Powerup
                # 20% Double Currency Multiplier
                
            if( RandomInt < Currency_Percentage ):
                #GrantCurrency
                RandomCurrencyAmount := GetRandomFloat(MinCurrencyToAward, MaxCurrencyToAward)
                PlayerData.IncrementCurrency(RandomCurrencyAmount)
                if(RandomCurrencyAmountInt := Floor[RandomCurrencyAmount]):
                    GrantCurrency_HUDMessage.SetText(StringToMessage("💲You got {RandomCurrencyAmountInt} Credits💲") )
                    GrantCurrency_HUDMessage.Show(Agent)

            else if( RandomInt < Currency_Percentage + XP_Percentage ):
                #GrantXP
                AccoladeManager.GrantMysteryBoxAccolade(Agent)
                GrantXP_HUDMessage.Show(Agent)

            #else if ( RandomInt < Currency_Percentage + XP_Percentage + DamageAmplifierPowerup_Percentage ):
            else:
                #GrantPowerup
                DamageAmplifierPowerup.Pickup(Agent)
                DamageAmplifierPowerup_HUDMessage.Show(Agent)

            #else:
                #GrantDoubleCurrencyMultipler
                #PlayerData.SetCurrencyMultiplier(2.0)
                #DoubleCurrencyMultiplier_HUDMessage.Show(Agent)

            MysteryBoxOpened_AudioPlayer.Play(Agent)
            MysteryBoxOpened_Cinematic.Play(Agent)

            
            if(QuestManager := MaybeQuestManager?):
                CurrentPlayerQuest := PlayerData.GetCurrentQuest()
                if(CurrentPlayerQuest = EQuests.OpenMysteryBox):
                    QuestManager.IncrementQuestValue(Agent, EQuests.OpenMysteryBox, 1)






using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { Lib }
using { MainScripts }


hat_store_DependecyInjector<localizes>:message = "Dependency Injector"
hat_store_Config<localizes>: message = "Configuration"
hat_store_Devices<localizes>: message = "Devices"
hat_store_Debug<localizes>: message = "Debugging"


EHats<public>:= enum<persistable>{ None, ScoutTrooper ,CaptainRex, BoKatan, DarthVader, Grogu, R2D2, BB8 }


hat_store<public> := class(creative_device):

    @editable:
        Categories := array{ hat_store_DependecyInjector }
    MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeGameManager<private>: ?game_manager = false
    var MaybeAccoladeManager<private>: ?accolade_manager = false
    var MaybeEventMediator<private>: ?event_mediator = false

    @editable:
        Categories := array{ hat_store_Config }
    HatNames<private>: []string = array{}

    @editable:
        Categories := array{ hat_store_Config }
    HatPrices<private>: []float = array{}

    @editable:
        Categories := array { hat_store_Devices }
    HatVFXs<public>: []visual_effect_powerup_device = array{}

    @editable:
        Categories := array{ hat_store_Devices }
    PurchaseHatButtons<private>: []button_device = array{}

    @editable:
        Categories := array{ hat_store_Devices }
    CantAffordHatHUDMessage<private>: hud_message_device = hud_message_device{}

    @editable:
        Categories := array{ hat_store_Devices }
    AlreadyOwnsHatHUDMessage<private>: hud_message_device = hud_message_device{}

    @editable:
        Categories := array{ hat_store_Devices }
    DoesntOwnAnyHatsHUDMessage<private>: hud_message_device = hud_message_device{}

    @editable:
        Categories := array{ hat_store_Devices }
    DoesntOwnHatHUDMessage<public>: hud_message_device = hud_message_device{}

    @editable:
        Categories := array{ hat_store_Devices }
    RemoveHatTrigger<public>: trigger_device = trigger_device{}

    @editable:
        Categories := array{ hat_store_Devices }
    PurchasedHatSFX<private>: audio_player_device = audio_player_device{}

    @editable:
        Categories := array{ hat_store_Devices }
    ShowHatsOwnedUIActivationZone<private> : mutator_zone_device = mutator_zone_device{}

    @editable:
        Categories := array{ hat_store_Debug }
    ResetHatsOwned<private>: button_device = button_device{}

    @editable:
        Categories := array { hat_store_Devices }
    HatEquippedSFX<public>: audio_player_device = audio_player_device{}

    @editable:
        Categories := array { hat_store_Devices }
    HatRemovedSFX<public>: audio_player_device = audio_player_device{}

    #@editable
    #var Array : []EHats = array{}
    HatPriceMessage<private><localizes> (Name : string, Price : float): message = "{Name}: {Price}"


    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        for:
            ButtonIndex -> PurchaseHatButton : PurchaseHatButtons, 
            HatName := HatNames[ButtonIndex],
            HatPrice :=  HatPrices[ButtonIndex]
        do:
            PurchaseHatButton.SetInteractionText( HatPriceMessage(HatName, HatPrice) )
            PurchaseHatButton.InteractedWithEvent.SubscribeAgent(OnPlayerPressesHatButton, ButtonIndex)


        ShowHatsOwnedUIActivationZone.AgentEntersEvent.Subscribe(OnPlayerEntersActivationZone)
        ResetHatsOwned.InteractedWithEvent.Subscribe(OnResetHatsOwnedButtonPressed)

        Sleep(1.0)
        GrantSavedHat()

        spawn:
            HideUIOnGameStart()


    SetupDependencies():void = 
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeAccoladeManager = DependencyInjector.GetAccoladeManager()
            set MaybeEventMediator = DependencyInjector.GetEventMediator()
        else:
            Print(
                "Dependency Injector not available from bounty_hunting script",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )


    OnResetHatsOwnedButtonPressed(Agent : agent): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            PlayerData.ResetHatsOwned()
            Print("Hats Owned reset!!!", ?Duration := 7.0, ?Color := NamedColors.Orange)
            

    OnPlayerPressesHatButton(Agent : agent, Index : int): void =
        #Print("Hat Button Pressed")
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
            HatPrice := HatPrices[Index]
        then:
            HatsOwnedPlayer := PlayerData.GetHatsOwned()
            MaybeHatOfIndex := GetEnumHatOfIndex(Index)
                #Check if the player already own the hat 
            if:
                HatOfIndex := MaybeHatOfIndex?
                HatsOwnedPlayer.Find[HatOfIndex]
            then:
                AlreadyOwnsHatHUDMessage.Show(Agent)
                #Print("Player already owns this hat!!!")
                return
            
            else:
                #Check if the player can Afford the Hat
                if:
                    PlayerCurrency := PlayerData.GetCurrency()
                    PriceOfHatIndex := HatPrices[Index]
                    PlayerCurrency >= PriceOfHatIndex
                    HatVFX := HatVFXs[Index]
                    HatOfIndex := MaybeHatOfIndex?
                    AccoladeManager := MaybeAccoladeManager?
                then:
                    PlayerData.UpdateHatsOwned(HatOfIndex)
                    PlayerData.DecrementCurrency(PriceOfHatIndex)
                    HatVFX.Pickup(Agent)
                    PurchasedHatSFX.Play(Agent)
                    AccoladeManager.GrantPurchasedHatAccolade(Agent)
                    PlayerData.SetCurrentHat(HatOfIndex)
                else:
                    CantAffordHatHUDMessage.Show(Agent)
                    #Print("Player cannot afford Hat!!!")


    GetEnumHatOfIndex(Index : int)<transacts>: ?EHats =
        var MaybeHat : ?EHats = false

        case(Index):
            0 => set MaybeHat = option { EHats.ScoutTrooper }
            1 => set MaybeHat = option { EHats.CaptainRex }
            2 => set MaybeHat = option { EHats.BoKatan }
            3 => set MaybeHat = option { EHats.DarthVader }
            4 => set MaybeHat = option { EHats.Grogu }
            5 => set MaybeHat = option { EHats.R2D2 }
            6 => set MaybeHat = option { EHats.BB8 }
            _=> 
                Print(
                    "Index invalid therefore can´t return an Enum from the index given inside hat_store", 
                    ?Duration := 7.0, 
                    ?Color := NamedColors.Red
                )

        return MaybeHat


    OnPlayerEntersActivationZone(Agent : agent): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            PlayerData.ShowHatsOwnedUI()
            
            #HatsOwnedPlayer := PlayerData.GetHatsOwned()
            #if(HatsOwnedPlayer.Length <= 0):
                #Print(
                    #"Player doesnt own any hats", 
                    #?Duration := 8.0, 
                    #?Color := NamedColors.Red
                #)
                #DoesntOwnAnyHatsHUDMessage.Show(Agent)
                #return

            #else:            
                #PlayerData.ShowHatsOwnedUI()


    GrantSavedHat(): void =
        AllPlayers := GetPlayspace().GetPlayers()
        if(GameManager := MaybeGameManager?):

            for:
                Player : AllPlayers
                MaybePlayerData := GameManager.GetMaybePlayerData(Player)
                PlayerData := MaybePlayerData?
            do:
                SavedHatPlayer := PlayerData.GetCurrentHat()
                case (SavedHatPlayer):
                    EHats.None => return
                    EHats.ScoutTrooper =>
                        if(HatVFX := HatVFXs[0]):
                            HatVFX.Pickup(Player)
                    EHats.CaptainRex =>
                        if(HatVFX := HatVFXs[1]):
                            HatVFX.Pickup(Player)
                    EHats.BoKatan =>
                        if(HatVFX := HatVFXs[2]):
                            HatVFX.Pickup(Player)
                    EHats.DarthVader =>
                        if(HatVFX := HatVFXs[3]):
                            HatVFX.Pickup(Player)
                    EHats.Grogu =>
                        if(HatVFX := HatVFXs[4]):
                            HatVFX.Pickup(Player)
                    EHats.R2D2 =>
                        if(HatVFX := HatVFXs[5]):
                            HatVFX.Pickup(Player)
                    EHats.BB8 =>
                        if(HatVFX := HatVFXs[6]):
                            HatVFX.Pickup(Player)


    HideUIOnGameStart()<suspends>: void =
        if(EventMediator := MaybeEventMediator?, GameManager := MaybeGameManager?):
            EventMediator.OnGameStarted.Await()

            AllPlayers := GetPlayspace().GetPlayers()
            for:
                Player : AllPlayers
                MaybePlayerData := GameManager.GetMaybePlayerData(Player)
                PlayerData := MaybePlayerData?
            do:
                PlayerData.HideHatsOwnedUI()
                
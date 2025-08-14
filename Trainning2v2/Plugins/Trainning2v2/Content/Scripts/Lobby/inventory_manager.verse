using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { Lib }
using { MainScripts }


inventory_manager_log_channel := class(log_channel){}

inventory_manager<public> := class(creative_device):

    Logger : log = log{Channel := inventory_manager_log_channel}
    
    @editable
    MaybeDependencyInjector : ?dependency_injector = false
    @editable
    CustomEquipmentRifleOrSMG : custom_equipment = custom_equipment{}
    @editable
    CustomEquipmentShotgun : custom_equipment = custom_equipment{}
    @editable
    CustomEquipmentHealingItem1 : custom_equipment = custom_equipment{}
    @editable
    CustomEquipmentHealingItem2 : custom_equipment = custom_equipment{}
    @editable
    EquipmentButtons : []button_device = array{}
    @editable
    DefaultLoadout<public> : item_granter_device = item_granter_device{}
    @editable
    InventorySaver : trigger_device = trigger_device{}
    @editable
    InventoryLoader : trigger_device = trigger_device{}
    @editable
    RiflesAndSMGs_ItemRemover : item_remover_device = item_remover_device{}
    @editable
    Shotguns_ItemRemover : item_remover_device = item_remover_device{}
    @editable
    HealingItems1_ItemRemover : item_remover_device = item_remover_device{}
    @editable
    HealingItems2_ItemRemover : item_remover_device = item_remover_device{}


    var MaybeGameManager: ?game_manager = false
    var MaybeEventMediator : ?event_mediator = false
    var MaybePregameLobby : ?pregame_lobby = false


    OnBegin<override>()<suspends>:void=
        #Set the Dependency Injector
        SetupDependencies()

        #Subscribe to the LoadoutSetted function for each button
        for(Button: EquipmentButtons):
            Button.InteractedWithEvent.Subscribe(LoadoutSetted)

        spawn{ OnRoundStarted() }

        spawn { OnGameEnds() }


    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeEventMediator = DependencyInjector.GetEventMediator()
            set MaybePregameLobby = DependencyInjector.GetPreGameLobby()
        else:
            Print(
                "Dependency Injector not available",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )
            
    LoadoutSetted(Agent : agent):void=
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            if:
                PlayerData := MaybePlayerData?
            then:
                PlayerData.SetPlayerLoadout(true)
               
    GiveDefaultLoadout():void=
        if(PregameLobby := MaybePregameLobby?):
            for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                # Print("Inventory Saved",?Duration := 7.0,?Color := NamedColors.Red)
                if(GameManager := MaybeGameManager?):
                    MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)
                    if:
                        PlayerData := MaybePlayerData?
                    then:
                        HasLoadout : logic = PlayerData.GetPlayerLoadout()
                        if(HasLoadout = false):
                            GrantDefaultWaponLoadOutToPlayer(CurrentGamePlayer)
                            set PlayerData.FullLoadOutGranter = option{ DefaultLoadout }
                            #save default loadout
                            SaveInvetory(CurrentGamePlayer)


    GrantDefaultWaponLoadOutToPlayer<public>(Player : player): void =
        DefaultLoadout.GrantItem(Player)


    LoadInventory(Agent : agent)<suspends>:void=
        if(EventMediator := MaybeEventMediator?):
            EventMediator.OnLoadInventory.Await()
            
            InventoryLoader.Trigger(Agent)
            # Print("Inventory Loaded",?Duration := 7.0,?Color := NamedColors.Green)
            LoadInventory(Agent)

    SaveInvetory(Agent : agent):void=
        InventorySaver.Trigger(Agent)
        
    OnRoundStarted()<suspends>:void=
        if(EventMediator := MaybeEventMediator?, PregameLobby := MaybePregameLobby?):
            EventMediator.OnRoundStarted.Await()
            
            GiveDefaultLoadout()
            #Save the inventory of all players
            for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                SaveInvetory(CurrentGamePlayer)

    GrantLoadoutOnRoundStart<public>(Agent : agent)<suspends>: void = 
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            if(PlayerData := MaybePlayerData?):
                if:
                    LoudOutGranter := PlayerData.FullLoadOutGranter?
                then:
                    #When full loadout is valid
                    LoudOutGranter.GrantItem(Agent)

                    Sleep(0.3)
                        #Check if they choose an Additional Rifle or SMG Weapon
                    if:
                        RifleOrSMGRemover := PlayerData.RifleOrSMGRemover?
                        RifleOrSMGGranter := PlayerData.RifleOrSMGGranter?
                        RifleOrSMGIndex := PlayerData.RifleOrSMGIndex?

                    then:
                        RifleOrSMGRemover.Remove(Agent)
                        RifleOrSMGGranter.GrantItemIndex(Agent, RifleOrSMGIndex)

                    Sleep(0.3)
                        #Check if they choose an Additional Shotgun
                    if:
                        ShotgunGranter := PlayerData.ShotgunGranter?
                        ShotgunRemover := PlayerData.ShotgunRemover?
                        ShotgunIndex := PlayerData.ShotgunIndex?
                    then:
                        ShotgunRemover.Remove(Agent)
                        ShotgunGranter.GrantItemIndex(Agent, ShotgunIndex)

                    Sleep(0.3)
                        #Check if they choose an Additional Healing item 1
                    if:
                        HealingItemsGranter := PlayerData.HealingItemsGranter?
                        HealingItemsRemover := PlayerData.HealingItemsRemover?
                        HealingItemsIndex := PlayerData.HealingItemsIndex?
                    then:
                        HealingItemsRemover.Remove(Agent)
                        HealingItemsGranter.GrantItemIndex(Agent, HealingItemsIndex)  

                    Sleep(0.3)
                        #Check if they choose an Additional Healing item 2
                    if:
                        HealingItemsGranter2 := PlayerData.HealingItemsGranter2?
                        HealingItemsRemover2 := PlayerData.HealingItemsRemover2?
                        HealingItemsIndex2 := PlayerData.HealingItemsIndex2?
                    then:
                        HealingItemsRemover2.Remove(Agent)

                        HealingItemsGranter2.GrantItemIndex(Agent, HealingItemsIndex2)

                else:
                    #When full loadout is not valid

                        #Check if they choose a Rifle or SMG Weapon
                    if:
                        RifleOrSMGGranter := PlayerData.RifleOrSMGGranter?
                        RifleOrSMGIndex := PlayerData.RifleOrSMGIndex?
                    then:
                        RifleOrSMGGranter.GrantItemIndex(Agent, RifleOrSMGIndex)
                        #Check if the player has selected healing items, if not give them a random Healing item 1 and 2
                        if:
                            not PlayerData.HealingItemsGranter?
                            not PlayerData.HealingItemsGranter2?
                        then:
                            HealingItemIndex1 : int = 0
                            CustomEquipmentHealingItem1.ItemGranter.GrantItemIndex(Agent, HealingItemIndex1)
                            HealingItemIndex2 : int = 0
                            CustomEquipmentHealingItem2.ItemGranter.GrantItemIndex(Agent, HealingItemIndex2)

                            Print("Player selected a healing item 1 but no gun, has been given a SMG or Rifle noww!!!")


                            set PlayerData.HealingItemsGranter = option{ CustomEquipmentHealingItem1.ItemGranter }
                            set PlayerData.HealingItemsIndex = option{ HealingItemIndex1 }
                            set PlayerData.HealingItemsRemover = option{ CustomEquipmentHealingItem1.Remover }

                            set PlayerData.HealingItemsGranter2 = option{ CustomEquipmentHealingItem2.ItemGranter }
                            set PlayerData.HealingItemsIndex2 = option{ HealingItemIndex2 }
                            set PlayerData.HealingItemsRemover2 = option{ CustomEquipmentHealingItem2.Remover }

                        #Check if they choose an Additional Shotgun
                    if:
                        ShotgunGranter := PlayerData.ShotgunGranter?
                        ShotgunIndex := PlayerData.ShotgunIndex?
                    then:
                        ShotgunGranter.GrantItemIndex(Agent, ShotgunIndex)

                        if:
                            not PlayerData.HealingItemsGranter?
                            not PlayerData.HealingItemsGranter2?
                        then:
                            HealingItemIndex1 : int = 0
                            CustomEquipmentHealingItem1.ItemGranter.GrantItemIndex(Agent, HealingItemIndex1)
                            HealingItemIndex2 : int = 0
                            CustomEquipmentHealingItem2.ItemGranter.GrantItemIndex(Agent, HealingItemIndex2)

                            Print("Player selected a healing item 1 but no gun, has been given a SMG or Rifle noww!!!")


                            set PlayerData.HealingItemsGranter = option{ CustomEquipmentHealingItem1.ItemGranter }
                            set PlayerData.HealingItemsIndex = option{ HealingItemIndex1 }
                            set PlayerData.HealingItemsRemover = option{ CustomEquipmentHealingItem1.Remover }

                            set PlayerData.HealingItemsGranter2 = option{ CustomEquipmentHealingItem2.ItemGranter }
                            set PlayerData.HealingItemsIndex2 = option{ HealingItemIndex2 }
                            set PlayerData.HealingItemsRemover2 = option{ CustomEquipmentHealingItem2.Remover }


                        #Check if they choose an Additional Healing item 
                    if:
                        HealingItemsGranter := PlayerData.HealingItemsGranter?
                        HealingItemsIndex := PlayerData.HealingItemsIndex?
                    then:
                        HealingItemsGranter.GrantItemIndex(Agent, HealingItemsIndex)
                        
                            #Check if the player has selected guns, if not give them a random shotgun and SMG/Rifle
                        if:
                            not PlayerData.RifleOrSMGGranter?
                            not PlayerData.ShotgunGranter?
                        then:
                            RifleOrSMGIndex : int = GetRandomInt(0, 5)
                            CustomEquipmentRifleOrSMG.ItemGranter.GrantItemIndex(Agent, RifleOrSMGIndex)
                            ShotgunSMGIndex : int = GetRandomInt(0, 5)
                            CustomEquipmentShotgun.ItemGranter.GrantItemIndex(Agent, ShotgunSMGIndex)

                            Print("Player selected a healing item 1 but no gun, has been given a SMG or Rifle noww!!!")


                            set PlayerData.RifleOrSMGGranter = option{ CustomEquipmentRifleOrSMG.ItemGranter }
                            set PlayerData.RifleOrSMGIndex = option{ RifleOrSMGIndex }
                            set PlayerData.RifleOrSMGRemover = option{ CustomEquipmentRifleOrSMG.Remover }

                            set PlayerData.ShotgunGranter = option{ CustomEquipmentShotgun.ItemGranter }
                            set PlayerData.ShotgunIndex = option{ ShotgunSMGIndex }
                            set PlayerData.ShotgunRemover = option{ CustomEquipmentShotgun.Remover }


                    if:
                        HealingItemsGranter2 := PlayerData.HealingItemsGranter2?
                        # HealingItemsRemover2 := PlayerData.HealingItemsRemover?
                        HealingItemsIndex2 := PlayerData.HealingItemsIndex2?
                    then:
                        # HealingItemsRemover2.Remove(Agent)
                        HealingItemsGranter2.GrantItemIndex(Agent, HealingItemsIndex2)

                        Print("Granted healing item 2 to player!!!")

                            #Check if the player has selected guns, if not give them a random shotgun and SMG/Rifle

                        if:
                            not PlayerData.RifleOrSMGGranter?
                            not PlayerData.ShotgunGranter?
                        then:
                            Print("Player did not select Any gun after selecting healing item 2!!!")

                            RifleOrSMGIndex : int = GetRandomInt(0, 5)
                            CustomEquipmentRifleOrSMG.ItemGranter.GrantItemIndex(Agent, RifleOrSMGIndex)
                            ShotgunSMGIndex : int = GetRandomInt(0, 5)
                            CustomEquipmentShotgun.ItemGranter.GrantItemIndex(Agent, ShotgunSMGIndex)

                            Print("Player selected a healing item 2 but no gun, has been given a SMG or Rifle noww!!!")


                            set PlayerData.RifleOrSMGGranter = option{ CustomEquipmentRifleOrSMG.ItemGranter }
                            set PlayerData.RifleOrSMGIndex = option{ RifleOrSMGIndex }
                            set PlayerData.RifleOrSMGRemover = option{ CustomEquipmentRifleOrSMG.Remover }

                            set PlayerData.ShotgunGranter = option{ CustomEquipmentShotgun.ItemGranter }
                            set PlayerData.ShotgunIndex = option{ ShotgunSMGIndex }
                            set PlayerData.ShotgunRemover = option{ CustomEquipmentShotgun.Remover }
                        else:

                            Print("Player did actually select a gun after selecting healing item 2!!!")




    OnGameEnds()<suspends>: void =
        if(EventMediator := MaybeEventMediator?):
            EventMediator.OnPlayersAreSentToPodium.Await()

            ClearAllCurrentGamePlayersInventory()

    
    ClearAllCurrentGamePlayersInventory()<suspends>: void =
        if(PregameLobby := MaybePregameLobby?):
            for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                RiflesAndSMGs_ItemRemover.Remove(CurrentGamePlayer)
                Sleep(0.3)
                Shotguns_ItemRemover.Remove(CurrentGamePlayer)
                Sleep(0.3)
                HealingItems1_ItemRemover.Remove(CurrentGamePlayer)
                Sleep(0.3)
                HealingItems2_ItemRemover.Remove(CurrentGamePlayer)        




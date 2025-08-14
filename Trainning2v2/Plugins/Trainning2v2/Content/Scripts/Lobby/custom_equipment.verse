using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { Lib }
using { MainScripts }
using { RoundSystem }


DependecyInjector<localizes>:message = "Dependency Injector"

custom_equipment := class(creative_device):

    @editable:
        Categories:= array{ DependecyInjector }
    var MaybeDependencyInjector : ?dependency_injector = false
    
    @editable 
    var WeaponType : string = "RifleOrSMG" #ASSIGN IN EDITORRRRRR

    @editable
    Button1 : button_device = button_device{}
     @editable
    Button2 : button_device = button_device{}
    @editable
    Button3 : button_device = button_device{}
    @editable
    Button4 : button_device = button_device{}
    @editable
    Button5 : button_device = button_device{}
    @editable
    Button6 : button_device = button_device{}
    @editable
    Button7 : button_device = button_device{}
    @editable
    Button8 : button_device = button_device{}
    @editable
    Button9 : button_device = button_device{}
    @editable
    Button10 : button_device = button_device{}
    @editable
    Button11 : button_device = button_device{}
    @editable
    Button12 : button_device = button_device{}

    @editable :
    Loadouts : []button_device = array{}
    @editable
    ItemGranter<public> : item_granter_device = item_granter_device{}
    @editable
    Remover : item_remover_device = item_remover_device{}
   
    var WeaponCounter : int = 0
    var MaybeGameManager : ?game_manager = false

    OnBegin<override>()<suspends>:void=
        SetupDependencies()   

        Button1.InteractedWithEvent.SubscribeAgent(GiveWeapon, 0)
        Button2.InteractedWithEvent.SubscribeAgent(GiveWeapon, 1)
        Button3.InteractedWithEvent.SubscribeAgent(GiveWeapon, 2)
        Button4.InteractedWithEvent.SubscribeAgent(GiveWeapon, 3)
        Button5.InteractedWithEvent.SubscribeAgent(GiveWeapon, 4)
        Button6.InteractedWithEvent.SubscribeAgent(GiveWeapon, 5)
        Button7.InteractedWithEvent.SubscribeAgent(GiveWeapon, 6)
        Button8.InteractedWithEvent.SubscribeAgent(GiveWeapon, 7)
        Button9.InteractedWithEvent.SubscribeAgent(GiveWeapon, 8)
        Button10.InteractedWithEvent.SubscribeAgent(GiveWeapon, 9)
        Button11.InteractedWithEvent.SubscribeAgent(GiveWeapon, 10)
        Button12.InteractedWithEvent.SubscribeAgent(GiveWeapon, 11)

        for(Button : Loadouts):
            Button.InteractedWithEvent.Subscribe(Addcounter)

    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
        else:
            Print(
                "Dependency Injector not available from Round Start manager",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )

    GiveWeapon(Agent : agent, Index : int):void =
                    
        set WeaponCounter += 1
        ItemGranter.GrantItemIndex(Agent, Index)
        if(WeaponCounter >= 2):
            Remover.Remove(Agent)
            set WeaponCounter = 1

        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            if(PlayerData := MaybePlayerData?):

                case(WeaponType):
                    "RifleOrSMG" => 
                        set PlayerData.RifleOrSMGGranter = option{ ItemGranter }
                        set PlayerData.RifleOrSMGIndex = option{ Index }
                        set PlayerData.RifleOrSMGRemover = option{ Remover }

                    "Shotgun" => 
                        set PlayerData.ShotgunGranter = option{ ItemGranter }
                        set PlayerData.ShotgunIndex = option{ Index }
                        set PlayerData.ShotgunRemover = option{ Remover }

                    "HealingItem1" => 
                        set PlayerData.HealingItemsGranter = option { ItemGranter }
                        set PlayerData.HealingItemsIndex = option{ Index }
                        set PlayerData.HealingItemsRemover = option{ Remover }

                    "HealingItem2" =>
                        set PlayerData.HealingItemsGranter2 = option { ItemGranter }
                        set PlayerData.HealingItemsIndex2 = option{ Index }
                        set PlayerData.HealingItemsRemover2 = option{ Remover }

                    _=> Print(
                            "An invalid weapon type was assigned to this custom_equipment device!!!", 
                            ?Duration := 5.0, 
                            ?Color := NamedColors.Red
                        )

    Addcounter(Agent : agent):void =         
        set WeaponCounter += 1




            
          
using { /Fortnite.com }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { MainScripts }


DependecyInjector_xpshop<localizes>:message = "Dependency Injector"
Devices_xpshop<localizes>:message = "Devices"
Config_xpshop<localizes>:message = "Configuration" 

xp_shop<public> := class(creative_device):

        #Dependencies
    @editable:
        Categories := array{ DependecyInjector_xpshop }
    MaybeDependencyInjector<private>: ?dependency_injector = false

    var MaybeGameManager<private>: ?game_manager = false

        #Devices
    @editable:
        Categories := array { Devices_xpshop }
    OpenXPShop_Button<private> : button_device = button_device{}

    @editable:
        Categories := array { Devices_xpshop }
    CantPurchaseXP_HUDMessage<public> : hud_message_device = hud_message_device{}

        #Configuration
    @editable:
        Categories := array { Config_xpshop }
    VerySmallCostAmount<private> : int = 0

    @editable:
        Categories := array { Config_xpshop }
    SmallCostAmount<private> : int = 0

    @editable:
        Categories := array { Config_xpshop }
    MediumCostAmount<private> : int = 0

    @editable:
        Categories := array { Config_xpshop }
    LargeCostAmount<private> : int = 0

    @editable:
        Categories := array { Config_xpshop }
    VeryLargeCostAmount<private> : int = 0


    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        OpenXPShop_Button.InteractedWithEvent.Subscribe(OnOpenShopButtonPressed)


    SetupDependencies():void = 
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
        else:
            Print(
                "Dependency Injector not available from quest_manager script",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )


    OnOpenShopButtonPressed(Agent : agent): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            PlayerData.ShowXPShopUI(VerySmallCostAmount, SmallCostAmount, MediumCostAmount, LargeCostAmount, VeryLargeCostAmount)
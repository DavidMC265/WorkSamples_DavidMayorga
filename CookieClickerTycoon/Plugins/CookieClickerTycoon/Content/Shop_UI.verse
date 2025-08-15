using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors }

Shop := class():
    var GameManager : game_manager = game_manager{}

    var ShopUIClass : Shop_UI = Shop_UI{}

    var ShopCanvas : canvas = canvas{}
    var ShopCanvasPage2 : canvas = canvas{}

    var Weapon1Button : button_loud = button_loud{}
    var Weapon2Button : button_loud = button_loud{}
    var Weapon3Button : button_loud = button_loud{}
    var Weapon4Button : button_loud = button_loud{}
    var Weapon5Button : button_loud = button_loud{}

    var CloseButton : button_loud = button_loud{}

    var Title : text_block = text_block{}
    var Description : text_block = text_block{}

    var NotEnoughCookiesMessage : hud_message_device = hud_message_device{}

    var ZombieZoneWeaponsGranter : item_granter_device = item_granter_device{}
    var Weapon1Cost : int = 500
    var Weapon2Cost : int = 1200
    var Weapon3Cost : int = 2000
    var Weapon4Cost : int = 5000
    var Weapon5Cost : int = 10000

    var PurchasedWeapon1 : logic = false
    var PurchasedWeapon2 : logic = false
    var PurchasedWeapon3 : logic = false
    var PurchasedWeapon4 : logic = false
    var PurchasedWeapon5 : logic = false

    var ShopBackground : texture_block = texture_block{DefaultImage := UI.ShopPageMain}

    GetShopUI(): canvas =
        ShopCanvas.AddWidget(canvas_slot:
            Widget := ShopBackground, 
            Anchors := anchors{Minimum := vector2{X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5}},
            Offsets := margin{Left:= 23.953552, Top := -5.629639, Right := 1433.828979, Bottom:= 1061.821777},
            Alignment := vector2{X:= 0.5, Y:= 0.5},
            SizeToContent := false,
            ZOrder := 0
        )
        ShopCanvas.AddWidget(canvas_slot:
            Widget := Weapon1Button, 
            Anchors := anchors{Minimum := vector2{X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5}},
            Offsets := margin{Left:= -400.960938, Top := 23.459473, Right := 198.898895, Bottom:= 54.414413},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := false,
            ZOrder := 1
        )
        ShopCanvas.AddWidget(canvas_slot:
            Widget := Weapon2Button, 
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}},
            Offsets := margin{Left:= 848.000000, Top := 564.000000, Right := 198.898926, Bottom:= 54.414429},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := false,
            ZOrder := 1
        )
        ShopCanvas.AddWidget(canvas_slot:
            Widget := Weapon3Button, 
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}},
            Offsets := margin{Left:= 1152.000000, Top := 568.000000, Right := 198.898926, Bottom:= 54.414429},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := false,
            ZOrder := 1
        )
        ShopCanvas.AddWidget(canvas_slot:
            Widget := Weapon4Button, 
            Anchors := anchors{Minimum := vector2{X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5}},
            Offsets := margin{Left:= -400.960938, Top := 307.459473, Right := 198.898895, Bottom:= 54.414413},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := false,
            ZOrder := 1
        )
        ShopCanvas.AddWidget(canvas_slot:
            Widget := Weapon5Button, 
            Anchors := anchors{Minimum := vector2{X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5}},
            Offsets := margin{Left:= -96.960938, Top := 307.459473, Right := 198.898895, Bottom:= 54.414413},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := false,
            ZOrder := 1
        )
        ShopCanvas.AddWidget(canvas_slot:
            Widget := CloseButton, 
            Anchors := anchors{Minimum := vector2{X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5}},
            Offsets := margin{Left:= 223.039062, Top := 303.459473, Right := 213.313324, Bottom:= 54.414413},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := false,
            ZOrder := 1
        )
        ShopCanvas.AddWidget(canvas_slot:
            Widget := Title, 
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}},
            Offsets := margin{Left:= 868.000000, Top := 164.000000, Right := 165.000000, Bottom:= 41.000000},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := true,
            ZOrder := 1
        )
        ShopCanvas.AddWidget(canvas_slot:
            Widget := Description, 
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}},
            Offsets := margin{Left:= 728.000000, Top := 236.000000, Right := 165.000000, Bottom:= 41.000000},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := true,
            ZOrder := 1
        )

        CloseButton.OnClick().Subscribe(HandleExit)
        # CloseButton.OnClick().Subscribe(ChangeUIPage)
        Weapon1Button.OnClick().Subscribe(BuyWeapon1)
        Weapon2Button.OnClick().Subscribe(BuyWeapon2)
        Weapon3Button.OnClick().Subscribe(BuyWeapon3)
        Weapon4Button.OnClick().Subscribe(BuyWeapon4)
        Weapon5Button.OnClick().Subscribe(BuyWeapon5)
        
        if(PurchasedWeapon1 = false):
            Weapon1Button.SetText(StringToMessage("500"))

        if(PurchasedWeapon2 = false):
            Weapon2Button.SetText(StringToMessage("1.2k"))

        if(PurchasedWeapon3 = false):
            Weapon3Button.SetText(StringToMessage("2k"))
        
        if(PurchasedWeapon4 = false):
            Weapon4Button.SetText(StringToMessage("5k"))

        if(PurchasedWeapon5 = false):
            Weapon5Button.SetText(StringToMessage("10k"))

        Title.SetText(StringToMessage("Weapon Shop"))
        Title.SetTextColor(NamedColors.White)

        Description.SetText(StringToMessage("Purchase Zombie Zone Weapons"))
        Description.SetTextColor(NamedColors.White)

        CloseButton.SetText(StringToMessage("CLOSE"))

        return ShopCanvas
        

    StringToMessage<localizes>(String : string) : message = "{String}"
        
    BuyWeapon1(Message : widget_message): void =
        Player := Message.Player
        OnWeaponPurchased(Weapon1Cost, PurchasedWeapon1, 1, Player, Weapon1Button)

    BuyWeapon2(Message : widget_message): void =
        Player := Message.Player
        OnWeaponPurchased(Weapon2Cost, PurchasedWeapon2, 2, Player, Weapon2Button)

    BuyWeapon3(Message : widget_message): void =
        Player := Message.Player
        OnWeaponPurchased(Weapon3Cost, PurchasedWeapon3, 3, Player, Weapon3Button)

    BuyWeapon4(Message : widget_message): void =
        Player := Message.Player
        OnWeaponPurchased(Weapon4Cost, PurchasedWeapon4, 4, Player, Weapon4Button)

    BuyWeapon5(Message : widget_message): void =
        Player := Message.Player
        OnWeaponPurchased(Weapon5Cost, PurchasedWeapon5, 5, Player, Weapon5Button)

    OnWeaponPurchased(WeaponCost : int, PurchasedWeapon : logic, NextWeaponItemIndex : int, Player : player, WeaponButon : button_loud): void = 
        if(GameManager.CurrentCookieCount >= WeaponCost and PurchasedWeapon = false):
            # ZombieZoneWeaponsGranter.CycleToNextItem(Player)
            set GameManager.CurrentCookieCount -= WeaponCost
            ZombieZoneWeaponsGranter.SetNextItem(NextWeaponItemIndex)
            WeaponButon.SetText(StringToMessage("EQUIP"))
            case(NextWeaponItemIndex):
                1=> 
                    set PurchasedWeapon1 = true
                    # Print("PurchasedWeapon1 is now true!", ?Duration := 2.0, ?Color := NamedColors.Yellow)
                2=> 
                    set PurchasedWeapon2 = true
                    # Print("PurchasedWeapon2 is now true!", ?Duration := 2.0, ?Color := NamedColors.Yellow)
                3=> 
                    set PurchasedWeapon3 = true
                    # Print("PurchasedWeapon3 is now true!", ?Duration := 2.0, ?Color := NamedColors.Yellow)
                4=> 
                    set PurchasedWeapon4 = true
                    # Print("PurchasedWeapon4 is now true!", ?Duration := 2.0, ?Color := NamedColors.Yellow)
                5=> 
                    set PurchasedWeapon5 = true
                    # Print("PurchasedWeapon1 is now true!", ?Duration := 2.0, ?Color := NamedColors.Yellow)
                _=> 
                    Print(
                        "No valid index weapon passed in", 
                        ?Duration := 2.0, 
                        ?Color := NamedColors.Red
                    )
        else if(PurchasedWeapon = true):
            ZombieZoneWeaponsGranter.SetNextItem(NextWeaponItemIndex)
            # Print("{NextWeaponItemIndex}th Weapon Equiped!", ?Duration := 2.5, ?Color := NamedColors.LightBlue)
        else if(GameManager.CurrentCookieCount <= WeaponCost):
            NotEnoughCookiesMessage.Show(Player)

    HandleExit(Message : widget_message): void = 
        Player := Message.Player
        if(PlayerUI := GetPlayerUI[Player]):
            PlayerUI.RemoveWidget(ShopCanvas)
        

Shop_UI := class(creative_device):

    var ShopComponentPerAgent:[agent]Shop = map{}

    @editable GameManager : game_manager = game_manager{}
    @editable ShopMutatorZone : mutator_zone_device = mutator_zone_device{}
    @editable NotEnoughCookiesMessage : hud_message_device = hud_message_device{}

    @editable ZombieZoneWeaponsGranter : item_granter_device = item_granter_device{}

    OnBegin<override>()<suspends>:void=
        ShopMutatorZone.AgentEntersEvent.Subscribe(OpenShopUI)

    OpenShopUI(Agent : agent): void =
        if(Player := player[Agent], PlayerUI := GetPlayerUI[Player], ExistingShop := ShopComponentPerAgent[Agent]):
            PlayerUI.AddWidget(ExistingShop.GetShopUI(), player_ui_slot{InputMode := ui_input_mode.All})
            # Print("Already Exising shop UI opened!", ?Duration := 5.0, ?Color := NamedColors.LightGreen)
        else:
            if(Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
                # Print("New Shop UI Created!", ?Duration := 5.0, ?Color := NamedColors.Orange)
                NewShop : Shop = Shop{GameManager := GameManager, ZombieZoneWeaponsGranter := ZombieZoneWeaponsGranter, NotEnoughCookiesMessage := NotEnoughCookiesMessage}
                if(set ShopComponentPerAgent[Agent] = NewShop):
                    PlayerUI.AddWidget(NewShop.GetShopUI(), player_ui_slot{InputMode := ui_input_mode.All})
        

        

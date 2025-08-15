using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors }


CookieClickerShop := class():
    var GameManager : game_manager = game_manager{}

    var ShopUIClass : CookieClickerShop_UI = CookieClickerShop_UI{}

    var ShopMultiplierCanvas : canvas = canvas{}

    var Multiplierx2Button : button_loud = button_loud{}
    var Multiplierx3Button : button_loud = button_loud{}
    var Multiplierx5Button : button_loud = button_loud{}
    var Multiplierx10Button : button_loud = button_loud{}

    var CloseButton : button_loud = button_loud{}

    var Title : text_block = text_block{}
    var Description : text_block = text_block{}

    var Multiplierx2Text : text_block = text_block{}
    var Multiplierx3Text : text_block = text_block{}
    var Multiplierx5Text : text_block = text_block{}
    var Multiplierx10Text : text_block = text_block{}

    var NotEnoughCookiesMessage : hud_message_device = hud_message_device{}
    var CookieMultiplerHUDMessage : hud_message_device = hud_message_device{}

    var Cookiex2MultiplierCost : int = 1000
    var Cookiex3MultiplierCost : int = 3000
    var Cookiex5MultiplierCost : int = 5000
    var Cookiex10MultiplierCost : int = 10000

    var PurchasedCookieMultiplierx2 : logic = false
    var PurchasedCookieMultiplierx3 : logic = false
    var PurchasedCookieMultiplierx5 : logic = false
    var PurchasedCookieMultiplierx10 : logic = false

    var ShopBackground : texture_block = texture_block{DefaultImage := UI.CookieClickerUI}

    GetCookieMultiplierShopUI(): canvas =
        ShopMultiplierCanvas.AddWidget(canvas_slot:
            Widget := ShopBackground, 
            Anchors := anchors{Minimum := vector2{X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5}},
            Offsets := margin{Left:= 23.953552, Top := -5.629639, Right := 1433.828979, Bottom:= 1061.821777},
            Alignment := vector2{X:= 0.5, Y:= 0.5},
            SizeToContent := false,
            ZOrder := 0
        )
        ShopMultiplierCanvas.AddWidget(canvas_slot:
            Widget := Multiplierx2Button, 
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}},
            Offsets := margin{Left:= 540.000000, Top := 576.000000, Right := 201.301315, Bottom:= 45.525539},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := false,
            ZOrder := 1
        )
        ShopMultiplierCanvas.AddWidget(canvas_slot:
            Widget := Multiplierx3Button, 
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}},
            Offsets := margin{Left:= 888.000000, Top := 580.000000, Right := 201.301315, Bottom:= 45.525539},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := false,
            ZOrder := 1
        )
        ShopMultiplierCanvas.AddWidget(canvas_slot:
            Widget := Multiplierx5Button, 
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}},
            Offsets := margin{Left:= 544.000000, Top := 868.000000, Right := 201.301315, Bottom:= 45.525539},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := false,
            ZOrder := 1
        )
        ShopMultiplierCanvas.AddWidget(canvas_slot:
            Widget := Multiplierx10Button, 
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}},
            Offsets := margin{Left:= 892.000000, Top := 868.000000, Right := 201.301315, Bottom:= 45.525539},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := false,
            ZOrder := 1
        )
        ShopMultiplierCanvas.AddWidget(canvas_slot:
            Widget := CloseButton, 
            Anchors := anchors{Minimum := vector2{X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5}},
            Offsets := margin{Left:= 247.039062, Top := 303.459473, Right := 213.313324, Bottom:= 54.414413},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := false,
            ZOrder := 1
        )
        ShopMultiplierCanvas.AddWidget(canvas_slot:
            Widget := Title, 
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}},
            Offsets := margin{Left:= 816.000000, Top := 168.000000, Right := 165.000000, Bottom:= 41.000000},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := true,
            ZOrder := 1
        )
        ShopMultiplierCanvas.AddWidget(canvas_slot:
            Widget := Description, 
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}},
            Offsets := margin{Left:= 704.000000, Top := 248.000000, Right := -228.993988, Bottom:= 19.378378},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := true,
            ZOrder := 1
        )
        ShopMultiplierCanvas.AddWidget(canvas_slot:
            Widget := Multiplierx2Text, 
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}},
            Offsets := margin{Left:= 692.000000, Top := 512.000000, Right := 165.000000, Bottom:= 41.000000},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := true,
            ZOrder := 1
        )
        ShopMultiplierCanvas.AddWidget(canvas_slot:
            Widget := Multiplierx3Text, 
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}},
            Offsets := margin{Left:= 1048.000000, Top := 516.000000, Right := 165.000000, Bottom:= 41.000000},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := true,
            ZOrder := 1
        )
        ShopMultiplierCanvas.AddWidget(canvas_slot:
            Widget := Multiplierx5Text, 
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}},
            Offsets := margin{Left:= 688.000000, Top := 804.000000, Right := 165.000000, Bottom:= 41.000000},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := true,
            ZOrder := 1
        )
        ShopMultiplierCanvas.AddWidget(canvas_slot:
            Widget := Multiplierx10Text, 
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}},
            Offsets := margin{Left:= 1052.000000, Top := 808.000000, Right := 165.000000, Bottom:= 41.000000},
            Alignment := vector2{X:= 0.0, Y:= 0.0},
            SizeToContent := true,
            ZOrder := 1
        )

        CloseButton.OnClick().Subscribe(HandleExit)
        # CloseButton.OnClick().Subscribe(ChangeUIPage)
        Multiplierx2Button.OnClick().Subscribe(BuyMultiplier2)
        Multiplierx3Button.OnClick().Subscribe(BuyMultiplier3)
        Multiplierx5Button.OnClick().Subscribe(BuyMultiplier5)
        Multiplierx10Button.OnClick().Subscribe(BuyMultiplier10)
        
        if(PurchasedCookieMultiplierx2 = false):
            Multiplierx2Button.SetText(StringToMessage("1k"))

        if(PurchasedCookieMultiplierx3 = false):
            Multiplierx3Button.SetText(StringToMessage("3k"))

        if(PurchasedCookieMultiplierx5 = false):
            Multiplierx5Button.SetText(StringToMessage("5k"))
        
        if(PurchasedCookieMultiplierx10 = false):
            Multiplierx10Button.SetText(StringToMessage("10k"))


        Title.SetText(StringToMessage("Cookie Clicker Shop"))
        Title.SetTextColor(NamedColors.White)

        Description.SetText(StringToMessage("Purchase Cookie Clicker Multiplier"))
        Description.SetTextColor(NamedColors.White)

        Multiplierx2Text.SetText(StringToMessage("x2"))
        Multiplierx2Text.SetTextColor(NamedColors.White)

        Multiplierx3Text.SetText(StringToMessage("x3"))
        Multiplierx3Text.SetTextColor(NamedColors.White)

        Multiplierx5Text.SetText(StringToMessage("x5"))
        Multiplierx5Text.SetTextColor(NamedColors.White)

        Multiplierx10Text.SetText(StringToMessage("x10"))
        Multiplierx10Text.SetTextColor(NamedColors.White)

        CloseButton.SetText(StringToMessage("CLOSE"))

        return ShopMultiplierCanvas


    StringToMessage<localizes>(String : string) : message = "{String}"
        
    BuyMultiplier2(Message : widget_message): void =
        Player := Message.Player
        OnWeaponPurchased(Cookiex2MultiplierCost, PurchasedCookieMultiplierx2, 1, Player, Multiplierx2Button)

    BuyMultiplier3(Message : widget_message): void =
        Player := Message.Player
        OnWeaponPurchased(Cookiex3MultiplierCost, PurchasedCookieMultiplierx3, 2, Player, Multiplierx3Button)

    BuyMultiplier5(Message : widget_message): void =
        Player := Message.Player
        OnWeaponPurchased(Cookiex5MultiplierCost, PurchasedCookieMultiplierx5, 3, Player, Multiplierx5Button)

    BuyMultiplier10(Message : widget_message): void =
        Player := Message.Player
        OnWeaponPurchased(Cookiex10MultiplierCost, PurchasedCookieMultiplierx10, 4, Player, Multiplierx10Button)


    OnWeaponPurchased(MultiplierCost : int, PurchasedWeapon : logic, NextWeaponItemIndex : int, Player : player, WeaponButon : button_loud): void = 
        if(GameManager.CurrentCookieCount >= MultiplierCost and PurchasedWeapon = false):
            # ZombieZoneWeaponsGranter.CycleToNextItem(Player)
            set GameManager.CurrentCookieCount -= MultiplierCost
            WeaponButon.SetText(StringToMessage("APPLY"))
            case(NextWeaponItemIndex):
                1=> 
                    set PurchasedCookieMultiplierx2 = true
                    CookieMultiplerHUDMessage.SetText(StringToMessage("+2🍪"))
                    # Print("Multiplier X2 has now been applied!", ?Duration := 2.0, ?Color := NamedColors.Yellow)
                    set GameManager.AmountToAddPerClick = 2
                2=> 
                    set PurchasedCookieMultiplierx3 = true
                    CookieMultiplerHUDMessage.SetText(StringToMessage("+3🍪"))
                    # Print("Multiplier X3 has now been applied!", ?Duration := 2.0, ?Color := NamedColors.Yellow)
                    set GameManager.AmountToAddPerClick = 3
                3=> 
                    set PurchasedCookieMultiplierx5 = true
                    CookieMultiplerHUDMessage.SetText(StringToMessage("+5🍪"))
                    # Print("Multiplier X5 has now been applied!", ?Duration := 2.0, ?Color := NamedColors.Yellow)
                    set GameManager.AmountToAddPerClick = 5
                4=> 
                    set PurchasedCookieMultiplierx10 = true
                    CookieMultiplerHUDMessage.SetText(StringToMessage("+10🍪"))
                    # Print("Multiplier X10 has now been applied!", ?Duration := 2.0, ?Color := NamedColors.Yellow)
                    set GameManager.AmountToAddPerClick = 10
                _=> 
                    Print(
                        "No valid index weapon passed in", 
                        ?Duration := 2.0, 
                        ?Color := NamedColors.Red
                    )
        else if(PurchasedWeapon = true):
            # Print("{NextWeaponItemIndex}th Weapon Equiped!", ?Duration := 2.5, ?Color := NamedColors.LightBlue)
        else if(GameManager.CurrentCookieCount <= MultiplierCost):
            NotEnoughCookiesMessage.Show(Player)

    HandleExit(Message : widget_message): void = 
        Player := Message.Player
        if(PlayerUI := GetPlayerUI[Player]):
            PlayerUI.RemoveWidget(ShopMultiplierCanvas)
    


CookieClickerShop_UI := class(creative_device):

    var ShopComponentPerAgent:[agent]CookieClickerShop = map{}

    @editable GameManager : game_manager = game_manager{}
    @editable ShopMutatorZone : mutator_zone_device = mutator_zone_device{}
    @editable NotEnoughCookiesMessage : hud_message_device = hud_message_device{}
    @editable CookieHudDevice : hud_message_device = hud_message_device{}

    OnBegin<override>()<suspends>:void=
        ShopMutatorZone.AgentEntersEvent.Subscribe(OpenShopUI)

    OpenShopUI(Agent : agent): void =
        if(Player := player[Agent], PlayerUI := GetPlayerUI[Player], ExistingShop := ShopComponentPerAgent[Agent]):
            PlayerUI.AddWidget(ExistingShop.GetCookieMultiplierShopUI(), player_ui_slot{InputMode := ui_input_mode.All})
            # Print(
            #     "Already Exising Cookie Multiplier shop UI opened!", 
            #     ?Duration := 5.0, 
            #     ?Color := NamedColors.LightGreen
            # )
        else:
            if(Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
                # Print(
                #     "New Cookie Multiplier Shop UI Created!", 
                #     ?Duration := 5.0, 
                #     ?Color := NamedColors.Orange
                # )
                NewShop : CookieClickerShop = CookieClickerShop{GameManager := GameManager, NotEnoughCookiesMessage := NotEnoughCookiesMessage, CookieMultiplerHUDMessage := CookieHudDevice}
                if(set ShopComponentPerAgent[Agent] = NewShop):
                    PlayerUI.AddWidget(NewShop.GetCookieMultiplierShopUI(), player_ui_slot{InputMode := ui_input_mode.All})
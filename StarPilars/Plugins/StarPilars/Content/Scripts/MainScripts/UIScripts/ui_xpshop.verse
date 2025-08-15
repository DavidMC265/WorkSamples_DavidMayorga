using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { Lib }


ui_xpshop<public> := class(base_ui):
    
    BackgroundImg<private>: texture_block = texture_block{ DefaultImage := UI_Bounty.fondo_metalico1 }
    UITitleText<private>: text_block = text_block { DefaultTextColor := NamedColors.Yellow }
    CloseUIButton<private>: button_loud = button_loud {}

    BuyButtonText<private><localizes>: message = "Buy"

    VerySmallXPText<private><localizes>: message = "Very Small"
    VerySmallXPTextBlock<private>: text_block= text_block { DefaultTextColor := NamedColors.Black}
    VerySmallXPBuyButton<private>: button_regular = button_regular{}
    VerySmallXPIconImage<private>: texture_block = texture_block { DefaultImage := UI_Bounty.XP_Img, DefaultDesiredSize := vector2{ X := 100.000000, Y := 100.000000 } }
    VerySmallXPCostAmountText<private> : text_block= text_block { DefaultTextColor := NamedColors.Yellow }
    var VerySmallXPCostAmount<private> : int = 0
    VerySmallCreditIconImage<private>: texture_block = texture_block { DefaultImage := UI_Bounty.STWMONEDA , DefaultDesiredSize := vector2{ X := 50.000000, Y := 50.000000 }}

    SmallXPText<private><localizes>: message = "Small"
    SmallXPTextBlock<private>: text_block= text_block { DefaultTextColor := NamedColors.Black }
    SmallXPBuyButton<private>: button_regular = button_regular{}
    SmallXPIconImage<private>: texture_block = texture_block { DefaultImage := UI_Bounty.XP_Img , DefaultDesiredSize := vector2{ X := 100.000000, Y := 100.000000 } }
    SmallXPCostAmountText<private> : text_block= text_block { DefaultTextColor := NamedColors.Yellow }
    var SmallXPCostAmount<private> : int = 0
    SmallCreditIconImage<private>: texture_block = texture_block { DefaultImage := UI_Bounty.STWMONEDA }

    MediumXPText<private><localizes>: message = "Medium"
    MediumXPTextBlock<private>: text_block= text_block { DefaultTextColor := NamedColors.Black }
    MediumXPBuyButton<private>: button_regular = button_regular{}
    MediumXPIconImage<private>: texture_block = texture_block { DefaultImage := UI_Bounty.XP_Img , DefaultDesiredSize := vector2{ X := 100.000000, Y := 100.000000 } }
    MediumXPCostAmountText<private> : text_block= text_block { DefaultTextColor := NamedColors.Yellow }
    var MediumXPCostAmount<private> : int = 0
    MediumCreditIconImage<private>: texture_block = texture_block { DefaultImage := UI_Bounty.STWMONEDA , DefaultDesiredSize := vector2{ X := 50.000000, Y := 50.000000 } }

    LargeXPText<private><localizes>: message = "Large"
    LargeXPTextBlock<private>: text_block= text_block { DefaultTextColor := NamedColors.Black }
    LargeXPBuyButton<private>: button_regular = button_regular{}
    LargeXPIconImage<private>: texture_block = texture_block { DefaultImage := UI_Bounty.XP_Img , DefaultDesiredSize := vector2{ X := 100.000000, Y := 100.000000 } }
    LargeXPCostAmountText<private> : text_block= text_block { DefaultTextColor := NamedColors.Yellow }
    var LargeXPCostAmount<private> : int = 0
    LargeCreditIconImage<private>: texture_block = texture_block { DefaultImage := UI_Bounty.STWMONEDA , DefaultDesiredSize := vector2{ X := 50.000000, Y := 50.000000 }}

    VeryLargeXPText<private><localizes>: message = "Very Large"
    VeryLargeXPTextBlock<private>: text_block= text_block { DefaultTextColor := NamedColors.Black }
    VeryLargeXPBuyButton<private>: button_regular = button_regular{}
    VeryLargeXPIconImage<private>: texture_block = texture_block { DefaultImage := UI_Bounty.XP_Img , DefaultDesiredSize := vector2{ X := 100.000000, Y := 100.000000 } }
    VeryLargeXPCostAmountText<private> : text_block= text_block { DefaultTextColor := NamedColors.Yellow }
    var VeryLargeXPCostAmount<private> : int = 0
    VeryLargeCreditIconImage<private>: texture_block = texture_block { DefaultImage := UI_Bounty.STWMONEDA , DefaultDesiredSize := vector2{ X := 50.000000, Y := 50.000000 }}


    
    CreateCanvas<override>():void=
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{ Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := 0.000000, Top := 0.000000, Right := 700.000000, Bottom := 1050.000000 }
                    Alignment := vector2{ X:= 0.5, Y:= 0.5 }
                    ZOrder := 0
                    SizeToContent := false
                    Widget := MainOverlay()

        VerySmallXPBuyButton.OnClick().Subscribe(AttemptBuyVerySmallXP)
        SmallXPBuyButton.OnClick().Subscribe(AttemptBuySmallXP)
        MediumXPBuyButton.OnClick().Subscribe(AttemptBuyMediumXP)
        LargeXPBuyButton.OnClick().Subscribe(AttemptBuyLargeXP)
        VeryLargeXPBuyButton.OnClick().Subscribe(AttemptBuyVeryLargeXP)


    MainOverlay(): overlay =
        MyOverlay : overlay = overlay:
            Slots := array:
                overlay_slot:
                    Widget := BackgroundImg
                    HorizontalAlignment := horizontal_alignment.Fill
                    VerticalAlignment := vertical_alignment.Fill
                    Padding := margin{ Left := 0.0, Top := 0.0, Right := 0.0, Bottom := 0.0 }
                overlay_slot:
                    Widget := UITitleStackBox()
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin{ Left := 0.0, Top := 130.0, Right := 0.0, Bottom := 0.0 }
                overlay_slot:
                    Widget :=  MainRowStackBox()
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding := margin{ Left := 0.0, Top := 0.0, Right := 0.0, Bottom := 25.0 }
                overlay_slot:
                    Widget := UIBottomStackBox()
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Bottom
                    Padding := margin{ Left := 0.0, Top := 15.0, Right := 0.0, Bottom := 125.0 }

        return MyOverlay

    
    SetTextPrices<public>(VerySmallAmount : int, SmallAmount : int, MediumAmount : int, LargeAmount : int, VeryLargeAmount : int): void=
        VerySmallXPCostAmountText.SetText( StringToMessage ("{VerySmallAmount}") )
        SmallXPCostAmountText.SetText( StringToMessage ("{SmallAmount}") )
        MediumXPCostAmountText.SetText( StringToMessage ("{MediumAmount}") )
        LargeXPCostAmountText.SetText( StringToMessage ("{LargeAmount}") )
        VeryLargeXPCostAmountText.SetText( StringToMessage ("{VeryLargeAmount}") )

        set VerySmallXPCostAmount = VerySmallAmount
        set SmallXPCostAmount = SmallAmount
        set MediumXPCostAmount = MediumAmount
        set LargeXPCostAmount = LargeAmount
        set VeryLargeXPCostAmount = VeryLargeAmount


    UITitleStackBox(): stack_box =
        UITitleText.SetText( StringToMessage("XP Shop") )

        TitleStackBox : stack_box = stack_box:
            Orientation := orientation.Horizontal
            Slots := array: 
                stack_box_slot:
                    Widget := UITitleText
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
        
        return TitleStackBox


    UIBottomStackBox(): stack_box =
        CloseUIButton.SetText( StringToMessage("Close") )

        BottomStackBox : stack_box = stack_box:
            Orientation := orientation.Horizontal
            Slots := array: 
                stack_box_slot:
                    Widget := CloseUIButton
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding:= margin{ Top := 0.0, Left := 15.0, Right := 0.0, Bottom := 0.0 }

        CloseUIButton.OnClick().Subscribe(CloseUIForPlayer)
        
        return BottomStackBox


    CloseUIForPlayer(WidgetPlayer : widget_message): void =
        if(PlayerData := MaybePlayerData?):
            PlayerData.HideXPShopUI()


    MainRowStackBox(): stack_box =
        StackBox : stack_box = stack_box:
            Orientation := orientation.Vertical
            Slots := array: 
                stack_box_slot:
                    Widget := Row1StackBox()
                    HorizontalAlignment := horizontal_alignment.Fill
                    VerticalAlignment := vertical_alignment.Fill
                    Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                stack_box_slot:
                    Widget := Row2StackBox()
                    HorizontalAlignment := horizontal_alignment.Fill
                    VerticalAlignment := vertical_alignment.Fill
                    Padding:= margin{ Top := 15.0, Left := 0.000000, Right := 0.0, Bottom := 0.0 }

        return StackBox



    Row1StackBox(): stack_box =
        StackBox : stack_box = stack_box:
            Orientation := orientation.Horizontal
            Slots := array: 
                stack_box_slot:
                    Widget := ShopItemSlot(VerySmallXPText, VerySmallXPTextBlock, VerySmallXPBuyButton, VerySmallXPIconImage, VerySmallXPCostAmountText, VerySmallCreditIconImage)
                    HorizontalAlignment := horizontal_alignment.Fill
                    VerticalAlignment := vertical_alignment.Fill
                    Padding:= margin{ Top := 0.0, Left := 0.0, Right := 50.0, Bottom := 0.0 }
                stack_box_slot:
                    Widget := ShopItemSlot(SmallXPText, SmallXPTextBlock, SmallXPBuyButton, SmallXPIconImage, SmallXPCostAmountText, SmallCreditIconImage)
                    HorizontalAlignment := horizontal_alignment.Fill
                    VerticalAlignment := vertical_alignment.Fill
                    Padding:= margin{ Top := 0.0, Left := 0.000000, Right := 50.0, Bottom := 0.0 }
                stack_box_slot:
                    Widget := ShopItemSlot(MediumXPText, MediumXPTextBlock, MediumXPBuyButton, MediumXPIconImage, MediumXPCostAmountText, MediumCreditIconImage)
                    HorizontalAlignment := horizontal_alignment.Fill
                    VerticalAlignment := vertical_alignment.Fill
                    Padding:= margin{ Top := 0.0, Left := 0.000000, Right := 0.0, Bottom := 0.0 }

        return StackBox


    Row2StackBox(): stack_box =
        StackBox : stack_box = stack_box:
            Orientation := orientation.Horizontal
            Slots := array: 
                stack_box_slot:
                    Widget := ShopItemSlot(LargeXPText, LargeXPTextBlock, LargeXPBuyButton, LargeXPIconImage, LargeXPCostAmountText, LargeCreditIconImage)
                    HorizontalAlignment := horizontal_alignment.Fill
                    VerticalAlignment := vertical_alignment.Fill
                    Padding:= margin{ Top := 0.0, Left := 110.0, Right := 50.0, Bottom := 0.0 }
                stack_box_slot:
                    Widget := ShopItemSlot(VeryLargeXPText, VeryLargeXPTextBlock, VeryLargeXPBuyButton, VeryLargeXPIconImage, VeryLargeXPCostAmountText, VeryLargeCreditIconImage)
                    HorizontalAlignment := horizontal_alignment.Fill
                    VerticalAlignment := vertical_alignment.Fill
                    Padding:= margin{ Top := 0.0, Left := 0.000000, Right := 0.0, Bottom := 0.0 }

        return StackBox


    ShopItemSlot(ItemNameMessage : message, ItemNameTextBlock : text_block, ItemBuyButton : button_regular, ItemXPIconImage : texture_block, ItemCostAmountTextBlock : text_block, ItemCreditsIconImage : texture_block): stack_box =
        ItemNameTextBlock.SetText( ItemNameMessage )
        ItemBuyButton.SetText(BuyButtonText)

        StackBox : stack_box = stack_box:
            Orientation := orientation.Vertical
                Slots := array: 
                    stack_box_slot:
                        Widget := ItemNameTextBlock
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Center
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := ItemXPIconImage
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Center
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := ItemCostStackBox(ItemCostAmountTextBlock, ItemCreditsIconImage)
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Center
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := ItemBuyButton
                        HorizontalAlignment := horizontal_alignment.Fill
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 20.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    
        return StackBox


    ItemCostStackBox(ItemCostAmountTextBlock : text_block, ItemCreditsIconImage : texture_block): stack_box =
        StackBox : stack_box = stack_box:
            Orientation := orientation.Horizontal
                Slots := array: 
                    stack_box_slot:
                        Widget := ItemCostAmountTextBlock
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Center
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := ItemCreditsIconImage
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    
        return StackBox


    AttemptBuyVerySmallXP(WidgetPlayer : widget_message): void =
        if:
            Player := WidgetPlayer.Player
            GameManager := MaybeGameManager?
            AccoladeManager := GameManager.MaybeAccoladeManager?
            XPShop := GameManager.MaybeXPShop?
            PlayerData := MaybePlayerData?
        then:
            PlayerCurrency := PlayerData.GetCurrency()
            if:
                PlayerCurrencyInt := Floor[PlayerCurrency]
                PlayerCurrencyInt >= VerySmallXPCostAmount
            then:
                UpdatedCurrencyInt := PlayerCurrencyInt - VerySmallXPCostAmount
                UpdatedCurrency := UpdatedCurrencyInt * 1.0
                PlayerData.SetCurrency(UpdatedCurrency)
                AccoladeManager.GrantVerySmallAccolade(Player)
            else:
                XPShop.CantPurchaseXP_HUDMessage.Show(Player)


    AttemptBuySmallXP(WidgetPlayer : widget_message): void =
        if:
            Player := WidgetPlayer.Player
            GameManager := MaybeGameManager?
            AccoladeManager := GameManager.MaybeAccoladeManager?
            XPShop := GameManager.MaybeXPShop?
            PlayerData := MaybePlayerData?
        then:
            PlayerCurrency := PlayerData.GetCurrency()
            if:
                PlayerCurrencyInt := Floor[PlayerCurrency]
                PlayerCurrencyInt >= SmallXPCostAmount
            then:
                UpdatedCurrencyInt := PlayerCurrencyInt - SmallXPCostAmount
                UpdatedCurrency := UpdatedCurrencyInt * 1.0
                PlayerData.SetCurrency(UpdatedCurrency)
                AccoladeManager.GrantSmallAccolade(Player)
            else:
                XPShop.CantPurchaseXP_HUDMessage.Show(Player)


    AttemptBuyMediumXP(WidgetPlayer : widget_message): void =
        if:
            Player := WidgetPlayer.Player
            GameManager := MaybeGameManager?
            AccoladeManager := GameManager.MaybeAccoladeManager?
            XPShop := GameManager.MaybeXPShop?
            PlayerData := MaybePlayerData?
        then:
            PlayerCurrency := PlayerData.GetCurrency()
            if:
                PlayerCurrencyInt := Floor[PlayerCurrency]
                PlayerCurrencyInt >= MediumXPCostAmount
            then:
                UpdatedCurrencyInt := PlayerCurrencyInt - MediumXPCostAmount
                UpdatedCurrency := UpdatedCurrencyInt * 1.0
                PlayerData.SetCurrency(UpdatedCurrency)
                AccoladeManager.GrantMediumAccolade(Player)
            else:
                XPShop.CantPurchaseXP_HUDMessage.Show(Player)


    AttemptBuyLargeXP(WidgetPlayer : widget_message): void =
        if:
            Player := WidgetPlayer.Player
            GameManager := MaybeGameManager?
            AccoladeManager := GameManager.MaybeAccoladeManager?
            XPShop := GameManager.MaybeXPShop?
            PlayerData := MaybePlayerData?
        then:
            PlayerCurrency := PlayerData.GetCurrency()
            if:
                PlayerCurrencyInt := Floor[PlayerCurrency]
                PlayerCurrencyInt >= LargeXPCostAmount
            then:
                UpdatedCurrencyInt := PlayerCurrencyInt - LargeXPCostAmount
                UpdatedCurrency := UpdatedCurrencyInt * 1.0
                PlayerData.SetCurrency(UpdatedCurrency)
                AccoladeManager.GrantLargeAccolade(Player)
            else:
                XPShop.CantPurchaseXP_HUDMessage.Show(Player)


    AttemptBuyVeryLargeXP(WidgetPlayer : widget_message): void =
        if:
            Player := WidgetPlayer.Player
            GameManager := MaybeGameManager?
            AccoladeManager := GameManager.MaybeAccoladeManager?
            XPShop := GameManager.MaybeXPShop?
            PlayerData := MaybePlayerData?
        then:
            PlayerCurrency := PlayerData.GetCurrency()
            if:
                PlayerCurrencyInt := Floor[PlayerCurrency]
                PlayerCurrencyInt >= VeryLargeXPCostAmount
            then:
                UpdatedCurrencyInt := PlayerCurrencyInt - VeryLargeXPCostAmount
                UpdatedCurrency := UpdatedCurrencyInt * 1.0
                PlayerData.SetCurrency(UpdatedCurrency)
                AccoladeManager.GrantVeryLargeAccolade(Player)
            else:
                XPShop.CantPurchaseXP_HUDMessage.Show(Player)

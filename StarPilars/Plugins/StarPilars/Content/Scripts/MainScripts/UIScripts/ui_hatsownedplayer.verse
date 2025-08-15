using { /Fortnite.com }
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { GameAreas }
using { UI }
using { UI_Pillars }


#using { /UnrealEngine.com/SpatialMath }

ui_hatsownedplayer<public> := class(base_ui):

    BackgroundImg<private>: texture_block = texture_block{ DefaultImage := UI_Bounty.fondo_metalico1 }
    UITitleText<private>: text_block = text_block { DefaultTextColor := NamedColors.Yellow }
    CloseUIButton<private>: button_loud = button_loud{}
    RemoveHatButton<private>: button_loud = button_loud{}

    Hat1Img<private>: texture_block = texture_block { DefaultImage := UIHatStore.Casco_scout1, DefaultDesiredSize := vector2{ X := 150.000000, Y := 150.000000 } }
    Hat1Button<private>: button_loud = button_loud {}
    Hat1NameText<private> : text_block = text_block{ DefaultTextColor := NamedColors.Yellow }
    var MaybeHat1Subscription:?cancelable = false

    Hat2Img<private>: texture_block = texture_block { DefaultImage := UIHatStore.Capitainrex_icon, DefaultDesiredSize := vector2{ X := 150.000000, Y := 150.000000 } }
    Hat2Button<private>: button_loud = button_loud {}
    Hat2NameText<private> : text_block = text_block{ DefaultTextColor := NamedColors.Yellow }

    Hat3Img<private>: texture_block = texture_block { DefaultImage := UIHatStore.bo_katan_Icon, DefaultDesiredSize := vector2{ X := 150.000000, Y := 150.000000 } }
    Hat3Button<private>: button_loud = button_loud {}
    Hat3NameText<private> : text_block = text_block{ DefaultTextColor := NamedColors.Yellow }

    Hat4Img<private>: texture_block = texture_block { DefaultImage := UIHatStore.casco_darth, DefaultDesiredSize := vector2{ X := 150.000000, Y := 150.000000 } }
    Hat4Button<private>: button_loud = button_loud {}
    Hat4NameText<private> : text_block = text_block{ DefaultTextColor := NamedColors.Yellow }

    Hat5Img<private>: texture_block = texture_block { DefaultImage := UIHatStore.Sombrero_Yoda, DefaultDesiredSize := vector2{ X := 150.000000, Y := 150.000000 } }
    Hat5Button<private>: button_loud = button_loud {}
    Hat5NameText<private> : text_block = text_block{ DefaultTextColor := NamedColors.Yellow }

    Hat6Img<private>: texture_block = texture_block { DefaultImage := UIHatStore.r2d2_icon, DefaultDesiredSize := vector2{ X := 150.000000, Y := 150.000000 } }
    Hat6Button<private>: button_loud = button_loud {}
    Hat6NameText<private> : text_block = text_block{ DefaultTextColor := NamedColors.Yellow }

    Hat7Img<private>: texture_block = texture_block { DefaultImage := UIHatStore.bb8_Icon, DefaultDesiredSize := vector2{ X := 150.000000, Y := 150.000000 } }
    Hat7Button<private>: button_loud = button_loud {}
    Hat7NameText<private> : text_block = text_block{ DefaultTextColor := NamedColors.Yellow }


    StringToMessage<private><localizes>(String : string): message = "{String}"


    CreateCanvas<override>():void=
        #Print("Canvas createddddd", ?Duration := 7.0, ?Color := NamedColors.Yellow)
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{ Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{ Left := 0.000000, Top := 0.000000, Right := 1600.000000, Bottom := 1100.0 }
                    Alignment := vector2{ X:= 0.5, Y:= 0.5 }
                    ZOrder := 0
                    SizeToContent := false
                    Widget := MainOverlay()

        CloseUIButton.SetText( StringToMessage("Close") )


    SubscribeButtonEvents<public>(): void =
        CloseUIButton.OnClick().Subscribe( OnCloseUIButtonPressed )

        Hat1Button.OnClick().Subscribe(AttemptToGrantHat1)
        Hat2Button.OnClick().Subscribe(AttemptToGrantHat2)
        Hat3Button.OnClick().Subscribe(AttemptToGrantHat3)
        Hat4Button.OnClick().Subscribe(AttemptToGrantHat4)
        Hat5Button.OnClick().Subscribe(AttemptToGrantHat5)
        Hat6Button.OnClick().Subscribe(AttemptToGrantHat6)
        Hat7Button.OnClick().Subscribe(AttemptToGrantHat7)


    OnCloseUIButtonPressed(WidgetPlayer : widget_message): void =
        if(PlayerData := MaybePlayerData?):
            PlayerData.HideHatsOwnedUI()


    MainOverlay(): overlay =
        MaybeRow1StackBoxWidget := Row1StackBox()
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
                    Padding := margin{ Left := 0.0, Top := 0.0, Right := 0.0, Bottom := 0.0 }
                overlay_slot:
                    Widget :=  Row1StackBox()
                    HorizontalAlignment := horizontal_alignment.Fill
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin{ Left := 0.0, Top := 150.000000, Right := 0.0, Bottom := 0.0 }
                overlay_slot:
                    Widget := Row2StackBox()
                    HorizontalAlignment := horizontal_alignment.Fill
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin{ Left := 0.0, Top := 500.000000, Right := 0.0, Bottom := 0.0 }
                # overlay_slot:
                #     Widget := CloseUIButton
                #     HorizontalAlignment := horizontal_alignment.Right
                #     VerticalAlignment := vertical_alignment.Top
                #     Padding := margin{ Left := 0.0, Top := 120.000000, Right := 70.000000, Bottom := 0.0 }
                overlay_slot:
                    Widget := UIBottomStackBox()
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Bottom
                    Padding := margin{ Left := 0.0, Top := 0.0, Right := 0.0, Bottom := 125.0 }

        return MyOverlay


    UITitleStackBox(): stack_box =
        UITitleText.SetText( StringToMessage("Hat Gallery") )

        TitleStackBox : stack_box = stack_box:
            Orientation := orientation.Horizontal
            Slots := array: 
                stack_box_slot:
                    Widget := UITitleText
                    HorizontalAlignment := horizontal_alignment.Fill
                    VerticalAlignment := vertical_alignment.Fill
                    Padding:= margin{ Top := 110.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
        
        return TitleStackBox


    UIBottomStackBox(): stack_box =
        RemoveHatButton.SetText( StringToMessage("Remove Current Hat") )

        BottomStackBox : stack_box = stack_box:
            Orientation := orientation.Horizontal
            Slots := array: 
                stack_box_slot:
                    Widget := RemoveHatButton
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding:= margin{ Top := 0.0, Left := 0.0, Right := 100.0, Bottom := 0.0 }
                stack_box_slot:
                    Widget := CloseUIButton
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }

        RemoveHatButton.OnClick().Subscribe(RemovePlayerHat)
        
        return BottomStackBox


    RemovePlayerHat(WidgetPlayer : widget_message): void =
        if:
            Player := WidgetPlayer.Player
            GameManager := MaybeGameManager?
            HatStore := GameManager.MaybeHatStore?
            PlayerData := MaybePlayerData?
        then:
            HatStore.RemoveHatTrigger.Trigger(Player)
            HatStore.HatRemovedSFX.Play(Player)
            PlayerData.SetCurrentHat(EHats.None)


    Row1StackBox(): stack_box =
        StackBox : stack_box = stack_box:
            Orientation := orientation.Horizontal
            Slots := array: 
                stack_box_slot:
                    Widget := Slot1StackBox()
                    HorizontalAlignment := horizontal_alignment.Left
                    VerticalAlignment := vertical_alignment.Top
                    Padding:= margin{ Top := 0.0, Left := 100.0, Right := 0.0, Bottom := 0.0 }
                stack_box_slot:
                    Widget := Slot2StackBox()
                    HorizontalAlignment := horizontal_alignment.Left
                    VerticalAlignment := vertical_alignment.Top
                    Padding:= margin{ Top := 0.0, Left := 50.000000, Right := 0.0, Bottom := 0.0 }
                stack_box_slot:
                    Widget := Slot3StackBox()
                    HorizontalAlignment := horizontal_alignment.Left
                    VerticalAlignment := vertical_alignment.Top
                    Padding:= margin{ Top := 0.0, Left := 50.000000, Right := 0.0, Bottom := 0.0 }
                stack_box_slot:
                    Widget := Slot4StackBox()
                    HorizontalAlignment := horizontal_alignment.Left
                    VerticalAlignment := vertical_alignment.Top
                    Padding:= margin{ Top := 0.0, Left := 50.000000, Right := 0.0, Bottom := 0.0 }

        return StackBox


    Row2StackBox(): stack_box =
        StackBox : stack_box = stack_box:
            Orientation := orientation.Horizontal
            Slots := array: 
                stack_box_slot:
                    Widget := Slot5StackBox()
                    HorizontalAlignment := horizontal_alignment.Left
                    VerticalAlignment := vertical_alignment.Top
                    Padding:= margin{ Top := 0.0, Left := 100.0, Right := 0.0, Bottom := 0.0 }
                stack_box_slot:
                    Widget := Slot6StackBox()
                    HorizontalAlignment := horizontal_alignment.Left
                    VerticalAlignment := vertical_alignment.Top
                    Padding:= margin{ Top := 0.0, Left := 50.000000, Right := 0.0, Bottom := 0.0 }
                stack_box_slot:
                    Widget := Slot7StackBox()
                    HorizontalAlignment := horizontal_alignment.Left
                    VerticalAlignment := vertical_alignment.Top
                    Padding:= margin{ Top := 0.0, Left := 50.000000, Right := 0.0, Bottom := 0.0 }

        return StackBox


    Slot1StackBox(): stack_box =
        Hat1NameText.SetText( StringToMessage("Scout Trooper") )

        StackBox : stack_box = stack_box:
            Orientation := orientation.Vertical
                Slots := array: 
                    stack_box_slot:
                        Widget := Hat1NameText
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := Hat1Img
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := Hat1Button
                        HorizontalAlignment := horizontal_alignment.Fill
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 20.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    
        return StackBox


    Slot2StackBox(): stack_box =
        Hat2NameText.SetText( StringToMessage("Captain Rex") )

        StackBox : stack_box = stack_box:
            Orientation := orientation.Vertical
                Slots := array: 
                    stack_box_slot:
                        Widget := Hat2NameText
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := Hat2Img
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := Hat2Button
                        HorizontalAlignment := horizontal_alignment.Fill
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 20.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    
        return StackBox


    Slot3StackBox(): stack_box =
        Hat3NameText.SetText( StringToMessage("Bo Katan") )

        StackBox : stack_box = stack_box:
            Orientation := orientation.Vertical
                Slots := array: 
                    stack_box_slot:
                        Widget := Hat3NameText
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := Hat3Img
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := Hat3Button
                        HorizontalAlignment := horizontal_alignment.Fill
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 20.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    
        return StackBox



    Slot4StackBox(): stack_box =
        Hat4NameText.SetText( StringToMessage("Darth Vader") )

        StackBox : stack_box = stack_box:
            Orientation := orientation.Vertical
                Slots := array: 
                    stack_box_slot:
                        Widget := Hat4NameText
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := Hat4Img
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := Hat4Button
                        HorizontalAlignment := horizontal_alignment.Fill
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 20.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    
        return StackBox


    Slot5StackBox(): stack_box =
        Hat5NameText.SetText( StringToMessage("Grogu") )

        StackBox : stack_box = stack_box:
            Orientation := orientation.Vertical
                Slots := array: 
                    stack_box_slot:
                        Widget := Hat5NameText
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := Hat5Img
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := Hat5Button
                        HorizontalAlignment := horizontal_alignment.Fill
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 20.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    
        return StackBox


    Slot6StackBox(): stack_box =
        Hat6NameText.SetText( StringToMessage("R2-D2") )

        StackBox : stack_box = stack_box:
            Orientation := orientation.Vertical
                Slots := array: 
                    stack_box_slot:
                        Widget := Hat6NameText
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := Hat6Img
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := Hat6Button
                        HorizontalAlignment := horizontal_alignment.Fill
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 20.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    
        return StackBox


    Slot7StackBox(): stack_box =
        Hat7NameText.SetText( StringToMessage("BB8") )

        StackBox : stack_box = stack_box:
            Orientation := orientation.Vertical
                Slots := array: 
                    stack_box_slot:
                        Widget := Hat7NameText
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := Hat7Img
                        HorizontalAlignment := horizontal_alignment.Center
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    stack_box_slot:
                        Widget := Hat7Button
                        HorizontalAlignment := horizontal_alignment.Fill
                        VerticalAlignment := vertical_alignment.Fill
                        Padding:= margin{ Top := 20.0, Left := 0.0, Right := 0.0, Bottom := 0.0 }
                    
        return StackBox


    SetButtonTexts<public>(): void =
        if(PlayerData := MaybePlayerData?, HatsOwnedPlayer := PlayerData.GetHatsOwned(), HatsOwnedPlayer.Find[EHats.ScoutTrooper]):
            Hat1Button.SetText( StringToMessage("EQUIP") )
        else:
            Hat1Button.SetText( StringToMessage("NOT OWNED") )

        if(PlayerData := MaybePlayerData?, HatsOwnedPlayer := PlayerData.GetHatsOwned(), HatsOwnedPlayer.Find[EHats.CaptainRex]):
            Hat2Button.SetText( StringToMessage("EQUIP") )
        else:
            Hat2Button.SetText( StringToMessage("NOT OWNED") )

        if(PlayerData := MaybePlayerData?, HatsOwnedPlayer := PlayerData.GetHatsOwned(), HatsOwnedPlayer.Find[EHats.BoKatan]):
            Hat3Button.SetText( StringToMessage("EQUIP") )
        else:
            Hat3Button.SetText( StringToMessage("NOT OWNED") )

        if(PlayerData := MaybePlayerData?, HatsOwnedPlayer := PlayerData.GetHatsOwned(), HatsOwnedPlayer.Find[EHats.DarthVader]):
            Hat4Button.SetText( StringToMessage("EQUIP") )
        else:
            Hat4Button.SetText( StringToMessage("NOT OWNED") )
 
        if(PlayerData := MaybePlayerData?, HatsOwnedPlayer := PlayerData.GetHatsOwned(), HatsOwnedPlayer.Find[EHats.Grogu]):
            Hat5Button.SetText( StringToMessage("EQUIP") )
        else:
            Hat5Button.SetText( StringToMessage("NOT OWNED") )

        if(PlayerData := MaybePlayerData?, HatsOwnedPlayer := PlayerData.GetHatsOwned(), HatsOwnedPlayer.Find[EHats.R2D2]):
            Hat6Button.SetText( StringToMessage("EQUIP") )
        else:
            Hat6Button.SetText( StringToMessage("NOT OWNED") )

        if(PlayerData := MaybePlayerData?, HatsOwnedPlayer := PlayerData.GetHatsOwned(), HatsOwnedPlayer.Find[EHats.BB8]):
            Hat7Button.SetText( StringToMessage("EQUIP") )
        else:
            Hat7Button.SetText( StringToMessage("NOT OWNED") )



    AttemptToGrantHat1(WidgetPlayer : widget_message): void =
        if:
            Player := WidgetPlayer.Player
            GameManager := MaybeGameManager?
            HatStore := GameManager.MaybeHatStore?
            PlayerData := MaybePlayerData?
        then:
            HatsOwnedPlayer := PlayerData.GetHatsOwned()
            if:
                HatsOwnedPlayer.Find[EHats.ScoutTrooper]
                HatVFX := HatStore.HatVFXs[0]
            then:
                HatVFX.Pickup(Player)
                HatStore.HatEquippedSFX.Play(Player)
                PlayerData.SetCurrentHat(EHats.ScoutTrooper)
                #Print(
                    #"Player is now wearing hat 1 beacuse he owns it!", 
                    #?Duration := 7.0, 
                    #?Color := NamedColors.LightGreen
                #)
            else:
                HatStore.DoesntOwnHatHUDMessage.Show(Player)



    AttemptToGrantHat2(WidgetPlayer : widget_message): void =
        if:
            Player := WidgetPlayer.Player
            GameManager := MaybeGameManager?
            HatStore := GameManager.MaybeHatStore?
            PlayerData := MaybePlayerData?
        then:
            HatsOwnedPlayer := PlayerData.GetHatsOwned()
            if:
                HatsOwnedPlayer.Find[EHats.CaptainRex]
                HatVFX := HatStore.HatVFXs[1]
            then:
                HatVFX.Pickup(Player)
                HatStore.HatEquippedSFX.Play(Player)
                PlayerData.SetCurrentHat(EHats.CaptainRex)
                #Print(
                    #"Player is now wearing hat 2 beacuse he owns it!", 
                    #?Duration := 7.0, 
                    #?Color := NamedColors.LightGreen
                #)
            else:
                HatStore.DoesntOwnHatHUDMessage.Show(Player)



    AttemptToGrantHat3(WidgetPlayer : widget_message): void =
        if:
            Player := WidgetPlayer.Player
            GameManager := MaybeGameManager?
            HatStore := GameManager.MaybeHatStore?
            PlayerData := MaybePlayerData?
        then:
            HatsOwnedPlayer := PlayerData.GetHatsOwned()
            if:
                HatsOwnedPlayer.Find[EHats.BoKatan]
                HatVFX := HatStore.HatVFXs[2]
            then:
                HatVFX.Pickup(Player)
                HatStore.HatEquippedSFX.Play(Player)
                PlayerData.SetCurrentHat(EHats.BoKatan)
                #Print(
                    #"Player is now wearing hat 2 beacuse he owns it!", 
                    #?Duration := 7.0, 
                    #?Color := NamedColors.LightGreen
                #)
            else:
                HatStore.DoesntOwnHatHUDMessage.Show(Player)


    AttemptToGrantHat4(WidgetPlayer : widget_message): void =
        if:
            Player := WidgetPlayer.Player
            GameManager := MaybeGameManager?
            HatStore := GameManager.MaybeHatStore?
            PlayerData := MaybePlayerData?
        then:
            HatsOwnedPlayer := PlayerData.GetHatsOwned()
            if:
                HatsOwnedPlayer.Find[EHats.DarthVader]
                HatVFX := HatStore.HatVFXs[3]
            then:
                HatVFX.Pickup(Player)
                HatStore.HatEquippedSFX.Play(Player)
                PlayerData.SetCurrentHat(EHats.DarthVader)
                #Print(
                    #"Player is now wearing hat 2 beacuse he owns it!", 
                    #?Duration := 7.0, 
                    #?Color := NamedColors.LightGreen
                #)
            else:
                HatStore.DoesntOwnHatHUDMessage.Show(Player)


    AttemptToGrantHat5(WidgetPlayer : widget_message): void =
        if:
            Player := WidgetPlayer.Player
            GameManager := MaybeGameManager?
            HatStore := GameManager.MaybeHatStore?
            PlayerData := MaybePlayerData?
        then:
            HatsOwnedPlayer := PlayerData.GetHatsOwned()
            if:
                HatsOwnedPlayer.Find[EHats.Grogu]
                HatVFX := HatStore.HatVFXs[4]
            then:
                HatVFX.Pickup(Player)
                HatStore.HatEquippedSFX.Play(Player)
                PlayerData.SetCurrentHat(EHats.Grogu)
                #Print(
                    #"Player is now wearing hat 2 beacuse he owns it!", 
                    #?Duration := 7.0, 
                    #?Color := NamedColors.LightGreen
                #)
            else:
                HatStore.DoesntOwnHatHUDMessage.Show(Player)


    AttemptToGrantHat6(WidgetPlayer : widget_message): void =
        if:
            Player := WidgetPlayer.Player
            GameManager := MaybeGameManager?
            HatStore := GameManager.MaybeHatStore?
            PlayerData := MaybePlayerData?
        then:
            HatsOwnedPlayer := PlayerData.GetHatsOwned()
            if:
                HatsOwnedPlayer.Find[EHats.R2D2]
                HatVFX := HatStore.HatVFXs[5]
            then:
                HatVFX.Pickup(Player)
                HatStore.HatEquippedSFX.Play(Player)
                PlayerData.SetCurrentHat(EHats.R2D2)
                #Print(
                    #"Player is now wearing hat 2 beacuse he owns it!", 
                    #?Duration := 7.0, 
                    #?Color := NamedColors.LightGreen
                #)
            else:
                HatStore.DoesntOwnHatHUDMessage.Show(Player)



    AttemptToGrantHat7(WidgetPlayer : widget_message): void =
        if:
            Player := WidgetPlayer.Player
            GameManager := MaybeGameManager?
            HatStore := GameManager.MaybeHatStore?
            PlayerData := MaybePlayerData?
        then:
            HatsOwnedPlayer := PlayerData.GetHatsOwned()
            if:
                HatsOwnedPlayer.Find[EHats.BB8]
                HatVFX := HatStore.HatVFXs[6]
            then:
                HatVFX.Pickup(Player)
                HatStore.HatEquippedSFX.Play(Player)
                PlayerData.SetCurrentHat(EHats.BB8)
                #Print(
                    #"Player is now wearing hat 2 beacuse he owns it!", 
                    #?Duration := 7.0, 
                    #?Color := NamedColors.LightGreen
                #)
            else:
                HatStore.DoesntOwnHatHUDMessage.Show(Player)


                
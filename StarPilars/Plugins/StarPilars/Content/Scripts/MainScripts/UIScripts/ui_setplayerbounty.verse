using { /Fortnite.com }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/FortPlayerUtilities }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { GameAreas }
using { Lib }


ui_setplayerbounty<public> := class(base_ui):

    AmountSlider<private> : slider_regular = slider_regular{}
    BackgroundImg<private> : texture_block = texture_block{ DefaultImage := UI_Bounty.bounty_amount }
    TitleText<private> : text_block = text_block { DefaultTextColor := NamedColors.White }
    CancelButton<private>: button_loud = button_loud{}
    AcceptButton<private>: button_loud = button_loud{}

    CancelButtonBackgroundImg<private>: texture_block = texture_block { DefaultImage := UI_Bounty.Boton_dorado }
    AcceptButtonBackgroundImg<private>: texture_block = texture_block {DefaultImage := UI_Bounty.Boton_dorado}

    MinValueBountyText<private> : text_block = text_block{ DefaultTextColor := NamedColors.White }
    MaxValueBountyText<private> : text_block = text_block{ DefaultTextColor := NamedColors.White }

    TitleTextMessage<private><localizes>: message = "Set Bounty Amount"
    CancelButtonTextMessage<private><localizes>: message = "Cancel"
    AcceptButtonTextMessage<private><localizes>: message = "Accept"

        #Player reference info
    AcceptBountyMessage<private><localizes> : message = "Take Bounty"

    var DialogConfirmButtonSubscription<private>:?cancelable = false


    CreateCanvas<override>():void=
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{Left := -472.960938, Top := -216.540527, Right := 923.714294, Bottom := 436.000000}
                    Alignment := vector2{X:= 0.0, Y:= 0.0}
                    ZOrder := 0
                    SizeToContent := false
                    Widget := BackgroundImg
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{Left := -160.960938, Top := -120.540527, Right := 165.000000, Bottom := 41.000000}
                    Alignment := vector2{X:= 0.0, Y:= 0.0}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := TitleText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{Left := -6.381382, Top := -13.138138, Right := 474.132141, Bottom := 53.723724}
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 1
                    SizeToContent := false
                    Widget := AmountSlider
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{Left := -336.960938, Top := 83.459473, Right := 204.013916, Bottom := 44.533989}
                    Alignment := vector2{X:= 0.0, Y:= 0.0}
                    ZOrder := 1
                    SizeToContent := false
                    Widget := CancelButton
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{Left := -376.960938, Top := 3.459473, Right := 280.794464, Bottom := 204.312012}
                    Alignment := vector2{X:= 0.0, Y:= 0.0}
                    ZOrder := 1
                    SizeToContent := false
                    Widget := CancelButtonBackgroundImg
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{Left := 127.039062, Top := 83.459473, Right := 204.013916, Bottom := 44.533989}
                    Alignment := vector2{X:= 0.0, Y:= 0.0}
                    ZOrder := 1
                    SizeToContent := false
                    Widget := AcceptButton
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{Left := 91.039062, Top := 3.459473, Right := 280.794464, Bottom := 204.312012}
                    Alignment := vector2{X:= 0.0, Y:= 0.0}
                    ZOrder := 1
                    SizeToContent := false
                    Widget := AcceptButtonBackgroundImg
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{Left := -332.960938, Top := -36.540527, Right := 165.000000, Bottom := 41.000000}
                    Alignment := vector2{X:= 0.0, Y:= 0.0}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := MinValueBountyText
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{Left := 263.039062, Top := -32.540527, Right := 165.000000, Bottom := 41.000000}
                    Alignment := vector2{X:= 0.0, Y:= 0.0}
                    ZOrder := 1
                    SizeToContent := true
                    Widget := MaxValueBountyText
                
                
        TitleText.SetText(TitleTextMessage)
        CancelButton.SetText(CancelButtonTextMessage)
        CancelButton.OnClick().Subscribe(OnCancelClicked)
        AcceptButton.SetText(AcceptButtonTextMessage)
        AcceptButton.OnClick().Subscribe(OnAcceptClicked)


    SetSliderValues<public>(MinValue : float, MaxValue : float): void =
        AmountSlider.SetMinValue(MinValue)
        MinValueBountyText.SetText(StringToMessage( AbbreviateNumber( (MinValue) * 1.0) ) )

        AmountSlider.SetMaxValue(MaxValue)
        MaxValueBountyText.SetText(StringToMessage( AbbreviateNumber( (MaxValue) * 1.0) ) )


    OnCancelClicked(WidgetPlayer : widget_message): void =
        if:
            PlayerData:=MaybePlayerData?
            Player := WidgetPlayer.Player
        then:
            MaybePlayerBountyInfoPlayer := PlayerData.GetMaybePlayerBountySetInfo()
            if(PlayerBountyInfoPlayer := MaybePlayerBountyInfoPlayer?):
                PlayerData.SetMaybePlayerBountySetInfo(false)
                PlayerData.HideSetPlayerBountyUI()


    OnAcceptClicked(WidgetPlayer : widget_message): void =
        if:
            PlayerData := MaybePlayerData?
            Player := WidgetPlayer.Player
        then:
            Value := AmountSlider.GetValue()
            MaybePlayerBountyInfoPlayer := PlayerData.GetMaybePlayerBountySetInfo()

            if(PlayerBountyInfoPlayer := MaybePlayerBountyInfoPlayer?, BountyDialog := PlayerBountyInfoPlayer.MaybeBountyDialog?):
                BountyDialog.Show(Player)
                set DialogConfirmButtonSubscription = option{ BountyDialog.RespondingButtonEvent.Subscribe(OnDialogButtonPressed) } #Gotta cancel it as well at some point!!


    OnDialogButtonPressed(Agent : agent, ButtonIndex : int): void =
        if(ButtonIndex = 0, PlayerData := MaybePlayerData?, GameManager := MaybeGameManager?):

            Value := AmountSlider.GetValue()

                #Check if player owns the amount of credits set for the bounty
            PlayerCredits := PlayerData.GetCurrency()
            if(BountyHunting := GameManager.MaybeBountyHunting?, PlayerCredits < Value):
                PlayerData.SetMaybePlayerBountySetInfo(false)
                PlayerData.HideSetPlayerBountyUI()
                BountyHunting.InsufficientCreditsHUDMessage.Show(Agent)
                return

                #When the player does own the Credits set for the bounty
            PlayerData.DecrementCurrency(Value)
            MaybePlayerBountyInfoPlayer := PlayerData.GetMaybePlayerBountySetInfo()
            if(AccoladeManager := GameManager.MaybeAccoladeManager?):
                AccoladeManager.GrantBountySetAccolade(Agent)

            if:
                PlayerBountyInfoPlayer := MaybePlayerBountyInfoPlayer?
                BountyAssigner := PlayerBountyInfoPlayer.MaybeBountyAssigner?
                PlayerToBounty := PlayerBountyInfoPlayer.MaybePlayerToBounty?
                BountyBillboard := PlayerBountyInfoPlayer.MaybeBountyBillboard?
                BountyButton := PlayerBountyInfoPlayer.MaybeBountyButton?
                BountyBeacon := PlayerBountyInfoPlayer.MaybeBountyBeacon?
                PlayerInfoIndex := PlayerBountyInfoPlayer.MaybeIndex?
                PropLetters := PlayerBountyInfoPlayer.MaybeLettersProp?
            then:
                BountyBeacon.Enable()      
                PropLetters.Show()          
                BountyButton.SetInteractionText(AcceptBountyMessage)
                BountyBillboard.ShowText()
                NumString := AbbreviateNumber( (Value) * 1.0) 
                BountyBillboard.SetText(PlayerBillboardText( NumString, BountyAssigner ) )
                PlayerData.HideSetPlayerBountyUI()

                    #Update the Player Info variable in player data with the amount passed in 
                UpdatedBountyInfoPlayer : PlayerBountyInfo = PlayerBountyInfo{
                    MaybeBountyAssigner := PlayerBountyInfoPlayer.MaybeBountyAssigner
                    MaybePlayerToBounty := PlayerBountyInfoPlayer.MaybePlayerToBounty
                    MaybeBountyBillboard := PlayerBountyInfoPlayer.MaybeBountyBillboard
                    MaybeBountyButton := PlayerBountyInfoPlayer.MaybeBountyButton
                    MaybeBountyBeacon := PlayerBountyInfoPlayer.MaybeBountyBeacon
                    MaybeLettersProp := PlayerBountyInfoPlayer.MaybeLettersProp
                    MaybeAmount := option{ Value }
                    MaybeIndex := PlayerBountyInfoPlayer.MaybeIndex
                }

                if(BountyHunting := GameManager.MaybeBountyHunting?):
                    if: 
                        set BountyHunting.BountySetForIndexMap[PlayerInfoIndex] = true
                        set BountyHunting.BountyInfoSetForIndexMap[PlayerInfoIndex] = UpdatedBountyInfoPlayer

                #PlayerData.SetMaybePlayerBountyInfo(UpdatedBountyInfoPlayer)

                set DialogConfirmButtonSubscription = false

        else:
            set DialogConfirmButtonSubscription = false


    PlayerBillboardText<localizes>(Amount : []char, BountyAssigner : player) : message =
        "Amount: {Amount}\nSet by: {BountyAssigner}"

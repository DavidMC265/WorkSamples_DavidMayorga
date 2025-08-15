using { /Fortnite.com }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { Lib }
using { MainScripts }
using { Tests }

Bounty_Hunting_DependecyInjector<localizes>:message = "Dependency Injector"
Bounty_Hunting_Config<localizes>: message = "Configuration"
Bounty_Hunting_Devices<localizes>: message = "Devices"
Bounty_Hunting_HUDMessages<localizes>: message = "HUD Messages"
Bounty_Hunting_Debug<localizes>: message = "Debug"

PlayerBountyInfo<public> := class():
    MaybeBountyAssigner<public> : ?player = false
    var MaybeBountyAccepter<public>: ?player = false
    MaybePlayerToBounty<public> : ?player = false
    MaybeAmount<public> : ?float = false
    MaybeBountyBillboard<public> : ?billboard_device = false
    MaybeBountyButton<public> : ?button_device = false
    MaybeBountyDialog<public> : ?popup_dialog_device = false
    MaybeBountyBeacon<public> : ?beacon_device = false
    MaybeLettersProp<public>: ?creative_prop = false
    MaybeIndex<public>: ?int = false


bounty_hunting<public> := class(creative_device):

        #Dependencies
    @editable:
        Categories := array{ Bounty_Hunting_DependecyInjector }
    var MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeGameManager<private> : ?game_manager = false
    var MaybeAccoladeManager<private>: ?accolade_manager = false
    var MaybePlayerCurrencyModifier<private>: ?player_currencymodifier = false

    @editable:
        Categories := array{ Bounty_Hunting_Config }
    var bCanPlayerPlaceBountyOnHimself<private> : logic = false

    @editable:
        Categories := array{ Bounty_Hunting_Config }
    var bCanPlayerAcceptOwnBounty<private>: logic = false

    @editable:
        Categories := array { Bounty_Hunting_Config }
    var MinBountyAmount<private> : float = 100.0

    @editable:
        Categories := array { Bounty_Hunting_Config }
    var MaxBountyAmount<private> : float = 500.0

        #Devices
    @editable:
        Categories := array{ Bounty_Hunting_Devices }
    PlayerReferences<private> : []player_reference_device = array{}

    @editable:
        Categories := array { Bounty_Hunting_Devices }
    PlayerReferenceButtons<private> : []button_device = array{}

    @editable:
        Categories := array{ Bounty_Hunting_Devices }
    PlayerReferenceBillboards<private>: []billboard_device = array{}

    @editable:
        Categories := array{ Bounty_Hunting_Devices }
    PlayerReferenceTrackers<private>: []tracker_device = array{}

    @editable:
        Categories := array{ Bounty_Hunting_Devices }
    PlayerReferenceBeacons<private>: []beacon_device = array{}

    @editable:
        Categories := array{ Bounty_Hunting_Devices }
    PlayerReferenceLetterProps<private>: []creative_prop = array{}

    @editable:
        Categories := array{ Bounty_Hunting_Devices }
    BountyConfirmationDialog<private> : popup_dialog_device = popup_dialog_device{}

    @editable:
        Categories := array{ Bounty_Hunting_Devices }
    NPCConversationDevice<private> : conversation_device = conversation_device{}

    @editable:
        Categories := array{ Bounty_Hunting_Devices }
    NPCConversationButton<private>: button_device = button_device{}

    @editable:
        Categories := array{ Bounty_Hunting_Devices }
    NPCConversationEndedTrigger<private>: trigger_device = trigger_device{}


        #HUD Messages
    @editable:
        Categories := array { Bounty_Hunting_HUDMessages }
    CantPlaceBountyHUDMessage<private> : hud_message_device = hud_message_device{}

    @editable:
        Categories := array { Bounty_Hunting_HUDMessages }
    BountyTakenMHUDessage<private> : hud_message_device = hud_message_device{}

    @editable:
        Categories := array { Bounty_Hunting_HUDMessages }
    CantAssignBountySetbyPlayer<private> : hud_message_device = hud_message_device{}

    @editable:
        Categories := array{ Bounty_Hunting_HUDMessages }
    BountyLimitHUDMessage<private>: hud_message_device = hud_message_device{}

    @editable:
        Categories := array{ Bounty_Hunting_HUDMessages }
    PlayerBountySetInfoValidMessage<private>: hud_message_device = hud_message_device{}

    @editable:
        Categories := array{ Bounty_Hunting_HUDMessages }
    InsufficientCreditsHUDMessage<public>: hud_message_device = hud_message_device{}

    @editable:
        Categories := array{ Bounty_Hunting_HUDMessages }
    BountyCompletedHUDMessage<public>: hud_message_device = hud_message_device{}

        #Debugging
    @editable:
        Categories := array{ Bounty_Hunting_Debug }
    DebugButtonGetCurentPlayerBountyAcceptedInfo<private> : button_device = button_device{}

    @editable:
        Categories := array{ Bounty_Hunting_Debug }
    DebugButtonGetCurentPlayerBountySetInfo<private> : button_device = button_device{}
    
    @editable:
        Categories := array{ Bounty_Hunting_Debug }
    LettersPropVisibilityOnButton<private> : button_device = button_device{}

    @editable:
        Categories := array{ Bounty_Hunting_Debug }
    LettersPropVisibilityOffButton<private> : button_device = button_device{}

    @editable:
        Categories := array{ Bounty_Hunting_Debug }
    LettersProp<private> : creative_prop = creative_prop{}

 
    PlayerName<private><localizes> (Agent : agent) : message = "{Agent}"
    IntToMessage<private><localizes> (Value : int): message = "{Value}"

    EmptyMessage<private><localizes>: message = ""
    PlaceBountyOnPlayerMessage<private><localizes>: message = "Place Bounty on Player"
    BountyTakenMessage<private><localizes>: message = "Bounty Taken"
    TrackerMessage<private><localizes> (Agent : agent, BountyAmount : []char): message = "Eliminate {Agent}\nPrize: {BountyAmount} + XP"


    var BountyTakenForIndexMap<private> : [int]logic = map{}
    var BountySetForIndexMap<public> : [int]logic = map{}
    var BountyInfoSetForIndexMap<public>: [int]PlayerBountyInfo = map{}


    OnBegin<override>()<suspends>:void=
        SetupDependencies()
        DebugButtonGetCurentPlayerBountyAcceptedInfo.InteractedWithEvent.Subscribe(OnShowBountyInfoAcceptedButtonPressed)
        DebugButtonGetCurentPlayerBountySetInfo.InteractedWithEvent.Subscribe(OnShowBountyInfoSetButtonPressed)

        NPCConversationEndedTrigger.TriggeredEvent.Subscribe(OnConversationEndedWithNPC)
        NPCConversationButton.InteractedWithEvent.Subscribe(OnNPCInteractedWith)

        LettersPropVisibilityOnButton.InteractedWithEvent.Subscribe(OnLettersPropVisibilityOnButtonPressed)
        LettersPropVisibilityOffButton.InteractedWithEvent.Subscribe(OnLettersPropVisibilityOffButtonPressed)
        LettersProp.Hide()

        for(PlayerReferenceBillboard : PlayerReferenceBillboards):
            PlayerReferenceBillboard.HideText()

        for(PlayerReferenceBeacon : PlayerReferenceBeacons):
            PlayerReferenceBeacon.Disable()

        for(PlayerReferenceLetterProp : PlayerReferenceLetterProps):
            PlayerReferenceLetterProp.Hide()

        for:
            PlayerReferenceButtonIndex -> PlayerReferenceButton : PlayerReferenceButtons
            PlayerReferenceForButton := PlayerReferences[PlayerReferenceButtonIndex] 
        do:
            #Print("PlayerReferenceButtonIndexes : {PlayerReferenceButtonIndex}")
            PlayerReferenceButton.Disable()
            PlayerReferenceButton.InteractedWithEvent.SubscribeAgent(OnPlayerReferenceButtonPressed, PlayerReferenceButtonIndex)

            if:
                set BountyTakenForIndexMap[PlayerReferenceButtonIndex] = false
                set BountySetForIndexMap[PlayerReferenceButtonIndex] = false
                set BountyInfoSetForIndexMap[PlayerReferenceButtonIndex] = PlayerBountyInfo{}
            then:
                #Do nothing, all map values have been assigned to this index


        Sleep(0.3)
        for(PlayerReferenceTracker : PlayerReferenceTrackers):
            PlayerReferenceTracker.RemoveFromAll()

        AllPlayers := GetPlayspace().GetPlayers()
        for(Player : AllPlayers):
            AssignPlayerReference(Player)
        
        GetPlayspace().PlayerAddedEvent().Subscribe(AssignPlayerReference)
        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerLeavesCurrentGame)


    SetupDependencies():void = 
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeAccoladeManager = DependencyInjector.GetAccoladeManager()
            set MaybePlayerCurrencyModifier = DependencyInjector.GetPlayerCurrencyModifier()
        else:
            Print(
                "Dependency Injector not available from bounty_hunting script",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )


    OnLettersPropVisibilityOnButtonPressed(Agent : agent): void =
        LettersProp.Show()

    OnLettersPropVisibilityOffButtonPressed(Agent : agent): void =
        LettersProp.Hide()



    AssignPlayerReference(Player : player): void =
        for:
            PlayerReferenceIndex -> PlayerReference : PlayerReferences
            PlayerReferenceButton := PlayerReferenceButtons[PlayerReferenceIndex] 
        do:
            PlayerRef := PlayerReference.GetAgent()
            if(not PlayerRef?):
                #Print("This Player Reference is available for a player to be registered")
                PlayerReference.Register(Player)  
                PlayerReferenceButton.Enable()                  
                return #THIS RETURN IS VEEEEERY IMPORTANT TO INCLUDE


    OnPlayerReferenceButtonPressed(Agent : agent, Index : int): void =
        # When the the bounty info has been set and the bounty has been taken by another player 
        if(BountySetForIndexMap[Index] = true and BountyTakenForIndexMap[Index] = true):
            #Print("Bounty has already been assigned to another player")
            BountyTakenMHUDessage.Show(Agent)
            return

        # When the the bounty info has been set and the bounty has not been taken by another player 
        else if(BountySetForIndexMap[Index] = true and BountyTakenForIndexMap[Index] = false):
            if:
                ButtonForPlayerReference := PlayerReferenceButtons[Index]
                InteractingPlayer := player[Agent]
            then:
                #Check that the player who is accepting the bounty isnt the one who Set it
                if(BountyInfoSetForIndexMap[Index].MaybeBountyAssigner = option{ InteractingPlayer }, bCanPlayerAcceptOwnBounty = false):
                    Print("Bounty cannot be assigned to the same player who set it")
                    CantAssignBountySetbyPlayer.Show(Agent)
                    return
                else:
                    #INDENT FROM HERE
                    if:
                        GameManager := MaybeGameManager?
                        MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
                        PlayerData := MaybePlayerData?
                    then:
                        MaybeBountyAcceptedInfoPlayer := PlayerData.GetMaybePlayerBountyAcceptedInfo()
                        if(not MaybeBountyAcceptedInfoPlayer?):
                            ButtonForPlayerReference.SetInteractionText(BountyTakenMessage)
                            AssignBountyToPlayer(Agent, Index)
                            return
                        else:
                            Print("Player already has a bounty assignedddd alreadyyyy")
                            return


        #Allow the player to set a bounty for this index since it hasnt been set 
        SetBountyByPlayer(Agent, Index)


    SetBountyByPlayer(Agent : agent, Index : int): void =
        #Initiate bounty info
        if:
            Player := player[Agent]
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Player)
            PlayerData := MaybePlayerData?
        then:
            MaybePlayerBountySetInfo := PlayerData.GetMaybePlayerBountySetInfo()
            #Check if player has already set a Bounty for another player
            if(PlayerBountySetinfo := MaybePlayerBountySetInfo?):
                PlayerBountySetInfoValidMessage.Show(Player)
                return
            else:
                if:
                    PlayerReference := PlayerReferences[Index]
                    ButtonForPlayerReference := PlayerReferenceButtons[Index]
                    BillboardForPlayerReference := PlayerReferenceBillboards[Index]
                    BountyDialogForPlayerReferecnce := BountyConfirmationDialog #THIS NEEDS TO HAVE THE INDEX NOT A SET DIALOG LIKE IT IS NOWWWW
                    BeaconForPlayerReference := PlayerReferenceBeacons[Index]
                    LettersPropForPlayerReference := PlayerReferenceLetterProps[Index]
                then:
                    MaybePlayerRefAgent := PlayerReference.GetAgent()
                    if(AgentRef := MaybePlayerRefAgent?, Agent = AgentRef, bCanPlayerPlaceBountyOnHimself = false):
                        #Print("Yes, this Player Reference is referencing another player right now")
                        Print(PlayerName(AgentRef))
                        if(Agent = AgentRef):
                            CantPlaceBountyHUDMessage.Show(Agent)
                    else:
                        if(AgentRef := MaybePlayerRefAgent?, PlayeRef := player[AgentRef]):
                            NewBountyInfo : PlayerBountyInfo = PlayerBountyInfo{
                                MaybeBountyAssigner := option{ Player }
                                MaybePlayerToBounty := option { PlayeRef }
                                MaybeBountyBillboard := option{ BillboardForPlayerReference }
                                MaybeBountyButton := option{ ButtonForPlayerReference }
                                MaybeBountyDialog := option{ BountyDialogForPlayerReferecnce }
                                MaybeBountyBeacon := option{ BeaconForPlayerReference }
                                MaybeLettersProp := option{ LettersPropForPlayerReference}
                                MaybeIndex := option{ Index }
                            }

                            PlayerData.SetMaybePlayerBountySetInfo( option{ NewBountyInfo } )
                            PlayerData.ShowSetPlayerBountyUI(MinBountyAmount, MaxBountyAmount)


    AssignBountyToPlayer(Agent : agent, Index : int): void =
        Print("Assigning bounty to player!!!")
        if:
            GameManager := MaybeGameManager?
            Player := player[Agent]
            MaybePlayerData := GameManager.GetMaybePlayerData(Player)
            PlayerData := MaybePlayerData?
        then:
            CurrentBountyCountPlayer := PlayerData.GetCurrentBountyCount()
            if(CurrentBountyCountPlayer >= 1):
                BountyLimitHUDMessage.Show(Player)
                #Print("Bounty Limit set by player limit reached!!")
                return
            else:
                #Print("Setting info for the player now!!")
                #MaybeNewBountyInfo := PlayerData.GetMaybePlayerBountyInfo()
                #if(NewBountyInfo := MaybeNewBountyInfo?, set BountyInfoSetForIndexMap[Index] = NewBountyInfo):
                if(IndexBountyInfo := BountyInfoSetForIndexMap[Index]):
                    ## Code to assign bounty to player here
                    #Print("Yes, Bounty Info already set for this Index is validddd")
                    if:
                        PlayerToBounty := IndexBountyInfo.MaybePlayerToBounty?
                        BountyAssigner := IndexBountyInfo.MaybeBountyAssigner?
                        BountyBillboard := IndexBountyInfo.MaybeBountyBillboard?
                        BountyAmount := IndexBountyInfo.MaybeAmount?
                        BountyBeacon := IndexBountyInfo.MaybeBountyBeacon?
                        PropLetters := IndexBountyInfo.MaybeLettersProp?
                        BountyTracker := PlayerReferenceTrackers[Index]
                    then:
                        if:
                            set BountyInfoSetForIndexMap[Index].MaybeBountyAccepter = option{ Player }
                            set BountyTakenForIndexMap[Index] = true
                        then:
                            BountyAmountMess : string= AbbreviateNumber( (BountyAmount) * 1.0 )
                            BountyTracker.SetDescriptionText(TrackerMessage( PlayerToBounty, BountyAmountMess ))
                            BountyTracker.Assign(Agent)
                            BountyBillboard.SetText( PlayerAcceptsBountyBillboardText(BountyAmountMess, BountyAssigner, Player) )
                            PlayerData.SetCurrentBountyCount(1)
                            PlayerData.SetMaybePlayerBountyAcceptedInfo( option{ IndexBountyInfo } )
                            BountyBeacon.Disable()
                            PropLetters.Hide()
                    else:
                        Print("Didnt go through here though")
    
                        
    PlayerAcceptsBountyBillboardText<localizes>(AmountStr : string, BountyAssigner : player, BountyAccepter : player) : message =
        "Amount: {AmountStr}\nSet by: {BountyAssigner}\nAccepted by: {BountyAccepter}"


    OnPlayerLeavesCurrentGame(LeavingAgent : agent): void=
        #Print("Player has left the game")
        for:
            PlayerReferenceIndex -> PlayerReference : PlayerReferences
            PlayerReferenceButton := PlayerReferenceButtons[PlayerReferenceIndex] 
            PlayerReferenceBillboard := PlayerReferenceBillboards[PlayerReferenceIndex]
        do:
            PlayerRef := PlayerReference.GetAgent()
            if:
                AgentRef := PlayerRef?, 
                LeavingAgent = AgentRef,
                set BountySetForIndexMap[PlayerReferenceIndex] = false,
                set BountyTakenForIndexMap[PlayerReferenceIndex] = false
                set BountyInfoSetForIndexMap[PlayerReferenceIndex] = PlayerBountyInfo{}
            then:
                #Print("This Player Reference is available for a player to be registered")
                PlayerReference.Clear() 
                PlayerReferenceButton.SetInteractionText(PlaceBountyOnPlayerMessage)
                PlayerReferenceButton.Disable()
                PlayerReferenceBillboard.HideText() 
                if:
                    GameManager := MaybeGameManager?
                    MaybePlayerData := GameManager.GetMaybePlayerData(LeavingAgent)
                    PlayerData := MaybePlayerData?
                then:
                    #Reset bounty variables in player data
                    MaybeSetBountyInfo := PlayerData.GetMaybePlayerBountySetInfo()
                    if:
                        SetBountyInfo := MaybeSetBountyInfo?
                        Index := SetBountyInfo.MaybeIndex?
                    then:
                        ClearBountyInfo(Index)
                        PlayerData.SetMaybePlayerBountySetInfo(false)


                    MaybeAcceptedBountyInfo := PlayerData.GetMaybePlayerBountyAcceptedInfo()
                    if:
                        AcceptedBountyInfo := MaybeAcceptedBountyInfo?
                        BountyAssigner := AcceptedBountyInfo.MaybeBountyAssigner?
                    then:
                        RefundPlayerBountyAmount(BountyAssigner)
                        PlayerData.SetMaybePlayerBountyAcceptedInfo(false) 

                    PlayerData.SetCurrentBountyCount(0) 


    OnShowBountyInfoAcceptedButtonPressed(Agent : agent): void =
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            if(PlayerData := MaybePlayerData?):
                MaybePlayerCurrentBountyInfo := PlayerData.GetMaybePlayerBountyAcceptedInfo()
                if(PlayerCurrentBountyInfo := MaybePlayerCurrentBountyInfo?):
                    PrintPlayerBountyInfo(PlayerCurrentBountyInfo)
                else:
                    Print("The player hasnt accepeted any bounty so farrr")


    OnShowBountyInfoSetButtonPressed(Agent : agent): void =
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            if(PlayerData := MaybePlayerData?):
                MaybePlayerCurrentBountyInfo := PlayerData.GetMaybePlayerBountySetInfo()
                if(PlayerCurrentBountyInfo := MaybePlayerCurrentBountyInfo?):
                    PrintPlayerBountyInfo(PlayerCurrentBountyInfo)
                else:
                    Print("The player hasnt Set any bounty so farrr")


    PrintPlayerBountyInfo<public>(PlayerBountyInfoIn : PlayerBountyInfo) : void =
        if(BountyAssigner := PlayerBountyInfoIn.MaybeBountyAssigner?, PlayerToBounty := PlayerBountyInfoIn.MaybePlayerToBounty?):
            Print(PlayerName(BountyAssigner), ?Duration := 7.0, ?Color := NamedColors.Orange)
            Print(PlayerName(PlayerToBounty), ?Duration := 7.0, ?Color := NamedColors.Orange)

        #if(Amount := PlayerBountyInfoIn.MaybeAmount?, Index := PlayerBountyInfoIn.MaybeIndex?):
            #Print(IntToMessage(Amount), ?Duration := 7.0, ?Color := NamedColors.Orange)
            #Print(IntToMessage(Index), ?Duration := 7.0, ?Color := NamedColors.Orange)


    FinalizeBounty<public>(CompletedBountyAgent : agent): void =
        if:
            GameManager := MaybeGameManager?
            AccoladeManager := MaybeAccoladeManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(CompletedBountyAgent)
            PlayerData := MaybePlayerData?
        then:
            MaybeBountyAcceptedInfoPlayer := PlayerData.GetMaybePlayerBountyAcceptedInfo()
            if:
                AcceptedInfoPlayer := MaybeBountyAcceptedInfoPlayer?
                BountyAssigner := AcceptedInfoPlayer.MaybeBountyAssigner?
                BountyAmount := AcceptedInfoPlayer.MaybeAmount?
                Index := AcceptedInfoPlayer.MaybeIndex?
            then:
                ClearBountyInfo(Index)

                if(BountyTracker := PlayerReferenceTrackers[Index]):
                    BountyTracker.Remove(CompletedBountyAgent)
                    PlayerData.IncrementCurrency(BountyAmount)

                    PlayerData.SetMaybePlayerBountyAcceptedInfo(false)
                
                    MaybePlayerDataBountyAssigner := GameManager.GetMaybePlayerData(BountyAssigner)
                    if(PlayerDataBountyAssigner := MaybePlayerDataBountyAssigner?):
                        PlayerDataBountyAssigner.SetMaybePlayerBountySetInfo(false)

                    BountyCompletedHUDMessage.Show(BountyAssigner)
                    AccoladeManager.GrantBountyAssignerAccolade(BountyAssigner)
                    AccoladeManager.GrantBountyAccepterAccolade(CompletedBountyAgent)


    ClearBountyInfo(Index : int): void =
        if:
            set BountySetForIndexMap[Index] = false,
            set BountyTakenForIndexMap[Index] = false
            set BountyInfoSetForIndexMap[Index] = PlayerBountyInfo{}
            BountyBillboard := PlayerReferenceBillboards[Index]
            PlayerReferenceButton := PlayerReferenceButtons[Index]
        then:
            BountyBillboard.HideText()
            PlayerReferenceButton.SetInteractionText(PlaceBountyOnPlayerMessage)


    RefundPlayerBountyAmount<public>(Agent : agent): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData :=GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            MaybePlayerBountySetInfo := PlayerData.GetMaybePlayerBountySetInfo()
            if:
                PlayerDataBountySetInfo := MaybePlayerBountySetInfo?
                BountyAmount := PlayerDataBountySetInfo.MaybeAmount?
            then:
                PlayerData.IncrementCurrency(BountyAmount)
                Print("Player has been refunded their bounty amount!!")



    OnConversationNumberPassed(Agent : agent, Index : int): void =
        Print("Conversation Event Calleddd")
        Print("Conversation {Index} Passed by player")


    OnNPCInteractedWith(Agent : agent): void =
        if: 
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            PlayerData.HidePlayerCurrencyUI()
            NPCConversationDevice.InitiateConversation(Agent)
            #Print("Player has interacted with NPC")


    OnConversationEndedWithNPC(MaybeAgent : ?agent): void =
        if: 
            Agent := MaybeAgent?
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
            PlayerCurrencyModifier := MaybePlayerCurrencyModifier?
            CurrencyBackgroundImgColor := PlayerCurrencyModifier.CurrencyBackgroundImgColorOP?
        then:
            PlayerData.ShowPlayerCurrencyUI(CurrencyBackgroundImgColor)
            #Print("Conversation ended with Agent")

    


                    

                    






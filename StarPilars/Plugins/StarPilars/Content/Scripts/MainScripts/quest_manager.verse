using { /Fortnite.com }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { Lib }
using { UI_Pillars }



EQuests<public>:= enum<persistable>{ None, CompleteRounds, EliminatePlayers, ElimsWithoutDying, OpenMysteryBox, WinGames} #CreditPickups


(Quest : EQuests).GetQuestName<public>(): string =
    case (Quest):
        EQuests.None => "None"
        EQuests.CompleteRounds => "Complete Rounds"
        EQuests.EliminatePlayers => "Eliminate Players"
        EQuests.ElimsWithoutDying => "Elimiate Players Without Dying"
        EQuests.OpenMysteryBox => "Open Mystery Box"
        EQuests.WinGames => "Win Games"
        #EQuests.CreditPickups => "Collect Credit Pickups"


DependecyInjector_QuestManager<localizes>:message = "Dependency Injector"
Devices_QuestManager<localizes>:message = "Devices"
Config_QuestManager<localizes>:message = "Configuration" 
Quest_1<localizes>:message = "Quest 1"
Quest_2<localizes>:message = "Quest 2"
Quest_3<localizes>:message = "Quest 3"
Quest_4<localizes>:message = "Quest 4"
Quest_5<localizes>:message = "Quest 5"
Quest_6<localizes>:message = "Quest 6"


quest_manager<public> := class(creative_device):

        #Dependencies
    @editable:
        Categories := array{ DependecyInjector_QuestManager }
    MaybeDependencyInjector<private>: ?dependency_injector = false

    var MaybeGameManager<private>: ?game_manager = false
    var MaybeAccoladeManager<private>: ?accolade_manager = false
    var MaybeEventMediator<private>: ?event_mediator = false

        # Devices
    @editable:
        Categories := array{ Devices_QuestManager }
    QuestUIButton<private>: button_device = button_device{}

    @editable:
        Categories := array{ Devices_QuestManager }
    AlreadyCompletedQuestMessage<private>: hud_message_device = hud_message_device{}

        #Quest 1
    @editable:
        Categories := array{ Quest_1 }
    Quest1_Dialog<private>: popup_dialog_device = popup_dialog_device{}

    @editable:
        Categories := array{ Quest_1 }
    Quest1_Tracker<private>: tracker_device = tracker_device{}

    @editable:
        Categories := array{ Quest_1 }
    Quest1_RewardAmount<private>: float = 1000.0

    @editable:
        Categories := array{ Quest_1 }
    Quest1_RoundsToComplete<private>: int = 3

        #Quest 2
    @editable:
        Categories := array{ Quest_2 }
    Quest2_Dialog<private>: popup_dialog_device = popup_dialog_device{}

    @editable:
        Categories := array{ Quest_2 }
    Quest2_Tracker<private>: tracker_device = tracker_device{}

    @editable:
        Categories := array{ Quest_2 }
    Quest2_RewardAmount<private>: float = 3000.0

    @editable:
        Categories := array{ Quest_2 }
    Quest2_EliminatePlayersRequired<private>: int = 3

        #Quest 3
    @editable:
        Categories := array{ Quest_3 }
    Quest3_Dialog<private>: popup_dialog_device = popup_dialog_device{}

    @editable:
        Categories := array{ Quest_3 }
    Quest3_Tracker<private>: tracker_device = tracker_device{}

    @editable:
        Categories := array{ Quest_3 }
    Quest3_RewardAmount<private>: float = 5000.0

    @editable:
        Categories := array{ Quest_3 }
    Quest3_EliminatePlayersWithoutDying<private>: int = 2

        #Quest 4
    @editable:
        Categories := array{ Quest_4 }
    Quest4_Dialog<private>: popup_dialog_device = popup_dialog_device{}

    @editable:
        Categories := array{ Quest_4 }
    Quest4_Tracker<private>: tracker_device = tracker_device{}

    @editable:
        Categories := array{ Quest_4 }
    Quest4_RewardAmount<private>: float = 6000.0

    @editable:
        Categories := array{ Quest_4 }
    Quest4_OpenMysteryBoxTimes<private>: int = 2

        #Quest 5
    @editable:
        Categories := array{ Quest_5 }
    Quest5_Dialog<private>: popup_dialog_device = popup_dialog_device{}

    @editable:
        Categories := array{ Quest_5 }
    Quest5_Tracker<private>: tracker_device = tracker_device{}

    @editable:
        Categories := array{ Quest_5 }
    Quest5_RewardAmount<private>: float = 9000.0

    @editable:
        Categories := array{ Quest_5 }
    Quest5_WinGamesAmount<private>: int = 1

        #Quest 6
    @editable:
        Categories := array{ Quest_6 }
    Quest6_Dialog<private>: popup_dialog_device = popup_dialog_device{}

    @editable:
        Categories := array{ Quest_6 }
    Quest6_Tracker<private>: tracker_device = tracker_device{}

    @editable:
        Categories := array{ Quest_6 }
    Quest6_RewardAmount<private>: float = 10000.0

    @editable:
        Categories := array{ Quest_6 }
    Quest6_PickupsAmount<private>: int = 30


    var QuestStatusArray : []tuple(EQuests, logic) = array{}

    var QuestDialogs : []popup_dialog_device = array{}


    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        set QuestDialogs = array{ Quest1_Dialog, Quest2_Dialog, Quest3_Dialog, Quest4_Dialog, Quest5_Dialog }
        for (QuestDialog : QuestDialogs):
            QuestDialog.SetButtonText(StringToMessage("{QuestDialogs.Length}"), 5)


        QuestUIButton.InteractedWithEvent.Subscribe(OnQuestUIButtonPressed)

        AllPlayers := GetPlayspace().GetPlayers()
        for(Player : AllPlayers):
            GetPlayerCurrentQuest(Player)
            #SetPlayerIncompletedQuests(Player)

        GetPlayspace().PlayerAddedEvent().Subscribe(GetPlayerCurrentQuest)
        #GetPlayspace().PlayerAddedEvent().Subscribe(SetPlayerIncompletedQuests)

        Quest1_Dialog.RespondingButtonEvent.Subscribe(OnQuest1DialogButtonPressed)
        Quest1_Dialog.SetButtonText(StringToMessage("{1}"), 4)
        Quest1Amount : string = AbbreviateNumber( (Quest1_RewardAmount) * 1.0)
        Quest1_Dialog.SetTitleText(StringToMessage( GetQuestTitle( EQuests.CompleteRounds) ) )
        Quest1_Dialog.SetDescriptionText(StringToMessage( GetQuestDescription( EQuests.CompleteRounds) ) )
        Quest1_Dialog.SetButtonText(StringToMessage("{Quest1Amount}"), 0)
        
        Quest1_Tracker.SetDescriptionText(StringToMessage( GetQuestTitle( EQuests.CompleteRounds) ) )
        #Quest1_Tracker.LoadForAll()
        #Quest1_Tracker.SetValue(0)
        Quest1_Tracker.SetTarget(Quest1_RoundsToComplete)

        Quest1_Tracker.CompleteEvent.SubscribeAgent(OnQuestCompleted, 0)

        
        Quest2_Dialog.RespondingButtonEvent.Subscribe(OnQuest2DialogButtonPressed)
        Quest2_Dialog.SetButtonText(StringToMessage("{2}"), 4)
        Quest2Amount : string = AbbreviateNumber( (Quest2_RewardAmount) * 1.0)
        Quest2_Dialog.SetTitleText(StringToMessage( GetQuestTitle( EQuests.EliminatePlayers) ) )
        Quest2_Dialog.SetDescriptionText(StringToMessage( GetQuestDescription( EQuests.EliminatePlayers) ) )
        Quest2_Dialog.SetButtonText(StringToMessage("{Quest2Amount}"), 0)

        Quest2_Tracker.SetDescriptionText(StringToMessage( GetQuestTitle( EQuests.EliminatePlayers) ) )
        #Quest2_Tracker.SetValue(0)
        Quest2_Tracker.SetTarget(Quest2_EliminatePlayersRequired)

        Quest2_Tracker.CompleteEvent.SubscribeAgent(OnQuestCompleted, 1)


        Quest3_Dialog.RespondingButtonEvent.Subscribe(OnQuest3DialogButtonPressed)
        Quest3_Dialog.SetButtonText(StringToMessage("{3}"), 4)
        Quest3Amount : string = AbbreviateNumber( (Quest3_RewardAmount) * 1.0)
        Quest3_Dialog.SetTitleText(StringToMessage( GetQuestTitle( EQuests.ElimsWithoutDying) ) )
        Quest3_Dialog.SetDescriptionText(StringToMessage( GetQuestDescription( EQuests.ElimsWithoutDying) ) )
        Quest3_Dialog.SetButtonText(StringToMessage("{Quest3Amount}"), 0)

        Quest3_Tracker.SetDescriptionText(StringToMessage( GetQuestTitle( EQuests.ElimsWithoutDying) ) )
        #Quest2_Tracker.SetValue(0)
        Quest3_Tracker.SetTarget(Quest3_EliminatePlayersWithoutDying)

        Quest3_Tracker.CompleteEvent.SubscribeAgent(OnQuestCompleted, 2)


        Quest4_Dialog.RespondingButtonEvent.Subscribe(OnQuest4DialogButtonPressed)
        Quest4Amount : string = AbbreviateNumber( (Quest4_RewardAmount) * 1.0)
        Quest4_Dialog.SetButtonText(StringToMessage("{4}"), 4)
        Quest4_Dialog.SetTitleText(StringToMessage( GetQuestTitle( EQuests.OpenMysteryBox) ) )
        Quest4_Dialog.SetDescriptionText(StringToMessage( GetQuestDescription( EQuests.OpenMysteryBox) ) )
        Quest4_Dialog.SetButtonText(StringToMessage("{Quest4Amount}"), 0)

        Quest4_Tracker.SetDescriptionText(StringToMessage( GetQuestTitle( EQuests.OpenMysteryBox) ) )
        #Quest2_Tracker.SetValue(0)
        Quest4_Tracker.SetTarget(Quest4_OpenMysteryBoxTimes)

        Quest4_Tracker.CompleteEvent.SubscribeAgent(OnQuestCompleted, 3)

        
        Quest5_Dialog.RespondingButtonEvent.Subscribe(OnQuest5DialogButtonPressed)
        Quest5_Dialog.SetButtonText(StringToMessage("{5}"), 4)
        Quest5Amount : string = AbbreviateNumber( (Quest5_RewardAmount) * 1.0)
        Quest5_Dialog.SetTitleText(StringToMessage( GetQuestTitle( EQuests.WinGames) ) )
        Quest5_Dialog.SetDescriptionText(StringToMessage( GetQuestDescription( EQuests.WinGames) ) )
        Quest5_Dialog.SetButtonText(StringToMessage("{Quest5Amount}"), 0)

        Quest5_Tracker.SetDescriptionText(StringToMessage( GetQuestTitle( EQuests.WinGames) ) )
        #Quest2_Tracker.SetValue(0)
        Quest5_Tracker.SetTarget(Quest5_WinGamesAmount)

        Quest5_Tracker.CompleteEvent.SubscribeAgent(OnQuestCompleted, 4)


        # Quest6_Dialog.RespondingButtonEvent.Subscribe(OnQuest6DialogButtonPressed)
        # Quest6_Dialog.SetButtonText(StringToMessage("{6}"), 4)
        # Quest6Amount : string = AbbreviateNumber( (Quest6_RewardAmount) * 1.0)
        # Quest6_Dialog.SetTitleText(StringToMessage( GetQuestTitle( EQuests.CreditPickups) ) )
        # Quest6_Dialog.SetDescriptionText(StringToMessage( GetQuestDescription( EQuests.CreditPickups) ) )
        # Quest6_Dialog.SetButtonText(StringToMessage("{Quest6Amount}"), 0)

        # Quest6_Tracker.SetDescriptionText(StringToMessage( GetQuestTitle( EQuests.CreditPickups) ) )
        # #Quest2_Tracker.SetValue(0)
        # Quest6_Tracker.SetTarget(Quest6_PickupsAmount)

        # Quest6_Tracker.CompleteEvent.SubscribeAgent(OnQuestCompleted, 5)

        
        spawn:
            CloseQuestUIForPlayers()
    

    SetupDependencies():void = 
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeAccoladeManager = DependencyInjector.GetAccoladeManager()
            set MaybeEventMediator = DependencyInjector.GetEventMediator()
        else:
            Print(
                "Dependency Injector not available from quest_manager script",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )


    OnQuestUIButtonPressed(Agent : agent): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            Quest1_Dialog.Show(Agent)
            # IncompleteQuestsPlayer := PlayerData.GetIncompleteQuests()
            # #Print("Incomplete Quests for player array length is {IncompleteQuestsPlayer.Length}", ?Duration := 7.0, ?Color := NamedColors.Orange)
            
            #     #Open first Element in array Dialog
            # MaybeIncompleteQuestPlayer := FindIncompleteQuestForPlayer(Agent)

            # if(IncompleteQuestPlayer := MaybeIncompleteQuestPlayer?):
            #     case(IncompleteQuestPlayer):
            #         EQuests.CompleteRounds => Quest1_Dialog.Show(Agent)
            #         EQuests.EliminatePlayers => Quest2_Dialog.Show(Agent)
            #         EQuests.ElimsWithoutDying => Quest3_Dialog.Show(Agent)
            #         EQuests.OpenMysteryBox => Quest4_Dialog.Show(Agent)
            #         _=>
            # else:
            #     return


    FindIncompleteQuestForPlayer(Agent : agent)<transacts>: ?EQuests = 
        var MaybeIncompleteQuest : ?EQuests = false

        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            IncompleteQuestsPlayer := PlayerData.GetIncompleteQuests()
            CurrentQuestPlayer := PlayerData.GetCurrentQuest()

            if(IncompleteQuestsPlayer.Length > 0):
                for(IncompleteQuest : IncompleteQuestsPlayer, not IncompleteQuest = CurrentQuestPlayer):
                    set MaybeIncompleteQuest = option { IncompleteQuest }
                    #Print("Found an Icompleted Quest for the player", ?Duration := 7.0, ?Color := NamedColors.Purple)
                    return MaybeIncompleteQuest

        return MaybeIncompleteQuest


    GetPlayerCurrentQuest(Agent : agent): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            CurrentPlayerQuest := PlayerData.GetCurrentQuest()
            case(CurrentPlayerQuest):
                EQuests.None => 
                EQuests.CompleteRounds => Quest1_Tracker.Load(Agent)
                EQuests.EliminatePlayers => Quest2_Tracker.Load(Agent)
                EQuests.ElimsWithoutDying => Quest3_Tracker.Load(Agent)
                EQuests.OpenMysteryBox => Quest4_Tracker.Load(Agent)
                EQuests.WinGames => Quest5_Tracker.Load(Agent)
                #EQuests.CreditPickups => Quest6_Tracker.Load(Agent)

            #Print("CurrentPlayer Quest is {CurrentPlayerQuest.GetQuestName()}")


    SetPlayerIncompletedQuests(Agent : agent): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            #IncompleteQuestsPlayer := PlayerData.GetIncompleteQuests()
            CompleteQuestsPlayer := PlayerData.GetCompletedQuests()
            #Print("Incomplete Quests for player array length is {IncompleteQuestsPlayer.Length}", ?Duration := 7.0, ?Color := NamedColors.Orange)
            AllQuests := GetAllQuests()

            for:
                Quest : AllQuests
                not CompleteQuestsPlayer.Find[Quest]
            do:
                #Print("This Quests has not been completed by the player", ?Duration := 7.0, ?Color := NamedColors.Orange)
                PlayerData.SetIncompleteQuests(Quest)
                
            IncompleteQuestsPlayer := PlayerData.GetIncompleteQuests()
            #Print("Incomplete Quests for player array length is now {IncompleteQuestsPlayer.Length}", ?Duration := 7.0, ?Color := NamedColors.Orange)

            # CurrentPlayerQuest := PlayerData.GetCurrentQuest()
            # if(CurrentPlayerQuest = EQuests.None, IncompleteQuestsPlayer.Length > 0):
            #     for(IncompleteQuestPlayer : IncompleteQuestsPlayer):
            #         case(IncompleteQuestPlayer):
            #             EQuests.CompleteRounds => 
            #                 Quest1_Tracker.Assign(Agent)
            #                 PlayerData.SetCurrentQuest(EQuests.CompleteRounds)
            #                 return
            #             EQuests.EliminatePlayers => 
            #                 Quest2_Tracker.Assign(Agent)
            #                 PlayerData.SetCurrentQuest(EQuests.EliminatePlayers)

            #             EQuests.ElimsWithoutDying => 
            #                 Quest3_Tracker.Assign(Agent)
            #                 PlayerData.SetCurrentQuest(EQuests.ElimsWithoutDying)
            #             _=>


        #VERY IMPORTANT TO ADD ALL ENUM VALUES INSIDE OF THIS ARRAY
    GetAllQuests(): []EQuests =

        var Quests : []EQuests = array{
            EQuests.CompleteRounds, 
            EQuests.EliminatePlayers, 
            EQuests.ElimsWithoutDying, 
            EQuests.OpenMysteryBox,
            EQuests.WinGames
            #EQuests.CreditPickups
        }

        return Quests
    

    IncrementQuestValue<public>(Agent : agent, Quest : EQuests, Value : int): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            CurrentPlayerQuest := PlayerData.GetCurrentQuest()
            if(CurrentPlayerQuest = Quest):
                #Print("Incrementing quest value")
                case(CurrentPlayerQuest):
                    EQuests.None => "None"
                    EQuests.CompleteRounds => Quest1_Tracker.Increment(Agent)
                    EQuests.EliminatePlayers => Quest2_Tracker.Increment(Agent)
                    EQuests.ElimsWithoutDying => Quest3_Tracker.Increment(Agent)
                    EQuests.OpenMysteryBox => Quest4_Tracker.Increment(Agent)
                    EQuests.WinGames => Quest5_Tracker.Increment(Agent)
                    #EQuests.CreditPickups => Quest6_Tracker.Increment(Agent)
            else:
                #Print("Failed Somewhere not incrementing quest value")
                return


    ResetQuestValue<public>(Agent : agent, Quest : EQuests): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            CurrentPlayerQuest := PlayerData.GetCurrentQuest()
            if(CurrentPlayerQuest = Quest):
                case(CurrentPlayerQuest):
                    EQuests.None => "None"
                    EQuests.CompleteRounds => Quest1_Tracker.SetValue(0)
                    EQuests.EliminatePlayers => Quest2_Tracker.SetValue(0)
                    EQuests.ElimsWithoutDying => Quest3_Tracker.SetValue(0)
                    EQuests.OpenMysteryBox => Quest4_Tracker.SetValue(0)
                    EQuests.WinGames => Quest5_Tracker.SetValue(0)
                    #EQuests.CreditPickups => Quest6_Tracker.SetValue(0)
            else:
                return


    GetQuestTitle(Quest : EQuests): string =
        case (Quest):
            EQuests.None => "None"
            EQuests.CompleteRounds => "Complete {Quest1_RoundsToComplete} Rounds"
            EQuests.EliminatePlayers => "Eliminate {Quest2_EliminatePlayersRequired} Players"
            EQuests.ElimsWithoutDying => "Get a {Quest3_EliminatePlayersWithoutDying} Player Killstreak"
            EQuests.OpenMysteryBox => "Open your Mystery Box {Quest4_OpenMysteryBoxTimes} Times"
            EQuests.WinGames => "Win {Quest5_WinGamesAmount} Game"
            #EQuests.CreditPickups => "Collect {Quest6_PickupsAmount} Credit Pickups"


    GetQuestDescription(Quest : EQuests): string =
        case (Quest):
            EQuests.None => "None"
            EQuests.CompleteRounds => "Complete {Quest1_RoundsToComplete} full rounds without\nleaving the game to finish this\nquest"
            EQuests.EliminatePlayers => "Eliminate {Quest2_EliminatePlayersRequired} players across games\nto complete this quest"
            EQuests.ElimsWithoutDying => "Eliminate Players {Quest3_EliminatePlayersWithoutDying} Without\nDying to complete this quest"
            EQuests.OpenMysteryBox => "Open your mystery box {Quest4_OpenMysteryBoxTimes} times. Remember, you\ncan only open 1 per round"
            EQuests.WinGames => "Win {Quest5_WinGamesAmount} Game without being eliminated"
            #EQuests.CreditPickups => "Pickup {Quest6_PickupsAmount} Collectible Credit pickups\nthat are located around the map to\ncomplete this quest"


    OnQuest1DialogButtonPressed(Agent : agent, ButtonIndex : int): void =
        #Print("A Responding button was pressed with index {ButtonIndex}")
        OnQuestButtonPressed(Agent, ButtonIndex, EQuests.CompleteRounds)


    OnQuest2DialogButtonPressed(Agent : agent, ButtonIndex : int): void =
        #Print("A Responding button was pressed with index {ButtonIndex}")
        OnQuestButtonPressed(Agent, ButtonIndex, EQuests.EliminatePlayers)


    OnQuest3DialogButtonPressed(Agent : agent, ButtonIndex : int): void =
        #Print("A Responding button was pressed with index {ButtonIndex}")
        OnQuestButtonPressed(Agent, ButtonIndex, EQuests.ElimsWithoutDying)

    OnQuest4DialogButtonPressed(Agent : agent, ButtonIndex : int): void =
        #Print("A Responding button was pressed with index {ButtonIndex}")
        OnQuestButtonPressed(Agent, ButtonIndex, EQuests.OpenMysteryBox)

    OnQuest5DialogButtonPressed(Agent : agent, ButtonIndex : int): void =
        #Print("A Responding button was pressed with index {ButtonIndex}")
        OnQuestButtonPressed(Agent, ButtonIndex, EQuests.WinGames)

    #OnQuest6DialogButtonPressed(Agent : agent, ButtonIndex : int): void =
        #Print("A Responding button was pressed with index {ButtonIndex}")
        #OnQuestButtonPressed(Agent, ButtonIndex, EQuests.CreditPickups)

    
    OnQuestButtonPressed(Agent : agent, ButtonIndex : int, Quest : EQuests): void =
        #Print("Quest Button Pressed")            

        var NextQuest : ?EQuests = false
        var PreviousQuest : ?EQuests = false
        var QuestDialog : popup_dialog_device = popup_dialog_device{}
        var QuestTracker : tracker_device = tracker_device{}

        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            # IncompleteQuestsPlayer := PlayerData.GetIncompleteQuests()
            CompleteQuestsPlayer := PlayerData.GetCompletedQuests()
            Print("{ButtonIndex}")

            if(ButtonIndex = 0, CompleteQuestsPlayer.Find[Quest]):
                Print("This player has completed the quest already!!", ?Duration := 7.0, ?Color := NamedColors.Red)
                AlreadyCompletedQuestMessage.Show(Agent)
                return



            # CurrentPlayerQuest := PlayerData.GetCurrentQuest()

            # AllQuests := GetAllQuests()
            # if(QuestIndex := AllQuests.Find[Quest]):
            #     #Find Next Incomplete Quest
            #     if: 
            #         NextIncompleteQuest := IncompleteQuestsPlayer[QuestIndex + 1], 
            #         #MaybeNextIncompleteQuest := FindIncompleteQuestForPlayer(Agent)
            #         #NextIncompleteQuest := MaybeNextIncompleteQuest?
            #         not CompleteQuestsPlayer.Find[NextIncompleteQuest]
            #         not NextIncompleteQuest = CurrentPlayerQuest
            #         #PreviousIncompleteQuest := IncompleteQuestsPlayer[IncompleteQuestsPlayer.Length - 1]
            #     then:
            #         # Print(
            #         #     "The quest Index is { QuestIndex } and the next incomplete quest is valid with name: {NextIncompleteQuest.GetQuestName() }", 
            #         #     ?Duration := 7.0, 
            #         #     ?Color := NamedColors.Pink
            #         # )

            #         set NextQuest = option { NextIncompleteQuest }

            #     else:
            #         # Print(
            #         #     "The next incomplete quest is invalid or has been already completed by the player", 
            #         #     ?Duration := 7.0, 
            #         #     ?Color := NamedColors.Red
            #         # )

            #     #Find Previous Incomplete Quest
            #     if:
            #         PreviousIncompleteQuest := IncompleteQuestsPlayer[QuestIndex - 1],
            #         #aybePreviousIncompleteQuest := FindIncompleteQuestForPlayer(Agent)
            #         #PreviousIncompleteQuest := MaybePreviousIncompleteQuest?
            #         not CompleteQuestsPlayer.Find[PreviousIncompleteQuest]
            #         not PreviousIncompleteQuest = CurrentPlayerQuest
            #     then:
            #         # Print(
            #         #     "The quest Index is { QuestIndex } and the previous incomplete quest is valid with name: { PreviousIncompleteQuest.GetQuestName() }", 
            #         #     ?Duration := 7.0, 
            #         #     ?Color := NamedColors.Pink
            #         # )

            #         set PreviousQuest = option { PreviousIncompleteQuest }

            #     else:
            #         # Print(
            #         #     "The previous incomplete quest is invalid or has been already completed by the player", 
            #         #     ?Duration := 7.0, 
            #         #     ?Color := NamedColors.Red
            #         # )


            case (Quest):
                EQuests.None => "None"

                EQuests.CompleteRounds => 
                    set PreviousQuest = option{ EQuests.WinGames }
                    set NextQuest = option {EQuests.EliminatePlayers}
                    set QuestDialog = Quest1_Dialog
                    set QuestTracker = Quest1_Tracker

                EQuests.EliminatePlayers =>
                    set PreviousQuest = option { EQuests.CompleteRounds }
                    set NextQuest = option { EQuests.ElimsWithoutDying }
                    set QuestDialog = Quest2_Dialog
                    set QuestTracker = Quest2_Tracker

                EQuests.ElimsWithoutDying =>
                    set PreviousQuest = option { EQuests.EliminatePlayers }
                    set NextQuest = option { EQuests.OpenMysteryBox }
                    set QuestDialog = Quest3_Dialog
                    set QuestTracker = Quest3_Tracker

                EQuests.OpenMysteryBox=>
                    set PreviousQuest = option { EQuests.ElimsWithoutDying }
                    set NextQuest = option { EQuests.WinGames }
                    set QuestDialog = Quest4_Dialog
                    set QuestTracker = Quest4_Tracker 

                EQuests.WinGames =>
                    set PreviousQuest = option { EQuests.OpenMysteryBox }
                    set NextQuest = option { EQuests.CompleteRounds }
                    set QuestDialog = Quest5_Dialog
                    set QuestTracker = Quest5_Tracker

                #EQuests.CreditPickups =>
                    #set PreviousQuest = option { EQuests.WinGames }
                    #set NextQuest = option{ EQuests.CompleteRounds}
                    #set QuestDialog = Quest6_Dialog
                    #set QuestTracker = Quest6_Tracker

            case (ButtonIndex):
                    # Assign Quest
                0 => OverrideCurrentPlayerQuest(Agent, Quest, QuestTracker)

                    # Close UI/Dialog
                1 => QuestDialog.Hide(Agent)

                    # Back
                2 => spawn { OpenPreviousUI(PreviousQuest, Agent, QuestDialog) }

                    # Next
                3 => spawn { OpenNextUI(NextQuest, Agent, QuestDialog) }

                _=> 
                    Print(
                        "Button Index received is not valid from quest_manager!",
                        ?Duration := 7.0,
                        ?Color := NamedColors.Red
                    )

    
    OverrideCurrentPlayerQuest(Agent : agent, NewQuest : EQuests, NewQuestTracker : tracker_device): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            CurrentPlayerQuest := PlayerData.GetCurrentQuest()
            case(CurrentPlayerQuest):
                EQuests.None => "None"
                EQuests.CompleteRounds => Quest1_Tracker.Remove(Agent)
                EQuests.EliminatePlayers => Quest2_Tracker.Remove(Agent)
                EQuests.ElimsWithoutDying => Quest3_Tracker.Remove(Agent)
                EQuests.OpenMysteryBox => Quest4_Tracker.Remove(Agent)
                EQuests.WinGames => Quest5_Tracker.Remove(Agent)
                #EQuests.CreditPickups => Quest6_Tracker.Remove(Agent)

            NewQuestTracker.Assign(Agent)
            PlayerData.SetCurrentQuest(NewQuest)


    OpenPreviousUI(MaybePreviousQuest : ?EQuests, Agent : agent, QuestDialog : popup_dialog_device)<suspends>: void =
        QuestDialog.Hide()
        Sleep(0.2)

        if(PreviousQuest := MaybePreviousQuest?):
            case (PreviousQuest):
                EQuests.None => # Do nothing 

                EQuests.CompleteRounds =>  Quest1_Dialog.Show(Agent)
                EQuests.EliminatePlayers => Quest2_Dialog.Show(Agent)
                EQuests.ElimsWithoutDying => Quest3_Dialog.Show(Agent)
                EQuests.OpenMysteryBox => Quest4_Dialog.Show(Agent)
                EQuests.WinGames => Quest5_Dialog.Show(Agent)
                #EQuests.CreditPickups => Quest6_Dialog.Show(Agent)
        else:
            #Print("Previous Quest is invalid")


    OpenNextUI(MaybeNextQuest : ?EQuests, Agent : agent, QuestDialog : popup_dialog_device)<suspends>: void =
        Print("Opening Next Quest Page!")
        QuestDialog.Hide()
        Sleep(0.2)

        if(NextQuest := MaybeNextQuest?):
            Print("Next Quest is valid")
            case (NextQuest):
                EQuests.None => # Do nothing 

                EQuests.CompleteRounds =>  Quest1_Dialog.Show(Agent)
                EQuests.EliminatePlayers => Quest2_Dialog.Show(Agent)
                EQuests.ElimsWithoutDying => Quest3_Dialog.Show(Agent)
                EQuests.OpenMysteryBox=> Quest4_Dialog.Show(Agent)
                EQuests.WinGames => Quest5_Dialog.Show(Agent)
                #EQuests.CreditPickups => Quest6_Dialog.Show(Agent)
        else:
            Print("Next Quest is invalid")


    OnQuestCompleted(Agent : agent, QuestIndex : int): void =
        if:
            GameManager := MaybeGameManager?
            AccoladeManager := MaybeAccoladeManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            AccoladeManager.GrantQuestCompletedAccolade(Agent)

            case(QuestIndex):
                0 => 
                    PlayerData.IncrementCurrency(Quest1_RewardAmount)
                    PlayerData.SetCompletedQuests(EQuests.CompleteRounds)
                    PlayerData.SetCurrentQuest(EQuests.None)
                1 => 
                    PlayerData.IncrementCurrency(Quest2_RewardAmount)
                    PlayerData.SetCompletedQuests(EQuests.EliminatePlayers)
                    PlayerData.SetCurrentQuest(EQuests.None)
                2 =>
                    PlayerData.IncrementCurrency(Quest3_RewardAmount)
                    PlayerData.SetCompletedQuests(EQuests.ElimsWithoutDying)
                    PlayerData.SetCurrentQuest(EQuests.None)
                3 =>
                    PlayerData.IncrementCurrency(Quest4_RewardAmount)
                    PlayerData.SetCompletedQuests(EQuests.OpenMysteryBox)
                    PlayerData.SetCurrentQuest(EQuests.None)
                4 =>
                    PlayerData.IncrementCurrency(Quest5_RewardAmount)
                    PlayerData.SetCompletedQuests(EQuests.WinGames)
                    PlayerData.SetCurrentQuest(EQuests.None)
                    #Print("Set the current quest to none now!")
                5 => 
                    PlayerData.IncrementCurrency(Quest6_RewardAmount)
                    #PlayerData.SetCompletedQuests(EQuests.CreditPickups)
                    PlayerData.SetCurrentQuest(EQuests.None)
                _=>
                    Print(
                        "Button Index received is not valid from quest_manager!",
                        ?Duration := 7.0,
                        ?Color := NamedColors.Red
                    )


    CloseQuestUIForPlayers()<suspends>: void =
        if(EventMediator := MaybeEventMediator?):
            EventMediator.OnGameStarted.Await()

            AllPlayers := GetPlayspace().GetPlayers()
            for(Player : AllPlayers):
                for(QuestDialog : QuestDialogs):
                    QuestDialog.Hide(Player)
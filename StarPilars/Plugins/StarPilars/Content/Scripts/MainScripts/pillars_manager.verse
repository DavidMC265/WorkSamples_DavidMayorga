using { /Fortnite.com }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { GameAreas }
using { Lib }
using { Tests }


Pillars_Manager_DependecyInjector<localizes>:message = "Dependency Injector"
Pillars_Manager_Devices<localizes>:message = "Devices"
Pillars_Manager_Config<localizes>:message = "Configuration" 
Pillars_Manager_UI<localizes>:message = "UI" 


pillars_manager<public> := class(creative_device):

        #Dependencies
    @editable:
        Categories := array{ Pillars_Manager_DependecyInjector}
    var MaybeDependencyInjector<private>: ?dependency_injector = false

    var MaybeGameManager<private>: ?game_manager = false
    var MaybeEventMediator<private>: ?event_mediator = false
    var MaybeBountyHunting<private>: ?bounty_hunting = false
    var MaybePlayerCurrencyModifier<private>: ?player_currencymodifier = false
    var MaybeQuestManager<private>: ?quest_manager = false

        #Config
    @editable:
        Categories := array{ Pillars_Manager_Config }
    EndGameWithOnePlayerLeft<private>: logic = false

    @editable:
        Categories := array{ Pillars_Manager_Config }
    PillarsArenaDevice<private>: pillars_arena = pillars_arena{}

        #Devices
    @editable:
        Categories := array{ Pillars_Manager_Devices }
    ItemGranter<private>: item_granter_device = item_granter_device{}

    @editable:
        Categories := array{ Pillars_Manager_Devices }
    DefaultGranter<private>: item_granter_device = item_granter_device{}

    @editable:
        Categories := array{ Pillars_Manager_Devices }
    GameBeginsInTimer<public>: timer_device = timer_device{}

    @editable:
        Categories := array{ Pillars_Manager_Devices }
    ItemGranterTimer<private>: timer_device = timer_device{}

    @editable:
        Categories := array{ Pillars_Manager_Devices }
    ElimManager<private>: elimination_manager_device = elimination_manager_device{}

    @editable:
        Categories := array{ Pillars_Manager_Devices }
    EndGameDevice<private>: end_game_device = end_game_device{}

    @editable:
        Categories := array{ Pillars_Manager_Devices }
    GameStartCountdown_AudioPlayer1<private>: audio_player_device = audio_player_device{}

    @editable:
        Categories := array{ Pillars_Manager_Devices }
    GameStartCountdown_AudioPlayer2<private>: audio_player_device = audio_player_device{}

    @editable:
        Categories := array{ Pillars_Manager_Devices }
    GameStartCountdown_AudioPlayer3<private>: audio_player_device = audio_player_device{}

    @editable:
        Categories := array{ Pillars_Manager_Devices }
    GameStartCountdownStart_AudioPlayer<private>: audio_player_device = audio_player_device{}

        #UI
    @editable:
        Categories := array{ Pillars_Manager_UI }
    CurrentGamePlayersCount_HUDMessage<private> : hud_message_device = hud_message_device{}


    @editable:
    TestButton : button_device = button_device{}


    var CurrentGamePlayers<private> : []player = array{}

    PlayerName<localizes> (Player : player): message = "{Player}"


    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        GameBeginsInTimer.SuccessEvent.Subscribe(OnGameBeginsInTimerCompleted)

        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerLeavesGame)

        ItemGranterTimer.SuccessEvent.Subscribe(GrantRandomItemToPlayer)
        TestButton.InteractedWithEvent.Subscribe(OnButtonPressed)
        AllPlayers := GetPlayspace().GetPlayers()
        for(Player : AllPlayers, FortCharacter := Player.GetFortCharacter[]):
            FortCharacter.EliminatedEvent().Subscribe(OnPlayerEliminated)
            FortCharacter.SetShield(100.0)

        spawn:
            AwaitGameStart()

        spawn:
            SetPlayerToMaxHealth()


    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeEventMediator = DependencyInjector.GetEventMediator()
            set MaybeBountyHunting = DependencyInjector.GetBountyHunting()
            set MaybePlayerCurrencyModifier = DependencyInjector.GetPlayerCurrencyModifier()
            set MaybeQuestManager = DependencyInjector.GetQuestManager()
        else:
            Print(
                "Dependency Injector not available from lobby_controller script",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )


    AwaitGameStart()<suspends>: void =
        if(EventMediator := MaybeEventMediator?):
            set CurrentGamePlayers = EventMediator.OnGameStarted.Await()
            PillarsArenaDevice.TeleportPlayersToArena(CurrentGamePlayers)
            CurrentGamePlayersCount_HUDMessage.SetText(StringToMessage("Arena Players\nRemaining: {CurrentGamePlayers.Length}"))
            CurrentGamePlayersCount_HUDMessage.Show()

            Sleep(2.0)
            loop:
                Sleep(1.0)
                CheckIfOnePlayerLeft()


    OnGameBeginsInTimerCompleted(MaybeAgent : ?agent): void =
        for(ArenaBarrier : PillarsArenaDevice.ArenaBarriers):
            ArenaBarrier.Disable()

        for(CurrentGamePlayer : CurrentGamePlayers):
            spawn{ StartItemTimerForPlayer(CurrentGamePlayer) }


        #Start the Item granter timer for all Current game Players
    StartItemTimerForPlayer<public>(Player : player)<suspends>: void =
        #DefaultGranter.GrantItem(Player)
        Sleep(1.0)
        ItemGranterTimer.Reset(Player)
        Sleep(0.3)
        ItemGranterTimer.Start(Player)

        
    RemoveItemTimerForPlayer<public>(Player : player): void =
        ItemGranterTimer.Disable(Player)


        #Grant Items To All Arena Players
    GrantRandomItemToPlayer(MaybeAgent : ?agent):void=
        if(Agent := MaybeAgent?, Player := player[Agent]):
            ItemGranterTimer.Reset(Agent)
            ItemGranter.CycleToRandomItem(Agent)

            spawn{ StartItemTimerForPlayer(Player) }


    OnPlayerJoinsGame(Agent : agent): void =
        spawn:
            ShowCurrentGamePlayerCounterUI(Agent)
        

    ShowCurrentGamePlayerCounterUI(Agent : agent)<suspends>: void =
        Sleep(2.0)

        CurrentGamePlayersCount_HUDMessage.SetText(StringToMessage("Arena Players\nRemaining: {CurrentGamePlayers.Length}"))
        CurrentGamePlayersCount_HUDMessage.Show()


    OnPlayerLeavesGame(Agent : agent) : void =
        if:
            PlayerIDX := CurrentGamePlayers.Find[Agent]
            NewArray := CurrentGamePlayers.RemoveElement[PlayerIDX]
        then:
            set CurrentGamePlayers = NewArray
            CurrentGamePlayersCount_HUDMessage.SetText(StringToMessage("Arena Players\nRemaining: {CurrentGamePlayers.Length}"))
            CurrentGamePlayersCount_HUDMessage.Show()

            spawn{ CheckIfOnePlayerLeft() }


    OnPlayerEliminated(Result : elimination_result):void=
        Target := Result.EliminatedCharacter
        MaybeInstigator := Result.EliminatingCharacter

        #Show Spectator UI to eliminated player
        if:
            AgentTarget := Target.GetAgent[]
            AgentPlayer := player[AgentTarget]
            PlayerTarget := player[AgentTarget]
            PlayerIDX := CurrentGamePlayers.Find[PlayerTarget]
            NewArray := CurrentGamePlayers.RemoveElement[PlayerIDX]
            Instigator := MaybeInstigator?
            AgentInstigator := Instigator.GetAgent[]
        then:
            set CurrentGamePlayers = NewArray
            CurrentGamePlayersCount_HUDMessage.SetText(StringToMessage("Arena Players\nRemaining: {CurrentGamePlayers.Length}"))
            CurrentGamePlayersCount_HUDMessage.Show()

            #spawn{ PillarsArenaDevice.ShowSpectatorModeUI(PlayerTarget) }
            spawn{ CheckIfOnePlayerLeft() }

            CheckPlayerBountyStatus(AgentInstigator, AgentTarget)
            AwardAgentElimination(AgentInstigator)

            HandleQuests(AgentTarget, AgentInstigator)
            RemoveItemTimerForPlayer(AgentPlayer)


    CheckPlayerBountyStatus(AgentInstigator : agent, AgentTarget : agent): void =
        #Check if Eliminating Player has an active Bounty
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(AgentInstigator)
            PlayerData := MaybePlayerData?
            BountyHunting := MaybeBountyHunting?
        then:
            MaybePlayerBountyInfoPlayer := PlayerData.GetMaybePlayerBountyAcceptedInfo()
            if:
                PlayerBountyInfoPlayer := MaybePlayerBountyInfoPlayer?
                BountyAssigner := PlayerBountyInfoPlayer.MaybeBountyAssigner?
                PlayerTarget := player[AgentTarget]
                PlayerToBounty := PlayerBountyInfoPlayer.MaybePlayerToBounty?
                PlayerToBounty = PlayerTarget
            then:

                BountyHunting.FinalizeBounty(AgentInstigator)


    HandleQuests(AgentInstigator : agent, AgentTarget : agent): void =
        if:
            QuestManager := MaybeQuestManager?
            GameManager := MaybeGameManager?
            MaybeAgentInstigator := GameManager.GetMaybePlayerData(AgentInstigator)
            MaybeAgentTarget := GameManager.GetMaybePlayerData(AgentTarget)
            PlayerDataInstigator := MaybeAgentInstigator?
            PlayerDataTarget := MaybeAgentTarget?
        then:
            CurrentPlayerQuestInstigator := PlayerDataInstigator.GetCurrentQuest()
            CurrentPlayerQuestTarget := PlayerDataInstigator.GetCurrentQuest()

            if(CurrentPlayerQuestInstigator = EQuests.ElimsWithoutDying):
                QuestManager.IncrementQuestValue(AgentInstigator, EQuests.ElimsWithoutDying, 1)

            if(CurrentPlayerQuestInstigator = EQuests.ElimsWithoutDying):
                QuestManager.IncrementQuestValue(AgentInstigator, EQuests.EliminatePlayers, 1)

            if(CurrentPlayerQuestTarget = EQuests.ElimsWithoutDying):
                QuestManager.ResetQuestValue(AgentTarget, EQuests.ElimsWithoutDying)


    AwardAgentElimination(AgentToAward : agent): void =
        if(PlayerCurrencyModifier := MaybePlayerCurrencyModifier?):
            PlayerCurrencyModifier.AwardAgentElimination(AgentToAward)

        
    AwardAgentGameWon(AgentToAward : agent): void =
        if(PlayerCurrencyModifier := MaybePlayerCurrencyModifier?, QuestManager := MaybeQuestManager?):
            PlayerCurrencyModifier.AwardAgentGameWon(AgentToAward)
            QuestManager.IncrementQuestValue(AgentToAward, EQuests.WinGames, 1)


    OnButtonPressed(Agent : agent): void =
        if(Player := player[Agent]):
            spawn{ PillarsArenaDevice.ShowSpectatorModeUI(Player) }


    CheckIfOnePlayerLeft()<suspends>:void=
        if:
            CurrentGamePlayers.Length = 1 
            WinningPlayer := CurrentGamePlayers[0]
            BountyHunting := MaybeBountyHunting?
            QuestManager := MaybeQuestManager?
        then:
            Sleep(1.0)

            if(EndGameWithOnePlayerLeft = false):
                return
            else:
                #End game behavior
                AllPlayers := GetPlayspace().GetPlayers()
                for(Player : AllPlayers):
                    BountyHunting.RefundPlayerBountyAmount(Player)

                        #Quests
                    QuestManager.IncrementQuestValue(Player, EQuests.CompleteRounds, 1)
                
                AwardAgentGameWon(WinningPlayer)
                Sleep(1.5)
                EndGameDevice.Activate(WinningPlayer)



    PlayRoundCountdownSoundCues<public>()<suspends>: void = 
        var SoundCuesPlayedCounter : int = 0
        loop:
            if(SoundCuesPlayedCounter = 3):
                set SoundCuesPlayedCounter = 0 
                for(CurrentGamePlayer : CurrentGamePlayers):
                    GameStartCountdownStart_AudioPlayer.Play(CurrentGamePlayer)
                break
            if(SoundCuesPlayedCounter = 1):
                for(CurrentGamePlayer : CurrentGamePlayers):
                    GameStartCountdown_AudioPlayer2.Play(CurrentGamePlayer)
            if(SoundCuesPlayedCounter = 2):
                for(CurrentGamePlayer : CurrentGamePlayers):
                    GameStartCountdown_AudioPlayer3.Play(CurrentGamePlayer)

            for(CurrentGamePlayer : CurrentGamePlayers):
                GameStartCountdown_AudioPlayer1.Play(CurrentGamePlayer)
            set SoundCuesPlayedCounter += 1
            Sleep(1.0)


            
    SetPlayerToMaxHealth()<suspends>: void =
        loop: 
            Sleep(1.0)
            AllPlayers := GetPlayspace().GetPlayers()
            for(Player : AllPlayers, FortCharacter := Player.GetFortCharacter[]):
                if:
                    not CurrentGamePlayers.Find[Player]
                    TotalHealth := FortCharacter.GetHealth()
                    TotalHealth <> 100.0
                then:
                    FortCharacter.SetHealth(100.0)






       

    
using { /Fortnite.com }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/FortPlayerUtilities }
using { /Fortnite.com/Game }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { Lobby }
using { MainScripts }



roundzonedevice_tag := class(tag):
    
RoundDependencies_RoundStartManager<localizes>:message = "Dependency Injection"
RoundConfig<localizes>:message = "Configuration"
RoundInteraction_RoundStartManager<localizes>:message = "Devices"
SoundCues_RoundStartManager<localizes>:message = "Sound Cues"

round_start_manager<public> := class(creative_device):

    @editable: 
        Categories := array{ RoundDependencies_RoundStartManager }
    var MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeGameManager<private>: ?game_manager = false
    var MaybeEventMediator<private> : ?event_mediator = false
    var MaybeMainRankManager<private> : ?main_rank_manager = false
    var MaybePregameLobby<private> : ?pregame_lobby = false

    @editable_slider(int):
        Categories := array{ RoundConfig }
        MinValue := option{ 4 }
        MaxValue := option{ 8 }
    RoundVictoriesToWin<private> : int = 8
    
    @editable:
        Categories := array{ RoundInteraction_RoundStartManager }
    RoundBeginTimerZones<private> : timer_device = timer_device{}

    @editable: 
        Categories := array{ RoundInteraction_RoundStartManager }
    NextRoundTimer<private> : timer_device = timer_device{}

    @editable:
        Categories := array{ RoundInteraction_RoundStartManager }
    ReadyToBeginRoundPlayerCounter<private> : player_counter_device = player_counter_device{}

    @editable:
        Categories := array{ RoundInteraction_RoundStartManager}
    WeaponSelectionHUDMessage<private>: hud_message_device = hud_message_device{}

    @editable:
        Categories := array{ RoundInteraction_RoundStartManager }
    RoundWinHUDMessage<public> : hud_message_device = hud_message_device{}

    @editable:
        Categories := array{ RoundInteraction_RoundStartManager }
    RoundLossHUDMessage<public> : hud_message_device = hud_message_device{}

    @editable:
        Categories := array{ RoundInteraction_RoundStartManager }
    WoodRoundGranter<private> : item_granter_device = item_granter_device{}

    @editable:
        Categories := array{ SoundCues_RoundStartManager }    
    SoundCueSecond1<private> : audio_player_device = audio_player_device{}

    @editable: 
        Categories := array{ SoundCues_RoundStartManager }     
    SoundCueSecond2<private> : audio_player_device = audio_player_device{}

    @editable:
        Categories := array{ SoundCues_RoundStartManager }
    SoundCueSecond3<private> : audio_player_device = audio_player_device{}

    @editable:
        Categories := array{ SoundCues_RoundStartManager }
    SoundCueCompletion<private> : audio_player_device = audio_player_device{}   

    @editable:
        Categories := array{ RoundInteraction_RoundStartManager }
    var EndGameSlowedTime_CinematicSequencer<private> : cinematic_sequence_device = cinematic_sequence_device{}


    var ZonesArray<private> : []round_zone = array{}
    var CurrentZoneDevice: ?round_zone = false

    var Team1Score<private> : int = 0
    var Team2Score<private> : int = 0

    var TeamVictory<private> : logic = false

    var SoundCuesPlayedCounter<private> : int = 0



    OnBegin<override>()<suspends>:void=
        SetupDependencies()            

        ReadyToBeginRoundPlayerCounter.CountSucceedsEvent.Subscribe(BeginRoundImmediately)

        SetAllRoundZones()
           
        WaitForRoundStart() #Async function
        OnWeaponSelectionTimerCompleted()


    AddPlayerToCurrentRoundZone<public>(Agent : agent): void=
        if(CurrentRoundZoneDevice := CurrentZoneDevice?):
            CurrentRoundZoneDevice.SubscribePlayerToEliminatedSubscription(Agent)

        

    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeEventMediator = DependencyInjector.GetEventMediator()
            set MaybeMainRankManager = DependencyInjector.GetMainRankManager()
            set MaybePregameLobby = DependencyInjector.GetPreGameLobby()
        else:
            Print(
                "Dependency Injector not available from Round Start manager",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )


    SetAllRoundZones(): void =
        TaggedList := FindCreativeObjectsWithTag(roundzonedevice_tag{})
        for(TaggedItem : TaggedList):
            if(RoundZoneDevice := round_zone[TaggedItem]):
                # if(RoundZoneDevice.Identifier = 1 or RoundZoneDevice.Identifier = 2 or RoundZoneDevice.Identifier = 3 or RoundZoneDevice.Identifier = 4):
                set ZonesArray += array{ RoundZoneDevice }


    WaitForRoundStart()<suspends>: void = 
        if:
            EventMediator := MaybeEventMediator?
            GameManager := MaybeGameManager?
            PregameLobby := MaybePregameLobby?
        then:
            EventMediator.OnRoundIsReadyToStart.Await()

            Print(
                "OnRoundIsReadyToStart await logic executed from WaitForRoundStart in the round_start_manager", 
                ?Duration := 7.0, 
                ?Color := NamedColors.Orange
            )

                #THIS IS WHAT ISNT BEING TRIGGERED BY THE BUG
            ReadyToBeginRoundPlayerCounter.SetTargetCount(PregameLobby.CurrentGamePlayers.Length)

            for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                if(MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer), PlayerData := MaybePlayerData?):
                    WeaponSelectionHUDMessage.Show(CurrentGamePlayer)
                    PlayerData.ShowWeaponSelectionTimerUI()


    OnWeaponSelectionTimerCompleted()<suspends>: void = 
        if:
            EventMediator := MaybeEventMediator?
            GameManager := MaybeGameManager?
            PregameLobby := MaybePregameLobby?
        then:
            EventMediator.OnWeaponSelectionTimerCompleted.Await()

            for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                if(MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer), PlayerData := MaybePlayerData?):
                    PlayerData.HideWeaponSelectionTimerUI()

            EventMediator.EmitRoundStarted()

            DisplayScoreboardUI()
            PickNextRoundZone()


    DisplayScoreboardUI(): void = 
        if(PregameLobby := MaybePregameLobby?, GameManager := MaybeGameManager?):
            for(CurrentGamePlayer: PregameLobby.CurrentGamePlayers):
                MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)
                if(PlayerData := MaybePlayerData?):
                    PlayerData.ShowScoreboardUI(Team1Score, Team2Score)

                    
    ShowUpdatedScoreboardUIToPlayer<public>(Agent : agent): void =
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            if(PlayerData := MaybePlayerData?):
                PlayerData.ShowScoreboardUI(Team1Score, Team2Score)
                


    PickNextRoundZone(): void =
        if(ZonesArray.Length = 0):
            Print(
                "Zones Array Length is now 0, no more zones to pickkk, Refilling zones array once again", 
                ?Duration := 15.0, 
                ?Color := NamedColors.Orange
            )
            return
            #SetAllRoundZones()

            
        if(TeamVictory = true):
            return
        
        RandomZoneIndex := GetRandomInt(0, ZonesArray.Length - 1)

        if(ZonePicked := ZonesArray[RandomZoneIndex], PregameLobby := MaybePregameLobby?):
            for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                WoodRoundGranter.GrantItem(CurrentGamePlayer)

            ZonePicked.TelportPlayersToZone(MaybeGameManager, RoundBeginTimerZones)
            set CurrentZoneDevice = option{ ZonePicked }

            if(NewArray := ZonesArray.RemoveElement[RandomZoneIndex]):
                set ZonesArray = NewArray

        else:
            Print(
                "Zones Array Index is invalid!!", 
                ?Duration := 5.0, 
                ?Color := NamedColors.Red
            )


    BeginRoundImmediately(): void =
        if:
            EventMediator := MaybeEventMediator?
            GameManager := MaybeGameManager?
            PregameLobby := MaybePregameLobby?
        then:
            EventMediator.EmitOnWeaponSelectionTimerCompleted()

            for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                if(MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer), PlayerData := MaybePlayerData?):
                    WeaponSelectionHUDMessage.Hide(CurrentGamePlayer)
   

    UpdateTeam1ScoreAfterWin<public>(): void =
        set Team1Score += 1

        if(PregameLobby := MaybePregameLobby?, GameManager := MaybeGameManager?):
            for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)
                if(PlayerData := MaybePlayerData?):
                    PlayerData.UpdateTeam1ScoreUI(Team1Score)

        if(Team1Score  = RoundVictoriesToWin, PregameLobby := MaybePregameLobby?):
            set TeamVictory = true
            EndGameSlowedTime_CinematicSequencer.Play()

            if(EventMediator := MaybeEventMediator?):
                EventMediator.EmitOnGameEnds()

            for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                if(GameManager := MaybeGameManager?):
                    MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)
                    if: 
                        PlayerData := MaybePlayerData?,
                        EventMediator := MaybeEventMediator?
                        RankManager := MaybeMainRankManager?
                    then:
                        TeamNumber:= PlayerData.GetTeamNumber()

                        if(TeamNumber = 0):
                            PlayerData.SetPlayerMatchesWon(1)
                            PlayerData.SetPlayerPrestige(40)
                            PlayerData.SaveDataForPlayer()
                            
                            EventMediator.EmitAgentEvent(EventMediator.OnWonMatchXP, CurrentGamePlayer)
                            RankManager.CalculatePlayerRank(CurrentGamePlayer)

                        else:
                            EventMediator.EmitAgentEvent(EventMediator.OnLoseMatchXP, CurrentGamePlayer)


                        CurrentGameKillstreak := PlayerData.GetCurrentGameKillstreak()
                        HighestGameKillstreak := PlayerData.GetCurrentGameHighestKillstreak()

                        if(CurrentGameKillstreak > HighestGameKillstreak):
                            PlayerData.UpdateCurrentGameHighestKillstreak(CurrentGameKillstreak)

                        UpdatedHighestGameKillstreak := PlayerData.GetCurrentGameHighestKillstreak()
                        HighestEverKillstreak := PlayerData.GetHighestEverKillstreak()

                        if(HighestGameKillstreak > HighestEverKillstreak):
                            PlayerData.UpdateHighestEverKillstreak(UpdatedHighestGameKillstreak)



    UpdateTeam2ScoreAfterWin(): void =
        set Team2Score += 1
        
        if(PregameLobby := MaybePregameLobby?, GameManager := MaybeGameManager?):
            for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)
                if(PlayerData := MaybePlayerData?):
                    PlayerData.UpdateTeam2ScoreUI(Team2Score)

        if(Team2Score  = RoundVictoriesToWin, PregameLobby := MaybePregameLobby?):
            set TeamVictory = true
            EndGameSlowedTime_CinematicSequencer.Play()

            if(EventMediator := MaybeEventMediator?):
                EventMediator.EmitOnGameEnds()

            for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                if(GameManager := MaybeGameManager?):
                    MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)
                    if:
                        PlayerData := MaybePlayerData?,
                        EventMediator := MaybeEventMediator?,
                        RankManager := MaybeMainRankManager?
                    then:
                        TeamNumber:= PlayerData.GetTeamNumber()

                        if(TeamNumber = 1):
                            PlayerData.SetPlayerMatchesWon(1)
                            PlayerData.SetPlayerPrestige(40)
                            PlayerData.SaveDataForPlayer()
                           
                            EventMediator.EmitAgentEvent(EventMediator.OnWonMatchXP, CurrentGamePlayer)

                        else:
                            EventMediator.EmitAgentEvent(EventMediator.OnLoseMatchXP, CurrentGamePlayer)

                        
                        CurrentGameKillstreak := PlayerData.GetCurrentGameKillstreak()
                        HighestGameKillstreak := PlayerData.GetCurrentGameHighestKillstreak()

                        if(CurrentGameKillstreak > HighestGameKillstreak):
                            PlayerData.UpdateCurrentGameHighestKillstreak(CurrentGameKillstreak)

                        UpdatedHighestGameKillstreak := PlayerData.GetCurrentGameHighestKillstreak()
                        HighestEverKillstreak := PlayerData.GetHighestEverKillstreak()

                        if(HighestGameKillstreak > HighestEverKillstreak):
                            PlayerData.UpdateHighestEverKillstreak(UpdatedHighestGameKillstreak)


    PlayRoundCountdownSoundCues()<suspends>: void = 
        loop:
            if(SoundCuesPlayedCounter = 3):
                set SoundCuesPlayedCounter = 0 
                SoundCueCompletion.Play()
                break
            if(SoundCuesPlayedCounter = 1):
                SoundCueSecond2.Play()
            if(SoundCuesPlayedCounter = 2):
                SoundCueSecond3.Play()

            SoundCueSecond1.Play()
            set SoundCuesPlayedCounter += 1
            Sleep(1.0)



        



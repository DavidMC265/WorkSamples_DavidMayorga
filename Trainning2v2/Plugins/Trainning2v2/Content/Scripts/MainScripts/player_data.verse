using { MainScripts }
# using { /Verse.org/SpatialMath }
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
# using { /Verse.org/SpatialMath }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using { RoundSystem}

var PersistablePlayerDataMap<public> : weak_map(player, persistable_agent_data) = map{}

persistable_agent_data<public> := class<final><persistable>:
    Version<public> : float
    Currency<public> : float
    Kills<public> : int
    Prestige<public> : int 
    HighestEverKillstreak<public> : int 
    Assists<public>: int 
    Deaths<public> : int
    MatchesWon<public> : int
    Rank<public> : int 
    CurrentGamePlayedTimeMinutes<public> : int
    CurrentQuest<public> : EQuests

PrintAgentNameMsg<localizes><public>(Agent:agent,Msg:string)<computes>: message = "⁙{Agent}⁙: {Msg}"
GetAgentName<localizes><public>(Agent:agent)<computes>: message = "{Agent}"
PlayerNameUI<localizes><public>(PlayerName : agent) : message = "{PlayerName}"

player_data<public> := class<final><unique>:

    Logger:log = log{Channel := simple_log, DefaultLevel := log_level.Normal}
    DebugLogger:log = log{Channel := debugging_tester_log, DefaultLevel := log_level.Debug}
    ExceptionLogger:log = log{Channel := catch_exceptions_log, DefaultLevel := log_level.Warning}
    
    Agent<public> : agent
    AgentName<public> : message
    Character<public> : fort_character
    GameManager<public>: game_manager
    EventMediator<public> : event_mediator
    UIManager<public> : ui_manager = ui_manager {}

    var Version: float = 0.0
    var Currency : float = 0.0
    var LastSavePlayedSeconds : float = 0.0
    var CurrentPlayedTimeSeconds : int = 0
    var CurrentGamePlayedTimeMinutes : int = 0
    var PlayerCheckPoint: vector3 = vector3{}
    var PlaytimeSeconds : float = 0.0
    var TeamNumber<public> : int = 0
    var Kills : int = 0
    var Prestige: int = 0
    var HighestEverKillstreak : int = 0
    var Assists : int = 0 
    var Deaths: int = 0
    var MatchesWon : int = 0
    var HasLoadout : logic = false
    var Rank : int = 0
    var CurrentQuest : EQuests = EQuests.None
    var CurrentGameEliminations : int = 0
    var CurrentGameKillstreak : int = 0
    var HighestCurrentGameKillstreak : int = 0
    var CurrentGameAssists : int = 0
    var HasLeftTheGame<public> : logic = false
    var HasSummaryPlacement<public>: logic = false
    var hasHat<public> : logic = false
    var bIsMusicPlaying : logic = false

    var HasSelectedTeam<public> : logic = false
    var HasSelectedTeamAsJoinedPlayer<public> : logic = false

    var FullLoadOutGranter<public>: ?item_granter_device = false

    var RifleOrSMGGranter<public> : ?item_granter_device = false
    var RifleOrSMGIndex<public> : ?int = false
    var RifleOrSMGRemover<public> : ?item_remover_device = false

    var ShotgunGranter<public> : ?item_granter_device = false
    var ShotgunIndex<public> : ?int = false
    var ShotgunRemover<public> : ?item_remover_device = false

    var HealingItemsGranter<public> : ?item_granter_device = false
    var HealingItemsIndex<public> : ?int = false
    var HealingItemsRemover<public> : ?item_remover_device = false

    var HealingItemsGranter2<public> : ?item_granter_device = false
    var HealingItemsIndex2<public> : ?int = false
    var HealingItemsRemover2<public> : ?item_remover_device = false

    var RespawningLocationSpectator<public> : vector3 = vector3{}
    var DefaultClassAndTeamSelector<public> : ?class_and_team_selector_device = false

    #Aura Removers
    var BlueAuraTrigger<public> : ?trigger_device = false
    var RedAuraTrigger<public> : ?trigger_device = false
    var GoldenAuraTrigger<public> : ?trigger_device = false
    var DarkAuraTrigger<public> : ?trigger_device = false
    var AllAurasTrigger<public> : ?trigger_device = false
    #Aura VFXs
    var BlueVFX<public> : ?visual_effect_powerup_device = false
    var RedVFX<public> : ?visual_effect_powerup_device = false
    var GoldenVFX<public> : ?visual_effect_powerup_device = false
    var DarkVFX<public> : ?visual_effect_powerup_device = false 

    #Aura Messages
    var BlueAuraMessage<public> : ?hud_message_device = false
    var RedAuraMessage<public> : ?hud_message_device = false
    var GoldenAuraMessage<public> : ?hud_message_device = false
    var DarkAuraMessage<public> : ?hud_message_device = false



    InitPlayerData<public>():void=
        InitEveryUI()
        set LastSavePlayedSeconds=GetSimulationElapsedTime()
        set PlayerCheckPoint = Character.GetTransform().Translation
    
    SaveDataForPlayer<public>():void=
        if:
            Player := player[Agent]
            set PersistablePlayerDataMap[Player]=AgentDataTmpToPersistent()
    
    LoadSaveDataForPlayer<public>():void=
        if:
            Player := player[Agent]
            if:
                PlayerPersistableData:=PersistablePlayerDataMap[Player]
            then:
                AgentDataPersistentToTmp(PlayerPersistableData)
            else:
                set PersistablePlayerDataMap[Player]=AgentDataTmpToPersistent()

    AgentDataTmpToPersistent()<transacts>:persistable_agent_data=
        CurrentTime := GetSimulationElapsedTime()            
        persistable_agent_data
        {
            Version:= Version
            Currency:= Currency
            Kills := Kills
            Prestige := Prestige
            HighestEverKillstreak := HighestEverKillstreak
            Assists := Assists
            Deaths := Deaths
            MatchesWon := MatchesWon
            Rank := Rank 
            CurrentGamePlayedTimeMinutes := CurrentGamePlayedTimeMinutes
            CurrentQuest := CurrentQuest
        }

    AgentDataPersistentToTmp(PersistableAgentData : persistable_agent_data)<transacts>:void=
        set Version = PersistableAgentData.Version
        set Currency = PersistableAgentData.Currency
        set Kills = PersistableAgentData.Kills
        set Prestige = PersistableAgentData.Prestige
        set HighestEverKillstreak = PersistableAgentData.HighestEverKillstreak
        set Assists = PersistableAgentData.Assists
        set Deaths = PersistableAgentData.Deaths
        set MatchesWon = PersistableAgentData.MatchesWon
        set Rank = PersistableAgentData.Rank
        set CurrentGamePlayedTimeMinutes = PersistableAgentData.CurrentGamePlayedTimeMinutes
        set CurrentQuest = PersistableAgentData.CurrentQuest
        
    # SaveCheckpoint<public>():void=
    #     set PlayerCheckPoint = Character.GetTransform().Translation
    #     Print("Checkpoint saved")
    
    # LoadCheckpoint<public>():void=
    #     PlayerTransform:=Character.GetTransform()
    #     if(Character.TeleportTo[PlayerCheckPoint, PlayerTransform.Rotation]){}

    Debug_AddPlaytimeSeconds<public>(Value:float):void=
        var aux:float=GetSimulationElapsedTime()
        var timePlayed:float=aux-LastSavePlayedSeconds
        set LastSavePlayedSeconds=aux
        set PlaytimeSeconds +=timePlayed
        set PlaytimeSeconds +=Value

    UpdatePlaytimeSeconds<public>():void=
        var aux:float=GetSimulationElapsedTime()
        var timePlayed:float=aux-LastSavePlayedSeconds
        set LastSavePlayedSeconds=aux
        set PlaytimeSeconds +=timePlayed

    ResetPlaytimeSeconds<public>():void=
        var aux:float=GetSimulationElapsedTime()
        var timePlayed:float=aux-LastSavePlayedSeconds
        set LastSavePlayedSeconds=aux
        set PlaytimeSeconds =0.0

    GetPlaytimeSeconds<public>():float=
        return PlaytimeSeconds


    GetTeamNumber<public>()<transacts>: int =
        return TeamNumber

    SetTeamNumber<public>(NewValue : int): void =
        set TeamNumber = NewValue

    GetPlayerKills<public>(): int = 
        return Kills

    SetPlayerKills<public>(Value : int): void= 
        set Kills += Value

    GetPlayerPrestige<public>(): int =
        return Prestige

    SetPlayerPrestige<public>(Value : int): void =
        set Prestige += Value

    GetPlayerDeaths<public>(): int =
        return Deaths
    
    SetPlayerDeaths<public>(Value : int): void =
        set Deaths += Value

    GetPlayerAssits<public>(): int =
        return Assists

    SetPlayerAssists<public>(Value : int): void =
        set Assists += Value

    GetPlayerMatchesWon<public>(): int =
        return MatchesWon

    SetPlayerMatchesWon<public>(Value : int): void =
        set MatchesWon += Value

    GetPlayerLoadout<public>(): logic =
        return HasLoadout

    SetPlayerLoadout<public>(Value : logic): void =
        set HasLoadout = Value

    GetPlayerRank<public>(): int =
        return Rank
        
    SetPlayerRank<public>(Value : int): void =
        set Rank += Value

    GetCurrentQuest<public>() : EQuests =
        return CurrentQuest
    
    SetCurrentQuest<public>(NewQuest : EQuests): void =
        set CurrentQuest = NewQuest

    GetCurrentGameEliminations<public>(): int =
        return CurrentGameEliminations  

    SetCurrentGameEliminations<public>(Value : int): void =
        set CurrentGameEliminations += Value

    GetCurrentGameKillstreak<public>(): int =
        return CurrentGameKillstreak  

    SetCurrentGameKillstreak<public>(Value : int): void =
        set CurrentGameKillstreak += Value

    ResetCurrentGameKillstreak<public>(): void=
        set CurrentGameKillstreak = 0

    GetCurrentGameHighestKillstreak<public>(): int =
        return HighestCurrentGameKillstreak

    UpdateCurrentGameHighestKillstreak<public>(Value : int): void =
        set HighestCurrentGameKillstreak = Value

    GetHighestEverKillstreak<public>() : int =
        return HighestEverKillstreak

    UpdateHighestEverKillstreak<public>(Value : int) : int =
        set HighestEverKillstreak = Value

    GetCurrentGameAssists<public>(): int = 
        return CurrentGameAssists

    SetCurrentGameAssists<public>(Value : int): void =
        set CurrentGameAssists += Value
        
    Debug_RemovePlayer<public>():void=
        PrintAgentNameMsg(Agent,"left the game")

    GetCurrentGamePlayedTimeMinutes<public>():int=
        return CurrentGamePlayedTimeMinutes

    IncrementCurrentGamePlayedTimeMinutes<public>(): void=
        set CurrentGamePlayedTimeMinutes += 1

    ResetCurrentGamePlayedTimeMinutes<public>(): void =
        set CurrentGamePlayedTimeMinutes = 0

    GetCurrentGamePlayedTimeSeconds<public>(): int =
        return CurrentPlayedTimeSeconds

    IncrementCurrentGamePlayedTimeSeconds<public>(): void=
        set CurrentPlayedTimeSeconds += 1

    ResetCurrentGamePlayedTimeSeconds<public>(): void =
        set CurrentPlayedTimeSeconds = 0    

    GetIsMusicPlayingPlayer<public>()<transacts>: logic =
        return bIsMusicPlaying

    SetIsMusicPlayingPlayer<public>(Value : logic): void =
        set bIsMusicPlaying = Value


        #UI            
    InitEveryUI<public>():void=
        UIManager.InitEveryPlayerUI(Agent,GameManager,option{Self},EventMediator)

    ShowResourcesUI<public>():void=
        Print("Showing Resurces UI from player Data")
        # UIManager.Resources.Show()
        # All the UI values that uses player values must be updated from the player data UIManager
        # UIManager.Resources.UpdateResources(100.0,200.0,3.0,40,50) #Example on how to update the resources

    HideResourcesUI<public>():void=
        # UIManager.Resources.Hide()
        Print("Hiding Resurces UI from player Data")

    ShowPlayerInfoUI<public>():void =
        # UIManager.PlayerInfo.Show()
        Print("Showing PlayerInfo UI from player Data")
        
    HidePlayerInfoUI<public>():void =
        Print("Hiding")
        # UIManager.PlayerInfo.Hide()

    ShowScoreboardUI<public>(Team1Score : int, Team2Score : int):void=
        UIManager.Scoreboard.Show()
        UIManager.Scoreboard.SetScores(Team1Score, Team2Score)
        # All the UI values that uses player values must be updated from the player data UIManager
        # UIManager.Resources.UpdateResources(100.0,200.0,3.0,40,50) #Example on how to update the resources

    HideScoreboardUI<public>():void=
        UIManager.Scoreboard.Hide()

    UpdateTeam1ScoreUI<public>(UpdatedScore : int):void =
        UIManager.Scoreboard.UpdateTeam1Score(UpdatedScore)

    UpdateTeam2ScoreUI<public>(UpdatedScore : int):void =
        UIManager.Scoreboard.UpdateTeam2Score(UpdatedScore)

    ShowTwoPlayersLeftUI<public>():void=
        UIManager.TwoPlayersLeft.Show()

    HideTwoPlayersLeftUI<public>():void=
        UIManager.TwoPlayersLeft.Hide()

    ShowTeamSelectionUI<public>():void =
        UIManager.TeamSelection.Show()

    HideTeamSelectionUI<public>(): void =
        UIManager.TeamSelection.Hide()

    UpdateTeamSelectionUITeam1<public>(): void =
        UIManager.TeamSelection.OnTeam1Choosen()

    UpdateTeamSelectionUITeam2<public>(): void =
        UIManager.TeamSelection.OnTeam2Choosen()

    RePositionTeamSelectionUI<public>(): void =
        Print("Re Positioning Team Selection UI")
        # UIManager.TeamSelection.RePositionTeamChoosenUI(GetTeamNumber())

    ShowSpectatorUI<public>(): void =
        UIManager.Spectator.ShowInteract()

    HideSpectatorUI<public>(): void =
        UIManager.Spectator.Hide()

    ShowGameStartClockUI<public>(Seconds : int, GameStartsClockString : string): void =
        UIManager.GameStartClock.Show()
        UIManager.GameStartClock.ShowCountdownUI(Seconds, GameStartsClockString)

    HideGameStartClockUI<public>(): void =
        UIManager.GameStartClock.Hide()

    ShowWeaponSelectionTimerUI<public>(): void =
        UIManager.WeaponSelectionTimer.Show()
        UIManager.WeaponSelectionTimer.ShowWeaponSelectionCountdownUI()

    HideWeaponSelectionTimerUI<public>(): void =
        UIManager.WeaponSelectionTimer.Hide()

    ShowRoundStartCountdownUI<public>():void =
        UIManager.RoundStartCountdownTimer.Show()
        UIManager.RoundStartCountdownTimer.ShowRoundStartCountdown()

    HideRoundStartCountdoownUI<public>(): void=
        UIManager.RoundStartCountdownTimer.Hide() 

    ShowMatchSummaryUI<public>(MatchSummaryInfo : match_summary_info): void =
        UIManager.MatchSummary.ShowInteract()
        UIManager.MatchSummary.SetSummaryValues(MatchSummaryInfo)

    HideSummaryUI<public>(): void =
        UIManager.MatchSummary.Hide()







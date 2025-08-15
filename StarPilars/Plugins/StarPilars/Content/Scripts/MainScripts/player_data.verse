using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using {MainScripts}
using { GameAreas }

var PersistablePlayerDataMap<public> : weak_map(player, persistable_agent_data) = map{}

persistable_agent_data<public> := class<final><persistable>:
    Version<public> : float
    Currency<public> : float
    HatsOwned<public> : []EHats
    CuurentHat<public>: EHats
    CurrentQuest<public>: EQuests
    CompletedQuests<public>: []EQuests

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
    GameManager<public> : game_manager
    UIManager<public> : ui_manager = ui_manager {}

    var Version: float = 0.0
    var Currency : float = 0.0
    var CurrencyMultiplier : float = 1.0
    var LastSavePlayedSeconds : float = 0.0
    var PlayerCheckPoint: vector3 = vector3{}
    var PlaytimeSeconds : float = 0.0
    var bHasLandedInPillarsArena : logic = false
    var BountySetInfo : ?PlayerBountyInfo = false
    var BountyAcceptedInfo : ?PlayerBountyInfo = false
    var HatsOwned : []EHats = array{}
    var CuurentHat : EHats = EHats.None
    var MinutesPlayedHUDIndex : ?int = false
    var CurrentQuest : EQuests = EQuests.None
    var CompletedQuests : []EQuests = array{}
    var IncompleteQuests : []EQuests = array{}
    var IsMusicPlaying : logic = false
    var HasFallen : logic = false
    #var MinutesPlayed : int = 2
    #var SecondsPlayed : int = 30

    var CurrentBountyCount : int = 0
    var BountiesCreatedCount : int = 0

    InitPlayerData<public>():void=
        InitEveryUI()
        set LastSavePlayedSeconds=GetSimulationElapsedTime()
        set PlayerCheckPoint = Character.GetTransform().Translation
        
    SaveCheckpoint<public>():void=
        set PlayerCheckPoint = Character.GetTransform().Translation
    
    LoadCheckpoint<public>():void=
        PlayerTransform:=Character.GetTransform()
        if(Character.TeleportTo[PlayerCheckPoint, PlayerTransform.Rotation]){}

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

    Debug_RemovePlayer<public>():void=
        PrintAgentNameMsg(Agent,"left the game")


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
            HatsOwned := HatsOwned
            CurrentQuest := CurrentQuest
            CompletedQuests := CompletedQuests
            CuurentHat := CuurentHat
        }

    AgentDataPersistentToTmp(PersistableAgentData : persistable_agent_data)<transacts>:void=
        set Version = PersistableAgentData.Version
        set Currency = PersistableAgentData.Currency
        set HatsOwned = PersistableAgentData.HatsOwned
        set CuurentHat = PersistableAgentData.CuurentHat
        set CurrentQuest = PersistableAgentData.CurrentQuest
        set CompletedQuests = PersistableAgentData.CompletedQuests

    GetCurrency<public>()<transacts>: float =
        return Currency

    SetCurrency<public>(NewValue : float): void =
        set Currency = NewValue
            #Update UI
        UpdatePlayerCurrencyUI(Currency)
        SaveDataForPlayer()

    IncrementCurrency<public>(Value : float): void =
        NewCurrency : float = Currency + Value

        Total : float = NewCurrency * CurrencyMultiplier
        set Currency = Total
            #Update UI 
        UpdatePlayerCurrencyUI(Currency)
        SaveDataForPlayer()

    DecrementCurrency<public>(Value : float): void =
        if(Currency <= 0.0):
            Print("Cannot Decrement player currency any further")
            return
        set Currency -= Value
            #Update UI 
        UpdatePlayerCurrencyUI(Currency)
        SaveDataForPlayer()

    GetCurrencyMultiplier<public>(): float =
        return CurrencyMultiplier

    SetCurrencyMultiplier<public>(NewMultiplier : float): void =
        set CurrencyMultiplier = NewMultiplier

    GetHasLandedInPillarsArena<public>(): logic = 
        return bHasLandedInPillarsArena

    SetHasLandedInPillarsArena<public>(Value : logic): void = 
        set bHasLandedInPillarsArena = Value

    GetMaybePlayerBountySetInfo<public>(): ?PlayerBountyInfo = 
        return BountySetInfo

    SetMaybePlayerBountySetInfo<public>(Value : ?PlayerBountyInfo): void =
        set BountySetInfo = Value

    GetMaybePlayerBountyAcceptedInfo<public>(): ?PlayerBountyInfo = 
        return BountyAcceptedInfo

    SetMaybePlayerBountyAcceptedInfo<public>(Value : ?PlayerBountyInfo): void =
        set BountyAcceptedInfo = Value 

    GetCurrentBountyCount<public>(): int =
        return CurrentBountyCount
    
    SetCurrentBountyCount<public>(Value : int): void =
        set CurrentBountyCount += 1

    GetBountiesCreatedCount<public>(): int =
        return BountiesCreatedCount
    
    IncrementBountiesCreatedCount<public>(Value : int): void =
        set BountiesCreatedCount += 1

    GetHatsOwned<public>()<transacts>: []EHats =
        return HatsOwned

    UpdateHatsOwned<public>(NewHat : EHats): void =
        set HatsOwned += array{ NewHat }

    GetHasFallen<public>(): logic =
        return HasFallen
        
    SetHasFallen<public>(Value : logic): void =
        set HasFallen = Value

    GetCurrentHat<public>(): EHats =
        return CuurentHat

    SetCurrentHat<public>(NewHat : EHats): void =
        set CuurentHat = NewHat

    ResetHatsOwned<public>(): void =
        set HatsOwned = array{ }

    GetMinutesPlayedHUDIndex<public>(): ?int =
        return MinutesPlayedHUDIndex

    SetMinutesPlayedHUDIndex<public>(Value : int): void =
        set MinutesPlayedHUDIndex = option{ Value }

    GetCurrentQuest<public>()<transacts>: EQuests =
        return CurrentQuest

    SetCurrentQuest<public>(NewQuest : EQuests): void =
        set CurrentQuest = NewQuest

    GetCompletedQuests<public>(): []EQuests =
        return CompletedQuests

    SetCompletedQuests<public>(NewQuest : EQuests): void =
        set CompletedQuests += array{ NewQuest }

    GetIncompleteQuests<public>()<transacts>: []EQuests =
        return IncompleteQuests

    SetIncompleteQuests<public>(Quest : EQuests): void =
        set IncompleteQuests += array{ Quest }

    GetIsMusicPlayingPlayer<public>()<transacts>: logic =
        return IsMusicPlaying

    SetIsMusicPlayingPlayer<public>(Value : logic): void =
        set IsMusicPlaying = Value

    #SetMinutesPlayed<public>(Value : int): void =
        #set MinutesPlayed = Value

    #GetSecondsPlayed<public>(): int =
        #return SecondsPlayed

    #SetSecondsPlayed<public>(Value : int): void =
        #set SecondsPlayed = Value
    

        #UI
    InitEveryUI<public>():void=
        UIManager.InitEveryPlayerUI(Agent,GameManager,option{Self})

    ShowSpectatorModeUI<public>(MaybeEventMediator : ?event_mediator, MaybeRespawningLobbyInfo : ?tuple(vector3, creative_prop), MaybeRespawningPropInfo : ?tuple(vector3, creative_prop) ): void =
        UIManager.SpectatorModeUI.ShowInteract()
        UIManager.SpectatorModeUI.InitVariables(MaybeEventMediator, MaybeRespawningLobbyInfo, MaybeRespawningPropInfo)

    HideSpectatorModeUI<public>(): void =
        UIManager.SpectatorModeUI.Hide()

    ShowSetPlayerBountyUI<public>(MinValue : float, MaxValue : float): void =
        UIManager.SetPlayerBountyUI.ShowInteract()
        UIManager.SetPlayerBountyUI.SetSliderValues(MinValue, MaxValue)

    HideSetPlayerBountyUI<public>(): void =
        UIManager.SetPlayerBountyUI.Hide()

    ShowPlayerCurrencyUI<public>(BackgroundIconColor : color): void =
        UIManager.PlayerCurrencyUI.Show()
        UIManager.PlayerCurrencyUI.SetValues(BackgroundIconColor)
    
    UpdatePlayerCurrencyUI<public>(Value : float): void =
        UIManager.PlayerCurrencyUI.UpdateCurrency(Value)

    HidePlayerCurrencyUI<public>(): void =
        UIManager.PlayerCurrencyUI.Hide()

    ShowHatsOwnedUI<public>(): void =
        UIManager.HatsOwnedPlayerUI.ShowInteract()
        UIManager.HatsOwnedPlayerUI.SubscribeButtonEvents()
        UIManager.HatsOwnedPlayerUI.SetButtonTexts()

    HideHatsOwnedUI<public>(): void =
        UIManager.HatsOwnedPlayerUI.Hide()

    ShowChairSpectatorUI<public>(): void =
        UIManager.ChairSpectatorUI.Show()
        spawn:
            UIManager.ChairSpectatorUI.StartTimerIncrease()

    HideChairSpectatorUI<public>(): void =
        UIManager.ChairSpectatorUI.Hide()
        UIManager.ChairSpectatorUI.StopTimerIncrease()

    ShowXPShopUI<public>(VerySmallAmount : int, SmallAmount : int, MediumAmount : int, LargeAmount : int, VeryLargeAmount : int): void =
        UIManager.XPShopUI.ShowInteract()
        UIManager.XPShopUI.SetTextPrices(VerySmallAmount, SmallAmount, MediumAmount, LargeAmount, VeryLargeAmount)

    HideXPShopUI<public>(): void =
        UIManager.XPShopUI.Hide()

    
    
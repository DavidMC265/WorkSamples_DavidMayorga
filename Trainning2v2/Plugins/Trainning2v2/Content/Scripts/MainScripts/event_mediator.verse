using { /Verse.org/Colors }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation }


event_mediator<public> := class(creative_device):

    OnExampleVoidEvent<public>: event() = event(){}

    OnRoundIsReadyToStart<public>: event() = event(){}

    OnFirstRoundStarted<public> : event() = event(){}

    OnRoundStarted<public>: event() = event(){}

    OnRoundTimerStartCompleted<public>: event() = event(){}
    
    OnLoadInventory<public>: event(agent) = event(agent){}

    OnExampleAgentEvent<public>: event(agent) = event(agent){}

    OnExampleTupleEvent<public>: event(tuple(agent,int)) = event(tuple(agent,int)){}

    OnExampleClassEvent<public>: event(player_data) = event(player_data){}

    OnGameEnds<public>: event() = event(){}

    OnKillXP<public>: event(agent)=event(agent){}

    OnRankUpXP<public>: event(agent)=event(agent){}

    OnRoundWinXP<public>: event(agent)=event(agent){}

    OnRoundLoseXP<public>: event(agent)=event(agent){}

    OnPracticeXP<public>: event(agent)=event(agent){}

    OnDeathXP<public>: event(agent)=event(agent){}

    OnLoseMatchXP<public>: event(agent)=event(agent){}

    OnWonMatchXP<public>: event(agent)=event(agent){}

    OnPlayersAreSentToPodium<public>: event() =event(){}

    OnPlayerClosesSpectatorUI<public>: event(agent) = event(agent){}

    OnGameStartClockFinished<public> : event() = event(){}

    OnRoundStartTimerCountdownCompleted<public> : event() = event(){}


    OnWeaponSelectionTimerCompleted<public> : event() = event(){}
    var WeaponSelectionTerminateCountdown<public> : logic = false



    EmitVoidEvent<public>(Evt: event()): void =
        Evt.Signal()

    EmitAgentEvent<public>(Evt: event(agent),Agent:agent): void =
        Evt.Signal(Agent)

    EmitIntAgentEvent<public>(Evt: event(tuple(agent,int)),Agent:agent,Number:int): void =
        Evt.Signal((Agent,Number))

    EmitPlayerDataEvent<public>(Evt: event(player_data),PlayerData:player_data): void =
        Evt.Signal(PlayerData)

    EmitRoundStarted<public>(): void =
        OnRoundStarted.Signal()

    EmitOnLoadInventory<public>(Agent : agent): void =
        OnLoadInventory.Signal(Agent)

    EmitFirstRoundStarted<public>(): void = 
        OnRoundIsReadyToStart.Signal()

    EmitOnGameEnds<public>(): void = 
        OnGameEnds.Signal()

    EmitOnRoundTimerStartCompleted<public>(): void =
        OnRoundTimerStartCompleted.Signal()

    EmitOnPlayersAreSentToPodium<public>(): void =
        OnPlayersAreSentToPodium.Signal()

    EmitOnSpectatorModeUIClosed<public>(Agent : agent): void =
        OnPlayerClosesSpectatorUI.Signal(Agent)

    EmitOnGameStartClockFinished<public>(): void =
        OnGameStartClockFinished.Signal()

    EmitOnWeaponSelectionTimerCompleted<public>(): void =
        OnWeaponSelectionTimerCompleted.Signal()
        set WeaponSelectionTerminateCountdown = true

    EmitOnRoundStartTimerCountdownCompleted<public>(): void =
        OnRoundStartTimerCountdownCompleted.Signal()

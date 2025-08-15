using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation }


event_mediator<public> := class(creative_device):

    OnExampleVoidEvent<public>: event() = event(){}
    
    OnExampleAgentEvent<public>: event(agent) = event(agent){}

    OnExampleTupleEvent<public>: event(tuple(agent,int)) = event(tuple(agent,int)){}

    OnExampleClassEvent<public>: event(player_data) = event(player_data){}

    OnGameStarted<public>: event([]player) = event([]player){}


    EmitVoidEvent<public>(Evt: event()): void =
        Evt.Signal()

    EmitAgentEvent<public>(Evt: event(agent),Agent:agent): void =
        Evt.Signal(Agent)

    EmitIntAgentEvent<public>(Evt: event(tuple(agent,int)),Agent:agent,Number:int): void =
        Evt.Signal((Agent,Number))

    EmitPlayerDataEvent<public>(Evt: event(player_data),PlayerData:player_data): void =
        Evt.Signal(PlayerData)

    EmitOnGameStarted<public>(StartingPlayers : []player): void =
        OnGameStarted.Signal(StartingPlayers)
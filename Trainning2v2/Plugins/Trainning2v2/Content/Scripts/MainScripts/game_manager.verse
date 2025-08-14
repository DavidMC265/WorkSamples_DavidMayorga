using { Lib }
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/Diagnostics }

game_manager<public> := class(creative_device):

    @editable       EventMediator : event_mediator = event_mediator{}

    var PlayerDataMap : [agent]player_data = map{}

    OnBegin<override>()<suspends>:void=  
        SetupPlayers()

    SetupPlayers<private>():void=
        Playspace := Self.GetPlayspace()
        Playspace.PlayerAddedEvent().Subscribe(AddPlayer)
        Playspace.PlayerRemovedEvent().Subscribe(RemovePlayer)
        Players := Playspace.GetPlayers()
        for (Player : Players):
            AddPlayer(Player)

    RemovePlayer<private>(Agent:agent):void=    
        if:
            PlayerData:=PlayerDataMap[Agent]
        then:
            PlayerData.Debug_RemovePlayer()

    AddPlayer<private>(Agent:agent):void=
        PlayerName:= PlayerNameUI(Agent)
        if:
            PlayerData := player_data:
                Agent := Agent
                AgentName:= PlayerName
                Character := Agent.GetFortCharacter[]
                GameManager := Self
                EventMediator := EventMediator
            set PlayerDataMap[Agent] = PlayerData
        then:
            PlayerData.InitPlayerData()
            PlayerData.LoadSaveDataForPlayer()

    GetMaybePlayerData<public>(Agent:agent)<transacts>:?player_data=
        if:
            PlayerData:=PlayerDataMap[Agent]
        then:
            return option{PlayerData}
        else:
            return false
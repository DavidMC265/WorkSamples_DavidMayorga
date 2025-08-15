using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using { /Verse.org/Colors/NamedColors }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { GameAreas }

# using { Lib }

GameManager_DependecyInjector<localizes>:message = "Dependency Injector"

game_manager<public> := class(creative_device):
        
    var PlayerDataMap : [agent]player_data = map{}

    #Dependencies
    @editable:
        Categories := array{ GameManager_DependecyInjector }
    var MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeBountyHunting<public> : ?bounty_hunting = false
    var MaybeHatStore<public>: ?hat_store = false
    var MaybeAccoladeManager<public> : ?accolade_manager = false
    var MaybeXPShop<public>: ?xp_shop = false

    OnBegin<override>()<suspends>:void=  
        SetupDependencies()          
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


    SetupDependencies():void = 
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeBountyHunting = DependencyInjector.GetBountyHunting()
            set MaybeHatStore = DependencyInjector.GetHatStore()
            set MaybeAccoladeManager = DependencyInjector.GetAccoladeManager()
            set MaybeXPShop = DependencyInjector.GetXPShop()
        else:
            Print(
                "Dependency Injector not available from bounty_hunting script",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )
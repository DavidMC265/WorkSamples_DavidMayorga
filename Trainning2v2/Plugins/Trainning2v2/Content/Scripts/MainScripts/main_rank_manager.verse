using { /Verse.org/Colors }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { MainScripts }
using { Lib }
using {UIScripts}


main_rank_manager<public> := class(creative_device):

    @editable
    MaybeDependencyInjector : ?dependency_injector = false
    @editable
    UIRanks : ui_ranks = ui_ranks{}
    @editable
    Settings : rank_settings = rank_settings{}
    @editable
    PlayerSpawners : []player_spawner_device = array{}
    @editable
    JoiningSpawners : []player_spawner_device = array{}

        #Rank Icon Materials
    @editable
    UnrankedIconMat<public>: ?material = false
    @editable
    BronzeIconMat<public>: ?material = false
    @editable
    SilverIconMat<public>: ?material = false
    @editable
    GoldIconMat<public>: ?material = false
    @editable
    PlatinumIconMat<public>: ?material = false
    @editable
    DiamondIconMat<public>: ?material = false
        
    
    var AllPlayers : []player = array{}
    var MaybeGameManager: ?game_manager = false
    var MaybeEventMediator : ?event_mediator = false
    

    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        Sleep(1.0)
        set AllPlayers = GetPlayspace().GetPlayers()
        
        for(Player : AllPlayers):
            UIRanks.Init(Player)
            Sleep(0.3)
            UIRanks.InitRankUI(Player , Settings)
            CalculatePlayerRank(Player)
                
        # Subscribe players who join the game
        for(Player : PlayerSpawners):
            Player.SpawnedEvent.Subscribe(OnPLayerJoinGame)

        for(Player : JoiningSpawners):
            Player.SpawnedEvent.Subscribe(OnPLayerJoinGame)

    CalculatePlayerRank<public>(Agent : agent):void= 
        if(GameManager := MaybeGameManager?, Player := player[Agent]):
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            if:
                PlayerData := MaybePlayerData?
            then:
                CurrentPrestige := PlayerData.GetPlayerPrestige()
                CurrentRankIndex := PlayerData.GetPlayerRank()
                #Print("CurrentPrestige for player : {CurrentPrestige}", ?Duration := 10.0, ?Color := NamedColors.LightGreen)
                UIRanks.UpdateProgress(Player, Settings)
                #Rank up
                if(NextRank := Settings.Ranks[CurrentRankIndex+1]):
                    if(CurrentPrestige >= NextRank.PointsNeeded):
                        PlayerData.SetPlayerRank(1)
                        UIRanks.UpdateRank(Player , Settings)
                        PlayerData.SaveDataForPlayer()
                        if(EventMediator := MaybeEventMediator?):
                            EventMediator.EmitAgentEvent(EventMediator.OnRankUpXP,Agent)

                else:
                    Print(
                        "No more ranks available!!!",
                        ?Duration := 4.0, 
                        ?Color := NamedColors.Red
                    )
                    
                #Rank down
                if(CurrentRank := Settings.Ranks[CurrentRankIndex]):
                    if(CurrentPrestige < CurrentRank.PointsNeeded):
                        PlayerData.SetPlayerRank(-1)
                        UIRanks.UpdateRank(Player , Settings)

    OnPLayerJoinGame(Agent : agent):void=
        if(Player := player[Agent]):
            UIRanks.Init(Player)
            UIRanks.InitRankUI(Player , Settings)
            CalculatePlayerRank(Player)

    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeEventMediator = DependencyInjector.GetEventMediator()

        else:
            Print(
                "Dependency Injector not available",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )

rank := class<concrete>:
    @editable
    Name : string = "Rank"
    @editable
    PointsNeeded : int = 0
    @editable
    ForegroundColor : color = color{}
    @editable
    BackgroundColor : color = color{}
    @editable
    ImageSize : vector2 = vector2{X:=80.0, Y:=70.0}
 
using { CustomProps }
rank_settings := class<concrete>:
    @editable
    Ranks : []rank = array{}
    Images<public> : []texture = array:
        Unranked
        Bronze_Initiate
        Silver_Adept
        Gold_Master
        Platinum_Elite
        Diamond_Legend



using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { MainScripts }
using { Lib }

PlayerScores := class():
    var Player : agent
    var Score : int = 0
    var Rank : int = 0

matches_leaderboard := class(creative_device):

    @editable
    MaybeDependencyInjector : ?dependency_injector = false

    @editable
    NamesBillboards : []billboard_device = array{}
    @editable
    ScoresBillboards : []billboard_device = array{}
    @editable
    Spawners : []player_spawner_device = array{}
    @editable
    JoiningSpawners : []player_spawner_device = array{}


    @editable
    PLayer1RankIcon : creative_prop = creative_prop{}
    @editable
    PLayer2RankIcon : creative_prop = creative_prop{}
    @editable
    PLayer3RankIcon : creative_prop = creative_prop{}
    @editable
    PLayer4RankIcon : creative_prop = creative_prop{}

   

    var AllPlayers : []player = array{}

    #Dependency Injection variables 
    var MaybeMainRankManager: ?main_rank_manager = false
    var MaybeGameManager: ?game_manager = false

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=

        SetupDependencies()
        
        #Hide the ranks of all players
        PLayer1RankIcon.Hide()
        PLayer2RankIcon.Hide()
        PLayer3RankIcon.Hide()
        PLayer4RankIcon.Hide()
        
        

        #Print the scores on the billboards
        Sleep(1.5)
        set AllPlayers = GetPlayspace().GetPlayers()

        for(Player:AllPlayers):
            UpdateScores(Player)
        
        #subscribe to the UpdateScores function for each player that joins the game
        for(Spawner : Spawners):
            Sleep(1.5)
            Spawner.SpawnedEvent.Subscribe(UpdateScores)

        for(Spawner :JoiningSpawners):
            Sleep(1.5)
            Spawner.SpawnedEvent.Subscribe(UpdateScores)


    StringToMessage<localizes>(String : string, Agent:agent) : message = "{String}{Agent}"
    ScoreToMessage<localizes>(String : string) : message = "{String}"

    UpdateScores(Agent:agent):void=
        var AllScores : []PlayerScores = array{}
        for(Player : GetPlayspace().GetPlayers()):
            if(GameManager := MaybeGameManager?, MainRankManager := MaybeMainRankManager?):

                MaybePlayerData := GameManager.GetMaybePlayerData(Player)
                if:
                    PlayerData := MaybePlayerData?
                then:
                    #get matches won of the player
                    MatchesWon := PlayerData.GetPlayerMatchesWon()
                    PlayerRank := PlayerData.GetPlayerRank()
                    #save the matches won as score in AllScores array
                    set AllScores += array{PlayerScores{Player := Player, Score := MatchesWon, Rank := PlayerRank}}
                SortedScores := SortScores(AllScores)

                #print the scores on the billboards
                for(idx -> S:SortedScores,BB := NamesBillboards[idx]):
                    BB.SetText(StringToMessage("#{idx+1 } ",S.Player))
                for(idx -> S:SortedScores,BB := ScoresBillboards[idx]):
                    BB.SetText(ScoreToMessage("{S.Score}"))

                #show the ranks on leaderboard
                for(idx -> S:SortedScores):
                    case(idx):
                        0=>
                            ShowPlayerRankIcon(S.Player, PLayer1RankIcon) 
                        1=>
                            ShowPlayerRankIcon(S.Player, PLayer2RankIcon)
                        2=>
                            ShowPlayerRankIcon(S.Player, PLayer3RankIcon)
                        3=>
                            ShowPlayerRankIcon(S.Player, PLayer4RankIcon)
                        _=>
                            Print("NO more players available to show ranks for!")
                

    SortScores(UnsortedScore : []PlayerScores) :[]PlayerScores= 
        var SortedArray : []PlayerScores = UnsortedScore
        for(I := 0..SortedArray.Length-1):
            for(J := 0..SortedArray.Length - I - 2):
                if(E1 := SortedArray[J],  E2 := SortedArray[J+1]):
                    if(E1.Score < E2.Score):
                        if:
                            set SortedArray[J] = E2
                            set SortedArray[J+1] = E1              
        return SortedArray

    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeMainRankManager = DependencyInjector.GetMainRankManager()
        else:
            Print(
                "Dependency Injector not available",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )
            
    ShowPlayerRankIcon(Agent : agent, RankIconCreativeProp : creative_prop): void=
        if(GameManager := MaybeGameManager?, MainRankManager := MaybeMainRankManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            var MaybeRankMat : ?material = false
            if(PlayerData := MaybePlayerData?):
                CurrentPlayerRank := PlayerData.GetPlayerRank()

                case(CurrentPlayerRank):
                    0 =>
                        set MaybeRankMat = MainRankManager.UnrankedIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.SetMaterial(RankMat)
                            RankIconCreativeProp.Show()
                    1 =>
                        set MaybeRankMat = MainRankManager.BronzeIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.SetMaterial(RankMat)
                            RankIconCreativeProp.Show()
                    2 =>
                        set MaybeRankMat = MainRankManager.SilverIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.SetMaterial(RankMat)
                            RankIconCreativeProp.Show()
                    3 =>
                        set MaybeRankMat = MainRankManager.GoldIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.SetMaterial(RankMat)
                            RankIconCreativeProp.Show()
                    4 =>
                        set MaybeRankMat = MainRankManager.PlatinumIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.SetMaterial(RankMat)
                            RankIconCreativeProp.Show()
                    5 =>
                        set MaybeRankMat = MainRankManager.DiamondIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.SetMaterial(RankMat)
                            RankIconCreativeProp.Show()
                    _=>
                        Print(
                            "Rank Index passed in to set the PlayerReference RankIcon Image is invalid!", 
                            ?Duration := 8.0, 
                            ?Color := NamedColors.Red
                        )
    
               
               

                






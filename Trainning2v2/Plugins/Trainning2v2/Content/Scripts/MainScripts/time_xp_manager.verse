using { /Fortnite.com }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }

Dependencies_TimeXPManager<localizes>:message = "Dependencies"
Devices_TimeXPManager<localizes>:message = "Devices"
Accolades_TimeXPManager<localizes>:message = "Accolades"

time_xp_manager := class(creative_device):

        #Dependencies
    @editable:
        Categories := array{ Dependencies_TimeXPManager }
    var MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeGameManager<private>: ?game_manager = false

        #Devices
    @editable:
        Categories := array{ Devices_TimeXPManager }
    TimePlayedStatCreator<private> : stat_creator_device = stat_creator_device{}

        #Accolades
    @editable:
        Categories := array{ Accolades_TimeXPManager }
    FirstLevelAccolade<private> : accolades_device = accolades_device{}

    @editable:
        Categories := array{ Accolades_TimeXPManager }
    SecondLevelAccolade<private> : accolades_device = accolades_device{}

    @editable:
        Categories := array{ Accolades_TimeXPManager }
    ThirdLevelAccolade<private> : accolades_device = accolades_device{}

    @editable:
        Categories := array{ Accolades_TimeXPManager }
    FourthLevelAccolade<private> : accolades_device = accolades_device{}

    @editable:
        Categories := array{ Accolades_TimeXPManager }
    FifthLevelAccolade<private> : accolades_device = accolades_device{}


    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        AllPlayers := GetPlayspace().GetPlayers()
        for(Player : AllPlayers):
            UpdatePlayerPlaytime(Player)

            #Update playtime for players
        GetPlayspace().PlayerAddedEvent().Subscribe(UpdatePlayerPlaytime)

        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerLeaves) 

        TimePlayedStatCreator.LevelChangedEvent.Subscribe(OnPlayerReachesNextLevel)
        TimePlayedStatCreator.MaximumReachedEvent.Subscribe(OnPlayerReachesMax)


    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
        else:
            Print(
                "Dependency Injector not available",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )

        
    UpdatePlayerPlaytime(Player : player): void =
        if(GameManager := MaybeGameManager?):
            spawn { StartPlaytimeLoop(Player) }


    StartPlaytimeLoop(Player : player)<suspends>: void = 
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Player)
            if(PlayerData := MaybePlayerData?):
                loop:
                    Sleep(1.0)
                    if(PlayerData.HasLeftTheGame = true):
                        break
                    PlayerData.UpdatePlaytimeSeconds()
                    PlayerData.IncrementCurrentGamePlayedTimeSeconds()

                    CurrentPlayedSeconds := PlayerData.GetCurrentGamePlayedTimeSeconds()
                    if(CurrentPlayedSeconds >= 60):
                        PlayerData.ResetCurrentGamePlayedTimeSeconds()
                        PlayerData.IncrementCurrentGamePlayedTimeMinutes()

                        CurrentPlayedMinutes := PlayerData.GetCurrentGamePlayedTimeMinutes()

                        if(TimePlayedStatCreator.SetValue[Player, CurrentPlayedMinutes]){}


    OnPlayerReachesNextLevel(MaybeAgent : ?agent, NewLevel : int): void =
        if:
            Agent := MaybeAgent?
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            PlayerData.ResetCurrentGamePlayedTimeMinutes()

            case(NewLevel):
                2 =>
                    FirstLevelAccolade.Award(Agent)
                3 =>
                    SecondLevelAccolade.Award(Agent)
                4 =>
                    ThirdLevelAccolade.Award(Agent)
                5 =>
                    FourthLevelAccolade.Award(Agent)
                _ =>
                    # Print(
                    #     "New Level for the time played stat creator is invalid or he has reached the max level! Cant grant XP to player", 
                    #     ?Duration := 8.0, 
                    #     ?Color := NamedColors.Red
                    # )

    OnPlayerReachesMax(MaybeAgent : ?agent, MaxValue : int): void =
        if:
            Agent := MaybeAgent?
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            PlayerData.GetCurrentGamePlayedTimeSeconds()
            PlayerData.ResetCurrentGamePlayedTimeMinutes()

            if(TimePlayedStatCreator.SetLevel[Agent, 1]){}


    OnPlayerLeaves(Player : player): void =
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Player)
            if(PlayerData := MaybePlayerData?):
                set PlayerData.HasLeftTheGame = true







                        
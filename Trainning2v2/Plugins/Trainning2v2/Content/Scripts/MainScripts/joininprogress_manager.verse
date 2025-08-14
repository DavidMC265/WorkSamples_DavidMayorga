using { /Fortnite.com }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { Lobby }
using { RoundSystem }


DependenciesJoinInProessManager<localizes>:message = "Dependencies"
DevicesJoinInProgressManager<localizes>:message = "Devices"
PropsJoinInProessManager<localizes>:message = "Props"


joininprogress_manager<public> := class(creative_device):
    #DependencyInjector
    @editable: 
        Categories := array{ DependenciesJoinInProessManager }
    var MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeGameManager<private>: ?game_manager = false
    var MaybeEventMediator<private> : ?event_mediator = false
    var MaybePracticeArea<private> : ?practice_area = false
    var MaybeRoundStartManager<private> : ?round_start_manager = false
    var MaybePregameLobby<private> : ?pregame_lobby = false
    var MaybeInventoryManager<private>: ?inventory_manager = false

    #Devices
    @editable: 
        Categories := array{ DevicesJoinInProgressManager }
    SpectateCurrentGameButton<private> : button_device = button_device{}

    @editable:
        Categories := array{ DevicesJoinInProgressManager }
    EyeImgProp<private> : creative_prop = creative_prop{}

    @editable:
        Categories := array{ DevicesJoinInProgressManager }
    SpectateButtonMutatorZone<private>: mutator_zone_device = mutator_zone_device{}

    @editable:
        Categories := array{ DevicesJoinInProgressManager}
    TeamSelectionButtonMapIndicator<public> : map_indicator_device = map_indicator_device{}

    @editable:
        Categories := array{ DevicesJoinInProgressManager }
    Team1SelectorDevice<private> : class_and_team_selector_device = class_and_team_selector_device{}

    @editable:
        Categories := array{ DevicesJoinInProgressManager }
    Team2SelectorDevice<private> : class_and_team_selector_device = class_and_team_selector_device{}

    @editable:
        Categories := array{ DevicesJoinInProgressManager }
    DefaultTeamSelector<private> : class_and_team_selector_device = class_and_team_selector_device{}

    @editable:
        Categories := array{ DevicesJoinInProgressManager }
    GameInProgressBillboard<private> : billboard_device = billboard_device{}

    @editable:
        Categories := array{ DevicesJoinInProgressManager }
    TeamSelectionDialog<private> : popup_dialog_device = popup_dialog_device{}

    @editable:
        Categories := array{ DevicesJoinInProgressManager }
    TeamFullMessage<private> : hud_message_device = hud_message_device{}


    #Props
    @editable:
        Categories := array{ DevicesJoinInProgressManager }
    ButtonStand<private> : creative_prop = creative_prop{}

    @editable:
        Categories := array{ DevicesJoinInProgressManager }
    RespawningPropSpectator<private> : creative_prop = creative_prop{}

    @editable
    ButtonDestination<private> : vector3 = vector3{}

    @editable
    ButtonStandDestination<private> : vector3 = vector3{}

    Message1<localizes><private>(String : string) : message = "{String}"

    

    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        SpectateCurrentGameButton.InteractedWithEvent.Subscribe(OnTeamSelectionButtonPressed)
        TeamSelectionDialog.RespondingButtonEvent.Subscribe(OnPlayerChoosesTeamFromUI)

        GameInProgressBillboard.HideText()
        SpectateButtonMutatorZone.Disable()
        EyeImgProp.Hide()
        RespawningPropSpectator.Hide()

            #Async Function
        OnGameStarted()


    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeEventMediator = DependencyInjector.GetEventMediator()
            set MaybePracticeArea = DependencyInjector.GetPracticeArea()
            set MaybeRoundStartManager = DependencyInjector.GetRoundStartManager()
            set MaybePregameLobby = DependencyInjector.GetPreGameLobby()
            set MaybeInventoryManager = DependencyInjector.GetInventoryManager()
        else:
            Print(
                "Dependency Injector not available",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )


    ShowTeamSelectionUIToPlayer(Agent : agent): void =
        TeamSelectionDialog.Show(Agent)


    OnPlayerChoosesTeamFromUI(Agent : agent, Index : int): void =
        if:
            PregameLobby := MaybePregameLobby?
            Player := player[Agent]
            GameManager := MaybeGameManager?
            InventoryManager := MaybeInventoryManager?
            RoundStartManager := MaybeRoundStartManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            if(Index = 0):
                if(PregameLobby.Team1Players.Length >= 2):
                    TeamFullMessage.Show(Agent)
                else:

                    spawn{ SwitchPlayerTeam(Team1SelectorDevice, Player) }
                    PregameLobby.AddPlayerToTeam1Players(Player)
                    PregameLobby.AddPlayerToCurrentGamePlayers(Player)

                    set PlayerData.FullLoadOutGranter = option{ InventoryManager.DefaultLoadout }

                    PlayerData.SetTeamNumber(0)
                    RoundStartManager.ShowUpdatedScoreboardUIToPlayer(Agent)
                    set PlayerData.HasSelectedTeamAsJoinedPlayer = true

                    RoundStartManager.AddPlayerToCurrentRoundZone(Agent)
                
            if(Index = 1):
                if(PregameLobby.Team2Players.Length >= 2):
                    TeamFullMessage.Show(Agent)
                else:

                    spawn{ SwitchPlayerTeam(Team2SelectorDevice, Player) }
                    PregameLobby.AddPlayerToTeam2Players(Player)
                    PregameLobby.AddPlayerToCurrentGamePlayers(Player)
                    
                    set PlayerData.FullLoadOutGranter = option{ InventoryManager.DefaultLoadout }

                    PlayerData.SetTeamNumber(1)
                    RoundStartManager.ShowUpdatedScoreboardUIToPlayer(Agent)
                    set PlayerData.HasSelectedTeamAsJoinedPlayer = true

                    RoundStartManager.AddPlayerToCurrentRoundZone(Agent)



    SwitchPlayerTeam(TeamSelectorDevice : class_and_team_selector_device, Player : player)<suspends>: void =
        if:
            FortCharacter := Player.GetFortCharacter[]
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Player)
            PlayerData := MaybePlayerData?
        then:

            Sleep(0.3)
            FortCharacter.Damage(500.0)

            Sleep(0.3)
            TeamSelectorDevice.ChangeTeamAndClass(Player)

            Sleep(1.5)
            FortCharacter.Damage(500.0)

            Sleep(1.0)
            DestinationTransform := RespawningPropSpectator.GetTransform()
            PropLocation := DestinationTransform.Translation

            DestinationLocation := vector3{X := PropLocation.X, Y := PropLocation.Y, Z := PropLocation.Z + 150.0}
            set PlayerData.RespawningLocationSpectator = DestinationLocation
            # set PlayerData.DefaultClassAndTeamSelector = option{ DefaultTeamSelector }

            ShowSpectatorUI(PlayerData)



    OnGameStarted()<suspends>: void =
        if(EventMediator := MaybeEventMediator?):
            EventMediator.OnRoundIsReadyToStart.Await()

            ShowSpectateCurrentGameButton()
            GameInProgressBillboard.SetText(Message1("Game In Progress"))
            GameInProgressBillboard.ShowText()
            SpectateButtonMutatorZone.Enable()
            EyeImgProp.Show()

            
    ShowSpectateCurrentGameButton()<suspends>: void =

        ButtonTransform := SpectateCurrentGameButton.GetTransform()

        SpectateCurrentGameButton.MoveTo(ButtonDestination, ButtonTransform.Rotation, 0.5)
        ButtonStand.MoveTo(ButtonStandDestination, IdentityRotation(), 0.5)


    OnTeamSelectionButtonPressed(Agent : agent): void =
        if:
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            if(PlayerData.HasSelectedTeamAsJoinedPlayer = true):
                Print(
                    "HasSelectedTeamAsJoinedPlayer is true so function will be returnrd", 
                    ?Duration:= 7.0, 
                    ?Color := NamedColors.Red
                )
                return

            else:
                if:
                    Player := player[Agent],
                    FortCharacter := Player.GetFortCharacter[]
                    PreGameLobby := MaybePregameLobby?
                    PreGameLobby.CurrentGamePlayers.Length > 0
                then: 
                    ShowTeamSelectionUIToPlayer(Player)

 

    ElimiatePlayer(FortCharacter : fort_character)<suspends>: void =
        Sleep(1.0)
        FortCharacter.Damage(500.0)

        Sleep(1.0)

        if:
            GameManager := MaybeGameManager?
            Player := FortCharacter.GetAgent[]
            MaybePlayerData := GameManager.GetMaybePlayerData(Player)
            PlayerData := MaybePlayerData?
        then:

            Team1SelectorDevice.ChangeTeamAndClass(Player)

            Sleep(1.5)
            FortCharacter.Damage(500.0)

            Sleep(1.0)
            DestinationTransform := RespawningPropSpectator.GetTransform()
            PropLocation := DestinationTransform.Translation

            DestinationLocation := vector3{X := PropLocation.X, Y := PropLocation.Y, Z := PropLocation.Z + 150.0}
            set PlayerData.RespawningLocationSpectator = DestinationLocation
            set PlayerData.DefaultClassAndTeamSelector = option{ DefaultTeamSelector }

            ShowSpectatorUI(PlayerData)

            
    ShowSpectatorUI(PlayerData : player_data): void =
        PlayerData.ShowSpectatorUI()




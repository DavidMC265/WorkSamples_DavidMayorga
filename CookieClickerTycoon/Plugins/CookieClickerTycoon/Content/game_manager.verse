#Game_Manager

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation/Tags }
using { /Verse.org/Colors }


PlayerClass := class< unique>() {
    AgentOBJ : agent
    UIManagerInst : UIManager = UIManager{}
}

SpawnersT := class(tag) {}

game_manager := class(creative_device):

    var PlayerMap < public> : [agent]PlayerClass = map{}

    @editable CookieFactoryTracker : tracker_device = tracker_device{}
    @editable ZombieZoneTracker : tracker_device = tracker_device{}
 
    @editable EndGameDevice : end_game_device = end_game_device{}

    var <public> CurrentCookieCount : int = 0
    var <public> AmountToAddPerClick : int = 1
    # var <public> CurrentCookieMultiplier : int = 1

    @editable var CookieSignalManagerDevice : signal_remote_manager_device = signal_remote_manager_device{}
    

    # Runs when the device is started in a running game
    OnBegin< override>()< suspends>:void=
        # TODO: Replace this with your code
        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerRemoved)

        CookieFactoryTracker.CompleteEvent.Subscribe(CheckIfPlayerHasWon)
        ZombieZoneTracker.CompleteEvent.Subscribe(CheckIfPlayerHasWon)

    
        AllPlayers := GetPlayspace().GetPlayers()
            for (Player : AllPlayers) {
            if (Agent := agent[Player]) {
                OnPlayerSpawned(Agent)
            }
        }
        CookieSignalManagerDevice.PrimarySignalEvent.Subscribe(HandleCookieUpdateAndDisplay)
        
        Sleep(2.5)
        InitSpawners()


    InitSpawners() : void = {
        TaggedSpawners := GetCreativeObjectsWithTag(SpawnersT{})

        for (Spawners : TaggedSpawners) {
            if (Spawner := player_spawner_device[Spawners]) {
                Spawner.SpawnedEvent.Subscribe(OnPlayerSpawned)
            }
        }
    }

    OnPlayerSpawned(Agent : agent) : void = {
        AddPlayerToMap(Agent)
    }

    AddPlayerToMap(Agent : agent): void =
        if (Player := player[Agent]) {
            PC : PlayerClass = PlayerClass{AgentOBJ := Agent}
             
            PC.UIManagerInst.Init(Player)
            PC.UIManagerInst.OpenWelcomeUI(Agent)

            option {
                set PlayerMap[Agent] = PC
                # Print("Player Added to the map!", ?Duration := 2.0, ?Color := NamedColors.DarkGreen)
            }
            spawn{UpdateCoinUI(Agent, Player)}
        }


    HandleCookieUpdateAndDisplay<public>(Agent : agent): void =
        set CurrentCookieCount += AmountToAddPerClick
        # Print(
        #     "Current Cookie Count : {CurrentCookieCount}", 
        #     ?Duration := 1.0, 
        #     ?Color := NamedColors.Orange
        # )
        if(Player := player[Agent]):
            if (PC := GetPlayerClass[Agent]):
                # Print("Player is already in the map!", ?Duration := 2.0, ?Color := NamedColors.Green)
                # PC.UIManagerInst.ShowCookieHUD(Agent)
                spawn { PC.UIManagerInst.UpdateCookiesToAddText(Player, AmountToAddPerClick) }
            else:
                # Print("Player Has not been added to the map!", ?Duration := 2.0, ?Color := NamedColors.Red)
                AddPlayerToMap(Agent)


    GetCoinsAmount< public>(Agent : agent) : int = {
        return CurrentCookieCount
        # return CheckGoldAmount.GetItemCount(Agent, 0)
    }

    GetPlayerClass<public>(Agent : agent)< decides>< transacts> : PlayerClass = {
        var PC : ?PlayerClass = false

        if (PlrClassCheck := PlayerMap[Agent]) {
            set PC = option{PlrClassCheck}
        }

        return PC?
    }

    UpdateCoinUI< public>(Agent : agent, Player : player)< suspends>: void = {
        if (PC := GetPlayerClass[Agent]) {
            loop {
                Sleep(0.1)
                PC.UIManagerInst.UpdateGoldText(Player, GetCoinsAmount(Agent))
            }
        }
    }

    OnPlayerRemoved(PlayerLeft : agent):void = {
        if (Agent := agent[PlayerLeft]):
            if (ActualPlayer := PlayerMap[Agent]):
                var TempAllPlayerMap : [agent]PlayerClass = map{}
                for (Key -> Value : PlayerMap, Key <> Agent):
                    set TempAllPlayerMap = ConcatenateMaps(TempAllPlayerMap, map{Key => Value})

                set PlayerMap = TempAllPlayerMap
    }

    CheckIfPlayerHasWon(Agent : agent): void =
        if(CookieFactoryTracker.HasReachedTarget[Agent] and ZombieZoneTracker.HasReachedTarget[Agent]):
            EndGameDevice.Activate(Agent)

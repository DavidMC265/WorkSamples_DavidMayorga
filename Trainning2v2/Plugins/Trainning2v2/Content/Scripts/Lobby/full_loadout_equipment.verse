using { /Fortnite.com/Devices }
using { /kogames@fortnite.com/Trainning2v2/Scripts/Lib }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { MainScripts }


DependecyInjectorFullLoadout<localizes>:message = "Dependency Injector"

full_loadout_equipment := class(creative_device):

    @editable:
        Categories:= array{ DependecyInjectorFullLoadout }
    var MaybeDependencyInjector : ?dependency_injector = false
    
    @editable       ClassicCombGranter1 : item_granter_device = item_granter_device{}
    @editable       ClassicCombButton1 : button_device = button_device{}
    @editable       ClassicCombGranter2 : item_granter_device = item_granter_device{}
    @editable       ClassicCombButton2 : button_device = button_device{}
    @editable       ClassicCombGranter3 : item_granter_device = item_granter_device{}
    @editable       ClassicCombButton3 : button_device = button_device{}
    @editable       ClassicCombGranter4 : item_granter_device = item_granter_device{}
    @editable       ClassicCombButton4 : button_device = button_device{}
    @editable       ClassicCombGranter5 : item_granter_device = item_granter_device{}
    @editable       ClassicCombButton5 : button_device = button_device{}
    @editable       ClassicCombGranter6 : item_granter_device = item_granter_device{}
    @editable       ClassicCombButton6 : button_device = button_device{}

    var MaybeGameManager : ?game_manager = false

    OnBegin<override>()<suspends>:void=
        SetupDependencies()   

        ClassicCombButton1.InteractedWithEvent.SubscribeAgent(GrantCombinationLoadOut, 1)
        ClassicCombButton2.InteractedWithEvent.SubscribeAgent(GrantCombinationLoadOut, 2)
        ClassicCombButton3.InteractedWithEvent.SubscribeAgent(GrantCombinationLoadOut, 3)
        ClassicCombButton4.InteractedWithEvent.SubscribeAgent(GrantCombinationLoadOut, 4)
        ClassicCombButton5.InteractedWithEvent.SubscribeAgent(GrantCombinationLoadOut, 5)
        ClassicCombButton6.InteractedWithEvent.SubscribeAgent(GrantCombinationLoadOut, 6)

    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
        else:
            Print(
                "Dependency Injector not available from Round Start manager",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )

    GrantCombinationLoadOut(Agent : agent, Index : int): void = 
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            if(PlayerData := MaybePlayerData?):
                case(Index):
                    1 => 
                        ClassicCombGranter1.GrantItem(Agent)
                        set PlayerData.FullLoadOutGranter = option{ ClassicCombGranter1 }

                    2 => 
                        ClassicCombGranter2.GrantItem(Agent)
                        set PlayerData.FullLoadOutGranter = option{ ClassicCombGranter2 }

                    3 => 
                        ClassicCombGranter3.GrantItem(Agent)
                        set PlayerData.FullLoadOutGranter = option{ ClassicCombGranter3 }

                    4 => 
                        ClassicCombGranter4.GrantItem(Agent)
                        set PlayerData.FullLoadOutGranter = option{ ClassicCombGranter4 }

                    5 => 
                        ClassicCombGranter5.GrantItem(Agent)
                        set PlayerData.FullLoadOutGranter = option{ ClassicCombGranter5 }
                        
                    6 => 
                        ClassicCombGranter6.GrantItem(Agent)
                        set PlayerData.FullLoadOutGranter = option{ ClassicCombGranter6 }

                    _ => Print(
                            "Combination Index invalid", 
                            ?Duration := 5.0, 
                            ?Color := NamedColors.Red
                        )


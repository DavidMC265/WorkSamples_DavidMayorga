using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using { /Verse.org/Simulation/Tags }
using {/Verse.org/Concurrency}
using { /Verse.org/Random }

Teleporters_CookieShooter_Editables := struct<concrete>:
    @editable IslandTeleporter : teleporter_device = teleporter_device{}
    @editable CookieShooterTeleporter : teleporter_device = teleporter_device{}
    @editable ShootingTargetsCompletedPortal : teleporter_device = teleporter_device{}

Buttons_CookieShooter_Editables := struct<concrete>:
    @editable HuntingRifle_Button : button_device = button_device{}
    @editable MarksmanSixShooter_Button : button_device = button_device{}
    @editable AssaultRifle_Button : button_device = button_device{}
    @editable SMG_Button : button_device = button_device{}

Granters_CookieShooter_Editables := struct<concrete>:
    @editable HuntingRifle_Granter : item_granter_device = item_granter_device{}
    @editable MarksmanSixShooter_Granter : item_granter_device = item_granter_device{}
    @editable AssaultRifle_Granter : item_granter_device = item_granter_device{}
    @editable SGM_Granter : item_granter_device = item_granter_device{}

CookiesToGrant_CookieShooter_Editables := struct<concrete>:
    @editable HuntingRifle_Amount : int = 100
    @editable MarksmanSixShooter_Amount : int = 75
    @editable AssaultRifle_Amount : int = 50
    @editable SMG_Amount : int = 25

ConditionalButtons_CookieShooter_Editables := struct<concrete>:
    @editable HuntingRifle_Conditional : conditional_button_device = conditional_button_device{}
    @editable MarksManSixShooter_Conditional : conditional_button_device = conditional_button_device{}
    @editable AssaultRifle_Conditional : conditional_button_device = conditional_button_device{}
    @editable SMG_Conditional : conditional_button_device = conditional_button_device{}

Manipulator_tag := class(tag):

Cookie_Shooter := class(creative_device):

    StringToMessage<localizes>(String : string) : message = "{String}"

    @editable GameManager : game_manager = game_manager{}
    @editable UIManagerInst : UIManager = UIManager{}

    @editable Teleporters : Teleporters_CookieShooter_Editables = Teleporters_CookieShooter_Editables{}
    @editable Buttons : Buttons_CookieShooter_Editables = Buttons_CookieShooter_Editables{}
    @editable Granters : Granters_CookieShooter_Editables = Granters_CookieShooter_Editables{}
    @editable CookiesToGrant : CookiesToGrant_CookieShooter_Editables= CookiesToGrant_CookieShooter_Editables{}
    @editable ConditionalButtons : ConditionalButtons_CookieShooter_Editables = ConditionalButtons_CookieShooter_Editables{}

    @editable ItemRemover : item_remover_device = item_remover_device{}

    @editable CookieShooterTracker : tracker_device = tracker_device{}

    var PropManipulators : []prop_manipulator_device = array{}

    var RandomPropManipulatorChoosen : prop_manipulator_device = prop_manipulator_device{}

    var CanCreateArray : logic = true;

    var TotalCookiesToGrant : int = 0 


    OnBegin<override>()<suspends>:void=
        Teleporters.IslandTeleporter.EnterEvent.Subscribe(TeleportPlayerToCookieShooter)
        Teleporters.CookieShooterTeleporter.EnterEvent.Subscribe(TeleportPlayerToIsland)
        Teleporters.CookieShooterTeleporter.TeleportedEvent.Subscribe(RemoveItems)

        CookieShooterTracker.CompleteEvent.Subscribe(OnAllTargetsShot)

        Buttons.HuntingRifle_Button.InteractedWithEvent.Subscribe(GrantHuntingRifle)
        Buttons.MarksmanSixShooter_Button.InteractedWithEvent.Subscribe(GrantMarksmanSixShooter)
        Buttons.AssaultRifle_Button.InteractedWithEvent.Subscribe(GrantAssaultRifle)
        Buttons.SMG_Button.InteractedWithEvent.Subscribe(GrantSMG)

        TaggedList := GetCreativeObjectsWithTag(Manipulator_tag{})
        for(Index ->TaggedActor : TaggedList):
            if(Device := prop_manipulator_device[TaggedActor]):
                set PropManipulators += array{Device}

        ChooseRandomCookieTarget()


    TeleportPlayerToCookieShooter(Agent : agent): void =
        Teleporters.CookieShooterTeleporter.Teleport(Agent)

    RemoveItems(Agent : agent): void =
        ItemRemover.Remove(Agent)

    TeleportPlayerToIsland(Agent : agent): void =
        Teleporters.IslandTeleporter.Teleport(Agent)

        #Hunting Rifle
    GrantHuntingRifle(Agent : agent): void =
        Granters.HuntingRifle_Granter.GrantItem(Agent)
        ApplyHuntingRifleMultiplier()
    
    ApplyHuntingRifleMultiplier(): void = 
        set TotalCookiesToGrant = CookiesToGrant.HuntingRifle_Amount
    
        #Marksman Six Shooter
    GrantMarksmanSixShooter(Agent : agent): void =
        Granters.MarksmanSixShooter_Granter.GrantItem(Agent)
        ApplyMarksmanSixShooterMultiplier()
    
    ApplyMarksmanSixShooterMultiplier(): void = 
        set TotalCookiesToGrant = CookiesToGrant.MarksmanSixShooter_Amount

        #AssaultRifle
    GrantAssaultRifle(Agent : agent): void =
        Granters.AssaultRifle_Granter.GrantItem(Agent)
        ApplyAssaultRifleMultiplier()
    
    ApplyAssaultRifleMultiplier(): void = 
        set TotalCookiesToGrant = CookiesToGrant.AssaultRifle_Amount
        
        #SMG
    GrantSMG(Agent : agent): void =
        Granters.SGM_Granter.GrantItem(Agent)
        ApplySMGMultiplier()
    
    ApplySMGMultiplier(): void = 
        set TotalCookiesToGrant = CookiesToGrant.SMG_Amount

    ChooseRandomCookieTarget(): void = 
        var RandomInt : int = 0
        set RandomInt = GetRandomInt(0, PropManipulators.Length -1)

        if(PropManipulators.Length <= 0 ): 
            # Print(
            #     "Prop Manipulators array length is 0!",
            #     ?Duration := 1.0,
            #     ?Color := NamedColors.Purple
            # )
            CreateManipulatorsArray()
            # spawn:
            #     CreateManipulatorsArray()
            # Print(
            #     "NewArrayLength is : {PropManipulators.Length}", 
            #     ?Duration := 1.0,
            #     ?Color := NamedColors.Blue
            # )
            # ChooseRandomCookieTarget()
        
        if(Prop := PropManipulators[RandomInt]):
            if(NewPropArray := PropManipulators.RemoveElement[RandomInt]):
                set RandomPropManipulatorChoosen = Prop
                set PropManipulators = NewPropArray
                # Print(
                #     "NewArrayLength is : {PropManipulators.Length}", 
                #     ?Duration := 1.0,
                #     ?Color := NamedColors.Yellow
                # )
                RandomPropManipulatorChoosen.ShowProps()
                RandomPropManipulatorChoosen.DamagedEvent.Subscribe(HideCookieTarget)

    CreateManipulatorsArray(): void = 
        Print("Making a new array!", ?Duration := 2.0, ?Color := NamedColors.Yellow)
        # CreateManipulatorsArray()
        # if(CanCreateArray = true):
        #     set CanCreateArray = false
        TaggedList := GetCreativeObjectsWithTag(Manipulator_tag{})
        for(Index ->TaggedActor : TaggedList):
            if(Device := prop_manipulator_device[TaggedActor]):
                set PropManipulators += array{Device}
                # Print("New Array length is equal to: {PropManipulators.Length}", ?Duration := 3.0, ?Color := NamedColors.Yellow)


    HideCookieTarget(Agent : agent): void =
        RandomPropManipulatorChoosen.HideProps()
        set GameManager.CurrentCookieCount += TotalCookiesToGrant
        CookieShooterTracker.Increment(Agent)
        ChooseRandomCookieTarget()

        if(ConditionalButtons.HuntingRifle_Conditional.IsHoldingItem[Agent], Player := player[Agent]):
            spawn { UIManagerInst.UpdateCookiesToAddText(Player, CookiesToGrant.HuntingRifle_Amount) }

        if(ConditionalButtons.MarksManSixShooter_Conditional.IsHoldingItem[Agent], Player := player[Agent]):
            spawn { UIManagerInst.UpdateCookiesToAddText(Player, CookiesToGrant.MarksmanSixShooter_Amount) }

        if(ConditionalButtons.AssaultRifle_Conditional.IsHoldingItem[Agent], Player := player[Agent]):
            spawn { UIManagerInst.UpdateCookiesToAddText(Player, CookiesToGrant.AssaultRifle_Amount) }
    
        if(ConditionalButtons.SMG_Conditional.IsHoldingItem[Agent], Player := player[Agent]):
            spawn { UIManagerInst.UpdateCookiesToAddText(Player, CookiesToGrant.SMG_Amount) }
            

    OnAllTargetsShot(Agent : agent): void = 
        Print("xd")
        Teleporters.ShootingTargetsCompletedPortal.Teleport(Agent)

        



            



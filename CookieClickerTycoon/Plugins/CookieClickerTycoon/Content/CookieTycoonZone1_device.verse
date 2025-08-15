using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/SpatialMath }

CookieTycoonZone1_device := class(creative_device):

    @editable GameManagerInst : game_manager = game_manager{}

    @editable var ClaimTycoonTrigger : trigger_device = trigger_device{}
    @editable var ClaimTycoonManipulator : prop_manipulator_device = prop_manipulator_device{}

    #Player Reference
    @editable PlayerReference : player_reference_device = player_reference_device{}

    #1st Floor
        #Walls
    @editable var BuyWalls1MutatorZone : mutator_zone_device = mutator_zone_device{}
    @editable var BuyWalls1Manipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var Walls1Manipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var Walls1Cost: int = 100
    var PurchasedWalls1 : logic = false
    var CanPurchaseWalls1 : logic = false

        #Floor
    @editable var FirstFloorManipulator : prop_manipulator_device = prop_manipulator_device{}
        #Stairs
    @editable var BuyStairsMutatorZone : mutator_zone_device = mutator_zone_device{}
    @editable var BuyStairsManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var StairsManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var StairsCost : int = 3000

        #Door
    @editable var BuyDoorMutatorZone : mutator_zone_device = mutator_zone_device{}
    @editable var BuyDoorManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var DoorManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var DoorCost : int = 1000

    #Droppers
        #Dropper 1
    @editable var CookieFromDropper1 : creative_prop = creative_prop{}
    @editable var DropperManipulator1 : prop_manipulator_device = prop_manipulator_device{}
    @editable Dropper1CookiesAmountToGrant : int = 50

        #Dropper 2
    @editable var BuyDropper2Manipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var BuyDropper2MutatorZone : mutator_zone_device = mutator_zone_device{}
    @editable var CookieFromDropper2 : creative_prop = creative_prop{}
    @editable var DropperManipulator2 : prop_manipulator_device = prop_manipulator_device{}
    @editable var Dropper2Cost : int = 250
    @editable Dropper2CookiesAmountToGrant : int = 100

        #Dropper 3
    @editable var BuyDropper3Manipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var BuyDropper3MutatorZone : mutator_zone_device = mutator_zone_device{}
    @editable var CookieFromDropper3 : creative_prop = creative_prop{}
    @editable var DropperManipulator3 : prop_manipulator_device = prop_manipulator_device{}
    @editable var Dropper3Cost : int = 500
    @editable Dropper3CookiesAmountToGrant : int = 150

    #Second Floor
        #Floor
    @editable var SecondFloorManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var BuySeconfFloorMutatorZone : mutator_zone_device = mutator_zone_device{}
    @editable var BuySecondFloorManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var SecondFloorCost : int = 4000

        #Walls
    @editable var SeconFloorWallsManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var BuySecondFloorWallsMutatorZone : mutator_zone_device = mutator_zone_device{}
    @editable var BuySecondFloorWallsManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var SecondFloorWallsCost : int = 5000

        #Dropper 1
    @editable var BuyDropper1SecondFloorManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var BuyDopper1SecondFloorMutatorZone : mutator_zone_device = mutator_zone_device{}
    @editable var CookieFromDropper1SecondFloor : creative_prop = creative_prop{}
    @editable var Dropper1SecondFloorManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var Dropper1SecondFloorCost : int = 8000
    @editable Dropper1SecondFloorCookiesAmountToGrant : int = 250

        #Dropper 2
    @editable var BuyDropper2SecondFloorManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var BuyDropper2SecondFloorMutatorZone : mutator_zone_device = mutator_zone_device{}
    @editable var CookieFromDropper2SecondFloor : creative_prop = creative_prop{}
    @editable var Dropper2SecondFloorManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var Dropper2SecondFloorCost : int = 13000
    @editable Dropper2SecondFloorCookiesAmountToGrant : int = 500

        #Dropper 3
    @editable var BuyDropper3SecondFloorManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var BuyDropper3SecondFloorMutatorZone : mutator_zone_device = mutator_zone_device{}
    @editable var CookieFromDropper3SecondFloor : creative_prop = creative_prop{}
    @editable var Dropper3SecondFloorManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var Dropper3SecondFloorCost : int = 20000
    @editable Dropper3SecondFloorCookiesAmountToGrant : int = 600

        #Roof
    @editable var BuySecondFloorRoofMutatorZone : mutator_zone_device = mutator_zone_device{}
    @editable var BuySecondFloorRoofManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var SecondFloorRoofManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var SecondFloorRoofCost : int = 30000

        #Decorations
    @editable var BuySecondFloorFloorDeacorationsMutatorZone : mutator_zone_device = mutator_zone_device{}
    @editable var BuySecondFloorDecorationsManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable var DecorationPropsManipulators : []prop_manipulator_device = array{}
    @editable var SecondFloorDecorationsCost : int = 50000
    @editable var CinematicDecorationSequence : cinematic_sequence_device = cinematic_sequence_device{}
    @editable var CookieFactoryTracker : tracker_device = tracker_device{}
    @editable var CookieFactoryCompletionSound : audio_player_device = audio_player_device{}

    var UnitsToMove : float = 300.0
    var MoveDuration : float = 5.0

    OnBegin<override>()<suspends>:void=
        ClaimTycoonTrigger.TriggeredEvent.Subscribe(RegisterTriggerAndDisableOtherTriggers)

        #First Floor
        BuyWalls1MutatorZone.AgentEntersEvent.Subscribe(OnPlayerPurchasesWalls)
        BuyDropper2MutatorZone.AgentEntersEvent.Subscribe(OnPlayerPurchasesDropper2)
        BuyDropper3MutatorZone.AgentEntersEvent.Subscribe(OnPlayerPurchasesDropper3)


        BuyDoorMutatorZone.AgentEntersEvent.Subscribe(OnPlayerPurchasesDoor)
        BuyStairsMutatorZone.AgentEntersEvent.Subscribe(OnPlayerPurchasesStairs)

        #Second Floor 
        BuySeconfFloorMutatorZone.AgentEntersEvent.Subscribe(OnPlayerPurchasesSecondFloor)
        BuySecondFloorWallsMutatorZone.AgentEntersEvent.Subscribe(OnPlayersPurchasesSecondFloorWalls)
        BuyDopper1SecondFloorMutatorZone.AgentEntersEvent.Subscribe(OnPlayerPurchasesSecondFloorDropper1)
        BuyDropper2SecondFloorMutatorZone.AgentEntersEvent.Subscribe(OnPlayerPurchasesSecondFloorDropper2)
        BuyDropper3SecondFloorMutatorZone.AgentEntersEvent.Subscribe(OnPlayerPurchasesSecondDropper3)
        BuySecondFloorRoofMutatorZone.AgentEntersEvent.Subscribe(OnPlayerPurchasesRoof)
        BuySecondFloorFloorDeacorationsMutatorZone.AgentEntersEvent.Subscribe(OnPlayerPurchasesDecorations)

    #First Floor
    RegisterTriggerAndDisableOtherTriggers(Agent : ?agent): void =
        if(Player := player[Agent?]):
            ClaimTycoonTrigger.Disable()
            ClaimTycoonManipulator.HideProps()
            OnPlayerClaimsTycoon(Player)

    OnPlayerClaimsTycoon(Agent : agent): void =
        PlayerReference.Register(Agent)
        FirstFloorManipulator.ShowProps()
        BuyWalls1Manipulator.ShowProps()
        # BuyWalls1Trigger.Enable()
        BuyDropper2Manipulator.ShowProps()
        BuyDropper2MutatorZone.Enable()

        if(Player := player[Agent]):
            BuyWalls1Manipulator.ShowProps()
            set CanPurchaseWalls1 = true
            spawn:
                SpawnDropper(DropperManipulator1, CookieFromDropper1, Dropper1CookiesAmountToGrant)
                
    OnPlayerPurchasesDropper2(Agent: agent): void =
        if(Player := player[Agent]):
            if(GameManagerInst.CurrentCookieCount >= Dropper2Cost):
                BuyDropper2Manipulator.HideProps()
                BuyDropper2MutatorZone.Disable()
                set GameManagerInst.CurrentCookieCount -= Dropper2Cost
                spawn:
                    SpawnDropper(DropperManipulator2, CookieFromDropper2, Dropper2CookiesAmountToGrant)
                BuyDropper3MutatorZone.Enable()
                BuyDropper3Manipulator.ShowProps()

    OnPlayerPurchasesDropper3(Agent: agent): void =
        if(Player := player[Agent]):
            if(GameManagerInst.CurrentCookieCount >= Dropper3Cost):
                BuyDropper3Manipulator.HideProps()
                BuyDropper3MutatorZone.Disable()
                set GameManagerInst.CurrentCookieCount -= Dropper3Cost
                spawn:
                    SpawnDropper(DropperManipulator3, CookieFromDropper3, Dropper3CookiesAmountToGrant)
        
    OnPlayerPurchasesWalls(Agent : agent): void =
        BuyDoorMutatorZone.Enable()
        BuyDoorManipulator.ShowProps()
        BuyStairsMutatorZone.Enable()
        BuyStairsManipulator.ShowProps()
        
        if(Player := player[Agent]):
            if(CanPurchaseWalls1 = true and GameManagerInst.CurrentCookieCount >= Walls1Cost and PurchasedWalls1 = false):
                set PurchasedWalls1 = true
                set GameManagerInst.CurrentCookieCount -= Walls1Cost
                Walls1Manipulator.ShowProps()
                BuyWalls1MutatorZone.Disable()
                BuyWalls1Manipulator.HideProps()

    OnPlayerPurchasesDoor(Agent : agent): void = 
        if(GameManagerInst.CurrentCookieCount >= DoorCost):
            set GameManagerInst.CurrentCookieCount -= DoorCost
            BuyDoorManipulator.HideProps()
            BuyDoorMutatorZone.Disable()
            DoorManipulator.ShowProps()

    OnPlayerPurchasesStairs(Agent : agent): void =
        if(GameManagerInst.CurrentCookieCount >= StairsCost):
            set GameManagerInst.CurrentCookieCount -= StairsCost
            BuyStairsMutatorZone.Disable()
            StairsManipulator.ShowProps()
            BuyStairsManipulator.HideProps()
            BuySecondFloorManipulator.ShowProps()
            BuySeconfFloorMutatorZone.Enable()

    #Second Floor
    OnPlayerPurchasesSecondFloor(Agent : agent): void = 
        if(Player := player[Agent]):
            if(GameManagerInst.CurrentCookieCount >= SecondFloorCost):
                set GameManagerInst.CurrentCookieCount -= SecondFloorCost
                SecondFloorManipulator.ShowProps()
                BuySecondFloorManipulator.HideProps()
                BuySeconfFloorMutatorZone.Disable()
                BuySecondFloorWallsManipulator.ShowProps()
                BuySecondFloorWallsMutatorZone.Enable()
                BuyDropper1SecondFloorManipulator.ShowProps()
                BuyDopper1SecondFloorMutatorZone.Enable()

    OnPlayersPurchasesSecondFloorWalls(Agent : agent): void =
        if(Player := player[Agent]):
            if(GameManagerInst.CurrentCookieCount >= SecondFloorWallsCost):
                set GameManagerInst.CurrentCookieCount -= SecondFloorWallsCost
                SeconFloorWallsManipulator.ShowProps()
                BuySecondFloorWallsManipulator.HideProps()
                BuySecondFloorWallsMutatorZone.Disable()
                BuySecondFloorRoofManipulator.ShowProps()
                BuySecondFloorRoofMutatorZone.Enable()
            
    OnPlayerPurchasesSecondFloorDropper1(Agent : agent): void =
        if(Player := player[Agent]):
            if(GameManagerInst.CurrentCookieCount >= Dropper1SecondFloorCost):
                set GameManagerInst.CurrentCookieCount -= Dropper1SecondFloorCost
                BuyDropper1SecondFloorManipulator.HideProps()
                BuyDopper1SecondFloorMutatorZone.Disable()
                spawn:
                    SpawnDropper(Dropper1SecondFloorManipulator, CookieFromDropper1SecondFloor, Dropper1SecondFloorCookiesAmountToGrant)
                BuyDropper2SecondFloorManipulator.ShowProps()
                BuyDropper2SecondFloorMutatorZone.Enable()

    OnPlayerPurchasesSecondFloorDropper2(Agent :agent): void =
        if(Player := player[Agent]):
            if(GameManagerInst.CurrentCookieCount >= Dropper2SecondFloorCost):
                set GameManagerInst.CurrentCookieCount -= Dropper2SecondFloorCost
                BuyDropper2SecondFloorManipulator.HideProps()
                BuyDropper2SecondFloorMutatorZone.Disable()
                spawn:
                    SpawnDropper(Dropper2SecondFloorManipulator, CookieFromDropper2SecondFloor, Dropper2SecondFloorCookiesAmountToGrant)
                BuyDropper3SecondFloorManipulator.ShowProps()
                BuyDropper3SecondFloorMutatorZone.Enable()

    OnPlayerPurchasesSecondDropper3(Agent : agent): void =
        if(Player := player[Agent]):
            if(GameManagerInst.CurrentCookieCount >= Dropper3SecondFloorCost):
                set GameManagerInst.CurrentCookieCount -= Dropper3SecondFloorCost
                BuyDropper3SecondFloorManipulator.HideProps()
                BuyDropper3SecondFloorMutatorZone.Disable()
                spawn:
                    SpawnDropper(Dropper3SecondFloorManipulator, CookieFromDropper3SecondFloor, Dropper3SecondFloorCookiesAmountToGrant)

    OnPlayerPurchasesRoof(Agent : agent): void = 
        if(Player := player[Agent]):
            if(GameManagerInst.CurrentCookieCount >= SecondFloorRoofCost):
                set GameManagerInst.CurrentCookieCount -= SecondFloorRoofCost
                BuySecondFloorRoofManipulator.HideProps()
                BuySecondFloorRoofMutatorZone.Disable()
                SecondFloorRoofManipulator.ShowProps()
                BuySecondFloorDecorationsManipulator.ShowProps()
                BuySecondFloorFloorDeacorationsMutatorZone.Enable()

    OnPlayerPurchasesDecorations(Agent : agent): void = 
        if(Player := player[Agent]):
            if(GameManagerInst.CurrentCookieCount >= SecondFloorDecorationsCost):
                # Print("Player has purchased Decorations!", ?Duration := 3.0, ?Color := NamedColors.LightGreen)
                set GameManagerInst.CurrentCookieCount -= SecondFloorDecorationsCost
                BuySecondFloorDecorationsManipulator.HideProps()
                BuySecondFloorFloorDeacorationsMutatorZone.Disable()
                for(Manipulator : DecorationPropsManipulators):
                    Manipulator.ShowProps()
                CinematicDecorationSequence.Play()
                CookieFactoryTracker.Complete(Player)
                CookieFactoryCompletionSound.Play(Player)

    #Dropper Functionality 
    SpawnDropper(DropperManipulator : prop_manipulator_device, CookieToMove : creative_prop, CookiesToGrant : int)<suspends>: void =
        DropperManipulator.ShowProps()
        spawn:
            MoveCookie(CookieToMove, CookiesToGrant)


    MoveCookie(Cookie : creative_prop, CookiesToGrant : int)<suspends>: void =
        CookieStartingTransform := Cookie.GetTransform()
        CookiePosition := CookieStartingTransform.Translation

        Cookie.MoveTo(vector3{
            X:= CookiePosition.X, 
            Y:= CookiePosition.Y, 
            Z:= CookiePosition.Z - 65.0}, 
            CookieStartingTransform.Rotation, 
            1.0
        )

        CookieSecondTransform := Cookie.GetTransform()
        CookieSecondPosition := CookieSecondTransform.Translation

        Cookie.MoveTo(vector3{
            X:= CookieSecondPosition.X, 
            Y:= CookieSecondPosition.Y -325.0, 
            Z:= CookieSecondPosition.Z}, 
            CookieSecondTransform.Rotation, 
            MoveDuration
        )

        CookieThirdTransform := Cookie.GetTransform()
        CookieThirdPosition := CookieThirdTransform.Translation

        Cookie.MoveTo(vector3{
            X:= CookieThirdPosition.X, 
            Y:= CookieThirdPosition.Y, 
            Z:= CookieThirdPosition.Z - 80.0}, 
            CookieThirdTransform.Rotation, 
            1.0
        )

        if(Cookie.TeleportTo[vector3{
            X:= CookiePosition.X, Y:= CookiePosition.Y, Z:= CookiePosition.Z}, CookieStartingTransform.Rotation]):
            set GameManagerInst.CurrentCookieCount += CookiesToGrant
            spawn:
                LoopMovement(Cookie, CookiesToGrant)

    LoopMovement(Cookie : creative_prop, CookiesToGrant : int)<suspends>: void = 
        spawn:
            MoveCookie(Cookie, CookiesToGrant)
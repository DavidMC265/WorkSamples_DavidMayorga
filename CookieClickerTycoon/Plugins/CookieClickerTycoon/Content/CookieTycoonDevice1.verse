
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.
# A Verse-authored creative device that can be placed in a level

TextMessage< localizes>(Agent : agent) : message = "{Agent}"

CookieTycoonDevice1 := class(creative_device):

    var OwnerAgent : ?agent = false

    @editable BuyableItems : []creative_prop = array{}

    @editable TycoonTriggerOwn : trigger_device = trigger_device{}
    @editable OffsetForButtonDownFloor1 : float = 265.0

    @editable Wall1 : creative_prop = creative_prop{}
    @editable Wall1Trigger : trigger_device = trigger_device{}

    @editable Crate : creative_prop = creative_prop{}
    @editable CrateBuyTrigger : trigger_device = trigger_device{}
    @editable CratePropManipulator : prop_manipulator_device = prop_manipulator_device{}
    @editable CrateVFX : vfx_spawner_device = vfx_spawner_device{}
    @editable CrateSound : audio_player_device = audio_player_device{}

    # Runs when the device is started in a running game
    OnBegin< override>()< suspends>:void = {
        # TODO: Replace this with your code
        
        TycoonTriggerOwn.TriggeredEvent.Subscribe(ClaimTycoon)

        Wall1Trigger.TriggeredEvent.Subscribe(BuildWall1)

        CrateBuyTrigger.TriggeredEvent.Subscribe(BuyCrate)

        CratePropManipulator.HarvestingEvent.Subscribe(HarvestCrate)

        for (Item : BuyableItems) {
            CurrentItemLocation := Item.GetTransform().Translation
            NewItemLocation := vector3{X := CurrentItemLocation.X, Y := CurrentItemLocation.Y, Z := -245.2}

            Print("{NewItemLocation}")

            if (Item.TeleportTo[NewItemLocation, IdentityRotation()]) {}
        }

    }

    BuildWall1(Agent : ?agent) : void = {
        if (OwnerAgent = Agent) {
            Wall1Trigger.Disable()

            Print("{OffsetForButtonDownFloor1}", ?Duration:=6.0)
    
            CurrentWallLocation := Wall1.GetTransform().Translation
            NewWallLocation := vector3{X := CurrentWallLocation.X, Y := CurrentWallLocation.Y, Z := CurrentWallLocation.Z + OffsetForButtonDownFloor1}
            spawn{BuildWall1Wait(NewWallLocation)}
    
            Print("{NewWallLocation}", ?Duration:=6.0)
    
            CurrentButtonLocation1 := Wall1Trigger.GetTransform().Translation
            NewButtonLocation1 := vector3{X := CurrentButtonLocation1.X, Y := CurrentButtonLocation1.Y, Z := CurrentButtonLocation1.Z - OffsetForButtonDownFloor1}
            if (Wall1Trigger.TeleportTo[NewButtonLocation1, IdentityRotation()]) {}

            CurrentButtonLocation := CrateBuyTrigger.GetTransform().Translation
            NewButtonLocation := vector3{X := CurrentButtonLocation.X, Y := CurrentButtonLocation.Y, Z := CurrentButtonLocation.Z + OffsetForButtonDownFloor1}
            if (CrateBuyTrigger.TeleportTo[NewButtonLocation, IdentityRotation()]) {}
        }
    }

    BuildWall1Wait(NewWallLocation : vector3) < suspends> :  void = {
        Wall1.MoveTo(NewWallLocation, IdentityRotation(), 1.0)
        Sleep(0.5)
        Wall1Trigger.Enable()
    }

    ClaimTycoon(Agent : ?agent) : void = {
        if (OwnerAgent = false) {
            if (PossibleAgent := Agent?) {
                TycoonTriggerOwn.Disable()
                set OwnerAgent = Agent
                Print(TextMessage(PossibleAgent))
                CurrentButtonLocation := TycoonTriggerOwn.GetTransform().Translation
                NewLocation := vector3{X := CurrentButtonLocation.X, Y := CurrentButtonLocation.Y, Z := CurrentButtonLocation.Z - OffsetForButtonDownFloor1}
                if (TycoonTriggerOwn.TeleportTo[NewLocation, TycoonTriggerOwn.GetTransform().Rotation]) {}
                
                CurrentButtonLocation1 := Wall1Trigger.GetTransform().Translation
                NewButtonLocation1 := vector3{X := CurrentButtonLocation1.X, Y := CurrentButtonLocation1.Y, Z := CurrentButtonLocation1.Z + OffsetForButtonDownFloor1}
                if (Wall1Trigger.TeleportTo[NewButtonLocation1, IdentityRotation()]) {}
                spawn{ClaimTycoonWait()}
            } 
        }
    }

    ClaimTycoonWait() < suspends> : void = {
        Sleep(0.5)
        TycoonTriggerOwn.Enable()
    }

    BuyCrate(Agent : ?agent) : void = {
        if (OwnerAgent = Agent) {
            CrateBuyTrigger.Disable()
   
            CurrentCrateLocation := Crate.GetTransform().Translation
            NewCrateLocation := vector3{X := CurrentCrateLocation.X, Y := CurrentCrateLocation.Y, Z := CurrentCrateLocation.Z + 362.0}
            spawn{BuildCrate1Wait(NewCrateLocation)}
    
            CurrentButtonLocation1 := CrateBuyTrigger.GetTransform().Translation
            NewButtonLocation1 := vector3{X := CurrentButtonLocation1.X, Y := CurrentButtonLocation1.Y, Z := CurrentButtonLocation1.Z - OffsetForButtonDownFloor1}
            if (CrateBuyTrigger.TeleportTo[NewButtonLocation1, IdentityRotation()]) {}
        }
    }

    BuildCrate1Wait(NewWallLocation : vector3) < suspends> :  void = {
        Crate.MoveTo(NewWallLocation, IdentityRotation(), 1.0)
        Sleep(0.5)
        CrateBuyTrigger.Enable()
    }

    HarvestCrate(Agent : agent) : void = {
        if (PossibleAgent := OwnerAgent?) {
            if (PossibleAgent = Agent) {
                CrateVFX.Restart()
                
                CrateSound.Play(Agent)
            }
        }
    }

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# A Verse-authored creative device that can be placed in a level
saving_hats := class(creative_device):

    @editable
    Trigger_CheckingForSavedData:trigger_device = trigger_device{}
    @editable
    Trigger_SavingPlayerHat:trigger_device = trigger_device{}

    OnBegin<override>()<suspends>:void=
        Trigger_CheckingForSavedData.TriggeredEvent.Subscribe(OnPlayerSavedHat)
    
    OnPlayerSavedHat(Agent:?agent):void =
        Print("Player Hat has hopefully been saved", ?Duration:=6.0)
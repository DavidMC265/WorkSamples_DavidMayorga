using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

FirstPersonDevices<localizes>:message = "FirstPersonDevices"

first_person_camera := class(creative_device):

    @editable:
        Categories := array{ FirstPersonDevices }
    var InputTriggerDevice : input_trigger_device = input_trigger_device{}

    @editable:
        Categories := array{ FirstPersonDevices }
    var FirstPersonCameraDevice : gameplay_camera_first_person_device = gameplay_camera_first_person_device{}

    var FirstPersonModePerAgent : [agent]logic = map{}

    OnBegin<override>()<suspends>:void=
        InputTriggerDevice.PressedEvent.Subscribe(OnPlayerPressesInputTrigger)

    OnPlayerPressesInputTrigger(Agent : agent): void=
        if(FirstPersonModePerAgent[Agent] = true):
            FirstPersonCameraDevice.RemoveFrom(Agent)
            if(set FirstPersonModePerAgent[Agent] = false){}
            # Print("Disabled First Person Mode for player!!")
        
        else:
            FirstPersonCameraDevice.AddTo(Agent)
            if(set FirstPersonModePerAgent[Agent] = true){}
            # Print("Enabled First Person Mode for player!!")



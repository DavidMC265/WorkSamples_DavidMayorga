using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/FortPlayerUtilities }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }


ui_spectatormode<public> := class(base_ui):

    Exit_Text<localizes> : message = "Exit"
    Exit_Button : button_loud = button_loud{}

    ReturnToLobby_Text<localizes> : message = "Return to Lobby"
    ReturnToLobby_Button : button_loud = button_loud{}

    var MaybeEventMediator : ?event_mediator = false

    var MaybeRespawningLobbyInfo : ?tuple(vector3, creative_prop) = false

    var MaybeRespawningLocationInfo : ?tuple(vector3, creative_prop) = false


    CreateCanvas<override>():void=
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{Left := -468.000000, Top := 200.000000, Right := 225.629608, Bottom := 75.555557}
                    Alignment := vector2{X:= 0.0, Y:= 0.0}
                    ZOrder := 2
                    SizeToContent := false
                    Widget := Exit_Button
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5} }
                    Offsets := margin{Left := 7.039062, Top := 200.000000, Right := 448.074066, Bottom := 75.555557}
                    Alignment := vector2{X:= 0.0, Y:= 0.0}
                    ZOrder := 2
                    SizeToContent := false
                    Widget := ReturnToLobby_Button

                    
        Exit_Button.SetText(Exit_Text)
        Exit_Button.OnClick().Subscribe(OnExitClicked)

        ReturnToLobby_Button.SetText(ReturnToLobby_Text)
        ReturnToLobby_Button.OnClick().Subscribe(OnReturnToLobbyButtonClicked)

    
    InitVariables<public>(MaybeEventMediatorIn : ?event_mediator, MaybeRespawningLobbyInfoIn : ?tuple(vector3, creative_prop), MaybeRespawningPropInfoIn : ?tuple(vector3, creative_prop) ): void =
        set MaybeEventMediator = MaybeEventMediatorIn
        set MaybeRespawningLocationInfo = MaybeRespawningPropInfoIn
        set MaybeRespawningLobbyInfo = MaybeRespawningLobbyInfoIn

        
    OnExitClicked(WidgetPlayer : widget_message): void =
        if:
            PlayerData:=MaybePlayerData?
            EventMediator := MaybeEventMediator?
            Player := WidgetPlayer.Player
            RespawningLocationInfo := MaybeRespawningLocationInfo?
            FortCharacter := Player.GetFortCharacter[]
        then:
            PlayerData.HideSpectatorModeUI()

            RespawningPropLocation := RespawningLocationInfo(0)
            RespawningProp := RespawningLocationInfo(1)

            PropTransform := RespawningProp.GetTransform()
            Location := vector3{ X:= RespawningPropLocation.X, Y:= RespawningPropLocation.Y, Z:= RespawningPropLocation.Z + 110.0}

            Print("{RespawningPropLocation}")
            Print("{Location}")

            Player.Respawn(Location, PropTransform.Rotation )


    OnReturnToLobbyButtonClicked(WidgetPlayer : widget_message): void =
        if:
            PlayerData:=MaybePlayerData?
            EventMediator := MaybeEventMediator?
            Player := WidgetPlayer.Player
            RespawningLobbyInfo := MaybeRespawningLobbyInfo?
            FortCharacter := Player.GetFortCharacter[]
        then:
            PlayerData.HideSpectatorModeUI()

            RespawningPropLocation := RespawningLobbyInfo(0)
            RespawningProp := RespawningLobbyInfo(1)

            PropTransform := RespawningProp.GetTransform()
            Location := vector3{ X:= RespawningPropLocation.X, Y:= RespawningPropLocation.Y, Z:= RespawningPropLocation.Z + 110.0}

            Print("{RespawningPropLocation}")
            Print("{Location}")

            Player.Respawn(Location, PropTransform.Rotation )

using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Simulation }



ui_twoplayersleft<public> := class(base_ui):

    TextForUIInfo<localizes>(Text : string) : message = "{Text}"


    CreateCanvas<override>():void=
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 0.0}, Maximum := vector2{X:= 0.5, Y:= 0.0} }
                    Offsets := margin{Left := 30.680725, Top := 210.539673, Right := 1383.283325, Bottom := 1405.079346}
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 0
                    SizeToContent := false
                    Widget := texture_block{ DefaultImage := CustomProps.MessageImg }
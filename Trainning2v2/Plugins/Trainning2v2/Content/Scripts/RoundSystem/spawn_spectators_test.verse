using { /Verse.org/Colors }
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Fortnite.com/FortPlayerUtilities }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/Diagnostics }


spawn_spectators_test := class(creative_device):

    @editable 
    var RespawnDeadPlayersButton : button_device = button_device{}

    @editable
    var RespawningProp : creative_prop = creative_prop{}

    @editable 
    var CheckAlivePlayers : button_device = button_device{}


    OnBegin<override>()<suspends>:void=
        RespawnDeadPlayersButton.InteractedWithEvent.Subscribe(GetAllPlayersSpectators)

        CheckAlivePlayers.InteractedWithEvent.Subscribe(GetAllPlayersInTeams)



    GetAllPlayersInTeams(Agent : agent): void = 
        TeamCollection := GetPlayspace().GetTeamCollection()    
        TeamArray := TeamCollection.GetTeams()
        Print("{TeamArray.Length}")
    
        # for (Team : TeamArray):
        #     Print("{Team.Length}")

    GetAllPlayersSpectators(Agent : agent): void =
        AllPlayers := GetPlayspace().GetPlayers()

        TransformLoc := RespawningProp.GetTransform()
        TranslationLoc := TransformLoc.Translation

        DestinationLoc := vector3{X:= TranslationLoc.X, Y:= TranslationLoc.Y, Z:= TranslationLoc.Z + 100.0}

        TeamCollection := GetPlayspace().GetTeamCollection()
        TeamArray := TeamCollection.GetTeams()


        for(Player : AllPlayers):
            if(Spectator := Player.IsSpectator[]):
                # Print(
                #     "Found spectiting player!!", 
                #     ?Duration := 6.0, 
                #     ?Color := NamedColors.LightBlue
                # )
                Player.Respawn(DestinationLoc, TransformLoc.Rotation)
                # Print(
                #     "Respawned player at location set!!!!", 
                #     ?Duration := 10.0, 
                #     ?Color := NamedColors.LightGreen
                # )
                if (AgentsTeam := TeamCollection.GetTeam[Player]):
                    for (TeamNumber->Team : TeamArray):
                        if (AgentsTeam = Team):
                            Print(
                                "The spectating player is on team {TeamNumber}", 
                                ?Duration := 10.0, 
                                ?Color := NamedColors.LightGreen
                            )

            else:
                Print(
                    "This player is not spectiting", 
                    ?Duration := 6.0, 
                    ?Color := NamedColors.Orange
                )



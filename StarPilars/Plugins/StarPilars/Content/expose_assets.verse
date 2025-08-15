using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation }


simple_log := class(log_channel){}
debugging_tester_log := class(log_channel){}
catch_exceptions_log := class(log_channel){}


Assets<public> := module:
    Animations<public> := module: # Animation sequences
    Materials<public> := module:  # Shaders, colors, textures for reusable materials
    MeshesNew<public> := module:     # 3D models, meshes, textures (add folder per type and object)
    Sounds<public> := module:     # Background music, SFX
    Textures<public> := module:   # Textures used for models.
    UI_Textures<public> := module:# Icons, HUD elements (add folder per UI category)
    Widgets<public> := module:    # UI frameworks or blueprints.

CustomProps<public> := module: # This folder is made automatically by the engine when you create a new prop via scripted actor actions.

Scripts<public>:= module:
    Lib := module:
    MainScripts:= module:
        UIScripts:= module:
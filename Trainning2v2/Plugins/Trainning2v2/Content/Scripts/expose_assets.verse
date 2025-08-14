using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }


<#> The logs are used to print messages to the console, they are used to debug the code.
    These messages are not shown in game, they are only visible in the console (editor and game console).
    Debug and Verbose log_level are shown only in the game console, defaultLevel can be changed in each script or inline.
    Normal, Warning or Error are also shown in the editor console.
simple_log := class(log_channel){}
debugging_tester_log := class(log_channel){}
catch_exceptions_log := class(log_channel){}

<#> This script is used to expose assets to the code, these modules are created automatically
    by the engine in Assets.digest.verse as private modules, we are overriding it in here as public.
    When naming folders be careful to not use reserved worlds because they are considered modules in code.
    An example of a reserved word is agent because it is used in the code.
Assets<public> := module:
    Animations<public> := module: # Animation sequences
    Materials<public> := module:  # Shaders, colors, textures for reusable materials
    Meshes<public> := module:     # 3D models, meshes, textures (add folder per type and object)
    Sounds<public> := module:     # Background music, SFX
    # Textures<public> := module:   # Textures used for models.
    UI_Textures<public> := module:# Icons, HUD elements (add folder per UI category)
    Widgets<public> := module:    # UI frameworks or blueprints.

CustomPropss<public> := module: # This folder is made automatically by the engine when you create a new prop via scripted actor actions.

# Scripts := module:
#     Lib := module:
#     MainScripts:= module:
#         # UIScripts<public> := module:
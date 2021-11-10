#define RECOMPILE_FUNCTIONS 0

class CfgPatches
{
    class RCODAM_patches
    {
        units[] =
        {
            "RCODAM_GeneralSettings",
			"RCODAM_AddMineLayerGroup",
			"RCODAM_RestrictObjective",
			"RCODAM_CreateExclusionZone"
		};
        requiredVersion = 1.00;
        requiredAddons[] =
        {
            "A3_Modules_F",
			"3DEN"
        };
        author = "Rimmy";
        name = "Dynamic AI Minefields - RCO";
        version = "1.0";
    };
};

class CfgFactionClasses
{
    class RCODAM_modules
    {
        displayname = "Dynamic AI Minefields - RCO";
        priority = 1;
        side = 7;
    };
};

class CfgFunctions
{
    class RCODAM
    {
        class RCODynAIMines
        {
            tag = "RCODAM";
            file = "\RCODAM\RCODynAIMines";
            class RCODAMcheckGroupMines {
				recompile = RECOMPILE_FUNCTIONS;
				};
			class RCODAMcheckNearestObjective {
				recompile = RECOMPILE_FUNCTIONS;
				};
			class RCODAMcheckSafeMineSpot {
				recompile = RECOMPILE_FUNCTIONS;
				};
			class RCODAMcheckUnitMines {
				recompile = RECOMPILE_FUNCTIONS;
				};
			class RCODAMcreateExclusionZone {
				recompile = RECOMPILE_FUNCTIONS;
				};
			class RCODAMdefenceObjective {
				recompile = RECOMPILE_FUNCTIONS;
				};
			class RCODAMinterceptObjective {
				recompile = RECOMPILE_FUNCTIONS;
				};
			class RCODAMinterdictObjective {
				recompile = RECOMPILE_FUNCTIONS;
				};
			class RCODAMmineGroupAssigner {
				recompile = RECOMPILE_FUNCTIONS;
				};
			class RCODAMplaceATMine {
				recompile = RECOMPILE_FUNCTIONS;
				};
			class RCODAMplaceMine {
				recompile = RECOMPILE_FUNCTIONS;
				};
			class RCODAMsettingsInitialiser {
				recompile = RECOMPILE_FUNCTIONS;
				};
			class RCODAMstuckChecker {
				recompile = RECOMPILE_FUNCTIONS;
				};
			class RCODAMdebugMessage {
				recompile = RECOMPILE_FUNCTIONS;
				};
			class RCODAMmineGroupTaskRestrict {
				recompile = RECOMPILE_FUNCTIONS;
				};
			
        };
	};
};

class CfgVehicles
{
    class Logic;
    class Module_F: Logic
    {
        class AttributesBase
        {
            class Default;
            class Edit; // Default edit box (i.e., text input field)
            class Combo; // Default combo box (i.e., drop-down menu)
            class CheckBox; // Tickbox, returns true/false
            class CheckBoxNumber; // Tickbox, returns 1/0
            class ModuleDescription; // Module description
        };
        class ModuleDescription
        {
            class Anything;
        };
    };
	
	// Dynamic AI Minefields Modules
    #include "modules\RCODAM_GeneralSettings.hpp"
	#include "modules\RCODAM_AddMineLayerGroup.hpp"
	#include "modules\RCODAM_RestrictObjective.hpp"
	#include "modules\RCODAM_CreateExclusionZone.hpp"
	
};
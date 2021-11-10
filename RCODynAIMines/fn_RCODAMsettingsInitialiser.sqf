_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {deleteVehicle _module};

_mineSide = _module getVariable "RCODAM_mineSide";
_updateTimer = _module getVariable "RCODAM_updateTimer";
_mineUpdateTimer = _module getVariable "RCODAM_mineUpdateTimer";
_groupLimitChoice = _module getVariable "RCODAM_groupLimitChoice";
_groupSizeLimitChoice = _module getVariable "RCODAM_groupSizeLimitChoice";
_friendlyGroupLimitChoice = _module getVariable "RCODAM_friendlyGroupLimitChoice";
_friendlyGroupSizeLimitChoice = _module getVariable "RCODAM_friendlyGroupSizeLimitChoice";
_forgetTimer = _module getVariable "RCODAM_forgetTimer";
_runIfEmpty = _module getVariable "RCODAM_runIfEmpty";
_needTaskForceforIntercept = _module getVariable "RCODAM_needTaskForceforIntercept";
_mineChance = _module getVariable "RCODAM_mineChance";
_defenceChance = _module getVariable "RCODAM_defenceChance";
_interceptChance = _module getVariable "RCODAM_interceptChance";
_interdictChance = _module getVariable "RCODAM_interdictChance";
_roadChance = _module getVariable "RCODAM_roadChance";
_ATmineadd = _module getVariable "RCODAM_ATMineList";
_minimumMineCount = _module getVariable "RCODAM_minimumMineCount";
_groupDetector = _module getVariable "RCODAM_groupDetector";
_debugOption = _module getVariable "RCODAM_debugMode";
_furthestTravel = _module getVariable "RCODAM_furthestTravel";

_ATmineaddArray = parseSimpleArray _ATmineadd;

rimmy_dam_var_ATmineArray = ["vn_mine_tripwire_arty_mag","ATMine_Range_Mag","SLAMDirectionalMine_Wire_Mag","vn_mine_m15_mag","vn_mine_tm57_mag"];
rimmy_dam_var_removeFromMineArray = ["MineDetector","APERSMineDispenser_Mag"];
rimmy_dam_var_ACEIEDExceptionArray = [];
if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {
	rimmy_dam_var_ACEIEDExceptionArray = ["IEDLandBig_Remote_Mag","IEDUrbanBig_Remote_Mag","IEDLandSmall_Remote_Mag","IEDUrbanSmall_Remote_Mag"];
	rimmy_dam_var_ATmineArray pushBackUnique "IEDLandBig_Remote_Mag";
	rimmy_dam_var_ATmineArray pushBackUnique "IEDUrbanBig_Remote_Mag";
};

rimmy_dam_var_ATmineArray = rimmy_dam_var_ATmineArray + _ATmineaddArray;

switch (_mineSide) do
{
	case "WEST": {_mineSide = west};
	case "EAST": {_mineSide = east};
	case "RESISTANCE": {_mineSide = resistance};
};

sleep 1;

[[_mineSide,_groupLimitChoice,_groupSizeLimitChoice,_friendlyGroupLimitChoice,_friendlyGroupSizeLimitChoice,_updateTimer,_forgetTimer,_needTaskForceforIntercept,_runIfEmpty,_debugOption],"RCODAM\RCODynAIMines\RCODAMinformationSorter.sqf"] remoteExec ["execVM",2];

sleep 3;

[[_mineSide,_mineUpdateTimer,_mineChance,_defenceChance,_interceptChance,_interdictChance,_roadChance,_runIfEmpty,_minimumMineCount,_groupDetector,_debugOption,_furthestTravel],"RCODAM\RCODynAIMines\RCODAMmineTaskCreator.sqf"] remoteExec ["execVM",2];
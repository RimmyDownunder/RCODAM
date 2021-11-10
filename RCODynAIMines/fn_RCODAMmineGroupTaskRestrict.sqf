_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {deleteVehicle _module};

waitUntil {sleep 10; !(isNil "rimmy_dam_var_mineLayingGroup_WEST") && !(isNil "rimmy_dam_var_mineLayingGroup_EAST") && !(isNil "rimmy_dam_var_mineLayingGroup_GUER");};

_defenceCheck = _module getVariable "RCODAM_defenceObjectiveChoice";
_interceptCheck = _module getVariable "RCODAM_interceptObjectiveChoice";
_interdictCheck = _module getVariable "RCODAM_interdictObjectiveChoice";

{
	private _groupToAdd = group _x;
	_groupToAdd setVariable ["rimmy_dam_groupvar_willTakeAnyTask",false];
	_groupToAdd setVariable ["rimmy_dam_groupvar_willTakeDefence",_defenceCheck];
	_groupToAdd setVariable ["rimmy_dam_groupvar_willTakeIntercept",_interceptCheck];
	_groupToAdd setVariable ["rimmy_dam_groupvar_willTakeInterdict",_interdictCheck];
} foreach (synchronizedObjects _module);
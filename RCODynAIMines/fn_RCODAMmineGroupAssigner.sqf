_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {deleteVehicle _module};

waitUntil {sleep 10; !(isNil "rimmy_dam_var_mineLayingGroup_WEST") && !(isNil "rimmy_dam_var_mineLayingGroup_EAST") && !(isNil "rimmy_dam_var_mineLayingGroup_GUER");};

{
	call compile ("rimmy_dam_var_mineLayingGroup_" + (str (side _x)) + " pushBackUnique (group _x)");
} foreach (synchronizedObjects _module);
params ["_scriptToCancel","_scriptStartTime","_mineLayer","_simulationControl"];	

if (isMultiplayer) then {
	waitUntil {sleep 5; (scriptDone _scriptToCancel) || ((_scriptStartTime + 120) <= serverTime)};
} else {
	waitUntil {sleep 5; (scriptDone _scriptToCancel) || ((_scriptStartTime + 120) <= time)};
};

if (!(scriptDone _scriptToCancel)) then {
	terminate _scriptToCancel;
	_mineLayer setVariable ["rimmy_dam_var_unitFreeToTask",true];
};
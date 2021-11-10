params ["_mineLayer","_currentMine","_mineSide","_objectName","_simulationControl"];	

_mineLayer doMove _currentMine;
_mineLayer setSpeedMode "NORMAL";

private _inventoryToCheck = [];
_inventoryToCheck = _inventoryToCheck + uniformItems _mineLayer;
_inventoryToCheck = _inventoryToCheck + vestItems _mineLayer;
_inventoryToCheck = _inventoryToCheck + backpackItems _mineLayer;

private _overallMineList = [];
private _ATMineList = [];

{
	if ((["mine",_x] call BIS_fnc_inString && !(["remote",_x] call BIS_fnc_inString) && !(_x in rimmy_dam_var_removeFromMineArray)) || _x in rimmy_dam_var_ACEIEDExceptionArray) then {
		_overallMineList pushBack _x;
	};

	if (_x in rimmy_dam_var_ATmineArray) then {
		_ATMineList pushBack _x;
	};
} forEach _inventoryToCheck;

private _mineConfigure = selectRandom _ATMineList;
private _minePicked = "mineFailedToPick";

if (_mineConfigure in rimmy_dam_var_ACEIEDExceptionArray) then {
switch (_mineConfigure) do
{
	case "IEDLandBig_Remote_Mag": { _minePicked = "ACE_IEDLandBig_Range" };
	case "IEDUrbanBig_Remote_Mag": { _minePicked = "ACE_IEDUrbanBig_Range" };
	case "IEDLandSmall_Remote_Mag": { _minePicked = "ACE_IEDLandSmall_Range" };
	case "IEDUrbanSmall_Remote_Mag": { _minePicked = "ACE_IEDUrbanSmall_Range" };
	default { "Failed with ACE IED mine picker." remoteExec ["systemChat",0] };
};
} else {
	_cutStringNum = _mineConfigure find "_mag";
if (_cutStringNum == -1) then {_cutStringNum = _mineConfigure find "_Mag"};
	_minePicked = _mineConfigure select [0, _cutStringNum];
};

if (!(isClass(configFile >> "CfgVehicles" >> _minePicked))) then {
	_cutStringNum = _mineConfigure find "_Range";
	_minePicked = _mineConfigure select [0, _cutStringNum];
};

if (!(isClass(configFile >> "CfgVehicles" >> _minePicked))) then {
	"Mine has failed to be found, reverting to default AP mine." remoteExec ["systemChat",0];
	_minePicked = "APERSMine";
};

private _targetBearingToAdjust = _objectName getRelDir _currentMine;
_targetBearingToAdjust = _targetBearingToAdjust + 180;
if (_targetBearingToAdjust > 360) then {_targetBearingToAdjust = _targetBearingToAdjust - 360;};

_stayedTime = serverTime;
if (isMultiplayer) then {_stayedTime = serverTime} else {_stayedTime = time};

waitUntil {sleep 0.2; ((getPosATL _mineLayer) distance _currentMine <= 6) || {if (isMultiplayer) then {_stayedTime + 40 <= serverTime} else {_stayedTime + 40 <= time}}};
if (!((getPosATL _mineLayer) distance _currentMine <= 6)) then {
_mineBackupPosition = [_currentMine, 0, 4, 1, 0, 0.5, 0, [], [[0,0],[0,0]]] call RCODAM_fnc_RCODAMcheckSafeMineSpot;
if (!(_mineBackupPosition isEqualTo [0,0])) then {
_mineLayer doMove _mineBackupPosition;
} else {
["Unit unable to find safe mine spot to move to: " + (str group _mineLayer),(missionNamespace getVariable format ["rimmy_dam_var_debugPerSide_%1", _mineSide])] call RCODAM_fnc_RCODAMdebugMessage;
};
};

waitUntil {sleep 0.2; (getPosATL _mineLayer) distance _currentMine <= 6};
doStop _mineLayer;

_stayedTime = serverTime;
if (isMultiplayer) then {_stayedTime = serverTime} else {_stayedTime = time};

waitUntil {sleep 0.1; (((getPos nearestObject [_currentMine, "CAManBase"]) distance _currentMine >= 2) || {if (isMultiplayer) then {_stayedTime + 10 <= serverTime} else {_stayedTime + 10 <= time}})};
_minePlaced = createMine [_minePicked,_currentMine,[],0];
[_minePlaced, _targetBearingToAdjust] remoteExec ["setDir",0,true];
_mineLayer playMoveNow "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon";

_allFriendlySides = [WEST,EAST,RESISTANCE,CIVILIAN];
_allFriendlySides = _allFriendlySides - (missionNamespace getVariable format ["rimmy_dam_var_enemySidesOfMineLayer_%1", _mineSide]);

{
_x revealMine _minePlaced;
} forEach _allFriendlySides;

_minePlaced enableSimulationGlobal false;

private _listOfMines = missionNamespace getVariable format ["rimmy_dam_var_minefieldSimulationControl_%1", _simulationControl];
_listOfMines pushBack _minePlaced;
missionNamespace setVariable [format ["rimmy_dam_var_minefieldSimulationControl_%1", _simulationControl],_listOfMines];

_mineLayer call RCODAM_fnc_RCODAMcheckUnitMines;

sleep 1;

_mineLayer setVariable ["rimmy_dam_var_unitFreeToTask",true];

_minePlaced
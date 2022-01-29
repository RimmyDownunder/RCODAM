params ["_mineGroup","_objective","_roadChance","_mineSide","_minimumMineCount"];	

private _vehicleStatus = false;
private _vehiclesInTarget = (_objectiveToPass select 1);
private _simulationControl = ((_objective select 0) select 0);

if (_vehiclesInTarget > 0) then {_vehicleStatus = true} else {_vehicleStatus = false};

for "_i" from count waypoints _mineGroup - 1 to 0 step -1 do
{
	deleteWaypoint [_mineGroup, _i];
};

private _markerToRemove = "TEMPMinefieldExclusionAreaMarker" + str _mineSide + str ((_objective select 0) select 0);
private _exclusionZoneMaintenance = missionNamespace getVariable format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide];
private _markerToRemoveCleanUp = _exclusionZoneMaintenance find _markerToRemove;
_exclusionZoneMaintenance deleteAt _markerToRemoveCleanUp;
deleteMarker _markerToRemove;

missionNamespace setVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],_exclusionZoneMaintenance];

private _minefieldCentre = [];
private _groupMoveToPos = _objective select 0;
if ((random 1) < _roadChance) then {
	_nearestRoad = [(_objective select 0), 250] call BIS_fnc_nearestRoad;
	if (isNull _nearestRoad) then {
	_minefieldCentre = [(_objective select 0), 0, 100, 0, 0, 0.5, 0, [(missionNamespace getVariable format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide])], [[0,0],[0,0]]] call RCODAM_fnc_RCODAMcheckSafeMineSpot;
	} else {
	_minefieldCentre = getPosATL _nearestRoad;
	};
} else {
	_minefieldCentre = [(_objective select 0), 0, 100, 0, 0, 0.5, 0, [(missionNamespace getVariable format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide])], [[0,0],[0,0]]] call RCODAM_fnc_RCODAMcheckSafeMineSpot;
};

_objectiveWP = _mineGroup addWaypoint [_minefieldCentre, 0];
_objectiveWP setWaypointType "MOVE";
_objectiveWP setWaypointSpeed "FULL";

_mineGroup setBehaviourStrong "AWARE";
_mineGroup setFormation "FILE";

private _totalMineCount = 0; 
_totalMineCount = _mineGroup call RCODAM_fnc_RCODAMcheckGroupMines;

_numberOfMinesToLay = ((ceil random _totalMineCount) max 4) min 50;
_numberOfMinesSpotsDecided = 1;

_minesToLay = [_minefieldCentre];
_mineDistance = 9;
_mineBearing = 0;

while {_numberOfMinesSpotsDecided < _numberOfMinesToLay} do {
		_minePositionToCheck = _minefieldCentre getPos [_mineDistance,_mineBearing];
		_mineBearing = _mineBearing + (ceil random 90 max 20);
	if (_mineBearing >= 360) then {
		_mineBearing = 0;
		_mineDistance = _mineDistance + (ceil random 17 max 5);
	};
	
	if (random 1 <= 0.95) then {
		_minePositionToAdd = [_minePositionToCheck, 0, 3, 2, 0, 0.5, 0, [(missionNamespace getVariable format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide])], [[0,0],[0,0]]] call RCODAM_fnc_RCODAMcheckSafeMineSpot;
		_minePositionToAdd set [2, 0];
	if (!(_minePositionToAdd IsEqualTo [0,0]) && {{if (_minePositionToAdd distance _x <= 4) exitWith {false}; true} forEach _minesToLay}) then {
		_minesToLay pushBack _minePositionToAdd;
		_numberOfMinesSpotsDecided = _numberOfMinesSpotsDecided + 1;
	};
	};
};

private _exclusionZoneSecondMaintenance = missionNamespace getVariable format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide];

private _markerName = "TEMPMinefieldExclusionAreaMarker" + str _mineSide + str ((_objective select 0) select 0);
_marker = createMarkerLocal [_markerName, _minefieldCentre];

_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerSizeLocal [350, 350];
_marker setMarkerAlphaLocal 0;
_marker setMarkerColorLocal "ColorYellow";

if (missionNamespace getVariable format ["rimmy_dam_var_debugPerSide_%1", _mineSide]) then {
	_marker setMarkerAlpha 0.5;
};

_exclusionZoneSecondMaintenance pushBack _marker;

missionNamespace setVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],_exclusionZoneSecondMaintenance];
 
waitUntil {sleep 5; (getPosATL leader _mineGroup) distance _minefieldCentre <= 80};

{
_x disableAI "COVER";
_x disableAI "AUTOCOMBAT";
} forEach units _mineGroup;
_mineGroup setBehaviourStrong "AWARE";

for "_i" from count waypoints _mineGroup - 1 to 0 step -1 do
{
	deleteWaypoint [_mineGroup, _i];
};

private _debugMarkersList = [];
if (missionNamespace getVariable format ["rimmy_dam_var_debugPerSide_%1", _mineSide]) then {
{
private _debugSpawnerPos = +_x;
_debugSpawnerPos set [2, 6];
_debugMarker = createVehicle ["VR_3DSelector_01_default_F", _debugSpawnerPos];
_debugMarkersList pushBack _debugMarker;
} forEach _minesToLay;
};

for "_i" from count waypoints _mineGroup - 1 to 0 step -1 do
{
	deleteWaypoint [_mineGroup, _i];
};

{
	doStop _x;
	_x call RCODAM_fnc_RCODAMcheckUnitMines;
} forEach units _mineGroup;

_targetLocationToAdjustMines = (_objective select 2);

private _objectName = createSimpleObject ["VR_GroundIcon_01_F", _targetLocationToAdjustMines];
_objectName hideObjectGlobal true;
private _groupIsFree = 0;
private _unitsFree = 0;

missionNamespace setVariable [format ["rimmy_dam_var_minefieldSimulationControl_%1", ((_objective select 0) select 0)],[]];
{
	_x setVariable ["rimmy_dam_var_unitFreeToTask",true];
	
	if (isClass(configFile >> "CfgPatches" >> "lambs_main")) then {
		_x setVariable ["lambs_danger_disableAI", true];
	};
} forEach units _mineGroup;

while {sleep 10; ((count _minesToLay > 0) || (_groupIsFree == 0))} do {
	_unitsFree = 0;
	{
		if (_x getVariable ["rimmy_dam_var_unitFreeToTask",true] && ((_x getVariable ["rimmy_dam_var_unitHasAPMines",false]) || (_x getVariable ["rimmy_dam_var_unitHasATMines",false]))) then {
			private _currentMine = _minesToLay select 0;
			if (!(isNil "_currentMine")) then {
			if (_currentMine IsEqualTo _minefieldCentre && _vehicleStatus) then {
				_firstATMineCheck = _x getVariable "rimmy_dam_var_unitHasATMines";
					if (_firstATMineCheck) then {
						_minesToLay deleteAt 0;
						_x setVariable ["rimmy_dam_var_unitFreeToTask",false];
						private _stayedTime = 0;
						if (isMultiplayer) then {_stayedTime = serverTime} else {_stayedTime = time};
						_minePlacedScriptHandler = [_x,_currentMine,_mineSide,_objectName,_simulationControl] spawn RCODAM_fnc_RCODAMplaceATMine;
						[_minePlacedScriptHandler,_stayedTime,_x,_simulationControl] spawn RCODAM_fnc_RCODAMstuckChecker;
					};
			} else {
				_minesToLay deleteAt 0;
				_x setVariable ["rimmy_dam_var_unitFreeToTask",false];
				private _stayedTime = 0;
				if (isMultiplayer) then {_stayedTime = serverTime} else {_stayedTime = time};
				_minePlacedScriptHandler = [_x,_currentMine,_mineSide,_objectName,_simulationControl] spawn RCODAM_fnc_RCODAMplaceMine;
				[_minePlacedScriptHandler,_stayedTime,_x,_simulationControl] spawn RCODAM_fnc_RCODAMstuckChecker;
			};
		};
		};
		if (_x getVariable ["rimmy_dam_var_unitFreeToTask",false]) then {
		_unitsFree = _unitsFree + 1;
		};
	
	} forEach units _mineGroup;

	[("Units not tasked in " + str _mineGroup + ":" + str _unitsFree),(missionNamespace getVariable format ["rimmy_dam_var_debugPerSide_%1", _mineSide])] call RCODAM_fnc_RCODAMdebugMessage;
	if (_unitsFree == (count units _mineGroup)) then {
		_groupIsFree = 1;
		["Group is finished with mine objective.",(missionNamespace getVariable format ["rimmy_dam_var_debugPerSide_%1", _mineSide])] call RCODAM_fnc_RCODAMdebugMessage;
	};
};

if ((count units _mineGroup) > 0) then {

_returnToTaskforce = missionNamespace getVariable format ["rimmy_dam_var_friendlyTaskforceList_%1", _mineSide];

sleep 3;

units _mineGroup doFollow leader _mineGroup;
_mineGroup setSpeedMode "NORMAL";
_mineGroup setBehaviourStrong "AWARE";

{
_x enableAI "COVER";
_x enableAI "AUTOCOMBAT";
} forEach units _mineGroup;

for "_i" from count waypoints _mineGroup - 1 to 0 step -1 do
{
	deleteWaypoint [_mineGroup, _i];
};

_returnToTaskforce = missionNamespace getVariable format ["rimmy_dam_var_friendlyTaskforceList_%1", _mineSide];

if (count _returnToTaskforce >= 1) then {
	private _closest = [];
	private _closestdist = 100000;
	{
		if ((getPosATL leader _mineGroup) distance (_x select 0) < _closestdist) then {
		_closest = _x;
		_closestdist = (_x select 0) distance (getPosATL leader _mineGroup);
		};
	} forEach _returnToTaskforce;
	
	_RTBWP = _mineGroup addWaypoint [(_closest select 0), 50];
	_RTBWP setWaypointType "MOVE";
	_RTBWP setWaypointSpeed "FULL";
} else {
	_remainBearing = random 360;
	_remainDistance = (ceil random 400 max 150);
	_remainPos = _minefieldCentre getPos [_remainDistance,_remainBearing];
		
	_remainWP = _mineGroup addWaypoint [_remainPos, 25];
	_remainWP setWaypointType "MOVE";
	_remainWP setWaypointSpeed "NORMAL";
	_remainWP setWaypointBehaviour "STEALTH";
};

_minesLeft = _mineGroup call RCODAM_fnc_RCODAMcheckGroupMines;
deleteVehicle _objectName;

private _markerToRemove = "TEMPMinefieldExclusionAreaMarker" + str _mineSide + str ((_objective select 0) select 0);
private _exclusionZoneMaintenance = missionNamespace getVariable format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide];
private _markerToRemoveCleanUp = _exclusionZoneMaintenance find _markerToRemove;
_exclusionZoneMaintenance deleteAt _markerToRemoveCleanUp;
deleteMarker _markerToRemove;

private _markerName = "PLANTEDMinefieldExclusionAreaMarker" + str _mineSide + str (_minefieldCentre select 0);
_marker = createMarkerLocal [_markerName, _minefieldCentre];

_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerSizeLocal [350, 350];
_marker setMarkerAlphaLocal 0;
_marker setMarkerColorLocal "ColorYellow";

if (missionNamespace getVariable format ["rimmy_dam_var_debugPerSide_%1", _mineSide]) then {
	_marker setMarkerAlpha 0.5;

	_markerName = "DefenceObjectiveMarker" + str (_objective select 0);  
	deleteMarker _markerName;
	
	{
		deleteVehicle _x;
	} forEach _debugMarkersList;
};

_exclusionZoneMaintenance pushBack _marker;

missionNamespace setVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],_exclusionZoneMaintenance];

if (_minesLeft < _minimumMineCount) then {
_currentMineGroups = missionNamespace getVariable format ["rimmy_dam_var_mineLayingGroup_%1", _mineSide];
_currentMineGroupsCleanUp = _currentMineGroups find _mineGroup;
_currentMineGroups deleteAt _currentMineGroupsCleanUp;
missionNamespace setVariable [format ["rimmy_dam_var_mineLayingGroup_%1", _mineSide],_currentMineGroups];
_mineGroup setVariable ["rimmy_dam_groupvar_assignedToObjective",false];
} else {
_mineGroup setVariable ["rimmy_dam_groupvar_assignedToObjective",false];
};

private _listOfMines = missionNamespace getVariable format ["rimmy_dam_var_minefieldSimulationControl_%1", _simulationControl];

sleep 60;

{
waitUntil {sleep 1; ((getPos nearestObject [_x, "CAManBase"]) distance _x >= 5)};
_x enableSimulationGlobal true;
} forEach _listOfMines;

} else {

deleteVehicle _objectName;

private _markerToRemove = "TEMPMinefieldExclusionAreaMarker" + str _mineSide + str ((_objective select 0) select 0);
private _exclusionZoneMaintenance = missionNamespace getVariable format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide];
private _markerToRemoveCleanUp = _exclusionZoneMaintenance find _markerToRemove;
_exclusionZoneMaintenance deleteAt _markerToRemoveCleanUp;
deleteMarker _markerToRemove;

_markerName = "PLANTEDMinefieldExclusionAreaMarker" + str _mineSide + str (_minefieldCentre select 0);
_marker = createMarkerLocal [_markerName, _minefieldCentre];

_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerSizeLocal [350, 350];
_marker setMarkerAlphaLocal 0;
_marker setMarkerColorLocal "ColorYellow";

if (missionNamespace getVariable format ["rimmy_dam_var_debugPerSide_%1", _mineSide]) then {
	_marker setMarkerAlpha 0.5;

	_markerName = "DefenceObjectiveMarker" + str (_objective select 0);  
	deleteMarker _markerName;
	
	{
		deleteVehicle _x;
	} forEach _debugMarkersList;
};

_exclusionZoneMaintenance pushBack _marker;

missionNamespace setVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],_exclusionZoneMaintenance];

private _listOfMines = missionNamespace getVariable format ["rimmy_dam_var_minefieldSimulationControl_%1", _simulationControl];

sleep 60;

_allFriendlySides = _allFriendlySides - (missionNamespace getVariable format ["rimmy_dam_var_enemySidesOfMineLayer_%1", _mineSide]);
_allFriendlySides = [WEST,EAST,RESISTANCE,CIVILIAN];

{
waitUntil {sleep 1; ((getPos nearestObject [_x, "CAManBase"]) distance _x >= 5)};
_x enableSimulationGlobal true;
_mineToPass = _x;
{
_x revealMine _minePlaced;
{_x reveal _minePlaced} forEach units _x;
} forEach _allFriendlySides;
} forEach _listOfMines;

};
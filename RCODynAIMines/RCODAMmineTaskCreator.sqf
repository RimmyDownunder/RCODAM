params ["_mineSide","_mineUpdateTimer","_mineChance","_defenceChance","_interceptChance","_interdictChance","_roadChance","_runIfEmpty","_minimumMineCount","_groupDetector","_debugOption","_furthestTravel"];	

_friendlyAreaMarkers = [];
_enemyTaskforceObjectMarker = [];
_enemyAreaMarkers = [];

_taskforceList = [];
_friendlyTaskforceList = [];
_groupsToIntercept = [];

_DAMdefenceTestingMarkers = [];
_DAMdefenceAreaArrayToCheck = [];
_DAMdefenceObjectiveList = [];

_DAMinterceptObjectiveList = [];

_DAMinterdictTestingMarkers = [];
_DAMinterdictObjectiveList = [];

_DAMaddToExclusionZone = [];

_DAMdefenceDistanceToPlace = 0;
_DAMdefenceMinefieldPlacement = [];
_DAMdefenceMinefieldVehicle = 0;
_DAMdefenceTargetTaskforceLocation = [];
_DAMdefenceMinefieldTime = 0;
_DAMinterceptMinefieldPlacement = [];
_DAMinterceptVehicleStatus = false;
_DAMinterceptTargetGroupLocation = [];
_DAMinterceptMinefieldTime = 0;
_DAMinterdictMinefieldPlacement = [];
_enemyTaskforceVehicleStatus = 0;
_DAMinterdictTargetTaskforceLocation = [];
_DAMinterdictMinefieldTime = 0;

private _debugOption = _debugOption;
private _groupDetector = _groupDetector;
missionNamespace setVariable [format ["rimmy_dam_var_debugPerSide_%1", _mineSide],_debugOption];

private _objectiveMaintenance = [];
private _alreadyPlantedZonesToAdd = [];

_testerObjectiveAreaMarkers = [];

_mineChance = (_mineChance min 1);
_defenceChance = (_defenceChance min 1);
_interceptChance = (_interceptChance min 1);
_interdictChance = (_interdictChance min 1);
_roadChance = (_roadChance min 1);
_minimumMineCount = (_minimumMineCount max 4);

private _checkIfZonesExist = missionNamespace getVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],[]];
if (_checkIfZonesExist IsEqualTo []) then {
missionNamespace setVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],[]];
};

sleep 5;

{
if (format ["PLANTEDMinefieldExclusionAreaMarker%1",_mineSide] in _x) then {
_alreadyPlantedZonesToAdd pushBack _x;
};
} forEach allMapMarkers;

_checkIfZonesExist = _checkIfZonesExist + _alreadyPlantedZonesToAdd;
missionNamespace setVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],_checkIfZonesExist];

waitUntil {sleep 8; !(isNil "rimmy_dam_var_mineLayingGroup_WEST") && !(isNil "rimmy_dam_var_mineLayingGroup_EAST") && !(isNil "rimmy_dam_var_mineLayingGroup_GUER");};
waitUntil {sleep 8; ((count (missionNamespace getVariable [format ["rimmy_dam_var_mineLayingGroup_%1", _mineSide],0])) >= 1 || _runIfEmpty)};

while {(count (missionNamespace getVariable format ["rimmy_dam_var_mineLayingGroup_%1", _mineSide])) >= 1 || _runIfEmpty} do {

_taskforceList = missionNamespace getVariable [format ["rimmy_dam_var_taskforceList_%1", _mineSide],[]];
_friendlyTaskforceList = missionNamespace getVariable [format ["rimmy_dam_var_friendlyTaskforceList_%1", _mineSide],[]];
_groupsToIntercept = missionNamespace getVariable [format ["rimmy_dam_var_groupsToIntercept_%1", _mineSide],[]];

if (_groupDetector) then {
private _allGroupsWithPlayers = [];
{_allGroupsWithPlayers pushBackUnique group _x} forEach allPlayers;
{
if ((side _x) == _mineSide && !(_x in (missionNamespace getVariable format ["rimmy_dam_var_mineLayingGroup_%1", _mineSide])) && !(_x in _allGroupsWithPlayers)) then {
_totalMineCount = _x call RCODAM_fnc_RCODAMcheckGroupMines;
if (_totalMineCount >= _minimumMineCount) then {
call compile ("rimmy_dam_var_mineLayingGroup_" + str _mineSide + " pushBackUnique _x");
};
};	
} forEach allGroups;	
};

private _mineLayingGroupAdjustment = missionNamespace getVariable format ["rimmy_dam_var_mineLayingGroup_%1", _mineSide];
{
if (count units _x == 0) then {
	_mineLayingGroupAdjustmentCleanUp = _mineLayingGroupAdjustment find _x;
	_mineLayingGroupAdjustment deleteAt _mineLayingGroupAdjustmentCleanUp;
};
	_x deleteGroupWhenEmpty true;
} forEach (missionNamespace getVariable format ["rimmy_dam_var_mineLayingGroup_%1", _mineSide]);
missionNamespace setVariable [format ["rimmy_dam_var_mineLayingGroup_%1", _mineSide],_mineLayingGroupAdjustment];

{
if (isMultiplayer) then {
	if (((_x select 3) + 1800) <= serverTime) then {
		_DAMdefenceObjectiveListCleanUp = _DAMdefenceObjectiveList find _x;
		_DAMdefenceObjectiveList deleteAt _DAMdefenceObjectiveListCleanUp;
	};
} else {
	if (((_x select 3) + 1800) <= time) then {
		_DAMdefenceObjectiveListCleanUp = _DAMdefenceObjectiveList find _x;
		_DAMdefenceObjectiveList deleteAt _DAMdefenceObjectiveListCleanUp;
	};
};
} forEach _DAMdefenceObjectiveList;

{
if (isMultiplayer) then {
	if (((_x select 3) + 1200) <= serverTime) then {
		_DAMinterceptObjectiveListCleanUp = _DAMinterceptObjectiveList find _x;
		_DAMinterceptObjectiveList deleteAt _DAMinterceptObjectiveListCleanUp;
	};
} else {
	if (((_x select 3) + 1200) <= time) then {
		_DAMinterceptObjectiveListCleanUp = _DAMinterceptObjectiveList find _x;
		_DAMinterceptObjectiveList deleteAt _DAMinterceptObjectiveListCleanUp;
	};
};
} forEach _DAMinterceptObjectiveList;

{
if (isMultiplayer) then {
	if (((_x select 3) + 1200) <= serverTime) then {
		_DAMinterdictObjectiveListCleanUp = _DAMinterdictObjectiveList find _x;
		_DAMinterdictObjectiveList deleteAt _DAMinterdictObjectiveListCleanUp;
	};
} else {
	if (((_x select 3) + 1200) <= time) then {
		_DAMinterceptObjectiveListCleanUp = _DAMinterceptObjectiveList find _x;
		_DAMinterceptObjectiveList deleteAt _DAMinterceptObjectiveListCleanUp;
	};
};
} forEach _DAMinterdictObjectiveList;

{
	if (!((_x select 0) in (missionNamespace getVariable format ["rimmy_dam_var_mineLayingGroup_%1", _mineSide]))) then {
		private _markerToRemove = "TEMPMinefieldExclusionAreaMarker" + str _mineSide + str ((_x select 0) select 0);
		private _exclusionZoneMaintenance = missionNamespace getVariable format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide];
		private _markerToRemoveCleanUp = _exclusionZoneMaintenance find _markerToRemove;
		_exclusionZoneMaintenance deleteAt _markerToRemoveCleanUp;
		missionNamespace setVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],_exclusionZoneMaintenance];
		terminate (_x select 1);
	};
	if (isMultiplayer) then {
	if (((_x select 2) + 3600) <= serverTime) then {
		private _markerToRemove = "TEMPMinefieldExclusionAreaMarker" + str _mineSide + str ((_x select 0) select 0);
		private _exclusionZoneMaintenance = missionNamespace getVariable format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide];
		private _markerToRemoveCleanUp = _exclusionZoneMaintenance find _markerToRemove;
		_exclusionZoneMaintenance deleteAt _markerToRemoveCleanUp;
		missionNamespace setVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],_exclusionZoneMaintenance];
		terminate (_x select 1);
	};
	} else {
	if (((_x select 2) + 3600) <= time) then {
		private _markerToRemove = "TEMPMinefieldExclusionAreaMarker" + str _mineSide + str ((_x select 0) select 0);
		private _exclusionZoneMaintenance = missionNamespace getVariable format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide];
		private _markerToRemoveCleanUp = _exclusionZoneMaintenance find _markerToRemove;
		_exclusionZoneMaintenance deleteAt _markerToRemoveCleanUp;
		missionNamespace setVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],_exclusionZoneMaintenance];
		terminate (_x select 1);
	};
	};
} forEach _objectiveMaintenance;

{
	if (format ["PLANTEDMinefieldExclusionAreaMarker%1",_mineSide] in _x) then {
		private _minefieldZoneToCheck = _x;
		private _minesInZone = 0;
		{
			if (_x inArea _minefieldZoneToCheck) then {
				_minesInZone = _minesInZone + 1;
			};
		} forEach detectedMines _mineSide;
		if (_minesInZone <= 3) then {deleteMarker _minefieldZoneToCheck};
	};
} forEach allMapMarkers;

{deleteMarker _x} forEach _friendlyAreaMarkers;
_friendlyAreaMarkers = [];
{
	_markerName = "FriendlyTaskforceAreaMarker" + str _mineSide + str (_x select 0);
	_marker = createMarkerLocal [_markerName, (_x select 0)];
	
	_marker setMarkerShapeLocal "ELLIPSE";
	_marker setMarkerSizeLocal [800, 800];
	_marker setMarkerAlphaLocal 0;
	_marker setMarkerColorLocal "ColorBlue";
	
	if (_debugOption) then {
		_marker setMarkerAlpha 0.7;
	};
	
	_friendlyAreaMarkers pushBack _marker;
	
} forEach _friendlyTaskforceList;
	
{deleteVehicle _x;} forEach _enemyTaskforceObjectMarker;
_enemyTaskforceObjectMarker = [];
_objectIterator = 0;
{deleteMarker _x} forEach _enemyAreaMarkers;
_enemyAreaMarkers = [];
	
{
	_markerName = "EnemyTaskforceAreaMarker" + str _mineSide + str ((_x select 0) select 0);
	_marker = createMarkerLocal [_markerName, (_x select 0)];
	
	_marker setMarkerShapeLocal "ELLIPSE";
	_marker setMarkerSizeLocal [800, 800];
	_marker setMarkerAlphaLocal 0;
	_marker setMarkerColorLocal "ColorRed";
	
	if (_debugOption) then {
		_marker setMarkerAlpha 0.7;
	};
	
	_enemyAreaMarkers pushBack _marker;
	
	_objectName = createSimpleObject ["VR_GroundIcon_01_F", _x select 0];
	_objectName hideObjectGlobal true;
	
	_objectName setVariable ["rimmy_dam_var_objectVehicleTracking", (_x select 1), true];
	
	_enemyTaskforceObjectMarker pushBack _objectName;

} forEach _taskforceList;

// generate the tasks here

if ((count _enemyTaskforceObjectMarker) >= 1) then {
{ // generate defence

_friendlyTaskforceLocation = (_x select 0);
_DAMdefenceTestingMarkers = [];

	{
	_DAMdefenceDistanceToPlace = (getPosATL _x) distance _friendlyTaskforceLocation; 
	if (_DAMdefenceDistanceToPlace <= 5000 && _DAMdefenceDistanceToPlace >= 600) then {
	_DAMdefenceBearingToPlace = _x getRelDir _friendlyTaskforceLocation;
	
	_markerIterator = 0;
	for "_i" from 0 to _DAMdefenceDistanceToPlace step 100 do { 
	
	_nextMarker = (getPosATL _x) getPos [_i,_DAMdefenceBearingToPlace];
	
	_markerIterator = _markerIterator + 1;  
	_markerName = "DAMdefenceTestMarker" + str _markerIterator;  
	_marker = createMarkerLocal [_markerName, _nextMarker];  
	_DAMdefenceTestingMarkers pushBack _marker;
	
	_marker setMarkerColorLocal "ColorBlack";  
	_marker setMarkerTypeLocal "hd_dot";  
	_marker setMarkerAlphaLocal 0;
	
	if (_debugOption) then {
	_marker setMarkerAlpha 1;
	};
	sleep 0.001;
	};
	
	_DAMdefenceAreaArrayToCheck = _friendlyAreaMarkers - [("FriendlyTaskforceAreaMarker" + str _mineSide + str _friendlyTaskforceLocation)];
	_DAMdefenceConflictFound = 0;
	_DAMdefenceAreaScan = (count _DAMdefenceAreaArrayToCheck);
	
		{
		for "_i" from 0 to _DAMdefenceAreaScan do {
		if ((getMarkerPos _x) inArea (_DAMdefenceAreaArrayToCheck select _i)) exitWith {
		_DAMdefenceConflictFound = 1;
		};		
		sleep 0.05;
		};
		if (_DAMdefenceConflictFound == 1) exitWith {};	
		} forEach _DAMdefenceTestingMarkers;
		
	if (_DAMdefenceConflictFound == 0) then {
	
	//["SUCCESS! Make a defence objective.",_debugOption] call RCODAM_fnc_RCODAMdebugMessage;
	
	_DAMdefenceMinefieldDisplacement = random [300, 400, 600];
	_DAMdefenceBearingToObjective = _DAMdefenceBearingToPlace + 180;
	if (_DAMdefenceBearingToObjective > 360) then {_DAMdefenceBearingToObjective = _DAMdefenceBearingToObjective - 360;};
	_DAMdefenceMinefieldPlacement = _friendlyTaskforceLocation getPos [_DAMdefenceMinefieldDisplacement,_DAMdefenceBearingToObjective];
	
	_DAMexclusionAreaScan = (count (missionNamespace getVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],[]]));
		for "_i" from 0 to _DAMexclusionAreaScan do {
		if (_DAMdefenceMinefieldPlacement inArea ((missionNamespace getVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],[]]) select _i)) exitWith {
		_DAMdefenceConflictFound = 1;
		
		//["Creating objective failed: Already minefield objective there.",_debugOption] call RCODAM_fnc_RCODAMdebugMessage;
		
		};
		};
		
	_DAMcheckSafePos = [_DAMdefenceMinefieldPlacement, 0, 50, 0, 0, 0.5, 0, [(missionNamespace getVariable format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide])], [[0,0],[0,0]]] call RCODAM_fnc_RCODAMcheckSafeMineSpot;
	if (_DAMcheckSafePos isEqualTo [0,0]) then {
	_DAMdefenceConflictFound = 1;
	
	["Creating objective failed: Only water found at location or no safe loctation.",_debugOption] call RCODAM_fnc_RCODAMdebugMessage;
	
	};
	
	if (_DAMdefenceConflictFound == 0) then {
	private _DAMdefenceMinefieldTime = serverTime;
	if (isMultiplayer) then {_DAMdefenceMinefieldTime = serverTime} else {_DAMdefenceMinefieldTime = time};
	_DAMdefenceMinefieldVehicle = _x getVariable ["rimmy_dam_var_objectVehicleTracking", 0];
	_DAMdefenceTargetTaskforceLocation = (getPosATL _x);
	
	_DAMdefenceObjectiveList pushBack [_DAMdefenceMinefieldPlacement,_DAMdefenceMinefieldVehicle,_DAMdefenceTargetTaskforceLocation,_DAMdefenceMinefieldTime];
	
	// Minefield Exclusion Zone
	
	_markerName = "TEMPMinefieldExclusionAreaMarker" + str _mineSide + str (_DAMdefenceMinefieldPlacement select 0);
	_marker = createMarkerLocal [_markerName, _DAMdefenceMinefieldPlacement];
	
	_marker setMarkerShapeLocal "ELLIPSE";
	_marker setMarkerSizeLocal [350, 350];
	_marker setMarkerAlphaLocal 0;
	_marker setMarkerColorLocal "ColorYellow";
	
	if (_debugOption) then {
	_marker setMarkerAlpha 0.5;
	};
	
	_DAMaddToExclusionZone = missionNamespace getVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],[]];
	_DAMaddToExclusionZone pushBack _marker;
	missionNamespace setVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],_DAMaddToExclusionZone];
	
	if (_debugOption) then {
	_markerName = "DefenceObjectiveMarker" + str _DAMdefenceMinefieldPlacement;  
	_marker = createMarkerLocal [_markerName, _DAMdefenceMinefieldPlacement]; 
	_marker setMarkerColorLocal "ColorBlack";  
	_marker setMarkerTypeLocal "hd_dot"; 
	_marker setMarkerText "Defence Objective";	
	_testerObjectiveAreaMarkers pushBack _marker;
	};
	
	};	
	};
	
	{deleteMarker _x} forEach _DAMdefenceTestingMarkers;
	};
	} forEach _enemyTaskforceObjectMarker;

} forEach _friendlyTaskforceList;
};

{ // generate intercept

_DAMinterceptMidpoint = ((_x select 1) distance (_x select 2))/2;
_DAMinterceptBearingObject = createSimpleObject ["VR_GroundIcon_01_F", (_x select 2)];
_DAMinterceptBearingObject hideObjectGlobal true;
_DAMinterceptBearing = _DAMinterceptBearingObject getRelDir (_x select 1);
_DAMinterceptMinefieldPlacement = (_x select 2) getPos [_DAMinterceptMidpoint,_DAMinterceptBearing];
_DAMinterceptConflictFound = 0;

_DAMexclusionAreaScan = (count (missionNamespace getVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],[]]));
	for "_i" from 0 to _DAMexclusionAreaScan do {
	if (_DAMinterceptMinefieldPlacement inArea ((missionNamespace getVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],[]]) select _i)) exitWith {
	_DAMinterceptConflictFound = 1;
	
	["FAILURE! (Intercept) Already minefield objective there.",_debugOption] call RCODAM_fnc_RCODAMdebugMessage;
	
	};
	};
		
_DAMcheckSafePos = [_DAMinterceptMinefieldPlacement, 0, 100, 0, 0, 0.5, 0, [(missionNamespace getVariable format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide])], [[0,0],[0,0]]] call RCODAM_fnc_RCODAMcheckSafeMineSpot;

	if (_DAMcheckSafePos isEqualTo [0,0]) then {
	_DAMinterceptConflictFound = 1;
	
	["FAILURE! (Intercept) Only water found at location or too steep.",_debugOption] call RCODAM_fnc_RCODAMdebugMessage;
	
	};
	
if (_DAMinterceptConflictFound == 0) then {
["SUCCESS! Create intercept objective.",_debugOption] call RCODAM_fnc_RCODAMdebugMessage;
private _DAMinterceptMinefieldTime = serverTime;
if (isMultiplayer) then {_DAMinterceptMinefieldTime = serverTime} else {_DAMinterceptMinefieldTime = time};
_DAMinterceptVehicleStatus = (_x select 4);
_DAMinterceptTargetGroupLocation = (_x select 2);

_DAMinterceptObjectiveList pushBack [_DAMinterceptMinefieldPlacement,_DAMinterceptVehicleStatus,_DAMinterceptTargetGroupLocation,_DAMinterceptMinefieldTime];

// Minefield Exclusion Zone
	
_markerName = "TEMPMinefieldExclusionAreaMarker" + str _mineSide + str (_DAMinterceptMinefieldPlacement select 0);
_marker = createMarkerLocal [_markerName, _DAMinterceptMinefieldPlacement];

_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerSizeLocal [350, 350];
_marker setMarkerAlphaLocal 0;
_marker setMarkerColorLocal "ColorYellow";

if (_debugOption) then {
_marker setMarkerAlpha 0.5;
};

_DAMaddToExclusionZone = missionNamespace getVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],[]];
_DAMaddToExclusionZone pushBack _marker;
missionNamespace setVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],_DAMaddToExclusionZone];

if (_debugOption) then {
_markerName = "InterceptObjectiveMarker" + str _DAMinterceptMinefieldPlacement;  
_marker = createMarkerLocal [_markerName, _DAMinterceptMinefieldPlacement]; 
_marker setMarkerColorLocal "ColorBlue";  
_marker setMarkerTypeLocal "hd_dot"; 
_marker setMarkerText "Intercept Objective";	
_testerObjectiveAreaMarkers pushBack _marker;
};

};
} forEach _groupsToIntercept;

if ((count _enemyTaskforceObjectMarker) >= 2) then {
{ // generate interdict
_enemyTaskforceCheckingLocation = (_x select 0);
_enemyTaskforceVehicleStatus = (_x select 1);
_DAMinterdictTestingMarkers = [];
	{
	
	_DAMinterdictDistanceToPlace = (getPosATL _x) distance _enemyTaskforceCheckingLocation; 
	if (_DAMinterdictDistanceToPlace <= 5000 && _DAMinterdictDistanceToPlace >= 1000) then {
	_DAMinterdictBearingToPlace = _x getRelDir _enemyTaskforceCheckingLocation;
	
	_markerIterator = 0;
	for "_i" from 0 to _DAMinterdictDistanceToPlace step 100 do { 
	
	_nextMarker = (getPosATL _x) getPos [_i,_DAMinterdictBearingToPlace];
	
	_markerIterator = _markerIterator + 1;  
	_markerName = "DAMinterdictTestMarker" + str _markerIterator;  
	_marker = createMarkerLocal [_markerName, _nextMarker];  
	_DAMinterdictTestingMarkers pushBack _marker;
	
	_marker setMarkerColorLocal "ColorBlack";  
	_marker setMarkerTypeLocal "hd_dot";  
	_marker setMarkerAlphaLocal 0;
	
	if (_debugOption) then {
	_marker setMarkerAlpha 1;
	};
	
	sleep 0.001;
	};
	
	_DAMinterdictAreaArrayToCheck = _friendlyAreaMarkers + (_enemyAreaMarkers - ([("EnemyTaskforceAreaMarker" + str _mineSide + str (_enemyTaskforceCheckingLocation select 0))] + [("EnemyTaskforceAreaMarker" + str _mineSide + str ((getPosATL _x) select 0))]));
	_DAMinterdictConflictFound = 0;
	_DAMinterdictAreaScan = (count _DAMinterdictAreaArrayToCheck);
	
		{
		for "_i" from 0 to _DAMinterdictAreaScan do {
		if ((getMarkerPos _x) inArea (_DAMinterdictAreaArrayToCheck select _i)) exitWith {
		_DAMinterdictConflictFound = 1;
		};		
		sleep 0.05;
		};
		if (_DAMinterdictConflictFound == 1) exitWith {};	
		} forEach _DAMinterdictTestingMarkers;
		
	if (_DAMinterdictConflictFound == 0) then {
	
	//["SUCCESS! Make an interdict objective.",_debugOption] call RCODAM_fnc_RCODAMdebugMessage;
	
	_DAMinterdictMidpoint = ((getPosATL _x) distance _enemyTaskforceCheckingLocation)/2;
	_DAMinterdictBearing = _x getRelDir _enemyTaskforceCheckingLocation;
	_DAMinterdictMinefieldPlacement = (getPosATL _x) getPos [_DAMinterdictMidpoint,_DAMinterdictBearing];
	
	_DAMexclusionAreaScan = (count (missionNamespace getVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],[]]));
	for "_i" from 0 to _DAMexclusionAreaScan do {
	if (_DAMinterdictMinefieldPlacement inArea ((missionNamespace getVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],[]]) select _i)) exitWith {
	_DAMinterdictConflictFound = 1;
	
	//["Creating objective failed: Already minefield objective there.",_debugOption] call RCODAM_fnc_RCODAMdebugMessage;
	
	};
	};
		
	_DAMcheckSafePos = [_DAMinterdictMinefieldPlacement, 0, 50, 0, 0, 0.5, 0, [(missionNamespace getVariable format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide])], [[0,0],[0,0]]] call RCODAM_fnc_RCODAMcheckSafeMineSpot;
	if (_DAMcheckSafePos isEqualTo [0,0]) then {
	_DAMinterdictConflictFound = 1;
	
	["Creating objective failed: Only water found at location or no safe loctation.",_debugOption] call RCODAM_fnc_RCODAMdebugMessage;
	
	};
	
	if (_DAMinterdictConflictFound == 0) then {
	private _DAMinterdictMinefieldTime = serverTime;
	if (isMultiplayer) then {_DAMinterdictMinefieldTime = serverTime} else {_DAMinterdictMinefieldTime = time};
	_DAMinterdictTargetTaskforceLocation = (getPosATL _x);
	
	_DAMinterdictObjectiveList pushBack [_DAMinterdictMinefieldPlacement,_enemyTaskforceVehicleStatus,_DAMinterdictTargetTaskforceLocation,_DAMinterdictMinefieldTime];
	
	// Minefield Exclusion Zone
	
	_markerName = "TEMPMinefieldExclusionAreaMarker" + str _mineSide + str (_DAMinterdictMinefieldPlacement select 0);
	_marker = createMarkerLocal [_markerName, _DAMinterdictMinefieldPlacement];

	_marker setMarkerShapeLocal "ELLIPSE";
	_marker setMarkerSizeLocal [350, 350];
	_marker setMarkerAlphaLocal 0;
	_marker setMarkerColorLocal "ColorYellow";
	
	if (_debugOption) then {
	_marker setMarkerAlpha 0.5;
	};

	_DAMaddToExclusionZone = missionNamespace getVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],[]];
	_DAMaddToExclusionZone pushBack _marker;
	missionNamespace setVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _mineSide],_DAMaddToExclusionZone];
	
	if (_debugOption) then {
	_markerName = "InterdictObjectiveMarker" + str _DAMinterdictMinefieldPlacement;  
	_marker = createMarkerLocal [_markerName, _DAMinterdictMinefieldPlacement]; 
	_marker setMarkerColorLocal "ColorGreen";  
	_marker setMarkerTypeLocal "hd_dot"; 
	_marker setMarkerText "Interdict Objective";	
	_testerObjectiveAreaMarkers pushBack _marker;
	};
	
	};	
	};
	
	{deleteMarker _x} forEach _DAMinterdictTestingMarkers;
	};
	} forEach _enemyTaskforceObjectMarker;
} forEach _taskforceList;
};



{
_x call RCODAM_fnc_RCODAMcheckGroupMines;
private _objectivePicked = "failed";

if (!(_x getVariable ["rimmy_dam_groupvar_assignedToObjective",false])) then {
if ((random 1) < _mineChance) then {
if (((count _DAMdefenceObjectiveList) >= 1 && (count _DAMinterceptObjectiveList) >= 1 && (count _DAMinterdictObjectiveList) >= 1) && (_x getVariable ["rimmy_dam_groupvar_willTakeAnyTask",true])) then {
	_objectivePicked = ["defence","intercept","interdict"] selectRandomWeighted [_defenceChance,_interceptChance,_interdictChance];
} else {
if ((count _DAMdefenceObjectiveList) == 0 && (count _DAMinterceptObjectiveList) == 0 && (count _DAMinterdictObjectiveList) == 0) then {
	_objectivePicked = "failed";
} else {
if ((count _DAMdefenceObjectiveList) >= 1 && (count _DAMinterceptObjectiveList) >= 1 && (count _DAMinterdictObjectiveList) == 0 && ((_x getVariable ["rimmy_dam_groupvar_willTakeAnyTask",true]) || ((_x getVariable ["rimmy_dam_groupvar_willTakeDefence",false]) && (_x getVariable ["rimmy_dam_groupvar_willTakeIntercept",false])))) then {
	_objectivePicked = ["defence","intercept"] selectRandomWeighted [_defenceChance,_interceptChance];
};
if ((count _DAMdefenceObjectiveList) >= 1 && (count _DAMinterceptObjectiveList) == 0 && (count _DAMinterdictObjectiveList) >= 1 && ((_x getVariable ["rimmy_dam_groupvar_willTakeAnyTask",true]) || ((_x getVariable ["rimmy_dam_groupvar_willTakeDefence",false]) && (_x getVariable ["rimmy_dam_groupvar_willTakeInterdict",false])))) then {
	_objectivePicked = ["defence","interdict"] selectRandomWeighted [_defenceChance,_interdictChance];
};
if ((count _DAMdefenceObjectiveList) == 0 && (count _DAMinterceptObjectiveList) >= 1 && (count _DAMinterdictObjectiveList )>= 1 && ((_x getVariable ["rimmy_dam_groupvar_willTakeAnyTask",true]) || ((_x getVariable ["rimmy_dam_groupvar_willTakeIntercept",false]) && (_x getVariable ["rimmy_dam_groupvar_willTakeInterdict",false])))) then {
	_objectivePicked = ["intercept","interdict"] selectRandomWeighted [_interceptChance,_interdictChance];
};
if ((count _DAMdefenceObjectiveList) >= 1 && (count _DAMinterceptObjectiveList) == 0 && (count _DAMinterdictObjectiveList) == 0 && ((_x getVariable ["rimmy_dam_groupvar_willTakeAnyTask",true]) || (_x getVariable ["rimmy_dam_groupvar_willTakeDefence",false]))) then {
	_objectivePicked = "defence";
};
if ((count _DAMdefenceObjectiveList) == 0 && (count _DAMinterceptObjectiveList) >= 1 && (count _DAMinterdictObjectiveList) == 0 && ((_x getVariable ["rimmy_dam_groupvar_willTakeAnyTask",true]) || (_x getVariable ["rimmy_dam_groupvar_willTakeIntercept",false]))) then {
	_objectivePicked = "intercept";
};
if ((count _DAMdefenceObjectiveList) == 0 && (count _DAMinterceptObjectiveList) == 0 && (count _DAMinterdictObjectiveList) >= 1 && ((_x getVariable ["rimmy_dam_groupvar_willTakeAnyTask",true]) || (_x getVariable ["rimmy_dam_groupvar_willTakeInterdict",false]))) then {
	_objectivePicked = "interdict";
};
};
};

switch (_objectivePicked) do
{
	case "defence": {
		["Starting defence objective.",_debugOption] call RCODAM_fnc_RCODAMdebugMessage;
		private _defenceObjectiveSorter = [];
		if (_x getVariable ["rimmy_dam_var_groupATMineCount",0] > 0) then {
		_defenceObjectiveSorter = _DAMdefenceObjectiveList;
		} else {
		if (_x getVariable ["rimmy_dam_var_groupATMineCount",0] == _x getVariable ["rimmy_dam_var_groupTotalMineCount",0]) then {
		{
		if (_x select 1 > 0) then {
		_defenceObjectiveSorter pushBack _x;
		};
		} forEach _DAMdefenceObjectiveList;	
		} else {
		{
		if (_x select 1 == 0) then {
		_defenceObjectiveSorter pushBack _x;
		};
		} forEach _DAMdefenceObjectiveList;
		};
		};
		
		if (count _defenceObjectiveSorter > 0) then {
		_objectiveToPass = [(getPosATL leader _x),_defenceObjectiveSorter] call RCODAM_fnc_RCODAMcheckNearestObjective;
		if ((getPosATL leader _x) distance (_objectiveToPass select 0) < _furthestTravel) then {
		_objectiveToPassCleanUp = _DAMdefenceObjectiveList find _objectiveToPass;
		_DAMdefenceObjectiveList deleteAt _objectiveToPassCleanUp;
		_x setVariable ["rimmy_dam_groupvar_assignedToObjective",true];
		_objectiveRunning = [_x,_objectiveToPass,_roadChance,_mineSide,_minimumMineCount] spawn RCODAM_fnc_RCODAMdefenceObjective;
		private _objectiveStartTime = serverTime;
		if (isMultiplayer) then {_objectiveStartTime = serverTime} else {_objectiveStartTime = time};
		_objectiveMaintenance pushBack [_x,_objectiveRunning,_objectiveStartTime];
		};
		};
	};
	
	case "intercept": {
		["Starting intercept objective.",_debugOption] call RCODAM_fnc_RCODAMdebugMessage;
		private _interceptObjectiveSorter = [];
		if (_x getVariable ["rimmy_dam_var_groupATMineCount",0] > 0) then {
		_interceptObjectiveSorter = _DAMinterceptObjectiveList;
		} else {
		if (_x getVariable ["rimmy_dam_var_groupATMineCount",0] == _x getVariable ["rimmy_dam_var_groupTotalMineCount",0]) then {
		{
		if (_x select 1 > 0) then {
		_interceptObjectiveSorter pushBack _x;
		};
		} forEach _DAMinterceptObjectiveList;	
		} else {
		{
		if (_x select 1 == 0) then {
		_interceptObjectiveSorter pushBack _x;
		};
		} forEach _DAMinterceptObjectiveList;
		};
		};
		
		if (count _interceptObjectiveSorter > 0) then {
		_objectiveToPass = [(getPosATL leader _x),_interceptObjectiveSorter] call RCODAM_fnc_RCODAMcheckNearestObjective;
		if ((getPosATL leader _x) distance (_objectiveToPass select 0) < _furthestTravel) then {
		_objectiveToPassCleanUp = _DAMinterceptObjectiveList find _objectiveToPass;
		_DAMinterceptObjectiveList deleteAt _objectiveToPassCleanUp;
		_x setVariable ["rimmy_dam_groupvar_assignedToObjective",true];
		_objectiveRunning = [_x,_objectiveToPass,_roadChance,_mineSide,_minimumMineCount] spawn RCODAM_fnc_RCODAMdefenceObjective;
		private _objectiveStartTime = serverTime;
		if (isMultiplayer) then {_objectiveStartTime = serverTime} else {_objectiveStartTime = time};
		_objectiveMaintenance pushBack [_x,_objectiveRunning,_objectiveStartTime];
		};
		};
	};
	case "interdict": {
		["Starting interdict objective.",_debugOption] call RCODAM_fnc_RCODAMdebugMessage;
		private _interdictObjectiveSorter = [];
		if (_x getVariable ["rimmy_dam_var_groupATMineCount",0] > 0) then {
		_interdictObjectiveSorter = _DAMinterdictObjectiveList;
		} else {
		if (_x getVariable ["rimmy_dam_var_groupATMineCount",0] == _x getVariable ["rimmy_dam_var_groupTotalMineCount",0]) then {
		{
		if (_x select 1 > 0) then {
		_interdictObjectiveSorter pushBack _x;
		};
		} forEach _DAMinterdictObjectiveList;	
		} else {
		{
		if (_x select 1 == 0) then {
		_interdictObjectiveSorter pushBack _x;
		};
		} forEach _DAMinterdictObjectiveList;
		};
		};
		
		if (count _interdictObjectiveSorter > 0) then {
		_objectiveToPass = [(getPosATL leader _x),_interdictObjectiveSorter] call RCODAM_fnc_RCODAMcheckNearestObjective;
		if ((getPosATL leader _x) distance (_objectiveToPass select 0) < _furthestTravel) then {
		_objectiveToPassCleanUp = _DAMinterdictObjectiveList find _objectiveToPass;
		_DAMinterdictObjectiveList deleteAt _objectiveToPassCleanUp;
		_x setVariable ["rimmy_dam_groupvar_assignedToObjective",true];
		_objectiveRunning = [_x,_objectiveToPass,_roadChance,_mineSide,_minimumMineCount] spawn RCODAM_fnc_RCODAMdefenceObjective;
		private _objectiveStartTime = serverTime;
		if (isMultiplayer) then {_objectiveStartTime = serverTime} else {_objectiveStartTime = time};
		_objectiveMaintenance pushBack [_x,_objectiveRunning,_objectiveStartTime];
		};
		};
	};
	
	case "failed": {};
	default {};
};	
};
};
if (isClass(configFile >> "CfgPatches" >> "lambs_main")) then {
_x setVariable ["lambs_danger_disableGroupAI", true];
};
} forEach (missionNamespace getVariable format ["rimmy_dam_var_mineLayingGroup_%1", _mineSide]);
sleep _mineUpdateTimer;
};
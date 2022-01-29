params ["_mineSide","_groupLimit","_groupSizeLimit","_friendlyGroupLimit","_friendlyGroupSizeLimit","_updateTimer","_forgetTimer","_needTaskForceforIntercept","_runIfEmpty","_debugOption"];	

_debugMarkers = [];
_trackingEnemyGroups = createHashMap;
_enemySides = [];	
_groupsToIntercept = [];
_trackGroupActual = grpNull;
rimmy_dam_var_mineLayingGroup_WEST = [];
rimmy_dam_var_mineLayingGroup_EAST = [];
rimmy_dam_var_mineLayingGroup_GUER = [];
publicVariable "rimmy_dam_var_mineLayingGroup_WEST";
publicVariable "rimmy_dam_var_mineLayingGroup_EAST";
publicVariable "rimmy_dam_var_mineLayingGroup_GUER";

if ([_mineSide, west] call BIS_fnc_sideIsEnemy) then {
_enemySides pushBack west;	
};	
if ([_mineSide, east] call BIS_fnc_sideIsEnemy) then {
_enemySides pushBack east;	
};	
if ([_mineSide, resistance] call BIS_fnc_sideIsEnemy) then {
_enemySides pushBack resistance;
};	

missionNamespace setVariable [format ["rimmy_dam_var_enemySidesOfMineLayer_%1", _mineSide],_enemySides];

_mineLayingGroups = missionNamespace getVariable format ["rimmy_dam_var_mineLayingGroup_%1", _mineSide];

waitUntil {sleep 10; ((count (missionNamespace getVariable format ["rimmy_dam_var_mineLayingGroup_%1", _mineSide])) >= 1 || _runIfEmpty)};

while {(count (missionNamespace getVariable format ["rimmy_dam_var_mineLayingGroup_%1", _mineSide])) >= 1 || _runIfEmpty} do {

_recordedEnemyGroups = [];	
_ignoreSmallGroups = [];
_taskforceList = [];
_friendlyGroups = [];
_friendlyTaskforceList = [];
_trackGroupVehicle = false;

	{
	if (_y select 3 || (!(_needTaskForceforIntercept))) then {
	_groupNameComparePass = _x;
	missionNamespace setVariable [format ["rimmy_dam_var_currentInterceptingGroup_%1", _mineSide],(_y select 4)];
	_locationComparePass = (_y select 0);
		{
		if (_mineSide knowsAbout _x > 1 || (_mineSide knowsAbout (vehicle _x) > 1)) exitWith {
		_groupToInterceptCheckPos = getPosATL _x;
		_groupToInterceptCheckDistance = _groupToInterceptCheckPos distance _locationComparePass;
		if (_groupToInterceptCheckDistance >= 1200) exitWith {
		private _groupToInterceptTime = serverTime;
		if (isMultiplayer) then {_groupToInterceptTime = serverTime} else {_groupToInterceptTime = time};		
		if ((vehicle _x) != _x) then {_trackGroupVehicle = true;} else {_trackGroupVehicle = false;};	
		_groupsToIntercept pushBack [_groupNameComparePass,_locationComparePass,_groupToInterceptCheckPos,_groupToInterceptTime,_trackGroupVehicle];
		};
		};
		
		} forEach (units (missionNamespace getVariable format ["rimmy_dam_var_currentInterceptingGroup_%1", _mineSide]));
	
	};
	
	if (isMultiplayer) then {
		if (((_y select 2) + _forgetTimer) <= serverTime) then {	
		_trackingEnemyGroups deleteAt _x;};
	} else {
		if (((_y select 2) + _forgetTimer) <= time) then {	
		_trackingEnemyGroups deleteAt _x;};
	};
	
	} forEach _trackingEnemyGroups;
	
	{
	if (isMultiplayer) then {
	if (((_x select 3) + _forgetTimer) <= serverTime) then {	
	_groupsToInterceptCleanUp = _groupsToIntercept find _x;
	_groupsToIntercept deleteAt _groupsToInterceptCleanUp;
	};
	} else {
	if (((_x select 3) + _forgetTimer) <= time) then {	
	_groupsToInterceptCleanUp = _groupsToIntercept find _x;
	_groupsToIntercept deleteAt _groupsToInterceptCleanUp;
	};
	};
	} forEach _groupsToIntercept;
		
	{
	_y set [3,false];	
	_trackingEnemyGroups set [_x,_y];
	} forEach _trackingEnemyGroups;	
	
	{	
		{	
			if (!((group _x) in _recordedEnemyGroups) || (group _x) in _ignoreSmallGroups) then {
			if ((count units group _x) >= _groupSizeLimit) then {
			// Checker if they're legit		
			if (_mineSide knowsAbout _x > 1 || (_mineSide knowsAbout (vehicle _x) > 1)) then {
			_unitToTrack = _x;	
			_unitNearCounter = 0;	
			_groupSizeLimitConfirmed = false;
			_trackVehicle = false;
				{
					
					if (_unitToTrack distance _x < 100) then {	
						_unitNearCounter = _unitNearCounter + 1;
					};	
						
					if ((_unitNearCounter >= _groupSizeLimit) || (vehicle _x != _x)) exitWith {	
						_groupSizeLimitConfirmed = true;	
						if (vehicle _x != _x) then {_trackVehicle = true;};
					};	
				} forEach units (group _x);	
				
			if (_groupSizeLimitConfirmed) then {	
			// Mainline Info	
				
			_recordedEnemyGroups pushBackUnique (group _x);	
				
			_trackGroup = str (group _x);	
			_trackLocation = (getPosATL _x);	
			if ((vehicle _x) != _x) then {_trackVehicle = true};
			private _trackTime = serverTime;
			if (isMultiplayer) then {_trackTime = serverTime} else {_trackTime = time};			
			_inTaskforce = false;	
			_trackGroupActual = (group _x);
			_trackingEnemyGroups set [_trackGroup,[_trackLocation,_trackVehicle,_trackTime,_inTaskforce,_trackGroupActual]]; 	
			};	
			};	
			};	
			} else {_ignoreSmallGroups pushBack (group _x)};
			sleep 0.02;	
		} forEach units _x;	
	} forEach _enemySides;	
	
	{	
	if (!(_y select 3)) then {
	_groupsToTaskforce = [];
	_groupsToTaskforce pushBack _x;
	_groupsNearLocation = 1;	
	_locationToCheck = (_y select 0);	
		
		{	
		if (!(_locationToCheck isEqualTo (_y select 0))) then {	
			if (_locationToCheck distance (_y select 0) < 1200) then {	
				
			_groupsNearLocation = _groupsNearLocation + 1;	
			_groupsToTaskforce pushBack _x;	
				
			};	
		};		
		} forEach _trackingEnemyGroups;	
			
	if (_groupsNearLocation >= _groupLimit) then {
	_taskforceGroupNames = [];
	_taskforceVehicles = 0;	
		{
		_updateTaskforce = _trackingEnemyGroups get _x;	
		_updateTaskforce set [3,true];	
		_trackingEnemyGroups set [_x,[(_updateTaskforce select 0),(_updateTaskforce select 1),(_updateTaskforce select 2),(_updateTaskforce select 3)]]; 	
		_taskforceGroupNames pushBack _x;	
		if (_updateTaskforce select 1) then {_taskforceVehicles = _taskforceVehicles + 1;};			
		} forEach _groupsToTaskforce;	
			
		// create task force	
		_taskforceLocation = (_y select 0);			
		_taskforceList pushBackUnique [_taskforceLocation,_taskforceVehicles,_taskforceGroupNames];	
			
	};		
	};		
	} forEach _trackingEnemyGroups;	
		
		//FRIENDLY TASK FORCES
		
	{	
	if ((side _x) == _mineSide && (count units _x) >= _friendlyGroupSizeLimit) then {
	_friendlyGroupLeader = leader _x;	
	_friendlyGroups pushBack [_friendlyGroupLeader,false];		
	};	
	} forEach allGroups;	
		
	{	
	if (!(_x select 1)) then {
	_friendlyGroupsToTaskforce = [];
	_friendlyTaskforceGroupLeaders = [];
	_groupsNearLocation = 0;	
	_locationToCheck = (getPosATL (_x select 0));	
		
		{	
		if (!(_locationToCheck isEqualTo (getPosATL (_x select 0)))) then {	
			if (_locationToCheck distance (getPosATL (_x select 0)) < 1000) then {	
				
			_groupsNearLocation = _groupsNearLocation + 1;	
			_friendlyGroupsToTaskforce pushBackUnique _x;	
				
			};	
		};		
		} forEach _friendlyGroups;	
			
	if (_groupsNearLocation >= _friendlyGroupLimit) then {
		{	
		_x set [1,true];	
		_friendlyTaskforceGroupLeaders pushBackUnique (_x select 0);
		} forEach _friendlyGroupsToTaskforce;	
			
		// create task force	
		_taskforceLocation = (getPosATL (_x select 0));			
		_friendlyTaskforceList pushBackUnique [_taskforceLocation,_friendlyTaskforceGroupLeaders];	
			
	};		
	};		
	} forEach _friendlyGroups;	

if (_debugOption) then {
	{deleteMarker _x} forEach _debugMarkers;
	_debugMarkers = [];
	
	_markerIterator = 0;
	{
		_markerIterator = _markerIterator + 1;
		_markerName = "EnemyTaskforceTestMarker" + str _mineSide + str _markerIterator;
		_marker = createMarkerLocal [_markerName, (_x select 0)];
		
		_marker setMarkerColorLocal "ColorRed";
		_marker setMarkerType "o_unknown";
		
		_debugMarkers pushBack _marker;
	} forEach _taskforceList;

	_markerIterator = 0;
	{
		_markerIterator = _markerIterator + 1;
		_markerName = "FriendlyTaskforceTestMarker" + str _mineSide + str _markerIterator;
		_marker = createMarkerLocal [_markerName, (_x select 0)];
		
		_marker setMarkerColorLocal "ColorBlue";
		_marker setMarkerType "b_unknown";
		
		_debugMarkers pushBack _marker;
	} forEach _friendlyTaskforceList;
};

missionNamespace setVariable [format ["rimmy_dam_var_taskforceList_%1", _mineSide],_taskforceList];
missionNamespace setVariable [format ["rimmy_dam_var_friendlyTaskforceList_%1", _mineSide],_friendlyTaskforceList];
missionNamespace setVariable [format ["rimmy_dam_var_groupsToIntercept_%1", _mineSide],_groupsToIntercept];

sleep _updateTimer;	

};
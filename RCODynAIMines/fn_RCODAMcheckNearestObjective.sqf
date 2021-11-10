params ["_posToCheck","_objectiveList","_groupToCheck","_vehicleStatus"];	

private _objectiveList = _objectiveList;
private _posToCheck = _posToCheck;

private _closest = [];
private _closestdist = 100000;
{
	if (_posToCheck distance (_x select 0) < _closestdist) then {
		_closest = _x;
		_closestdist = (_x select 0) distance _posToCheck;
	};
} forEach _objectiveList;

_closest
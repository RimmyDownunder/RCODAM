_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {deleteVehicle _module};

private _side = _module getVariable "RCODAM_side";
private _radiusX = _module getVariable "RCODAM_radiusX";
private _radiusY = _module getVariable "RCODAM_radiusY";
private _debug = _module getVariable "RCODAM_debug";

private _centreOfZone = getPos _module;

_markerName = "PERMMinefieldExclusionAreaMarker" + _side + str (_centreOfZone select 0);
_marker = createMarkerLocal [_markerName, _centreOfZone];

_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerSizeLocal [_radiusX, _radiusY];
_marker setMarkerColorLocal "ColorYellow";
_marker setMarkerAlpha 0;

if (_debug) then {
	_marker setMarkerAlpha 0.5;
};

_DAMaddToExclusionZone = missionNamespace getVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _side],[]];
_DAMaddToExclusionZone pushBack _marker;
missionNamespace setVariable [format ["rimmy_dam_var_minefieldExclusionZone_%1", _side],_DAMaddToExclusionZone];
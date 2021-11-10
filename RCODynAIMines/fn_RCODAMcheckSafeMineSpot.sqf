

scopeName "main";

params [
["_checkPos",[]], 
["_minDistance",0], 
["_maxDistance",-1], 
["_objectProximity",0],
["_waterMode",0], 
["_maxGradient",0], 
["_shoreMode",0], 
["_posBlacklist",[]],
["_defaultPos",[]]
];


if (_checkPos isEqualType objNull) then {_checkPos = getPos _checkPos};





if !([_checkPos,_minDistance,_maxDistance,_objectProximity,_waterMode,_maxGradient,_shoreMode,_posBlacklist,_defaultPos] isEqualTypeParams [[],0,0,0,0,0,0,[],[]]) exitWith {[[_checkPos,_minDistance,_maxDistance,_objectProximity,_waterMode,_maxGradient,_shoreMode,_posBlacklist,_defaultPos], "isEqualTypeParams", [[],0,0,0,0,0,0,[],[]]] call (missionNamespace getVariable "BIS_fnc_errorParamsType")};

private _defaultMaxDistance = worldSize / 2;
private _defaultCenterPos = [_defaultMaxDistance, _defaultMaxDistance, 0];

private _fnc_defaultPos = 
{
_defaultPos = _defaultPos param [parseNumber _this, []];
if !(_defaultPos isEqualTo []) exitWith {_defaultPos};

_defaultPos = getArray (configFile >> "CfgWorlds" >> worldName >> "Armory" >> ["positionStart", "positionStartWater"] select _this);
if !(_defaultPos isEqualTo []) exitWith {_defaultPos};

_defaultPos = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
if !(_defaultPos isEqualTo []) exitWith {_defaultPos};

_defaultCenterPos
};

if (_checkPos isEqualTo []) then
{
_checkPos = getArray (configFile >> "CfgWorlds" >> worldName >> "safePositionAnchor");
if (_checkPos isEqualTo []) then {_checkPos = _defaultCenterPos};
};

if (_maxDistance < 0) then 
{
_maxDistance = getNumber (configFile >> "CfgWorlds" >> worldName >> "safePositionRadius");
if (_maxDistance <= 0) then {_maxDistance = _defaultMaxDistance};
};

private _checkProximity = _objectProximity > 0;
private _checkBlacklist = !(_posBlacklist isEqualTo []);

_shoreMode = _shoreMode != 0;

if (_checkBlacklist) then
{
_posBlacklist = _posBlacklist apply 
{

if (_x isEqualTypeParams [[],[]]) then 
{
_x select 0 params [["_x0", 0], ["_y0", 0]];
_x select 1 params [["_x1", 0], ["_y1", 0]];
private _a = (_x1 - _x0) / 2;
private _b = (_y0 - _y1) / 2;
[[_x0 + _a, _y0 - _b], abs _a, abs _b, 0, true]
}
else
{

_x call BIS_fnc_getArea
};
};
};

private _off = (_minDistance / _maxDistance) ^ 2;
private _rem = 1 - _off;
private _gradientRadius = 1 max _objectProximity * 0.1;

for "_i" from 1 to 3000 do
{
_checkPos getPos [_maxDistance * sqrt (_off + random _rem), random 360] call
{

if (_this isFlatEmpty [-1, -1, _maxGradient, _gradientRadius, _waterMode, _shoreMode] isEqualTo []) exitWith {};


if (_checkProximity && {!(nearestTerrainObjects [_this,["TREE","SMALL TREE","BUILDING","HOUSE","CHURCH","CHAPEL","CROSS","BUNKER","FORTRESS","FOUNTAIN","VIEW-TOWER",
"LIGHTHOUSE","QUAY","FUELSTATION","HOSPITAL","FENCE","WALL","HIDE","BUSSTOP","FOREST","TRANSMITTER","STACK","RUIN","TOURISM","WATERTOWER","ROCK","ROCKS",
"POWER LINES","RAILWAY","POWERSOLAR","POWERWAVE","POWERWIND","SHIPWRECK"], _objectProximity, false, true] isEqualTo [])}) exitWith {};	


if !(lineIntersectsSurfaces [AGLtoASL _this, AGLtoASL _this vectorAdd [0, 0, 50], objNull, objNull, false, 1, "GEOM", "NONE"] isEqualTo []) exitWith {};


if (_checkBlacklist && {{if (_this inArea _x) exitWith {true}; false} forEach _posBlacklist}) exitWith {};

_this select [0, 2] breakOut "main";
};
};


(_waterMode != 0) call _fnc_defaultPos 
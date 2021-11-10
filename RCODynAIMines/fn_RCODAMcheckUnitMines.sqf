params ["_unitToCheck","_ATMineCount","_totalMineCount"];	

private _totalMineCount = 0;
private _ATMineCount = 0;

private _inventoryToCheck = [];

_inventoryToCheck = _inventoryToCheck + uniformItems _unitToCheck;
_inventoryToCheck = _inventoryToCheck + vestItems _unitToCheck;
_inventoryToCheck = _inventoryToCheck + backpackItems _unitToCheck;

{
	if ((["mine",_x] call BIS_fnc_inString && !(["remote",_x] call BIS_fnc_inString) && !(_x in rimmy_dam_var_removeFromMineArray)) || _x in rimmy_dam_var_ACEIEDExceptionArray) then {
		_totalMineCount = _totalMineCount + 1;
	};
	
	if (_x in rimmy_dam_var_ATmineArray) then {
		_ATMineCount = _ATMineCount + 1;
	};
	
} forEach _inventoryToCheck;

_unitToCheck setVariable ["rimmy_dam_var_unitTotalMineCount",_totalMineCount];
_unitToCheck setVariable ["rimmy_dam_var_unitATMineCount",_ATMineCount];

if (_ATMineCount > 0) then {_unitToCheck setVariable ["rimmy_dam_var_unitHasATMines",true];} else {_unitToCheck setVariable ["rimmy_dam_var_unitHasATMines",false];};
if ((_totalMineCount - _ATMineCount) == 0) then {_unitToCheck setVariable ["rimmy_dam_var_unitHasAPMines",false];} else {_unitToCheck setVariable ["rimmy_dam_var_unitHasAPMines",true];};

_totalMineCount
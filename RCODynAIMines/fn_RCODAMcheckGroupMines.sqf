params ["_groupToCheck","_ATMineCount","_totalMineCount"];	

private _totalMineCount = 0;
private _ATMineCount = 0;

private _inventoryToCheck = [];

{
_inventoryToCheck = _inventoryToCheck + uniformItems _x;
_inventoryToCheck = _inventoryToCheck + vestItems _x;
_inventoryToCheck = _inventoryToCheck + backpackItems _x;
} forEach units _groupToCheck;

{
private _current = toLower _x;
if (("mine" in _current && !("remote" in _current) && !(_x in rimmy_dam_var_removeFromMineArray)) || _x in rimmy_dam_var_ACEIEDExceptionArray) then {
_totalMineCount = _totalMineCount + 1;
};

if (_x in rimmy_dam_var_ATmineArray) then {
_ATMineCount = _ATMineCount + 1;
};

} forEach _inventoryToCheck;

_groupToCheck setVariable ["rimmy_dam_var_groupTotalMineCount",_totalMineCount];
_groupToCheck setVariable ["rimmy_dam_var_groupATMineCount",_ATMineCount];

_totalMineCount
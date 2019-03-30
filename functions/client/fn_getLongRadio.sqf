_caller = _this select 1;
_backpackcontents = [];

_backpack = backpack player;
if (_backpack != "" && _backpack != "B_Parachute" ) then {
	_backpackcontents = backpackItems player;
};

removeBackpack _caller;
_caller addBackpack "tf_rt1523g_rhs";

if ( _backpack != "" && _backpack != "B_Parachute" ) then {
	clearAllItemsFromBackpack player;
	{player addItemToBackpack _x } foreach _backpackcontents;
};
[false, true, false] call TG_fnc_reprogramRadios;

waituntil {!isnull player};
//-----------------------------UAV start---------------------------------
0 = [
		token2,
		"The town is garrisoned by Russian forces. US NAVY SEALs are staging offshore before launching the rescue operation...",
		100, //altitude
		nil, //radius
		70, //viewing angle in degrees
		1, //rotation direction. 0 anti clockwise, 1 clockwise.
		[]
	] spawn BIS_fnc_establishingShot;

//--------------------------Lives------------------------------------
_numberOfPlayerRespawns = 2;
player setVariable ["isDead", false, true];
[player, _numberOfPlayerRespawns + 1] call BIS_fnc_respawnTickets;

//--------------------------SuqadUI----------------------------------
[] spawn TG_fnc_squadUI;

//---------------------------Group-----------------------------------
["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups;

//-----------------------JIP Handling -------------------------------
if ([] call BIS_fnc_didJIP) then
{
    [] spawn TG_fnc_teleportToSL;
};

//------------------------Radio menus--------------------------------
_is_tfr_enabled_locally = isClass(configFile/"CfgPatches"/"task_force_radio");
if (_is_tfr_enabled_locally) then
{
    _tgRadioActions = ["tg_radioMenu", "TG Radios", "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\radio_ca.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions", "ACE_Equipment"], _tgRadioActions] call ace_interact_menu_fnc_addActionToObject;

	_actionBoth = ["tg_radioSelfAction", "Reset Radios", "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\radio_ca.paa", {[true, true, false] spawn TG_fnc_reprogramRadios;}, {true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions", "ACE_Equipment", "tg_radioMenu"], _actionBoth] call ace_interact_menu_fnc_addActionToObject;

	_actionSR = ["tg_radioSelfAction", "Reset SR", "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\radio_ca.paa", {[true, false, false] spawn TG_fnc_reprogramRadios;}, {true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions", "ACE_Equipment", "tg_radioMenu"], _actionSR] call ace_interact_menu_fnc_addActionToObject;

	_actionLR = ["tg_radioSelfAction", "Reset LR", "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\radio_ca.paa", {[false, true, false] spawn TG_fnc_reprogramRadios;}, {true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions", "ACE_Equipment", "tg_radioMenu"], _actionLR] call ace_interact_menu_fnc_addActionToObject;

	[nil, player] spawn TG_fnc_getShortRadio;//add short range for all

    _leaders = ["B_officer_F","B_Soldier_SL_F","B_Soldier_TL_F"];
    _type = typeOf player;
    if (_type IN _leaders) then
    {
        [nil, player] spawn TG_fnc_getLongRadio; //add long range for leaders.
    };
};

//------------------------View Distance------------------------------
_action3 = ["tg_chvd", "View Distance", "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\scout_ca.paa", {[] spawn CHVD_fnc_openDialog;}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _action3] call ace_interact_menu_fnc_addActionToObject;

//--------------------------- Gear saving----------------------------
FAR_Player_Init = {
	player addEventHandler
	[
		"Killed",
		{
			// Remove dead body of player (for missions with respawn enabled)
			_body = _this select 0;

			[player, [missionnamespace, "VirtualInventory"]] call BIS_fnc_saveInventory;

			[_body] spawn
			{
				waitUntil { alive player };
				_body = _this select 0;
				deleteVehicle _body;
			}
		}
	];

	[player, [missionnamespace, "VirtualInventory"]] call BIS_fnc_loadInventory;
};

[] spawn {
    waitUntil { !isNull player };

	[player, [missionnamespace, "VirtualInventory"]] call BIS_fnc_saveInventory;
	[] spawn FAR_Player_Init;

	// Event Handlers
	player addEventHandler
	[
		"Respawn",
		{
			[] spawn FAR_Player_Init;
		}
	];
};

//Stick's limited respawns implementation of re-join trapping
nul = [] spawn
{
    if ((getPlayerUID player) in (missionnamespace getvariable ["sticklimitedrespawnsdeathlist",[]]) ) then
    {
        titleText ["You already died too many times for this mission. Please wait for the next mission.", "BLACK OUT", 1];
        endMission "outoftickets";
    };
};

_poss = [
            [7060.46,8019.4,0.62027],
            [7342.25,7983.29,0.501434],
            [7155.9,7762.65,3.87939]
        ];

_pos = selectRandom _poss;

prisoner setPosATL _pos;

//-----------------------------set time of day-----------------------
_paramDaytimeHour = "paramDaytimeHour" call BIS_fnc_getParamValue;
if (_paramDaytimeHour == 0) then
{
	setDate [2010, 6, 22, (round(random 24)), (round(random 55))];//(round(random 1440))
}
else
{
	setDate [2010, 6, 22, _paramDaytimeHour, 0];
};

//---------------------------set the fog value-----------------------
_randnum = round (random 100);
_PARAM_Fog = "PARAM_Fog" call BIS_fnc_getParamValue;
if (_PARAM_Fog == 1) then
{
	[_randnum * 0.01, 0.125, 2] call BIS_fnc_setFog;
}
else
{
	[_PARAM_Fog * 0.01, 0.125, 2] call BIS_fnc_setFog;
};

//------------------------Set the overcast value---------------------
_PARAM_Overcast = "PARAM_Overcast" call BIS_fnc_getParamValue;
if (_PARAM_Overcast == 1) then
{
	[_randnum * 0.01] call bis_fnc_setOvercast;
}
else
{
	[_PARAM_Overcast * 0.01] call bis_fnc_setOvercast;
};

//----------------------------Dynamic group--------------------------
["Initialize", [true]] call BIS_fnc_dynamicGroups;

//------------------Delete bodies upon disconnect--------------------
addMissionEventHandler ['HandleDisconnect',{deleteVehicle (_this select 0);}];

//------------------------------Briefing-----------------------------
execVM "objectives\briefing.sqf";

//----------------------------Relogging block------------------------
missionnamespace setvariable ["sticklimitedrespawnsdeathlist",[],true];

//-----------------If all players died end mission-------------------
[] spawn TG_fnc_ifAllPlayersDead;
[] spawn TG_fnc_missionTimer;

//----------------------Respawn pos----------------------------------
call TG_fnc_hostageInit;

[west, boat1, "Boat-1"] call BIS_fnc_addRespawnPosition;
[west, boat2, "Boat-2"] call BIS_fnc_addRespawnPosition;
[west, boat3, "Boat-3"] call BIS_fnc_addRespawnPosition;

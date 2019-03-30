//Unk
//Reprogram Radios Script by |TG189| Unkl for TacticalGamer.com
//USAGE - pass parameters for which radios you want to reprogram
//[	SHORT RANGE, //boolean (true = reprogram sr  --  false = don't reprogram sr
//	LONG RANGE,  //boolean (true = reprogram lr  --  false = don't reprogram lr
//	WAIT		 //boolean (true = if player has just received a new radio this must be true to wait for TFR)
//] spawn TG_fnc_reprogramRadios;
//
//for example below - 	if i want to leave the short range as is and only reprogram a players long range but player already
//						has all their radios and we don't need to wait for a radio to be initialized:
//[false, true, false] spawn TG_fnc_reprogramRadios;
//************************************************************************************************************

private ["_short", "_long", "_wait", "_either", "_mssg"];
//set data type and default value
_short = true;
_long = true;
_wait = true;
_mssg = "";
//get passed parameters
_short = _this select 0;
_long = _this select 1;
_wait = _this select 2;

systemChat "Standby while your radio(s) are reprogrammed...";
if (_wait) then {sleep 6;}; //ensure radios are initialized and have received their ids from the server

//***************REPROGRAM SHORT RANGE RADIOS ***********************************
if (_short) then {
	//set short wave radio channels
	[(call TFAR_fnc_activeSwRadio), 1, "100"] call TFAR_fnc_SetChannelFrequency;
	[(call TFAR_fnc_activeSwRadio), 2, "102"] call TFAR_fnc_SetChannelFrequency;
	[(call TFAR_fnc_activeSwRadio), 3, "104"] call TFAR_fnc_SetChannelFrequency;
	[(call TFAR_fnc_activeSwRadio), 4, "106"] call TFAR_fnc_SetChannelFrequency;
	[(call TFAR_fnc_activeSwRadio), 5, "108"] call TFAR_fnc_SetChannelFrequency;
	[(call TFAR_fnc_activeSwRadio), 6, "200"] call TFAR_fnc_SetChannelFrequency;
	[(call TFAR_fnc_activeSwRadio), 7, "202"] call TFAR_fnc_SetChannelFrequency;
	[(call TFAR_fnc_activeSwRadio), 8, "204"] call TFAR_fnc_SetChannelFrequency;

	//set SR sterio setting to left
	[(call TFAR_fnc_ActiveSWRadio), 1] call TFAR_fnc_setSwStereo;
};

//**************REPROGRAM ACTIVE LONG RANGE RADIO********************************
if (_long) then {
	if !(call TFAR_fnc_haveLRRadio) exitWith {_long = false;};

	//set longe range radio channels
	[(call TFAR_fnc_activeLrRadio), 1, "50"] call TFAR_fnc_SetChannelFrequency;
	[(call TFAR_fnc_activeLrRadio), 2, "52"] call TFAR_fnc_SetChannelFrequency;
	[(call TFAR_fnc_activeLrRadio), 3, "54"] call TFAR_fnc_SetChannelFrequency;
	[(call TFAR_fnc_activeLrRadio), 4, "56"] call TFAR_fnc_SetChannelFrequency;
	[(call TFAR_fnc_activeLrRadio), 5, "58"] call TFAR_fnc_SetChannelFrequency;
	[(call TFAR_fnc_activeLrRadio), 6, "60"] call TFAR_fnc_SetChannelFrequency;
	[(call TFAR_fnc_activeLrRadio), 7, "62"] call TFAR_fnc_SetChannelFrequency;
	[(call TFAR_fnc_activeLrRadio), 8, "64"] call TFAR_fnc_SetChannelFrequency;
	[(call TFAR_fnc_activeLrRadio), 9, "30"] call TFAR_fnc_SetChannelFrequency;
	[(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1, 2] call TFAR_fnc_setLrStereo;
};

if (_short && !_long) then {_mssg = "Your short range radio has been programmed.";};
if (!_short && _long) then {_mssg = "Your active long range radio has been programmed.";};
if (_short && _long) then {_mssg = "Both your active radios have been reprogrammed.";};
systemChat _mssg;
//end

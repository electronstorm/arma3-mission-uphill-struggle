/*Usage: ["makername", "expression_string", west, east] spawn TG_fnc_mySector;

Parameters:
"markername" - a rectangle marker on the map in editor
"expression_string" - "[_this select 0, _this select 1, _this select 2] execVM 'objectives\tasks\task21Success.sqf';"
*/

if !(isServer) exitWith {};

private ["_mrkName",  "_expression_string", "_mrkSize", "_mrkDir", "_mrkPos", "_areaTrig", "_logic",
        "_areaLogic", "_side1", "_side2"];

//Retrieve marker information
_mrkName = _this select 0;
_expression_string = _this select 1;
_side1 = _this select 2;
_side2 = _this select 3;
_mrkSize = getMarkerSize _mrkName;
_mrkDir = markerDir _mrkName;
_mrkPos = markerPos _mrkName;

//Create a trigger
_areaTrig = createTrigger ["EmptyDetector", _mrkPos];
_areaTrig setTriggerArea [_mrkSize select 0, _mrkSize select 1, _mrkDir, true, 20];

//Create the sector logic
_logic = (createGroup sideLogic) createUnit ["ModuleSector_F", _mrkPos, [], 0, "NONE"];

//Creates area & side logics and trigger
_areaLogic = (createGroup sideLogic)createUnit["LocationArea_F", _mrkPos, [], 0, "NONE"];

// Synchronizes the area
_logic synchronizeObjectsAdd [_areaLogic];

//Synchronze the area to the trigger
_areaLogic synchronizeObjectsAdd [_areaTrig];

//Sector settings
_logic setVariable ["Name"," "];
_logic setVariable ["Designation",""];
_logic setVariable ["ScoreReward","0"];
_logic setVariable ["OnOwnerChange", _expression_string]; //[_this select 0, _this select 1, _this select 2] execVM "objectives\tasks\task21Success.sqf";
_logic setVariable ["OwnerLimit","0.8"];
_logic setVariable ["DefaultOwner","0"]; //"-1"= None, "0"= East, "1" = West, "2"= Indi
_logic setVariable ["TaskOwner","0"]; //nobody 0
_logic setVariable ["TaskTitle",""];
_logic setVariable ["TaskDescription",""];
_logic setVariable ["CostInfantry","1"];
_logic setVariable ["CostWheeled","2"];
_logic setVariable ["CostTracked","4"];
_logic setVariable ["CostWater","0"];
_logic setVariable ["CostAir","2"];
_logic setVariable ["CostPlayers","1"];

//Set sides competing for the sector
_logic setVariable ["sides", [_side1, _side2]];

//initialize the module code
[_logic] call BIS_fnc_moduleSector;

//Wait until sector is initialised
waitUntil
{
    !isNil { _logic getVariable [ "finalized", nil ] } &&
    { !( _logic getVariable [ "finalized", true ] ) }
};

//Hide the markers
_areas = _logic getVariable "areas";
_trigger = _areas select 0;
_trigMarker = (_trigger getVariable "markers") select 0;
_iconMarker = (_trigger getVariable "markers") select 1;
_trigMarker setMarkerAlpha 0;
_iconMarker setMarkerAlpha 0;

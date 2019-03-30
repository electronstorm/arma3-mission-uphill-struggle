/*version: 2019_01_30*/
if (isDedicated) exitWith {};

private ["_marker","_markerNumber", "_markerName", "_getNextMarker",
        "_vehicle", "_str", "_txt"];

_getNextMarker = //Function to create or update position of the marker.
{
    private ["_marker"];

    _markerNumber = _markerNumber + 1;
    _marker = format["um%1",_markerNumber];

    if(getMarkerType _marker == "") then
    {
        createMarkerLocal [_marker, _this];
    }
    else
    {
        _marker setMarkerPosLocal _this;
    };

    _marker;
};

while {true} do //The Main loop
{
    waitUntil {sleep 1; (visibleMap or visibleGPS);};//wait until map or gps
    _markerNumber = 0;
    _ctrl = (findDisplay 12) displayCtrl 51;
    _zoom = ctrlMapScale _ctrl;
    _fade = linearConversion[0.001, 0.07, _zoom, 1, 0, true ];

    _occupiedVics = [];
    {
        _vehicle = vehicle _x;

        if(_vehicle != _x) then //if the _x is in a vehicle create a list
        {
            if (!(_vehicle in _occupiedVics)) then
            {
                _occupiedVics pushBack _vehicle;
            };
        }
        else
        {
            _pos = getPosATL _vehicle;
            _txt = name _x;
            _marker = _pos call _getNextMarker;
            _colorName = "ColorBrown";
            _markerType = "mil_dot";
            _markerSize = 0.4;

            if ( _x in (units group player)) then
            {
                _markerType = "mil_dot";

                if (_x == leader player) then
                {
                    _markerType = "mil_circle";
                    _markerSize = 0.5;
                };

                switch (assignedTeam _x) do
                {
                    case "MAIN":{_colorName = "Default";};
                    case "RED":{_colorName = "ColorRed";};
                    case "GREEN":{_colorName = "ColorGreen";};
                    case "BLUE":{_colorName = "ColorBlue";};
                    case "YELLOW":{_colorName = "ColorYellow";};
                    default     {_colorName = "Default";};
                };
            }
            else
            {
                if (_x == (leader group _x)) then
                {
                    _markerType = "mil_box";
                    _markerSize = 0.5;
                    _txt = format["%1 [%2]", name(leader _x), groupID (group _x)];
                    _fade = linearConversion[0.001, 1, _zoom, 1, 0, true ];
                };
            };

            if(!visibleGPS || visibleMap) then
            {
                _marker setMarkerTextLocal _txt;
                _marker setMarkerAlpha _fade;
            }
            else
            {
                _marker setMarkerTextLocal "";
            };

            _marker setMarkerColorLocal _colorName;
            _marker setMarkerTypeLocal _markerType;
            _marker setMarkerSizeLocal [_markerSize, _markerSize];
        };
    } forEach playableUnits;

    {
        _aVic = _x;
        _str = ""; _txt = "";

        {
            if(_foreachindex == ((count (crew (vehicle _x))) - 1)) then
            {
                _str = format["%1",name _x];
            }
            else
            {
                _str = format["%1, ",name _x];
            };
            _txt = _txt + _str;
        }forEach crew (_aVic);

        _pos = getPosATL _aVic;
        _marker = _pos call _getNextMarker;
        if(!visibleGPS || visibleMap) then
        {
            _marker setMarkerTextLocal _txt;
            _fade = linearConversion[0.001, 1, _zoom, 1, 0, true ];
            _marker setMarkerAlpha _fade;
        }
        else
        {
            _marker setMarkerTextLocal "";
        };

        _marker setMarkerColorLocal "ColorOrange";
        _marker setMarkerSizeLocal [0.7, 0.7];
        _marker setMarkerTypeLocal "n_inf";
    }forEach _occupiedVics;

    _markerNumber = _markerNumber + 1;
    _marker = format["um%1",_markerNumber];

    while {(getMarkerType _marker) != ""} do
    {
        deleteMarkerLocal _marker;
        _markerNumber = _markerNumber + 1;
        _marker = format["um%1",_markerNumber];
    };
};

 _caller = _this select 1;

_caller addItem "tf_anprc152";
_caller assignItem "tf_anprc152";

[true, false, true] call TG_fnc_reprogramRadios;

_pow = prisoner;

_pow setBehaviour "Careless";
dostop _pow;
//_pow playActionNow "Surrender";
//_pow playmove "amovpercmstpsnonwnondnon_amovpercmstpssurwnondnon";
_pow switchMove "Acts_AidlPsitMstpSsurWnonDnon_loop";
_pow disableAI "MOVE";

_pow setVariable ["notrescued", true, true];

[
    _pow,                                                                        
    "<t size='1.5' shadow='2' color='#2EFEF7'>Rescue Hostage</t>",                                                                      
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa",                   
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa",                   
    "(alive _target) and (_target getVariable 'notrescued')",                                                      
    "true",                                                   
    {_this select 1 sidechat "Hold still while I get you free";},
    {},                                                                                
    {call TG_fnc_hostageJoin;},
    {_this select 1 sidechat "Wait one moment";},
    [],                                                                                
    10,                                                                                
    6,                                                                                 
    true,                                                                              
    false
] remoteExec ["BIS_fnc_holdActionAdd",0,_pow];
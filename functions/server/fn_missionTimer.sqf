if !(isServer) exitWith {};
MT = 4500; //75mins - 4500

[ "itemAdd", ["timer",
    {
		MT = MT - 100;

        if (MT isEqualTo 1800) then //30min = 1800
        {
            "There is 30 minutes left to complete the mission." remoteExecCall ["Hint"];
        };

        if (MT isEqualTo 600) then //10min = 600
        {
            "There is only ten minutes to complete the mission." remoteExecCall ["Hint"];
        };

        if (MT isEqualTo 300) then //5min 300
        {
            "There is only five minutes to complete the mission." remoteExecCall ["Hint"];
        };

		if (MT isEqualTo 0) then
        {
			"timeout" call BIS_fnc_endMissionServer;
		};
    },
    100, "seconds", {true}
]] call BIS_fnc_loop;

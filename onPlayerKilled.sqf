_playerLivesLeft = ([player, 0] call BIS_fnc_respawnTickets) - 1;

if (_playerLivesLeft < 0) then
{
    systemChat "You have died your final time. Please spectate until the mission is over.";

    //record the players' name in mission space so he cannot rejoin
    _deathlist = missionnamespace getvariable "sticklimitedrespawnsdeathlist";
    _deathlist pushback (getPlayerUID player);
    missionnamespace setvariable ["sticklimitedrespawnsdeathlist", _deathlist, true];

    //check if all players are dead and end mission if necessary
    player setVariable ["isDead", true, true];
    [] remoteExec ["TG_fnc_ifAllPlayersDead", 2];
};


_playerLivesLeft = ([player, 0] call BIS_fnc_respawnTickets) - 1;

if (_playerLivesLeft > 0) then
{
	systemChat format ["You only have %1 respawns left.", _playerLivesLeft];
}
else
{
	systemChat "You have no additional lives left! Be careful!";
};

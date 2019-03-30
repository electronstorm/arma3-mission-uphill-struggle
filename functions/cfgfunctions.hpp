class TG
{
	tag = "TG";
	class client
	{
		file = "functions\client";
		class squadUI {};
		class getLongRadio {};
		class getShortRadio {};
		class teleportToSL {};
        class reprogramRadios {};
	};
	class server
	{
		file = "functions\server";
		class zenOccupyHouse {};
        class mySector {};
        class ifAllPlayersDead {};
        class missionTimer {};
        class hostageInit {};
        class hostageJoin {};
	};
};

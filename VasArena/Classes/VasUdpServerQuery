//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasUdpServerQuery expands UdpServerQuery;

// Return a string of important system information.
function string GetInfo() {
	local string ResultSet;

	// The server name, i.e.: Bob's Server
	ResultSet = "\\hostname\\"$Level.Game.GameReplicationInfo.ServerName;

	// The short server name
	//ResultSet = ResultSet$"\\shortname\\"$Level.Game.GameReplicationInfo.ShortName;

	// The server port.
	ResultSet = ResultSet$"\\hostport\\"$Level.Game.GetServerPort();

	// (optional) The server IP
	// if (ServerIP != "")
	//	ResultSet = ResultSet$"\\hostip\\"$ServerIP;

	// The map/level title
	ResultSet = ResultSet$"\\maptitle\\"$Level.Title;
	
	// Map name
	ResultSet = ResultSet$"\\mapname\\"$Left(string(Level), InStr(string(Level), "."));

	// The mod or game type
	if (GetItemName(string(Level.Game.Class)) == "VasArenaGameInfo")
	{ResultSet = ResultSet$"\\gametype\\ArenaGameInfo";}
	else
	{ResultSet = ResultSet$"\\gametype\\"$GetItemName(string(Level.Game.Class));}


	// The number of players
	ResultSet = ResultSet$"\\numplayers\\"$Level.Game.NumPlayers;

	// The maximum number of players
	ResultSet = ResultSet$"\\maxplayers\\"$Level.Game.MaxPlayers;

	// The game mode: openplaying
	ResultSet = ResultSet$"\\gamemode\\openplaying";

	// The version of this game.
	ResultSet = ResultSet$"\\gamever\\"$Level.EngineVersion;

	// The most recent network compatible version.
	ResultSet = ResultSet$"\\minnetver\\"$Level.MinNetVersion;

	ResultSet = ResultSet$Level.Game.GetInfo();

	return ResultSet;
}

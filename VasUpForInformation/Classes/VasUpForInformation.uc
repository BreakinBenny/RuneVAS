//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasUpForInformation extends Mutator config(VasUpForInformation);

var(VasUpForInformation) config bool GameEndCorrectly;
var(VasUpForInformation) config int UpFor;
var bool DoOnce;

function PreBeginPlay()
{
	local string MSG;
	if(!DoOnce)
	{
		DoOnce = true;
		LOG (" ************ Powered by VasUpForInformation -  Kal Corp");
		LOG (" ************ Development Forums Http://VasServer.dyndns.org:88");

		if (GameEndCorrectly)
			UpFor++;
		else
			UpFor = 1;
		GameEndCorrectly = false;
		SaveConfig();
	}
	if (UpFor == 1)
		MSG = UpFor$" Map *";
	else
		MSG = UpFor$" Maps *";
	if(Level.Game.GameReplicationInfo != none)
		Level.Game.GameReplicationInfo.ServerName = Level.Game.GameReplicationInfo.ServerName$"    * Server UpFor: "$MSG;
	SetTimer(0.5, true);

	Super.PreBeginPlay();
}

function Timer()
{
	if((Level.Game.bGameEnded) && (!GameEndCorrectly))
	{
		GameEndCorrectly = true;
		SaveConfig();
	}
}

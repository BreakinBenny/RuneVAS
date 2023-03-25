//-----------------------------------------------------------
//	VasArena - Kal Corp
//
//
//	Http://VasServer.dyndns.org/Kalsforums
//
//
//-----------------------------------------------------------
class VasArenaMutator expands Mutator Config(VasArena);

var config float timerInterval;
var int Timercounter;
var() config string SavePlayerName[501];
var() string TSavePlayerName[501];
var() config int SaveplayerTotalFrags[501];
var() int TSaveplayerTotalFrags[501];
var() Bool VasServerSaveon;
var() int PasswordOK[501];
Var() String PlayerName;
var() int VasPlayerSaveNumber;
var() bool FlameSword;

var() config int BaseSpeed;
var() config int MinSpeed;
var() bool crossbow;


function PreBeginPlay()
{
	SetTimer(1.000000,true);
	Super.PreBeginPlay();
}

function ScoreKill(Pawn Killer, Pawn Other)
{
	if(Other.bIsPlayer)
		VasUpdateplayerStats(other);
	if(Killer.bIsPlayer)
		VasUpdateplayerStats(killer);
	Super.ScoreKill(Killer, Other);
}

function ModifyPlayer(Pawn Other)
{
	VasServerSaveON = true;
	Super.ModifyPlayer(Other);
	VasGetplayerStats(other);
}

function INT VasGetplayerNumber(Pawn Player)
{
	local int i;
	local string PlayerName;
	local int playernumber;

	PlayerName = Player.PlayerReplicationInfo.PlayerName;
	for(i=0;i<=500; i++)
	{
		if(SavePlayerName[i]== PlayerName)
		{
			playernumber=i;
		}
	}
	return (playernumber);
}

function bool VasGetplayerStats(pawn Player)
{
	local int i;
	local string PlayerName;

	VasPlayerSaveNumber=0;
	PlayerName = Player.PlayerReplicationInfo.PlayerName;
	for(i=0;i<=500; i++)
	{
		if(SavePlayerName[i]== PlayerName)
		{
			SavePlayerName[i] = PlayerName;
			Player.PlayerReplicationInfo.Deaths = SaveplayerTotalFrags[i];
			//SaveConfig();
			return True;
		}
		if(SavePlayerName[i] == "NONE")
		{
			SavePlayerName[i] = PlayerName;
			SaveplayerTotalFrags[i] = Player.PlayerReplicationInfo.Deaths;
			//SaveConfig();
			return True;
		}
	}
	Log("Player Not Found:"$PlayerName$" ID="$i);
	return True;
}

function bool VasUpdateplayerStats(pawn Player)
{
	local int i;
	local string PlayerName;

	PlayerName = Player.PlayerReplicationInfo.PlayerName;
	for(i=0;i<=500; i++)
	{
		if(SavePlayerName[i]== PlayerName)
		{
			Log("************Save player "$PlayerName$" ID="$i);
			SaveplayerTotalFrags[i] = Player.PlayerReplicationInfo.Deaths;
			//SaveConfig();
		}
	}
	return True;
}

function Mutate(string MutateString, PlayerPawn Sender)
{
	local int PlayerNumber;

	PlayerNumber=VasGetplayerNumber(sender);

	if(MutateString == "VAS-cleanup")
	{
		if (sender.bAdmin)
			VSSDelete(sender, 20);
		else
		{
			sender.ClientMessage("Only Admin Can Clean Up VasArenaSaved Players");
		}
	}
	Super.Mutate(MutateString, Sender);
}

function VSSDelete(playerpawn sender,int level)
{
	local int i;
	local int t;

	t = 0;

	sender.ClientMessage("VasArenaServerSave Cleanup Started Delete Players With low Victories -"$level);
	for(i=0; i<=500; i++)
	{
		if(SaveplayerTotalFrags[i] >= level )
		{
			tSavePlayerName[t] = SavePlayerName[i];
			tSaveplayerTotalFrags[t] = SaveplayerTotalFrags[i];
			t +=1;
		}
		else
		{
			sender.ClientMessage("VasArenaServerSave - Player deleted -"$SaveplayerName[i]);
		}
	}
	sender.ClientMessage("VasArenaServerSave - Total saved Players="$t);

	for(i=0;i<=500; i++)
	{
		if(tSavePlayerName[i] == "" )
		{
			tSavePlayerName[i] = "NONE";
			tSaveplayerTotalFrags[i] = 0;
		}
	}
	SaveConfig();
	t = 0;
	for(i=0;i<=500; i++)
	{
		SavePlayerName[i] = tSavePlayerName[t];
		SaveplayerTotalFrags[i] = tSaveplayerTotalFrags[t];
		t +=1;
	}
	SaveConfig();
	sender.ClientMessage("VasAreanServerSave Cleanup completed");
}

function Timer()
{
	local runeplayer runeplayer;
	foreach AllActors(class'runeplayer', runeplayer)
	{
		SetGroundSpeed(runeplayer);
	}

	if (Timercounter >= timerInterval)
	{
		Timercounter =0;
		Saveconfig();
	}
	Timercounter +=1;
}

function SetGroundSpeed(runeplayer runeplayer)
{
	local int temp,temp2;

	RunePlayer.Groundspeed = BaseSpeed;

	if(RunePlayer.Weapon != NONE)
	{
		temp = (((runeplayer.Weapon.Mass*10)-60)*0.75);
		if(temp <=0)
			temp=0;
		RunePlayer.Groundspeed -= (temp);
	}
	if(runeplayer.shield != NONE)
	{
		temp2 = (runeplayer.Shield.Mass/5);
		if(temp2 <=0)
			temp2=0;
		RunePlayer.Groundspeed -= (temp2);
	}

	if(RunePlayer.Groundspeed < MinSpeed)
		RunePlayer.Groundspeed = MinSpeed;

		RunePlayer.Mass += temp+temp2;
}

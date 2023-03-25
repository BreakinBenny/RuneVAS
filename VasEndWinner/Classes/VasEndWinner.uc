//-----------------------------------------------------------
//	VasExperience -  By Kal-Corp      Kal-Corp@cfl.rr.com
//		http://Vasserver.dyndns.org/KalsForums
//-----------------------------------------------------------
class VasEndWinner expands Mutator;

var bool EndGame;
var bool init;
var string Winner;
var int Timercounter;

function PostBeginPlay()
{
	BroadcastMessage("Powered by VasEndWinner -  Kal Corp");
	LOG("Powered by VasEndWinner -  Kal Corp");
}

function Tick(float DeltaTime)
{
	if((Level.Game.bGameEnded) && (!init))
	{
		init = true;
		SetEndCams();
	}

	Super.Tick(DeltaTime);
}

function Mutate(string MutateString, PlayerPawn Sender)
{
	Super.Mutate(MutateString, Sender);
}

function bool SetEndCams()
{
	local pawn P, Best;
	local PlayerPawn Player;
	for(P=Level.PawnList; P!=None; P=P.nextPawn)
		if(P.bIsPlayer && !P.IsA('Spectator') && ((Best == None) || (P.PlayerReplicationInfo.Score > Best.PlayerReplicationInfo.Score)))
			Best = P;

	for(P=Level.PawnList; P!=None; P=P.nextPawn)
	{
		Player = PlayerPawn(P);
		if(Player != None)
		{
		if(player.IsA('Runeplayer'))
			player.RunePower = 0;
			PlayWinMessage(Player, (Player == Best));
			Winner = Best.PlayerReplicationInfo.playername;
			ViewPlayer(Player);
		}
	}
	return true;
}

function PlayWinMessage(PlayerPawn Player, bool bWinner)
{
	if(bWinner)
	{
		Player.Clientmessage("You are the Winner!",'Pickup');
		Player.Clientmessage("You are the Winner!",'subtitle');
	}
	else
	{
		Player.Clientmessage("The Winner!",'Pickup');
		Player.Clientmessage("The Winner!",'subtitle');
	}
}

function ViewPlayer(pawn Player)
{
	local Pawn P;

	for(P=Level.pawnList; P!=None; P= P.NextPawn)
		if(P.bIsPlayer && (P.PlayerReplicationInfo.PlayerName ~= Winner))
			break;

	if(P != None)
	{
		if(Player.PlayerReplicationInfo.PlayerName == Winner)
		{
			EndFireWorks(Player);
			Return;
		}
	}
	Player.GroundSpeed = 0;
	Player.AirSpeed = 0;
	Player.SetCollision(false, false, false);
	Player.bCollideWorld = false;
	Player.SetPhysics(PHYS_Flying);
	Player.GotoState('CheatFlying');
	Player.SETlocation( p.location );
	Player.MoveTarget = P;
	Player.bHidden = true;
	RunePlayer(Player).bCameraLock = False;
}

function EndFireWorks(Pawn player)
{
	local LightningPowerupBall b;
	local vector X, Y, Z;

	GetAxes(PlayerPawn(player).ViewRotation, X, Y, Z);

	b = Spawn(class'LightningPowerupBall', player,,player.location, player.rotation);
	// b.Velocity = X * 20 + Z * 35;
	b.ZapDamage =  0;
	b.Time = 30.000000;
}

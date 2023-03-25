//-----------------------------------------------------------
// VasArena - Kal Corp
//
//
// Http://VasServer.dyndns.org/Kalsforums
//-----------------------------------------------------------
class VasArenaGameInfo expands ArenaGameInfo;

Var() VasArenaScoreboard VasArenaScoreboard;
Var() int Playetimer;
Var int VasnumChampSpots;
Var int VasnumNormSpots;
Var int curSupport;
Var int playerstochange2;
Var int playerstochange3;
Var Int ArenaTimerDamageCounter;
Var bool playeronfire;
Var int RandomTimer;
Var Bool bRandomTimercheck;
Var int players;
var int Autochangetimer;
var int tmaxArenaTeam;

event playerpawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
)
{
	local playerpawn NewPlayer;
	NewPlayer = Super.Login(Portal, Options, Error, SpawnClass);
	if(NewPlayer != None)
	{
		if(Left(NewPlayer.PlayerReplicationInfo.PlayerName, 6) == DefaultPlayerName)
			ChangeName(NewPlayer, (DefaultPlayerName$NumPlayers), false);
		NewPlayer.bAutoActivate = true;
	}
	return NewPlayer;
}


function PostBeginPlay()
{
local int i;
local NavigationPoint N;
local ArenaStart aStart;
Local int numChampSpots;
Local int numNormSpots;
Local int curSupport;

	GameReplicationInfo.ServerName  = GameName$"- "$GameReplicationInfo.ServerName;
	Super.PostBeginPlay();

	players = 1;
	numChampSpots = 0;
	numNormSpots = 0;
	for(N = Level.NavigationPointList; N != None; N = N.nextNavigationPoint)
	{
		if(N.IsA('ArenaStart'))
		{
			aStart = ArenaStart(N);
			if(aStart != None)
			{
				if(aStart.bChampion || aStart.bChampionTeam)
					numChampSpots++;
				else
					numNormSpots++;
			}
		}
	}
	VasnumChampSpots = numChampSpots;
	vasnumNormSpots = numNormSpots;
	curSupport = Min(numChampSpots, numNormSpots);
	maxArenaTeam = Min(curSupport, MaxTeamSupport);
	setXonX(numChampSpots, numNormSpots );
	GameState = ASTATE_WaitingPlayers;
	CurrentMatch = 1;
	if(ArenaGameReplicationInfo(GameReplicationInfo) != None)
	{
		ArenaGameReplicationInfo(GameReplicationInfo).CurMatch = CurrentMatch;
		ArenaGameReplicationInfo(GameReplicationInfo).matchSize = maxArenaTeam;
	}

	ChampionsLeft = maxArenaTeam;
	ChallengersLeft = maxArenaTeam;
}

Function setXonX(int numChampSpots,int numNormSpots )
{
Local int curSupport;
local byte lType;
local byte TeamType;
local Playerpawn a;
Local int i;

tmaxArenaTeam = maxArenaTeam;

if((players == 1) && ( GameReplicationInfo.NumPlayers >= 5 ))
	players = 2;
if(((players == 2) || (players == 1)) && ( GameReplicationInfo.NumPlayers >= 7))
	players = 3;
if((players == 3) && ( GameReplicationInfo.NumPlayers < 6))
	players = 2;
if (((players == 2) || (players == 3)) && ( GameReplicationInfo.NumPlayers < 4 ))
	players = 1;

	curSupport = Min(numChampSpots, numNormSpots);
	maxArenaTeam = Min(curSupport, players);
	ArenaGameReplicationInfo(GameReplicationInfo).matchSize = maxArenaTeam ;

if((tmaxArenaTeam != maxArenaTeam) && (Autochangetimer > 60))
{
	Autochangetimer = 0;
	BroadcastMessage("{VasArena} - AutoGame change to "$players$" on "$players);
	foreach AllActors(class 'PlayerPawn', A)
	{
		if((A.Region.Zone.IsA('ArenaZone')) || (A.Region.Zone.IsA('QueueZone')))
			RestartPlayer(a);
		for(i = 0; i < maxArenaTeam; i++)
			{ChampionList[i].Fighter = none;
			ChallengerList[i].Fighter = none;}
		GameState = ASTATE_WaitingPlayers;
		ResetMatchVariables();
		InterruptMatchStart();
		bStartedTimer = false;
	}
}
}

function Timer()
{
local ArenaGameReplicationInfo ArenaRepInfo;
local ZoneInfo A;
local Pawn aPawn;
local class<scriptpawn> NewClass;
local class<inventory> Newweapon;
local string Classname;
local playerpawn p;
local scriptpawn Sp;
local int i,tempa;
local PlayerPawn aPlayer;

	Autochangetimer += 1;
	tempa  = 60 - Autochangetimer;

if((tmaxArenaTeam != maxArenaTeam) && (Autochangetimer <= 0))
	BroadcastMessage("{VasArena} - AutoGame change to "$players$" on "$players$" when match is complete");
  
	Super.Timer();
	ArenaRepInfo = ArenaGameReplicationInfo(GameReplicationInfo);
	switch(GameState)
	{
		case ASTATE_WaitingPlayers:
			setXonX(VasnumChampSpots, VasnumNormSpots );
			ArenaTimerDamageCounter = 0;
			playeronfire = false;
				foreach AllActors(class 'PlayerPawn', p)
				{
					if(p.Region.Zone.IsA('ArenaZone'))
					{
						p.jumpz = p.Default.jumpz;
						p.SetCollisionSize(p.CollisionRadius, p.CollisionHeight);
						p.GroundSpeed = p.Default.GroundSpeed;
						p.DrawScale = p.Default.DrawScale;
					}
				}
				foreach AllActors(class 'scriptPawn', Sp)
				{
					if(Sp.Region.Zone.IsA('ArenaZone'))
						Sp.Destroyed();;
				}
			return;
		break;

		case ASTATE_DuringMatch:

			ArenaTimerDamageCounter += 1;

			if(playeronfire)
			{foreach AllActors(class 'PlayerPawn', p)
			{
				if(p.Region.Zone.IsA('ArenaZone'))
					p.PowerupFire(none);
			}
			}
			if(ArenaTimerDamageCounter == RandomTimer)
			{BroadcastMessage("Warriors Fight or be punished by the VasGods!");}
			if (ArenaTimerDamageCounter == RandomTimer+5)
			{BroadcastMessage("Warrriors fight NOW or be punished by the VasGods. This is your last chance!");
			foreach AllActors(class 'PlayerPawn', p)
			{
				p.ShakeView(1.0, 800, 0.5);
				if(Rand(100) < 25)
					p.Dropweapon();
			}
			}
			if(ArenaTimerDamageCounter == RandomTimer+10)
			{
				BroadcastMessage("Arena Warriors have angered the VasGods!");}

				if (ArenaTimerDamageCounter == RandomTimer+13)
				{
					ArenaTimerDamageCounter = 0;
					switch (rand(8))
					{
					case 0:
					BroadcastMessage("The VasGods has killed all the Warriors - The VasGods win the Match!");
					GameState = ASTATE_WaitingPlayers;
					ResetMatchVariables();
					InterruptMatchStart();
					bStartedTimer = false;
					foreach AllActors(class 'PlayerPawn', p)
					{
						if(p.Region.Zone.IsA('ArenaZone'))
							p.Died(sp, 'gibbed', p.Location);
						p.ShakeView(1.0, 800, 0.5);
					}
					for(i = 0; i < 4; i++)
					{ChampionList[i].Fighter = none;
					ChallengerList[i].Fighter = none;}
					return;
					break;
					case 1:
					classname = "Runei.SarkSword";
					BroadcastMessage("The VasGods has summoned there Master Sword Warriors!");
					NewClass = class<scriptpawn>(DynamicLoadObject( ClassName, class'Class' ));
					if(NewClass!=None )
					{
						foreach AllActors(class 'PlayerPawn', p)
						{
							p.ShakeView(1.0, 800, 0.5);
							if(p.Region.Zone.IsA('ArenaZone'))
							{
								SP=Spawn( NewClass,,,p.Location + 72 * Vector(Rotation) + vect(0,0,1) * 15 );
								sp.health=500;
								Sp.enemy = p;
							}
						 }
					 }
					 break;

					case 2:
					classname = "Runei.SarkConrack";
					BroadcastMessage("The VasGods has summoned there Grandmaster Warriors!");
					NewClass = class<scriptpawn>( DynamicLoadObject( ClassName, class'Class' ) );
					if(NewClass!=None )
					{
					foreach AllActors(class 'PlayerPawn', p)
					{
						p.ShakeView(1.0, 800, 0.5);
						if(p.Region.Zone.IsA('ArenaZone'))
						{
							SP=Spawn( NewClass,,,p.Location + 72 * Vector(Rotation) + vect(0,0,1) * 15 );
							sp.health=800;
							Sp.enemy = p;
						}
					}
					}
					break;
					case 3:
					case 4:
					BroadcastMessage("The VasGods has made the warriors smaller");
					foreach AllActors(class 'PlayerPawn', p)
					{
						p.ShakeView(1.0, 800, 0.5);
						if(p.Region.Zone.IsA('ArenaZone'))
						{
							p.drawscale = p.Drawscale*0.5;
							p.jumpz = p.jumpz * p.DrawScale/p.Default.DrawScale;
							p.SetCollisionSize(p.CollisionRadius*p.DrawScale/p.Default.DrawScale, p.CollisionHeight*p.DrawScale/p.Default.DrawScale);
							p.GroundSpeed = p.GroundSpeed * p.DrawScale/p.Default.DrawScale;
						}
					}
					break;
					case 5:
					BroadcastMessage("The VasGods has Spawned Weapons of Mass Destruction");
					classname = "VasArena.VasArenaVasGodAxe";
					BroadcastMessage("The VasGods has summoned there Grandmaster Warriors!");
					Newweapon = class<inventory>( DynamicLoadObject( ClassName, class'Class' ) );
					if( Newweapon!=None )
					{
						foreach AllActors(class 'PlayerPawn', p)
						{
							p.ShakeView(1.0, 800, 0.5);
							if(p.Region.Zone.IsA('ArenaZone'))
							Spawn(Newweapon,,,p.Location + 72 * Vector(Rotation) + vect(0,0,1) * 15);
						}
					}
					break;
					case 6:
					case 7:
					case 8:
					BroadcastMessage("The VasGods has summoned Fire on the Warriors");
					ArenaTimerDamageCounter = 100;
					playeronfire = true;
					break;
					}
				}

			if(!bStartedTimer)
			{
				ArenaRepInfo.bInMatch = true;
				curTimer = 0;
				bStartedTimer = true;

				StateChangeFighters(true);
				SendFightMessage();
				PlayBeginMatch();
			}
		break;

		case ASTATE_PreMatch:

			if(!bRandomTimercheck)
			{
				RandomTimer = 10 + Rand(30);
				BroadcastMessage("The VasGods have set the punishment counter to "$RandomTimer$" seconds.");
				bRandomTimercheck = true;
			}

			foreach AllActors(class 'PlayerPawn', p)
			{
				if(p.Region.Zone.IsA('ArenaZone'))
				{
					p.jumpz = p.Default.jumpz;
					p.SetCollisionSize(p.CollisionRadius, p.CollisionHeight);
					p.GroundSpeed = p.Default.GroundSpeed;
					p.DrawScale = p.Default.DrawScale;
				}
			}

			setXonX(VasnumChampSpots, VasnumNormSpots);
			if(!bStartedTimer)
			{
				ArenaGameReplicationInfo(GameReplicationInfo).curTimer = TimeBetweenMatch;
				curTimer = TimeBetweenMatch;
				ArenaGameReplicationInfo(GameReplicationInfo).bDrawTimer = true;
				bStartedTimer = true;

				SetupMatch();
				SendGetReadyMsg();
				CurrentCountdownIndex = Rand(3);
				if(curTimer == 5)
					PlayCountdown(CurrentCountdownIndex);	
			}
			else if(curTimer == 3)
			{
				StateChangeFighters(false);
				curTimer--;
				ArenaGameReplicationInfo(GameReplicationInfo).curTimer = curTimer;
				PlayCountdown(CurrentCountdownindex);
			}

			else if(curTimer == 0)
			{
				foreach AllActors(class 'ZoneInfo', A)
				{
					if(A.IsA('ArenaZone'))
						ArenaZone(A).BeginArenaMatch();
				}
				foreach AllActors(class 'scriptpawn', sp)
				{
					if((sp.IsA('Sark')) || (sp.IsA('zombie')))
						sp.Died(sp, 'gibbed', sp.Location);
				}
				StartMatch();
				bStartedTimer = false;
				ArenaGameReplicationInfo(GameReplicationInfo).bDrawTimer = false;
				foreach AllActors(class 'PlayerPawn', p)
				{
					if(p.Region.Zone.IsA('ArenaZone'))
					{
						p.jumpz = p.Default.jumpz;
						p.SetCollisionSize(p.CollisionRadius, p.CollisionHeight);
						p.GroundSpeed = p.Default.GroundSpeed;
						p.DrawScale = p.Default.DrawScale;
					}
				}
			}
			else
			{
				curTimer--;
				ArenaGameReplicationInfo(GameReplicationInfo).curTimer = curTimer;
				if(curTimer > 0 && curTimer < 6)
					PlayCountdown(CurrentCountdownIndex);
			}
		break;

		case ASTATE_PostMatch:
			 bRandomTimercheck = false;
				foreach AllActors(class 'PlayerPawn', p)
				{
					if(p.Region.Zone.IsA('ArenaZone'))
					{
						p.jumpz = p.Default.jumpz;
						p.SetCollisionSize(p.CollisionRadius, p.CollisionHeight);
						p.GroundSpeed = p.Default.GroundSpeed;
						p.DrawScale = 1.0;
					}
				}
			setXonX(VasnumChampSpots, VasnumNormSpots );
			ArenaTimerDamageCounter = 0;
			playeronfire = false;
			if(!bStartedTimer)
			{
				PlayEndMatch();
				ArenaRepInfo.bInMatch = false;
				
				if(DetermineWinner() == LTYPE_Challenger)
					MoveChallengers();

				ResetDeadPlayers();

				foreach AllActors(class 'ZoneInfo', A)
				{
					if(A.IsA('ArenaZone'))
						ArenaZone(A).EndArenaMatch();
				}
				ResetMatchVariables();
				curTimer = 5;
				bStartedTimer = true;
			}
			else if(curTimer <= 0)
			{
				GameState = ASTATE_WaitingPlayers;
				InterruptMatchStart();
			}
			else
				curTimer--;
		break;

		default:

		break;
	}
}

function bool ClearList(byte lType)
{
local int i;
local PlayerPawn aPlayer;

	if(lType == LTYPE_Champion)
	{
		AnnounceResults(LTYPE_Challenger);
		
		for(i = 0; i < MaxArenaPlayers; i++)
		{
			aPlayer = PlayerPawn(ChampionList[i].Fighter);
			if(aPlayer != None)
			{
				//aPlayer.PlayerReplicationInfo.Deaths += 1;
				aPlayer.PlayerReplicationInfo.Team = 255;
			}

			ClearFighterList(ChampionList[i]);

			aPlayer = PlayerPawn(ChallengerList[i].Fighter);
			if(aPlayer != None)
				aPlayer.PlayerReplicationInfo.Score += 1;
			aPlayer.PlayerReplicationInfo.deaths += 1;
		}

		return true;
	}
	else if(lType == LTYPE_Challenger)
	{
		AnnounceResults(LTYPE_Champion);
	
		for(i = 0; i < MaxArenaPlayers; i++)
		{	
			aPlayer = PlayerPawn(ChallengerList[i].Fighter);
			if(aPlayer != None)
			{
				//aPlayer.PlayerReplicationInfo.Deaths += 1;
				aPlayer.PlayerReplicationInfo.Team = 255;
			}

			ClearFighterList(ChallengerList[i]);

			aPlayer = PlayerPawn(ChampionList[i].Fighter);
			if(aPlayer != None)
				aPlayer.PlayerReplicationInfo.Score += 1;
				aPlayer.PlayerReplicationInfo.deaths += 1;
		}

		return true;
	}

	return false;
}

function ReduceDamage(out int BluntDamage, out int SeverDamage, name DamageType, pawn injured, pawn instigatedBy)
{
local PlayerPawn aInstigator, aInjured;

	injured.Enemy = InstigatedBy;
	InstigatedBy.Enemy = injured;

	Super.ReduceDamage(BluntDamage, SeverDamage, DamageType, injured, instigatedBy);

	aInstigator = PlayerPawn(instigatedBy);
	aInjured = PlayerPawn(injured);
	if(aInjured == None || aInstigator == None)
		return;

	if(aInstigator.PlayerReplicationInfo.Team == aInjured.PlayerReplicationInfo.Team)
	{
		BluntDamage = 0;
		SeverDamage = 0;
	}
	ArenaTimerDamageCounter = 0;
}

function bool RestartPlayer(pawn aPlayer)
{
	local bool result;
	local PlayerPawn aPlayerPawn;

	aPlayerPawn = PlayerPawn(aPlayer);

	//HACK TO WORK WITH RESTARTING PLAYERS
	if(aPlayerPawn != None && aPlayerPawn == LastRestarted)
	{
		LastRestarted = None;
		return true;
	}

	result = Super.RestartPlayer(aPlayer);
	aPlayer.DesiredColorAdjust = aPlayer.Default.DesiredColorAdjust;
	aPlayer.MaxHealth = 200;
	aPlayer.Health = 200;
	aPlayerPawn = PlayerPawn(aPlayer);
	aPlayerPawn.DrawScale = aPlayerPawn.Default.DrawScale;
	aPlayerPawn.jumpz = aPlayerPawn.Default.jumpz;
	aPlayerPawn.SetCollisionSize(aPlayerPawn.CollisionRadius, aPlayerPawn.CollisionHeight);
	aPlayerPawn.GroundSpeed = aPlayerPawn.Default.GroundSpeed;

	if(aPlayerPawn != None)
	{
		aPlayerPawn.PlayerReplicationInfo.Team = 255;
		aPlayerPawn.PlayerReplicationInfo.TeamID = 255;
	}

	return result;
}

defaultproperties
{
	MaxArenaPlayers=6
	GetReadyMessage="The VasGods have selected you to fight! Prepare For Battle!"
	SuicideDeathMessage=" Could not handle the Arena and Suicided out!!!"
	KillDeathMessage="%o was killed by %k, The VasGods are pleased"
	HeadDeathMessage="%o has given up a head to %k, The VasGods are very Pleased!"
	ScoreBoardType=Class'VasArena.VasArenaScoreboard'
	HUDType=Class'VasArena.VasArenaHud'
	GameName="(VasArena)v1.8.1- "
}
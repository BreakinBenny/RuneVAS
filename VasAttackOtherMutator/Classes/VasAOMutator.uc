//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasAOMutator expands Mutator;

Var String Player[201],tPlayer[201];
Var int Attackothers[201],tAttackothers[201];
Var Bool bInitialized;

function PostBeginPlay()
{
BroadcastMessage("Powered by VasAttackOthers -	Kal Corp");
BroadcastMessage("In Console Type Mutate Attackothers to Turn ON/OFF");
LOG("Powered by VasAttackOthers -	Kal Corp");
LOG("In Console Type Attackothers to Turn ON/OFF");

	if(bInitialized)
		return;
	bInitialized = True;
	Level.Game.RegisterDamageMutator(Self);
	SetTimer(300.000000,True);
}


function MutatorJointDamaged(out int ActualDamage, Pawn Victim, Pawn InstigatedBy, out Vector HitLocation, out Vector Momentum, name DamageType, out int joint)
{
	if(Victim != NONE)
	{
		if((Victim.IsA('playerpawn')) && (InstigatedBy.IsA('playerpawn')))
		{
			if(!AOBool(getplayernumber(InstigatedBy)))
			ActualDamage = 0;
		}
	}
	Super.MutatorJointDamaged(ActualDamage, Victim, InstigatedBy, HitLocation, Momentum, DamageType, joint);
}

function Mutate(string MutateString, PlayerPawn Sender)
{
	local int temp;
	local bool temp2;

	temp= getplayernumber(Sender);
	if(
		(MutateString == "attackothers" ) ||
		(MutateString == "Attackothers" ) ||
		(MutateString == "ATTACKOTHERS" ) ||
		(MutateString == "AttackOthers" )
		)
		{
			temp2 = AOBool(temp);
			SetAttackothers(temp);
			Sender.ClientMessage("AttackOthers Set to "$temp2, 'Subtitle');
			if(temp2)
				Sender.bShootSpecial = false;
			if(!temp2)
				Sender.bShootSpecial = true;
		}
	Super.Mutate(MutateString, Sender);
}

Function SetAttackothers(int playerNumber)
{
	local int temp;
	temp = Attackothers[playerNumber];
	if(temp == 1)
		Attackothers[playerNumber]=0;;
	if(temp == 0)
		Attackothers[playerNumber]=1;
}

Function bool AOBool(int playerNumber)
{
	if(Attackothers[playerNumber] == 1)
		Return False;
	if(Attackothers[playerNumber] == 0)
		Return True;
}

function int getplayernumber(pawn other)
{
	local int PlayerNumber;
	local int i;
	local string PlayerName;

	PlayerName = Other.PlayerReplicationInfo.PlayerName;
	for(i=1; i<=200; i++)
	{
		if((Player[i]==PlayerName) || (Player[i] == ""))
		{
			Player[i] = PlayerName;
			PlayerNumber=i;
			break;
		}
	}
	return PlayerNumber;
}

function CleanUpList()
{
	local string PlayerName;
	local int i;
	local int t;
	Local playerpawn playerpawn;

	t = 1;

	foreach AllActors(class'playerpawn', playerpawn)
	{
		PlayerName = playerpawn.PlayerReplicationInfo.PlayerName;
		for(i=1;i<=200; i++)
		{
			if(Player[i] == PlayerName)
			{
				tPlayer[t] = Player[t];
				tAttackothers[t] = Attackothers[i];
				t +=1;
				break;
			}
		}
	}

	for(i=t;i<=200; i++)
	{
		tPlayer[i] = "";
		tAttackothers[i] = 0;
	}
	t = 1;
	for(i=1; i<=200; i++)
	{
		Player[i] = tPlayer[t];
		Attackothers[i] = tAttackothers[t];
		t +=1;
	}
}

function timer()
{
	CleanUpList();
}

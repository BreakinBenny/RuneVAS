//	VasCSSummon -  By Kal-Corp      Kal-Corp@cfl.rr.com
//		http://Vasserver.dyndns.org:88/KalsForums
//-----------------------------------------------------------
class VasCSSummonMutatorStart expands Mutator Config (VasCSSummon);

Var() config int VasDebuglevel;
Var Bool bInitialized;
Var() config Bool shownames;

function PostBeginPlay()
{
	VasDebug(" PostBeginPlay Started ",2);
	BroadcastMessage("Powered by VasCSSummon -  Kal Corp");
	LOG("Powered by VasCSSummon -  Kal Corp");
	VasDebug(" PostBeginPlay bInitialized="$bInitialized,3);
	setTimer(1, true);

	if(bInitialized)
		return;
	bInitialized = True;
	Level.Game.RegisterDamageMutator(Self);
}

function ModifyPlayer(Pawn Other)
{
	local Pawn P;
	local VasCSSummonsMutator VasCSSummonsMutator;
	VasDebug (" ModifyPlayer Started ",2);

	Super.ModifyPlayer(Other);
	if(!shownames)
		return;
	foreach AllActors(class'VasCSSummonsMutator', VasCSSummonsMutator)
	{
		VasDebug (" ModifyPlayer All VasCSSummonsMutator="$VasCSSummonsMutator,3);
		if(VasCSSummonsMutator.owner == Other)
		{
			VasDebug (" ModifyPlayer VasCSSummonsMutator.owner == other -"$other,2);
			Return;
		}
	}
	VasDebug (" ModifyPlayer VasCSSummonsMutator not found spawning",2);
	VasCSSummonsMutator = Spawn(Class'VasCSSummons.VasCSSummonsMutator',other);
	if(VasCSSummonsMutator != none)
	{
	// VasCSSummonsMutator.XXX = XXX;
	}
	else
		VasDebug(" ModifyPlayer VasCSSummonsMutator == NONE",1);
}

function bool checkattack(pawn Victim,pawn InstigatedBy)
{
	local scriptpawn scriptpawn;

	if(InstigatedBy != NONE)
	{
	// *****************   Summon hit master Return true no Damage
	if(InstigatedBy.isa('Scriptpawn'))
		if(Scriptpawn(InstigatedBy).ally == Victim)
			return true;

	// *****************   master hit - summon attack same if no enemy
	if(InstigatedBy.isa('playerpawn'))
	{
		foreach InstigatedBy.VisibleActors(class'scriptpawn', scriptpawn)
		{
			if(scriptpawn.Ally == InstigatedBy)
				if(scriptpawn.enemy == none)
					Scriptpawn.Enemy = Victim;
			Scriptpawn.SetEnemy(Victim);
		}
	}
}

	if(Victim != NONE)
	{

	// *****************   master hit its summon no damage
	if(Victim.isa('Scriptpawn'))
		if(Scriptpawn(Victim).ally == InstigatedBy)
	return true;

	// *****************   master was hit summon attack InstigatedBy
	if(Victim.isa('playerpawn'))
	{
		foreach Victim.VisibleActors(class'scriptpawn', scriptpawn)
		{
			if(scriptpawn.Ally == Victim)
				Scriptpawn.Enemy = InstigatedBy;
			Scriptpawn.SetEnemy(InstigatedBy);
		}
	}
}

	if((InstigatedBy != NONE) && (Victim != NONE))
	{
	// *****************   summon hit summon with same master no damgae
	if((InstigatedBy.isa('Scriptpawn')) && (Victim.isa('Scriptpawn')))
		if(Scriptpawn(InstigatedBy).ally == Scriptpawn(Victim).ally)
			return true;
}

	return false;
}

function MutatorJointDamaged( out int ActualDamage, Pawn Victim, Pawn InstigatedBy, out Vector HitLocation, out Vector Momentum, name DamageType, out int joint)
{

	VasDebug (" MutatorJointDamaged Started ",3);

	if((Victim != NONE) || (InstigatedBy != NONE))
	{
		if(checkattack(Victim,InstigatedBy))
		ActualDamage = 0;
	}

	//if(Victim.isa('scriptpawn'))
	//	if(scriptpawn(Victim).ally != NONE)
	//		Victim.SightRadius = Victim.default.SightRadius;

	Super.MutatorJointDamaged(ActualDamage, Victim, InstigatedBy, HitLocation, Momentum, DamageType, joint);
}

function summonfollow(PlayerPawn Sender)
{
	local Pawn P;
	local VasCSSummonRepl VasCSSummonRepl;
	Sender.ClientMessage("You command your summons to Follow you!",'subtitle');
	Sender.ServerTaunt('X1_Taunt');
	foreach AllActors(class'VasCSSummonRepl', VasCSSummonRepl)
	{
		if(VasCSSummonRepl.ally == Sender)
			VasCSSummonRepl.SummonState = "FOLLOW";
	}
}

function SummonStay(PlayerPawn Sender)
{
	local Pawn P;
	local VasCSSummonRepl VasCSSummonRepl;

	Sender.ClientMessage("You command your summons to Stay here!",'subtitle');
	Sender.ServerTaunt('X1_Taunt');
	foreach AllActors(class'VasCSSummonRepl', VasCSSummonRepl)
	{
		if(VasCSSummonRepl.ally == Sender)
			VasCSSummonRepl.SummonState = "STAY";
	}
}

function SummonAttack(PlayerPawn Sender)
{
	local Pawn P;
	local VasCSSummonRepl VasCSSummonRepl;
	Sender.ClientMessage("You command your summons to Attack!",'subtitle');
	Sender.ServerTaunt('X1_Taunt');
	foreach AllActors(class'VasCSSummonRepl', VasCSSummonRepl)
	{
		if(VasCSSummonRepl.ally == Sender)
			VasCSSummonRepl.SummonState = "ATTACK";
	}
}

function SummonGUARD (PlayerPawn Sender)
{
	local Pawn P;
	local VasCSSummonRepl VasCSSummonRepl;
	Sender.ClientMessage("You command your summons to Guard You!",'subtitle');
	Sender.ServerTaunt('X1_Taunt');

	foreach AllActors(class'VasCSSummonRepl', VasCSSummonRepl)
	{
		if(VasCSSummonRepl.ally == Sender)
			VasCSSummonRepl.SummonState = "GUARD";
	}
}

function Mutate(string MutateString, PlayerPawn Sender)
{
	if(Caps(MutateString) == "SUMMONATTACK")
		SummonAttack(Sender);
	if(Caps(MutateString) == "SUMMONSTAY")
		SummonStay(Sender);
	if(Caps(MutateString) == "SUMMONFOLLOW")
		summonfollow(Sender);
	if(Caps(MutateString) == "SUMMONGUARD")
		summonguard(Sender);

	Super.Mutate(MutateString, Sender);
}

function VasDebug(String Text, int level)
{
	local String text1,test2;

	if(VasDebuglevel > 0)
	{
		if( level <= VasDebuglevel)
		{
			if(level == 1)
				text1 = "* VasDebug L1 * ";
			if(level == 2)
				text1 = "** VasDebug L2 ** ";
			if(level == 3)
				text1 = "*** VasDebug L3 *** ";
			Log (text1$" "$Class.name$" - "$Text);
		}
	}
}
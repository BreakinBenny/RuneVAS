//-----------------------------------------------------------
// VasCast -	By Kal-Corp	Kal-Corp@cfl.rr.com
//	http://Vasserver.dyndns.org:88/KalsForums
//-----------------------------------------------------------
class VasCastStart expands Mutator config(VasCastSpell);

Var config int VasDebuglevel;
Var Config bool PlayersCast;
Var Config bool MonstersCast;
var Config string SpellName[51];
var Config string SpellClass[51];
var Config INT PointsRequired[51];
var Config INT CastPercent[51];
Var Bool bInitialized;
var Config String MonsterName[51];
var Config int MonsterSpell1[51];
var Config int MonsterSpell1Percent[51];
var Config int MonsterSpell2[51];
var Config int MonsterSpell2Percent[51];
var Config int MonsterSpell3[51];
var Config int MonsterSpell3Percent[51];
var Config int MonsterSpell4[51];
var Config int MonsterSpell4Percent[51];
var Config int MonsterSpell5[51];
var Config int MonsterSpell5Percent[51];
var Config int MonsterSpell6[51];
var Config int MonsterSpell6Percent[51];
var Config int MonsterSpell7[51];
var Config int MonsterSpell7Percent[51];
var Config int MonsterSpell8[51];
var Config int MonsterSpell8Percent[51];
var Config int MonsterSpell9[51];
var Config int MonsterSpell9Percent[51];
var Config int MonsterSpell10[51];
var Config int MonsterSpell10Percent[51];
var Config int MonsterSpell11[51];
var Config int MonsterSpell11Percent[51];
var Config int MonsterSpell12[51];
var Config int MonsterSpell12Percent[51];
var Config int MonsterSpell13[51];
var Config int MonsterSpell13Percent[51];
var Config int MonsterSpell14[51];
var Config int MonsterSpell14Percent[51];
var Config int MonsterSpell15[51];
var Config int MonsterSpell15Percent[51];
var Config int MonsterSpell16[51];
var Config int MonsterSpell16Percent[51];
var Config int MonsterSpell17[51];
var Config int MonsterSpell17Percent[51];
var Config int MonsterSpell18[51];
var Config int MonsterSpell18Percent[51];
var Config int MonsterSpell19[51];
var Config int MonsterSpell19Percent[51];
var Config int MonsterSpell20[51];
var Config int MonsterSpell20Percent[51];

Var int PowerTimer;
Var int Casterlevel;

function timer()
{
local ScriptPawn ScriptPawn;
Local Runeplayer Runeplayer;
local int MonsterNumber;

VasDebug(" PreBeginPlay timer",2);
if(MonstersCast)
	{
		foreach AllActors(class'ScriptPawn', ScriptPawn)
			{
			VasDebug(" PreBeginPlay All ScriptPawn="$ScriptPawn,3);
			if(ScriptPawn.Enemy != none)
				if(CheckMonsterlist(ScriptPawn, MonsterNumber))
					CheckCastMonsterSpell(ScriptPawn, MonsterNumber);
			}
	}

if((PlayersCast) && (PowerTimer >= 10))
{
	foreach AllActors(class'Runeplayer', Runeplayer)
	{
		VasDebug(" PreBeginPlay All Runeplayer="$Runeplayer,3);
		Runeplayer.runepower += 2;
		if(Runeplayer.runepower > Runeplayer.maxpower)
			Runeplayer.runepower = Runeplayer.maxpower;
	}
	PowerTimer = 0;
}
PowerTimer +=1;
}

function bool CheckMonsterlist(ScriptPawn ScriptPawn,out int MonsterNumber)
{
local Int i;

VasDebug(" CheckMonsterlist Started",2);

	for(i=1; i<=50; i++)
	{
		if(MonsterName[i] == "")
			continue;
		if(ScriptPawn.IsA(Name(MonsterName[i])))
		{
			MonsterNumber = i;
			return True;
		}
	}
	Return False;
}


function PostBeginPlay()
{
VasDebug(" PostBeginPlay Started timer 2sec",2);

BroadcastMessage("Powered by VasCastSpells - Kal Corp");
LOG("Powered by VasCastSpells - Kal Corp");

	if(bInitialized)
		return;
	SetTimer(2.000000,true);
	bInitialized = True;
	Level.Game.RegisterDamageMutator( Self );

}
Function bool MagicProtect(pawn Player)
{
Local VasCPMagicProtectRepl VasCPMagicProtectRepl ;

	foreach AllActors(class'VasCPMagicProtectRepl', VasCPMagicProtectRepl)
	{
		if(VasCPMagicProtectRepl.owner == Player)
			Return VasCPMagicProtectRepl.magicProtect;
	}
Return False;
}

function MutatorJointDamaged( out int ActualDamage, Pawn Victim, Pawn InstigatedBy, out Vector HitLocation, out Vector Momentum, name DamageType, out int joint)
{
local int quarterDamage;

VasDebug(" MutatorJointDamaged Started",2);
VasDebug(" (IN) ActualDamage="$ActualDamage$" Victim="$Victim$" InstigatedBy="$InstigatedBy$" DamageType="$DamageType,3);

if((DamageType == 'MAGIC') ||(DamageType == 'fire'))
{
	if(MagicProtect(Victim))
	{
		Spawn(class'EmpathyFlash',Victim,,HitLocation,);
		ActualDamage = 0;
	}
}

	if(Victim != none)
	{
		if(((Victim.AmbientGlow == 255) && (Victim.LightEffect == LE_NonIncidence))	&& (DamageType !='DamageBack'))
		{
			quarterDamage = ActualDamage*0.25;
			ActualDamage -= quarterDamage;
			if(InstigatedBy != none)
				InstigatedBy.JointDamaged(quarterDamage*1.5, InstigatedBy, HitLocation, Momentum, 'DamageBack', 0);
			Spawn(class'EmpathyFlash',Victim,,HitLocation,);
		}
	 }

if(Victim != none)
{
	if(Victim.isa('playerpawn'))
	{
		if(Victim.SkelGroupSkins[1] == texture'statues.sb_body_stone')
		{
			if(DamageType == 'blunt')
				ActualDamage *= 1.5;
			if(DamageType == 'sever')
				ActualDamage *= 0.10;
			if(DamageType == 'bluntsever')
				ActualDamage *= 0.2;
			if(DamageType == 'fire')
				ActualDamage *= 0;
		}
	}
}
	VasDebug(" (OUT) ActualDamage="$ActualDamage$" Victim="$Victim$" InstigatedBy="$InstigatedBy$" DamageType="$DamageType,3);
	Super.MutatorJointDamaged(ActualDamage, Victim, InstigatedBy, HitLocation, Momentum, DamageType, joint);
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
VasDebug(" CheckReplacement Started Power For all weapons OFF",2);

	if(other != NONE)
		if(Other.IsA('Weapon'))
			Weapon(Other).bCanBePoweredUp = false;
		return true;	
}

function ModifyPlayer(Pawn Other)
{
local Pawn P;
local VasCastMutator VasCastMutator;

VasDebug(" ModifyPlayer Started For "$Other,2);
Super.ModifyPlayer(Other);

	if(PlayersCast)
	{
		foreach AllActors(class'VasCastMutator', VasCastMutator )
		{
			if(VasCastMutator.owner == Other)
				Return;
		}
		VasCastMutator = Spawn(Class'VasCastSpell.VasCastMutator',other);
		if(VasCastMutator != none)
			nextspell(playerpawn(Other),VasCastMutator);
		else
			VasDebug(" ModifyPlayer VasCastMutator = NONE",1);
	}
}

function Mutate(string MutateString, PlayerPawn Sender)
{
local VasCastMutator VasCastMutator;
local int temp;

VasDebug(" Mutate Started Sender="$Sender$" MutateString="$MutateString, 2);

	if((MutateString == "castspell") || (MutateString == "CASTSPELL") ||	(MutateString == "CastSpell"))
	{
		foreach AllActors(class'VasCastMutator', VasCastMutator)
		{
			if(VasCastMutator.owner == Sender)
			{
				Castspell(Sender, VasCastMutator);
				break;
			}
		}
	}
	if((MutateString == "nextspell") || (MutateString == "NEXTSPELL") || (MutateString == "NextSpell"))
	{
		foreach AllActors(class'VasCastMutator', VasCastMutator )
		{
			if(VasCastMutator.owner == Sender)
			{
				nextspell(Sender,VasCastMutator);
				break;
			}
		}
	}
	if((MutateString == "VasCast 1") || (MutateString == "vascast 1") || (MutateString == "VASCAST 1"))
		temp = 1;
	if((MutateString == "VasCast 2") || (MutateString == "vascast 2") || (MutateString == "VASCAST 2"))
		temp = 2;
	if((MutateString == "VasCast 3") || (MutateString == "vascast 3") || (MutateString == "VASCAST 3"))
		temp = 3;
	if(
		(MutateString == "VasCast 4" ) ||
		(MutateString == "vascast 4" ) ||
		(MutateString == "VASCAST 4" )
		)
		temp = 4;
	if(
		(MutateString == "VasCast 5" ) ||
		(MutateString == "vascast 5" ) ||
		(MutateString == "VASCAST 5" )
		)
		temp = 5;
	if(
		(MutateString == "VasCast 6" ) ||
		(MutateString == "vascast 6" ) ||
		(MutateString == "VASCAST 6" )
		)
		temp = 6;
	if(
		(MutateString == "VasCast 7" ) ||
		(MutateString == "vascast 7" ) ||
		(MutateString == "VASCAST 7" )
		)
		temp = 7;
	if(
		(MutateString == "VasCast 8" ) ||
		(MutateString == "vascast 8" ) ||
		(MutateString == "VASCAST 8" )
		)
		temp = 8;
	if(
		(MutateString == "VasCast 9" ) ||
		(MutateString == "vascast 9" ) ||
		(MutateString == "VASCAST 9" )
		)
		temp = 9;
	if(
		(MutateString == "VasCast 10" ) ||
		(MutateString == "vascast 10" ) ||
		(MutateString == "VASCAST 10" )
		)
		temp = 10;
	if(
		(MutateString == "VasCast 11" ) ||
		(MutateString == "vascast 11" ) ||
		(MutateString == "VASCAST 11" )
		)
		temp = 11;
	if(
		(MutateString == "VasCast 11" ) ||
		(MutateString == "vascast 11" ) ||
		(MutateString == "VASCAST 11" )
		)
		temp = 11;
	if(
		(MutateString == "VasCast 12" ) ||
		(MutateString == "vascast 12" ) ||
		(MutateString == "VASCAST 12" )
		)
		temp = 12;
	if(
		(MutateString == "VasCast 13" ) ||
		(MutateString == "vascast 13" ) ||
		(MutateString == "VASCAST 13" )
		)
		temp = 13;
	if(
		(MutateString == "VasCast 14" ) ||
		(MutateString == "vascast 14" ) ||
		(MutateString == "VASCAST 14" )
		)
		temp = 14;
	if(
		(MutateString == "VasCast 15" ) ||
		(MutateString == "vascast 15" ) ||
		(MutateString == "VASCAST 15" )
		)
		temp = 15;
	if(
		(MutateString == "VasCast 16" ) ||
		(MutateString == "vascast 16" ) ||
		(MutateString == "VASCAST 16" )
		)
		temp = 16;
	if(
		(MutateString == "VasCast 17" ) ||
		(MutateString == "vascast 17" ) ||
		(MutateString == "VASCAST 17" )
		)
		temp = 17;
	if(
		(MutateString == "VasCast 18" ) ||
		(MutateString == "vascast 18" ) ||
		(MutateString == "VASCAST 18" )
		)
		temp = 18;
	if(
		(MutateString == "VasCast 19" ) ||
		(MutateString == "vascast 19" ) ||
		(MutateString == "VASCAST 19" )
		)
		temp = 19;
	if(
		(MutateString == "VasCast 20" ) ||
		(MutateString == "vascast 20" ) ||
		(MutateString == "VASCAST 20" )
		)
		temp = 20;
	if(
		(MutateString == "VasCast 21" ) ||
		(MutateString == "vascast 21" ) ||
		(MutateString == "VASCAST 21" )
		)
		temp = 21;
	if(
		(MutateString == "VasCast 22" ) ||
		(MutateString == "vascast 22" ) ||
		(MutateString == "VASCAST 22" )
		)
		temp = 22;
	if(
		(MutateString == "VasCast 23" ) ||
		(MutateString == "vascast 23" ) ||
		(MutateString == "VASCAST 23" )
		)
		temp = 23;
	if(
		(MutateString == "VasCast 24" ) ||
		(MutateString == "vascast 24" ) ||
		(MutateString == "VASCAST 24" )
		)
		temp = 24;
	if(
		(MutateString == "VasCast 25" ) ||
		(MutateString == "vascast 25" ) ||
		(MutateString == "VASCAST 25" )
		)
		temp = 25;
	if(
		(MutateString == "VasCast 26" ) ||
		(MutateString == "vascast 26" ) ||
		(MutateString == "VASCAST 26" )
		)
		temp = 26;
	if(
		(MutateString == "VasCast 27" ) ||
		(MutateString == "vascast 27" ) ||
		(MutateString == "VASCAST 27" )
		)
		temp = 27;
	if(
		(MutateString == "VasCast 28" ) ||
		(MutateString == "vascast 28" ) ||
		(MutateString == "VASCAST 28" )
		)
		temp = 28;
	if(
		(MutateString == "VasCast 29" ) ||
		(MutateString == "vascast 29" ) ||
		(MutateString == "VASCAST 29" )
		)
		temp = 29;
	if(
		(MutateString == "VasCast 30" ) ||
		(MutateString == "vascast 30" ) ||
		(MutateString == "VASCAST 30" )
		)
		temp = 30;
	if(
		(MutateString == "VasCast 31" ) ||
		(MutateString == "vascast 31" ) ||
		(MutateString == "VASCAST 31" )
		)
		temp = 31;
	if(
		(MutateString == "VasCast 32" ) ||
		(MutateString == "vascast 32" ) ||
		(MutateString == "VASCAST 32" )
		)
		temp = 32;
	if(
		(MutateString == "VasCast 33" ) ||
		(MutateString == "vascast 33" ) ||
		(MutateString == "VASCAST 33" )
		)
		temp = 33;
	if(
		(MutateString == "VasCast 34" ) ||
		(MutateString == "vascast 34" ) ||
		(MutateString == "VASCAST 34" )
		)
		temp = 34;
	if(
		(MutateString == "VasCast 35" ) ||
		(MutateString == "vascast 35" ) ||
		(MutateString == "VASCAST 35" )
		)
		temp = 35;
	if(
		(MutateString == "VasCast 36" ) ||
		(MutateString == "vascast 36" ) ||
		(MutateString == "VASCAST 36" )
		)
		temp = 36;
	if(
		(MutateString == "VasCast 37" ) ||
		(MutateString == "vascast 37" ) ||
		(MutateString == "VASCAST 37" )
		)
		temp = 37;
	if(
		(MutateString == "VasCast 38" ) ||
		(MutateString == "vascast 38" ) ||
		(MutateString == "VASCAST 38" )
		)
		temp = 38;
	if(
		(MutateString == "VasCast 39" ) ||
		(MutateString == "vascast 39" ) ||
		(MutateString == "VASCAST 39" )
		)
		temp = 39;
	if(
		(MutateString == "VasCast 40" ) ||
		(MutateString == "vascast 40" ) ||
		(MutateString == "VASCAST 40" )
		)
		temp = 40;
	if(
		(MutateString == "VasCast 41" ) ||
		(MutateString == "vascast 41" ) ||
		(MutateString == "VASCAST 41" )
		)
		temp = 41;
	if(
		(MutateString == "VasCast 42" ) ||
		(MutateString == "vascast 42" ) ||
		(MutateString == "VASCAST 42" )
		)
		temp = 42;
	if(
		(MutateString == "VasCast 43" ) ||
		(MutateString == "vascast 43" ) ||
		(MutateString == "VASCAST 43" )
		)
		temp = 43;
	if(
		(MutateString == "VasCast 44" ) ||
		(MutateString == "vascast 44" ) ||
		(MutateString == "VASCAST 44" )
		)
		temp = 44;
	if(
		(MutateString == "VasCast 45" ) ||
		(MutateString == "vascast 45" ) ||
		(MutateString == "VASCAST 45" )
		)
		temp = 45;
	if(
		(MutateString == "VasCast 46" ) ||
		(MutateString == "vascast 46" ) ||
		(MutateString == "VASCAST 46" )
		)
		temp = 46;
	if(
		(MutateString == "VasCast 47" ) ||
		(MutateString == "vascast 47" ) ||
		(MutateString == "VASCAST 47" )
		)
		temp = 47;
	if(
		(MutateString == "VasCast 48" ) ||
		(MutateString == "vascast 48" ) ||
		(MutateString == "VASCAST 48" )
		)
		temp = 48;
	if(
		(MutateString == "VasCast 49" ) ||
		(MutateString == "vascast 49" ) ||
		(MutateString == "VASCAST 49" )
		)
		temp = 49;
	if(
		(MutateString == "VasCast 50" ) ||
		(MutateString == "vascast 50" ) ||
		(MutateString == "VASCAST 50" )
		)
		temp = 50;

	if(temp > 0)
	{
		foreach AllActors(class'VasCastMutator', VasCastMutator)
		 {
			if(VasCastMutator.owner == Sender)
			{
				VasDebug (" Mutate VasCastMutator found",2);
				SetSpell(Sender,VasCastMutator , temp );
				Castspell(Sender, VasCastMutator);
				break;
			}
		}
	}

Super.Mutate(MutateString, Sender);
}

function SetSpell(PlayerPawn Sender,VasCastMutator VasCastMutator,int Spell)
{
local int temp2;
local PlayerReplicationInfo PRI;
local int Casterlevel;

VasDebug(" SetSpell Started Sender="$Sender$" VasCastMutator="$VasCastMutator$" Spell="$Spell,2);

	PRI = Sender.PlayerReplicationInfo;
	Casterlevel = INT(PRI.OldName);
	if(casterlevel <= 0)
		Casterlevel = 50;
VasDebug(" SetSpell Casterlevel="$Casterlevel, 3);
		temp2 = (CastPercent[Spell]+CasterLevel);
		if(temp2 > 90)
			temp2 = 90;
		if(temp2 < 5)
			temp2 = 5;
VasDebug(" SetSpell CastPercent="$temp2,3);
	if(VasCastMutator != NONE)
	{
		VasCastMutator.Spellnumber = Spell;
		VasCastMutator.CurrentSpell = SpellName[Spell];
		VasCastMutator.PointsRequired = PointsRequired[Spell];
		VasCastMutator.CastPercent = temp2 ;
	}
	else
		VasDebug(" SetSpell VasCastMutator=NONE", 1);
}

function NextSpell(PlayerPawn Sender,VasCastMutator VasCastMutator)
{
local int temp,temp2;
local PlayerReplicationInfo PRI;
local int Casterlevel;

VasDebug(" NextSpell Started Sender="$Sender$" VasCastMutator="$VasCastMutator, 2);

	Temp = VasCastMutator.Spellnumber;
	temp += 1;

	PRI = Sender.PlayerReplicationInfo;
	Casterlevel = INT(PRI.OldName);
	if(casterlevel <= 0)
		Casterlevel = 50;
VasDebug(" NextSpell Casterlevel="$Casterlevel,3);
	temp2 = (CastPercent[Temp]+CasterLevel);
	if(temp2 > 90)
		temp2 = 90;
	if(temp2 < 5)
		temp2 = 5;

	if(SpellName[temp] == "" )
		temp = 1;
VasDebug(" NextSpell CastPercent="$temp2,3);
	if(VasCastMutator != NONE)
	{
		VasCastMutator.Spellnumber = Temp;
		VasCastMutator.CurrentSpell = SpellName[Temp];
		VasCastMutator.PointsRequired = PointsRequired[Temp];
		VasCastMutator.CastPercent = temp2;
	}
	else
		 VasDebug(" NextSpell VasCastMutator=NONE",1);
}

function CastSpell(PlayerPawn Sender,VasCastMutator VasCastMutator)
{
local int temp,temp2;
local VasCastSpell VasCastSpell;
local class<VasCastSpell> LoadSpell;
local PlayerReplicationInfo PRI;
local int Casterlevel;

VasDebug(" CastSpell Started Sender="$Sender$" VasCastMutator="$VasCastMutator,2);

	PRI = Sender.PlayerReplicationInfo;
	Casterlevel = INT(PRI.OldName);
	if(casterlevel <= 0)
		Casterlevel = 50;
VasDebug(" CastSpell Casterlevel="$Casterlevel,3);
	PRI.bIsABot = false;

	Temp = VasCastMutator.Spellnumber;
	if(Sender.RunePower < PointsRequired[Temp])
	{
		Sender.ClientMessage("You dont have the power to cast this!",'subtitle');
		return;
	}
	temp2 = (CastPercent[Temp]+CasterLevel);
	if(temp2 > 90)
		temp2 = 90;
	if(temp2 < 5)
		temp2 = 5;

	if(rand(100) > temp2)
	{
		Sender.ClientMessage("You fail to cast this spell",'subtitle');
		Sender.RunePower -= PointsRequired[Temp]/3;
		return;
	}
	if(VasCastMutator != NONE)
	{
		if(VasCastMutator.spellactive)
		{
			Sender.ClientMessage("You must wait to cast this spell!",'subtitle');
			return;
		}
	}
	else
		VasDebug (" CastSpell VasCastMutator=NONE",1);

	PRI.bIsABot = true;
	LoadSpell = class<VasCastSpell>( DynamicLoadObject(SpellClass[Temp], class'Class' ));
	if(LoadSpell == None)
	{
		VasDebug ("CastSpell LoadSpell=NONE", 1);
		Sender.ClientMessage("This spell is not available",'subtitle');
		return;
	}
	VasCastSpell = Spawn(LoadSpell,Sender,,Location);
	if(VasCastSpell == None)
	{
		VasDebug(" CastSpell VasCastSpell=NONE",1);
		Sender.ClientMessage("This spell is not available",'subtitle');
		return;
	}
	if(VasCastSpell != NONE)
	{
		VasCastSpell.PointsRequired = VasCastMutator.PointsRequired;
		VasCastSpell.CastSpell(Sender);
		VasCastMutator.spellactive= true;
	}
}

function CastMonsterSpell(Scriptpawn monster, int Spell)
{
local VasCastSpell VasCastSpell;
local class<VasCastSpell> LoadSpell;

VasDebug(" CastMonsterSpell Started monster="$monster$" Spell="$Spell,2);

if(monster != NONE)
{
	if((monster.Health > 0) && (!monster.IsInState('FallingState')))
	{
		LoadSpell = class<VasCastSpell>( DynamicLoadObject(SpellClass[Spell], class'Class' ));
		if(LoadSpell==None)
		{
			VasDebug(" CastMonsterSpell LoadSpell=NONE", 1);
			return;
		}
		VasCastSpell = Spawn(LoadSpell,monster,,Location);
		if(VasCastSpell==None)
		{
			VasDebug(" CastMonsterSpell VasCastSpell=NONE",1);
			return;
		}
		if(VasCastSpell != NONE)
		{
			VasCastSpell.PointsRequired = 0;
			VasCastSpell.CastSpell(monster);
		}
	}
	else
		VasDebug(" CastMonsterSpell Monster Dead or in FallingState - NOT Casting - Fix for Server Crash! :-)",1);
}
else
	 VasDebug (" CastMonsterSpell monster=NONE",1);
}


function CheckCastMonsterSpell(ScriptPawn ScriptPawn,int MonsterNumber)
{
Local Int i;

VasDebug(" CheckCastMonsterSpell Started ScriptPawn="$ScriptPawn$" MonsterNumber="$MonsterNumber,2);

if(MonsterSpell1[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell1Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell1[MonsterNumber]);
		return;
	}
}
if(MonsterSpell2[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell2Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell2[MonsterNumber]);
		return;
	}
}
if(MonsterSpell3[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell3Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell3[MonsterNumber]);
		return;
	}
}
if(MonsterSpell4[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell4Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell4[MonsterNumber]);
		return;
	}
}
if(MonsterSpell5[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell5Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell5[MonsterNumber]);
		return;
	}
}
if(MonsterSpell6[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell6Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell6[MonsterNumber]);
		return;
	}
}
if(MonsterSpell7[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell7Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell7[MonsterNumber]);
		return;
	}
}
if(MonsterSpell8[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell8Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell8[MonsterNumber]);
		return;
	}
}
if(MonsterSpell9[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell9Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell9[MonsterNumber]);
		return;
	}
}
if(MonsterSpell10[MonsterNumber] != 0)
	{
	if(rand(100) <= MonsterSpell10Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell10[MonsterNumber]);
		return;
	}
}
if(MonsterSpell11[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell11Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell11[MonsterNumber]);
		return;
	}
}
if(MonsterSpell12[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell12Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell12[MonsterNumber]);
		return;
	}
}
if(MonsterSpell13[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell13Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell13[MonsterNumber]);
		return;
	}
}
if(MonsterSpell14[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell14Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell14[MonsterNumber]);
		return;
	}
}
if(MonsterSpell15[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell15Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell15[MonsterNumber]);
		return;
	}
}
if(MonsterSpell16[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell16Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell16[MonsterNumber]);
		return;
	}
}
if(MonsterSpell17[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell17Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell17[MonsterNumber]);
		return;
	}
}
if(MonsterSpell18[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell18Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell18[MonsterNumber]);
		return;
	}
}
if(MonsterSpell19[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell19Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell19[MonsterNumber]);
		return;
	}
}
if(MonsterSpell20[MonsterNumber] != 0)
{
	if(rand(100) <= MonsterSpell20Percent[MonsterNumber])
	{
		CastMonsterSpell(Scriptpawn,MonsterSpell20[MonsterNumber]);
		return;
	}
}
}

function VasDebug(String Text, int level)
{
Local String text1,test2;

if(VasDebuglevel > 0)
{
	if(level <= VasDebuglevel)
	{
		if(level == 1)
			text1 = "* VasDebug L1 * ";
		if(level == 2)
			text1 = "** VasDebug L2 ** ";
		if(level == 3)
			text1 = "*** VasDebug L3 *** ";
		Log(text1$" "$Class.name$" - "$Text);
		}
	}
}

defaultproperties
{
	PlayersCast=True
	MonstersCast=True
	SpellName(1)="Heal"
	SpellName(2)="Mass Heal"
	SpellName(3)="Fire Ball"
	SpellName(4)="JetSpells - Ultima Mark"
	SpellName(5)="JetSpells - Ultima Recall"
	SpellName(6)="JetSpells - Ultima Energy Bolt"
	SpellName(7)="Reserved"
	SpellName(8)="Earth-quake"
	SpellName(9)="Lighting"
	SpellName(10)="Big"
	SpellName(11)="Small"
	SpellName(12)="Reactive Armor"
	SpellName(13)="Teleport"
	SpellName(14)="Summon Zombie"
	SpellName(15)="Chemeleon"
	SpellName(16)="Magic Dispel"
	SpellName(17)="Magic Protect"
	SpellName(18)="Summon Monsters"
	SpellName(19)="Summon The Fat Asses"
	SpellName(20)="Summon Undead"
	SpellName(21)="Summon Dragons"
	SpellName(22)="Jet Spells - Burn"
	SpellName(23)="Jet Spells - Zeal"
	SpellName(24)="Jet Spells - Toss"
	SpellName(25)="Jet Spells - Flame Strike"
	SpellName(26)="Jet Spells - Blade Fury!"
	SpellName(27)="Jet Spells - Confusion"
	SpellName(28)="Jet Spells - Ice Ball"
	SpellName(29)="Jet Spells - ~Flash~"
	SpellName(30)="Jet Spells - Drain"
	SpellName(31)="Jet Spells - Explosion"
	SpellName(32)="Jet Spells - Magic Missiles"
	SpellName(33)="Jet Spells - Volcano"
	SpellName(34)="Jet Spells - CounterSpell"
	SpellName(35)="Jet Spells - Inversion"
	SpellName(36)="Jet Spells - Magic Arrow"
	SpellName(37)="Jet Spells - Poison"
	SpellName(38)="Jet Spells - Beam"
	SpellName(39)="Jet Spells - Blast"
	SpellName(40)="Jet Spells - Invisibility"
	SpellName(41)="Jet Super Spells - Wind Scar"
	SpellClass(1)="VasCastSpell.VasCSHeal"
	SpellClass(2)="VasCastSpell.VasCSHealRing"
	SpellClass(3)="VasCastSpell.VasCSFireBall"
	SpellClass(4)="JetVasSpells.JetVasSpellMark"
	SpellClass(5)="JetVasSpells.JetVasSpellRecall"
	SpellClass(6)="JetVasSpells.JetVasSpellUOEbolt"
	SpellClass(7)="None"
	SpellClass(8)="VasCastSpell.VasCSEarthQuake"
	SpellClass(9)="VasCastSpell.VASCSLightingBolt"
	SpellClass(10)="vasCastSpell.VasCSGiant"
	SpellClass(11)="VasCastSpell.VasCSSmall"
	SpellClass(12)="VasCastSpell.VasCSReactiveArmor"
	SpellClass(13)="VasCastSpell.VasCSTeleport"
	SpellClass(14)="VasCSBonusPack1.VasCSZombieHead"
	SpellClass(15)="VasCSBonusPack1.VASCSDMCameleon"
	SpellClass(16)="VasCSBonusPack1.VASCSDispelMagic"
	SpellClass(17)="VasCastSpell.VasCPMagicProtect"
	SpellClass(18)="VasCSSummons.VasCSSummonsSetA"
	SpellClass(19)="VasCSSummons.VasCSSummonsSetB"
	SpellClass(20)="VasCSSummons.VasCSSummonsSetC"
	SpellClass(21)="VasCSSummons.VasCSSummonsSetD"
	SpellClass(22)="JetVasSpells.JetVasSpellBurn"
	SpellClass(23)="JetVasSpells.JetVasSpellZeal"
	SpellClass(24)="JetVasSpells.JetVasSpellToss"
	SpellClass(25)="JetVasSpells.JetVasSpellFlameStrike"
	SpellClass(26)="JetVasSpells.JetVasSpellBladeFury"
	SpellClass(27)="JetVasSpells.JetVasSpellConfusion"
	SpellClass(28)="JetVasSpells.JetVasSpellIceBall"
	SpellClass(29)="JetVasSpells.JetVasSpellFlash"
	SpellClass(30)="JetVasSpells.JetVasSpellSapStrength"
	SpellClass(31)="JetVasSpells.JetVasSpellExplosion"
	SpellClass(32)="JetVasSpells.JetVasSpellMagicMissiles"
	SpellClass(33)="JetVasSpells.JetVasSpellVolcano"
	SpellClass(34)="JetVasSpells.JetVasSpellCounterSpell"
	SpellClass(35)="JetVasSpells.JetVasSpellInversion"
	SpellClass(36)="JetVasSpells.JetVasSpellMagicArrow"
	SpellClass(37)="JetVasSpells.JetVasSpellPoison"
	SpellClass(38)="JetVasSpells.JetVasSpellBeam"
	SpellClass(39)="JetVasSpells.JetVasSpellBlast"
	SpellClass(40)="JetVasSpells.JetVasSpellInvisibility"
	SpellClass(41)="JetVasSpells.JetVasSpellWindScar"
	PointsRequired(1)=20
	PointsRequired(2)=50
	PointsRequired(3)=20
	PointsRequired(4)=35
	PointsRequired(5)=40
	PointsRequired(6)=70
	PointsRequired(8)=200
	PointsRequired(9)=30
	PointsRequired(10)=30
	PointsRequired(11)=15
	PointsRequired(12)=20
	PointsRequired(13)=60
	PointsRequired(14)=30
	PointsRequired(15)=30
	PointsRequired(16)=50
	PointsRequired(17)=50
	PointsRequired(18)=80
	PointsRequired(19)=120
	PointsRequired(20)=180
	PointsRequired(21)=250
	PointsRequired(22)=65
	PointsRequired(23)=1
	PointsRequired(24)=65
	PointsRequired(25)=90
	PointsRequired(26)=80
	PointsRequired(27)=110
	PointsRequired(28)=140
	PointsRequired(29)=110
	PointsRequired(30)=80
	PointsRequired(31)=90
	PointsRequired(32)=90
	PointsRequired(33)=110
	PointsRequired(34)=45
	PointsRequired(35)=70
	PointsRequired(36)=80
	PointsRequired(37)=80
	PointsRequired(38)=140
	PointsRequired(39)=80
	PointsRequired(40)=30
	PointsRequired(41)=170
	CastPercent(1)=60
	CastPercent(2)=30
	CastPercent(3)=40
	CastPercent(4)=10
	CastPercent(5)=20
	CastPercent(6)=25
	CastPercent(8)=1
	CastPercent(9)=20
	CastPercent(10)=20
	CastPercent(11)=60
	CastPercent(12)=30
	CastPercent(13)=30
	CastPercent(14)=30
	CastPercent(15)=30
	CastPercent(16)=30
	CastPercent(17)=60
	CastPercent(19)=-20
	CastPercent(20)=-30
	CastPercent(21)=-70
	CastPercent(22)=-10
	CastPercent(23)=10
	CastPercent(24)=-10
	CastPercent(26)=-20
	CastPercent(27)=-30
	CastPercent(28)=-40
	CastPercent(29)=-20
	CastPercent(32)=-20
	CastPercent(34)=10
	CastPercent(35)=-5
	CastPercent(36)=20
	CastPercent(37)=10
	CastPercent(38)=40
	CastPercent(39)=20
	CastPercent(41)=-10
	MonsterName(1)="aaa"
	MonsterName(4)="Dragons"
	MonsterName(5)="VasBeholder"
	MonsterName(6)="VasBeholderBody"
	MonsterName(7)="Demon"
	MonsterName(8)="Cyclops"
	MonsterName(9)="IceDaemon"
	MonsterName(10)="Elder"
	MonsterName(11)="DreadSark"
	MonsterSpell1(1)=1
	MonsterSpell1(4)=3
	MonsterSpell1(5)=6
	MonsterSpell1(6)=6
	MonsterSpell1(7)=22
	MonsterSpell1(8)=24
	MonsterSpell1(9)=28
	MonsterSpell1(10)=35
	MonsterSpell1(11)=38
	MonsterSpell1Percent(4)=30
	MonsterSpell1Percent(5)=10
	MonsterSpell1Percent(6)=70
	MonsterSpell1Percent(7)=20
	MonsterSpell1Percent(8)=10
	MonsterSpell1Percent(9)=85
	MonsterSpell1Percent(10)=30
	MonsterSpell1Percent(11)=20
	MonsterSpell2(5)=3
	MonsterSpell2(6)=33
	MonsterSpell2(7)=25
	MonsterSpell2(10)=36
	MonsterSpell2(11)=39
	MonsterSpell2Percent(5)=10
	MonsterSpell2Percent(6)=70
	MonsterSpell2Percent(7)=20
	MonsterSpell2Percent(10)=30
	MonsterSpell2Percent(11)=20
	MonsterSpell3(5)=1
	MonsterSpell3(7)=26
	MonsterSpell3(10)=37
	MonsterSpell3Percent(5)=5
	MonsterSpell3Percent(7)=15
	MonsterSpell3Percent(10)=10
	MonsterSpell4(7)=32
	MonsterSpell4(10)=28
	MonsterSpell4Percent(7)=15
	MonsterSpell4Percent(10)=30
}
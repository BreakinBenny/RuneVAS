//-----------------------------------------------------------
// VasCastSpell -  By Kal-Corp	Kal-Corp@cfl.rr.com
//	http://Vasserver.dyndns.org:88/KalsFor
//-----------------------------------------------------------
class VasCastSpell expands Info config(VasCastSpell);

var int PointsRequired;
Var int PlayerRunePower;
var string CastMassage;
Var bool CastSuccess;
Var bool CastTaunt;
Var name StrTaunt;
Var int Casterlevel;
Var Bool bPostSpell;
Var Bool bCastwithWeapon;
Var actor Caster;
Var vector DummyLocation,DummyLocation2;
Var int HealPoints;
Var int DamagePoints;
Var int Counter;
Var bool bEndSpell;
Var Bool bEndWithTimer;
Var bool bCastCheck;
Var int SpellLevel;
Var inventory tempinv;
Var config int VasDebuglevel;

function CastSpell(actor aCaster)
{
local PlayerReplicationInfo PRI;

VasDebug(" CastSpell Started Caster="$Caster,2);

VasDebug(" CastSpell PointsRequired="$PointsRequired$" Casterlevel="$Casterlevel$" bCastwithWeapon="$bCastwithWeapon,3);

	CastSuccess = True;
	CastMassage="You lack the Power to cast this spell";
	Caster = aCaster;

	if(Caster != none)
	{
		if(Caster.IsA('runeplayer'))
		{
			PRI = pawn(owner).PlayerReplicationInfo;
			Casterlevel = INT(PRI.OldName);
			if(casterlevel <=0)
				Casterlevel = 50;
			if(runeplayer(Caster).Health < 0)
			{
				bEndWithTimer=false;
				CastSuccess = false;
				PostSpell();
			}
			if(pawn(Caster).Region.Zone.bWaterZone)
			{
				CastMassage="You can't cast while swimming!";
				bEndWithTimer=false;
				CastSuccess = false;
				PostSpell();
			}
			if(pawn(Caster).Weapon != none)
			{
				if(!bCastwithWeapon)
				{
					CastMassage="You can't cast with this weapon in hand!";
					bEndWithTimer=false;
					CastSuccess = false;
					PostSpell();
				}
			}

			if((CastTaunt) && (Caster.AnimProxy != None))
			{
				if(Caster.AnimProxy.GetStateName() != 'Idle')
				{
					bEndWithTimer=false;
					CastSuccess = false;
					PostSpell();
				}
			}
		if(Caster.IsA('RunePlayer'))
		{
			if(Pawn(Caster).RunePower<PointsRequired)
			{
				CastMassage="You lack the Power to cast this spell";
				bEndWithTimer=false;
				CastSuccess = false;
				PostSpell();
			}
			Pawn(Caster).NextStateAfterPain = 'PlayerWalking';
		}
	}
	if(CastTaunt)
		Pawn(Caster).PlayUninterruptedAnim(StrTaunt);

	if(CastSuccess)
	{
		if(Caster.IsA('RunePlayer'))
		{
			Pawn(Caster).RunePower-=PointsRequired;
			DummyLocation=vector(Pawn(Caster).ViewRotation);
		}
		if(Caster.IsA('ScriptPawn'))
		{
			if(Pawn(Caster).Enemy != none)
			{
				if(!Caster.isa('Dragons'))
					DummyLocation= Normal(Pawn(Caster).Enemy.Location - (Caster.GetJointPos(Caster.JointNamed('rwrist'))));
				else
					DummyLocation= Normal(Pawn(Caster).Enemy.Location - (Caster.GetJointPos(Caster.JointNamed('llip'))));
			}
			else
				self.Destroy();
		}
		SpellRun();
	}
	}
	else
		VasDebug(" CastSpell Caster=NONE", 1);
}

function SpellRUN()
{
	if(bPostSpell)
		PostSpell();
}

function PostSpell()
{
	if(Caster.IsA('RunePlayer'))
		playerpawn(Caster).ClientMessage(CastMassage, 'Subtitle');
	if(!bEndWithTimer)
		bEndSpell = TRUE;
}

function VasCastEffect(actor EventInstigator)
{
local RespawnFire F;
	  F = Spawn(class'RespawnFire',pawn(EventInstigator),,pawn(EventInstigator).location);
}

function Tick(float DeltaTime)
{
	if(bEndSpell)
		Self.destroy();

	Super.Tick(DeltaTime);
}

Function EndSpell()
{
//  to end spell from outside
}

replication
{
	reliable if(Role<ROLE_Authority)
		CastSpell, PostSpell, SpellRUN;
}

function VasDebug(String Text, int level)
{
Local String text1,test2;

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
		Log(text1$" "$Class.name$" - "$Text);
	}
}
}

defaultproperties
{
	  CastTaunt=True
	  StrTaunt=X1_Taunt
	  bPostSpell=True
	  Counter=10
	  bCastCheck=True
	  SpellLevel=1
	  VasDebuglevel=1
}
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasCPMagicProtect expands VasCastSpell;

var int temp;
var float tempspeed;
var float tempcollisionsize1;
var float tempcollisionsize2;
Var weapon weapon, Weapon2;
var int Scriptpawncounter;
var VasCPMagicProtectRepl VasCPMagicProtectRepl;
var ParticleSystem F;

function SpellRUN()
{
	GetVASCPMPRepl();

	if(VasCPMagicProtectRepl == NONE)
	{
		CastMassage="You unsuccessfully cast Magic Protect!";
		PostSpell();
		CastSuccess = False;
		return;
	}
	VasCPMagicProtectRepl.magicProtect= true;
	CastMassage="You cast Magic Protect";
	CastSuccess = True;
	Counter=50;
	Scriptpawncounter = RandRange(10, 50);
	Temp = pawn(Caster).RunePower;
	SetTimer(1.000000,true);
	If (bPostSpell)
	PostSpell();
}

function GetVASCPMPRepl()
{
	foreach AllActors(class'VasCPMagicProtectRepl', VasCPMagicProtectRepl)
	{
		VasDebug(" SpellRUN All VasCPMagicProtectRepl="$VasCPMagicProtectRepl,3);
		if(VasCPMagicProtectRepl.owner == caster)
		{
			VasDebug(" ModifyPlayer VasCPMagicProtectRepl.owner == Caster -"$caster,2);
			Return;
		}
	}
	VasDebug(" SpellRUN VasCPMagicProtectRepl not found spawning", 2);
	VasCPMagicProtectRepl = Spawn(Class'VasCastSpell.VasCPMagicProtectRepl',caster);
	if(VasCPMagicProtectRepl == none)
		VasDebug(" SpellRUN VasCPMagicProtectRepl == NONE", 1);
return;
}

Function EndSpell()
{
	if(VasCPMagicProtectRepl != NONE)
	{
		VasCPMagicProtectRepl.magicProtect = False;
		VasCPMagicProtectRepl.Destroyed();
	}
bEndSpell=TRUE;
}

function timer()
{
	if( pawn(Caster).RunePower > temp )
		pawn(Caster).RunePower = temp;
pawn(Caster).RunePower -=3;
Temp = pawn(Caster).RunePower;
Scriptpawncounter -= 1;
}

function Tick(float DeltaTime)
{
if(Caster.IsA('playerPawn'))
{
	if((pawn(Caster).Health<=0) || (pawn(Caster).RunePower<=0))
		EndSpell();
}
if (Caster.IsA('ScriptPawn'))
{
	if((pawn(Caster).Health<=0) || (Scriptpawncounter<=0))
		EndSpell();
}
	Super.Tick(DeltaTime);
}

function CastEffect()
{
	F = Spawn(class'HelixEmpathy',pawn(caster),,pawn(caster).location);
	if(f != NONE)
		F.SetBase(caster);
}

defaultproperties
{
	bEndWithTimer=True
	SpellLevel=6
}
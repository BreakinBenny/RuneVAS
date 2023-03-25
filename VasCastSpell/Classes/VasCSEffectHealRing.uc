//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasCSEffectHealRing expands Effects;

var float TimePassed;
const StartRadius = 10.0;
const EndRadius=300;
const EffectTime=3.0;
var int Healpoints;
var int CasterLevel;
Var Actor Caster;

simulated function Spawned()
{
	TimePassed=0.0;
	ScaleGlow = EffectTime;
	DoRadiusEffect();
}


function DoRadiusEffect()
{
local pawn A;
local int i;

	foreach RadiusActors(class'Pawn', A, EndRadius * 2, Location)
	{
		if(A==Instigator)
			continue;
		if(A.bHidden)
			continue;
		if(!FastTrace(Location, A.Location))
			continue;
		if(a.IsA('scriptpawn'))
			continue;
		if(a.IsA('playerpawn'))
			if((caster.ScaleGlow != 0.004) && (a.ScaleGlow != 0.004))
				continue;
		CastHeal(A);
	}
}

Function CastHeal(Pawn ToHeal)
{
local VasCastSpell VasCastSpell;
local class<VasCastSpell> LoadSpell;

	LoadSpell = class<VasCastSpell>( DynamicLoadObject("VasCastSpell.VasCSHeal", class'Class' ));
	if(LoadSpell==None)
		return;
	VasCastSpell = Spawn( LoadSpell,ToHeal,,ToHeal.Location);
	if(VasCastSpell==None)
		return;
	VasCastSpell.PointsRequired =0;
	VasCastSpell.CastTaunt= False;
	VasCastSpell.Casterlevel = CasterLevel;
	VasCastSpell.Castspell(ToHeal);
}

simulated function Tick(float DeltaTime)
{
local float newRadius;

	TimePassed += DeltaTime;
	newRadius = StartRadius + (EndRadius-StartRadius) * (TimePassed/EffectTime);
	DrawScale = newRadius/StartRadius;
	ScaleGlow -= DeltaTime;
	if(ScaleGlow <= 0)
	Destroy();
}

defaultproperties
{
	HealPoints=50
	Casterlevel=50
	RemoteRole=ROLE_SimulatedProxy
	DrawType=DT_VerticalSprite
	Style=STY_Translucent
	Texture=Texture'RuneFX.Blastring'
	AmbientGlow=50
	CollisionRadius=22.000000
	CollisionHeight=22.000000
	bCollideActors=True
}
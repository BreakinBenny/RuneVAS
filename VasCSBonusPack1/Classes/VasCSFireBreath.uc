//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasCSFireBreath expands VasCastSpell;

function SpellRUN(){
	DamagePoints = RandRange(Casterlevel/4, Casterlevel/2);
	CastMassage="You cast FireBreath @ "$DamagePoints$" Powerlevel ";
	firebreath();
	PostSpell();
}

function firebreath(){
local actor a;
local vector l;
local vector FireLocation;

	FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('rwrist'));
	a = Spawn(class'VasCSFireBreathE', Caster,,FireLocation,pawn(Caster).ViewRotation);
	a.Velocity = DummyLocation * 50;
	a.SetPhysics(PHYS_Projectile);
}

defaultproperties{
	StrTaunt=X3_Taunt
}
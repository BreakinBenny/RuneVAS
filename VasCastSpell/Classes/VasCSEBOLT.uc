//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasCSEBOLT expands VasCastSpell;

Var bool BMassfireball;

function SpellRUN()
{
	DamagePoints = RandRange(Casterlevel/2, Casterlevel);
	if(DamagePoints < 10)
		DamagePoints = 10;
	CastMassage="You cast EnergyBolt @ "$DamagePoints$" Powerlevel ";
	ThrowFireball();
	PostSpell();
}

Function ThrowFireball()
{
local Projectile ball;
local vector FireLocation;
local int ballspeed;

	CastSuccess = True;
	if(!Caster.isa('Dragons'))
		FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('rwrist'));
	else
		FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('llip'));

	ball = Spawn(class'VasCSLightingBall',Caster,,FireLocation,pawn(Caster).ViewRotation);
	ball.SetPhysics(PHYS_Projectile);
	ball.Velocity = DummyLocation * ball.Speed;
	Ball.Damage = DamagePoints*2;
	if(Caster.isa('Dragons'))
	{
		Ball.drawscale = Ball.drawscale * 3;
		Ball.Damage = Ball.Damage * 3;
	}
	PlaySound(Sound'WeaponsSnd.PowerUps.aelec01', SLOT_Misc,,,, 1.0 + FRand()*0.4-0.2);
}

defaultproperties
{
	SpellLevel=6
}
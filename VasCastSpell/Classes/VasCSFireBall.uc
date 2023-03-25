//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasCSFireBall expands VasCastSpell;

Var bool BMassfireball;
Var int NumberOfTargets;

function SpellRUN()
{
	DamagePoints = RandRange(Casterlevel/4, Casterlevel/2);
	if(DamagePoints < 10)
		DamagePoints = 10 ;
	CastMassage="You cast FireBall @ "$DamagePoints$" Powerlevel ";
	ThrowFireball();
	PostSpell();
}

Function ThrowFireball()
{
local Projectile ball;
local vector FireLocation;
local int ballspeed;
	NumberOfTargets +=1;
	CastSuccess = True;
	if(Caster.IsA('runeplayer'))
		FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('rwrist'));
	else
	{
		if(!Caster.isa('Dragons'))
			FireLocation = Caster.location;
		else
			FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('llip'));
	}
	ball = Spawn(class'VasCSProjectileFireball',Caster,,FireLocation,pawn(Caster).ViewRotation);
	ball.SetPhysics(PHYS_Projectile);
	if(BMassfireball)
		ball.Velocity = Normal(Caster.location - FireLocation) * ball.Speed;
	else
		ball.Velocity = DummyLocation * ball.Speed;
	Ball.Damage = DamagePoints;
	if(Caster.isa('Dragons'))
	{
		Ball.drawscale = Ball.drawscale * 3;
		Ball.Damage = Ball.Damage * 3;
	}
	PlaySound(Sound'CreaturesSnd.Mech.mechfire01', SLOT_Misc,,,, 1.0 + FRand()*0.4-0.2);
}

defaultproperties
{
	SpellLevel=3
}
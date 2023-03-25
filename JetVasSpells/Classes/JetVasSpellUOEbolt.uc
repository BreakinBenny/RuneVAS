//=============================================================================
// JetVasSpellUOEbolt.
//=============================================================================
class JetVasSpellUOEbolt expands VasCSEBOLT;

Var bool BMassfireball;

function SpellRUN(){
	DamagePoints = RandRange(Casterlevel/2.55, Casterlevel/1.55);
	if(DamagePoints < 20)
		DamagePoints = 20;
	CastMassage="You cast Ultima Energy Bolt @ "$DamagePoints$" Powerlevel ";
	ThrowFireball();
	PostSpell();
}

Function ThrowFireball(){
local Projectile ball;
local vector FireLocation;
local int ballspeed;

	CastSuccess = True;
	if(!Caster.isa('Dragons'))
		FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('rwrist'));
	else
		FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('llip'));

	ball = Spawn(class'JetVasSpells.JetVasSpellUOEnergyBoltProj',Caster,,FireLocation,pawn(Caster).ViewRotation);
	ball.SetPhysics(PHYS_Projectile);
	ball.Velocity = DummyLocation * ball.Speed;
	Ball.Damage = DamagePoints*2;
	if(Caster.isa('Dragons'))
		Ball.drawscale = Ball.drawscale * 3;
	self.setLocation(FireLocation);
	self.PlaySound(Sound'JetVasSounds.Package0.nrgybolt', SLOT_Misc,,,, 1.0 + FRand()*0.4-0.2);
}

defaultproperties{}
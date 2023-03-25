//=============================================================================
// JetVasSpellBlast.
//=============================================================================
class JetVasSpellBlast expands VasCastSpell;

function SpellRUN(){
local JVSP JVSP;
	DamagePoints = RandRange(Casterlevel/4, Casterlevel/2);
	if(DamagePoints < 10)
		DamagePoints = 10;
	CastMassage="You cast Blast @ "$DamagePoints$" Powerlevel ";
	ThrowFireball();
	PostSpell();
}

Function ThrowFireball(){
	 local int x;
	 local Projectile ball;
	 local vector FireLocation;
	 //local int ballspeed;
	 CastSuccess = True;
	 if(Caster.IsA('runeplayer'))
		FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('rwrist'));
	else{
		if(!Caster.isa('Dragons'))
			FireLocation = Caster.location;
		else
			FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('llip'));
	}
	for(x = 0; x<5; x++){
		ball = Spawn(class'BlastProjectile',Caster,,FireLocation,pawn(Caster).ViewRotation);
		ball.SetPhysics(PHYS_Projectile);
		ball.Velocity = DummyLocation * ball.Speed;
		Ball.Damage = DamagePoints;
		if(Caster.isa('Dragons')){
			Ball.drawscale = Ball.drawscale * 3;
			Ball.Damage = Ball.Damage * 3;
		}
		Ball.Velocity.X*=RandRange(0.8,1.2);
		Ball.Velocity.Y*=RandRange(0.8,1.2);
		Ball.Velocity.Z*=RandRange(0.65,1.35);
	}
	self.setLocation(FireLocation);
	self.PlaySound(Sound'CreaturesSnd.Mech.mechcrash01', SLOT_Misc,,,, 1.0 + FRand()*0.4-0.2);
}

defaultproperties{}
//=============================================================================
// JetVasSpellBladeFury.
//=============================================================================
class JetVasSpellBladeFury expands VasCastSpell;

Var bool BMassfireball;

function SpellRUN(){
	DamagePoints = RandRange(Casterlevel/3, Casterlevel/2);
	if(DamagePoints < 10)
		DamagePoints = 10;
	CastMassage="You cast Blade Fury @ "$DamagePoints$" power level ";
	ThrowFireball();
	PostSpell();
}

Function ThrowFireball(){
	 local Projectile ball;
	 local Debris debris;
	 local vector FireLocation;
	 local int ballspeed;

	CastSuccess = True;
	if(!Caster.isa('Dragons'))
		FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('rwrist'));
	else
		FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('llip'));

	 ball = Spawn(class'JetVasSpells.JetVasSpellBladeFuryProjectile',Caster,,FireLocation,pawn(Caster).ViewRotation);
	 ball.SetPhysics(PHYS_Projectile);
	 ball.Velocity = DummyLocation * ball.Speed;
	 Ball.Damage = DamagePoints*2;
	 debris = Spawn(class'RuneI.DebrisStone',Caster,,FireLocation,pawn(Caster).ViewRotation);
}

defaultproperties{}
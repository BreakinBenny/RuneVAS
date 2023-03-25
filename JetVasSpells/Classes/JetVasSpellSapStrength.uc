class JetVasSpellSapStrength expands VasCastSpell;

Var bool BMassfireball;

function SpellRUN(){
	CastMassage="You cast Drain";
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

	ball = Spawn(class'JetVasSpells.JetVasSpellStrengthSapper',Caster,,FireLocation,pawn(Caster).ViewRotation);
	ball.SetPhysics(PHYS_Projectile);
	ball.Velocity = DummyLocation * ball.Speed;
	debris = Spawn(class'RuneI.DebrisStone',Caster,,FireLocation,pawn(Caster).ViewRotation);
}

defaultproperties{}
//=============================================================================
// JetVasSpellPoison.
//=============================================================================
class JetVasSpellPoison expands VasCastSpell;

Var bool BMassfireball;

function SpellRUN(){
	DamagePoints = RandRange(Casterlevel/26.0, Casterlevel/20.5);
	if(DamagePoints < 3)
		DamagePoints = 3;
	CastMassage="You cast Poison @ "$DamagePoints*12$" Powerlevel ";
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

	ball = Spawn(class'JetVasSpells.JetVasSpellPoisonProj',Caster,,FireLocation,pawn(Caster).ViewRotation);
	ball.SetPhysics(PHYS_Projectile);
	ball.Velocity = DummyLocation * ball.Speed;
	ball.Damage = DamagePoints;
	if(Caster.isa('ScriptPawn'))
		Ball.Damage = Ball.Damage * 3;
}

defaultproperties{}
//=============================================================================
// JetVasSpellIceBall.
//=============================================================================
class JetVasSpellIceBall expands VasCastSpell;

Var bool BMassfireball;
Var int NumberOfTargets;

function SpellRUN(){
	DamagePoints = RandRange(Casterlevel/3, Casterlevel/1.5);
	if(DamagePoints < 10)
		DamagePoints = 10;
	CastMassage="You cast Ice Ball @ "$DamagePoints$" Powerlevel";
	ThrowFireball();
	PostSpell();
}

Function ThrowFireball(){
local Projectile ball;
local vector FireLocation;
local int ballspeed;
	NumberOfTargets +=1;
	CastSuccess = True;
		if(Caster.IsA('runeplayer'))
			FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('rwrist'));
		else{
			if(!Caster.isa('Dragons'))
				FireLocation = Caster.location;
			else
				FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('llip'));
		}
	ball = Spawn(class'JetVasSpells.JetVasSpellIceballProjectile',Caster,,FireLocation,pawn(Caster).ViewRotation);
	ball.SetPhysics(PHYS_Projectile);
		if(BMassfireball)
			ball.Velocity = Normal(Caster.location - FireLocation) * ball.Speed;
		else
			ball.Velocity = DummyLocation * ball.Speed;
		if(Caster.isa('RunePlayer'))
	Ball.Damage = DamagePoints;
	if(Caster.isa('SciptPawn') && !Caster.isa('IceDaemon')){
		Ball.Damage = DamagePoints * 2;
		if(Caster.isa('IceDaemon'))
			Ball.Damage = DamagePoints * 2 + 20;
	}
	PlaySound(Sound'CreaturesSnd.Mech.mechfire01', SLOT_Misc,,,, 1.0 + FRand()*0.4-0.2);
}

defaultproperties{}
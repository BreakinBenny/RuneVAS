//=============================================================================
// JetVasSpellFlameStrike.
//=============================================================================
class JetVasSpellFlameStrike expands VasCastSpell;

Var int NumberOfTargets;

function SpellRUN(){
	DamagePoints = RandRange(Casterlevel/1.7, Casterlevel/0.825);
	if(DamagePoints < 25)
		DamagePoints = 25;
	CastMassage="You cast Flame Strike @ "$DamagePoints$" Powerlevel ";
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
	ball = Spawn(class'JetVasSpells.JetVasSpellProjectileFlamestrike',Caster,,FireLocation,pawn(Caster).ViewRotation);
	ball.SetPhysics(PHYS_Projectile);
	ball.Velocity = DummyLocation * ball.Speed;
	Ball.Damage = DamagePoints;
	Ball.Instigator = Pawn(Caster);
	if(Caster.isa('Dragons')){
		Ball.drawscale = Ball.drawscale * 3;
		Ball.Damage = Ball.Damage * 3;
	}
	self.setLocation(FireLocation);
	PlaySound(Sound'CreaturesSnd.Mech.mechfire01', SLOT_Misc,,,, 1.0 + FRand()*0.4-0.2);
}

defaultproperties{
	bHidden=False
}
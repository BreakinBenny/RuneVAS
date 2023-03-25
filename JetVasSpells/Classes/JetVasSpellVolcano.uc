//=============================================================================
// JetVasSpellVolcano.
//=============================================================================
class JetVasSpellVolcano expands VasCastSpell;

function SpellRUN(){
	DamagePoints = RandRange(Casterlevel/4, Casterlevel/2);
	if(DamagePoints < 10)
		DamagePoints = 15;
	CastMassage="You cast Volcano @ "$DamagePoints*2$" Powerlevel ";
	ThrowFireball();
	PostSpell();
}

Function ThrowFireball(){
local Projectile ball;
local vector FireLocation;
local int ballspeed;
	CastSuccess = True;
	if(Caster.IsA('runeplayer'))
		FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('rwrist'));
	else{
		if(!Caster.isa('Dragons'))
			FireLocation = Caster.location;
		else
			FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('llip'));
	}
	ball = Spawn(class'JetVasSpells.JetVasSpellVolcanoProj',Caster,,FireLocation,pawn(Caster).ViewRotation);
	ball.SetPhysics(PHYS_Projectile);
	ball.Velocity = DummyLocation * ball.Speed;
	Ball.Damage = DamagePoints;
	self.setLocation(FireLocation);
	self.PlaySound(Sound'OtherSnd.Explosions.explosion02', SLOT_None,,,, 1.0 + FRand()*0.4-0.2);
}

defaultproperties{}
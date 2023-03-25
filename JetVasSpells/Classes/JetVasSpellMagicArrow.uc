//=============================================================================
// JetVasSpellMagicArrow.
//=============================================================================
class JetVasSpellMagicArrow expands VasCastSpell;

function SpellRUN(){
	DamagePoints = RandRange(Casterlevel/2.7, Casterlevel/1.8);
	if(DamagePoints < 10)
		DamagePoints = 12 ;
	CastMassage="You cast Magic Arrow @ "$DamagePoints$" Powerlevel ";
	ThrowFireball();
	PostSpell();
}

Function ThrowFireball()
{
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
	ball = Spawn(class'JetVasSpells.MagicArrow',Caster,,FireLocation,pawn(Caster).ViewRotation);
	ball.SetPhysics(PHYS_Projectile);
	ball.Velocity = DummyLocation * ball.Speed;
	ball.Instigator = Pawn(Caster);
	Ball.Damage = DamagePoints;
	if(Caster.isa('ScriptPawn'))
		Ball.Damage = Ball.Damage * 3;
	self.setLocation(FireLocation);
	self.PlaySound(Sound'CreaturesSnd.Mech.mechfire01', SLOT_Misc,,,, 1.0 + FRand()*0.4-0.2);
}

defaultproperties{}
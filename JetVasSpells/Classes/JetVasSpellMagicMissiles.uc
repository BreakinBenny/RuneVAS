class JetVasSpellMagicMissiles expands VasCastSpell;

Var bool BMassfireball;
Var int NumberOfTargets;

function SpellRUN(){
local int blahblah;
	DamagePoints = RandRange(Casterlevel/5.5, Casterlevel/4.1);
	if(DamagePoints < 6)
		DamagePoints = 6 ;
	Blahblah = DamagePoints * 3;
	CastMassage="You cast Magic Missiles @ "$Blahblah$" Powerlevel ";
	ThrowFireball();
	PostSpell();
}

Function ThrowFireball(){
local Projectile ball;
local Projectile ball2;
local Projectile ball3;
local vector FireLocation;
local int ballspeed;
local vector FireLocation2;
local vector FireLocation3;

	NumberOfTargets +=1;
	CastSuccess = True;
	if(Caster.IsA('runeplayer')){
		FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('rwrist'));
		FireLocation2 = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('rwrist'));
		FireLocation3 = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('rwrist'));
	}
	else{
		if(!Caster.isa('Dragons')){
			FireLocation = Caster.location;
			FireLocation2 = Caster.location;
			FireLocation3 = Caster.location;
		}
		else{
			FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('llip'));
			FireLocation2 = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('llip'));
			FireLocation3 = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('llip'));
		}
	}
	// Whew!

	FireLocation.Z = RandRange(FireLocation.Z - 5, FireLocation.Z + 10);
	FireLocation.X = RandRange(FireLocation.X - 5, FireLocation.X + 5);
	FireLocation.Y = RandRange(FireLocation.Y - 5, FireLocation.Y + 5);
	FireLocation2.Z = RandRange(FireLocation2.Z - 5, FireLocation2.Z + 10);
	FireLocation2.X = RandRange(FireLocation2.X - 5, FireLocation2.X + 5);
	FireLocation2.Y = RandRange(FireLocation2.Y - 5, FireLocation2.Y + 5);
	FireLocation3.Z = RandRange(FireLocation3.Z - 5, FireLocation3.Z + 10);
	FireLocation3.X = RandRange(FireLocation3.X - 5, FireLocation3.X + 5);
	FireLocation3.Y = RandRange(FireLocation3.Y - 5, FireLocation3.Y + 5);

	ball = Spawn(class'JetVasSpells.JetVasSpellMagicMissile',Caster,,FireLocation,pawn(Caster).ViewRotation);
	ball.SetPhysics(PHYS_Projectile);
	ball.Instigator = Pawn(Caster);
	ball2 = Spawn(class'JetVasSpells.JetVasSpellMagicMissile',Caster,,FireLocation2,pawn(Caster).ViewRotation);
	ball2.SetPhysics(PHYS_Projectile);
	ball2.Instigator = Pawn(Caster);
	ball3 = Spawn(class'JetVasSpells.JetVasSpellMagicMissile',Caster,,FireLocation3,pawn(Caster).ViewRotation);
	ball3.SetPhysics(PHYS_Projectile);
	ball3.Instigator = Pawn(Caster);
	if(BMassfireball){
		ball.Velocity = Normal(Caster.location - FireLocation) * ball.Speed;
		ball2.Velocity = Normal(Caster.location - FireLocation) * ball2.Speed;
		ball3.Velocity = Normal(Caster.location - FireLocation) * ball3.Speed;
	}
	else{
		ball.Velocity = DummyLocation * ball.Speed;
		ball2.Velocity = DummyLocation * ball2.Speed;
		ball3.Velocity = DummyLocation * ball3.Speed;
	}
	Ball.Damage = RandRange(DamagePoints * 0.85,DamagePoints * 1.15);
	Ball2.Damage = RandRange(DamagePoints * 0.85,DamagePoints * 1.15);
	Ball3.Damage = RandRange(DamagePoints * 0.85,DamagePoints * 1.15);
	if(Caster.isa('Dragons')){
		Ball.drawscale = Ball.drawscale * 2;
		Ball.Damage = Ball.Damage * 2;
		Ball2.drawscale = Ball2.drawscale * 2;
		Ball2.Damage = Ball2.Damage * 2;
		Ball3.drawscale = Ball3.drawscale * 2;
		Ball3.Damage = Ball3.Damage * 2;
	}
	PlaySound(Sound'CreaturesSnd.Mech.mechfire01', SLOT_Misc,,,, 1.0 + FRand()*0.4-0.2);
}

defaultproperties{}
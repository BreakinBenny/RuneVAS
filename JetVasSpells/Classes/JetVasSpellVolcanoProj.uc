//=============================================================================
// JetVasSpellVolcanoProj.
//=============================================================================
class JetVasSpellVolcanoProj expands VasCSProjectileFireball;

simulated function PreBeginPlay(){
	effect = Spawn(class'TrailFire', , , , Rotation);
	trail_effect = Spawn(class'Fire', , , , Rotation);
	effect.SetBase(self);
	effect.drawscale = drawscale;
	trail_effect.SetBase(self);
	trail_effect.drawscale = drawscale;
}

simulated function ProcessTouch(Actor Other, Vector HitLocation){
	if(other != owner){
		if(Other.IsA('Weapon'))
			return;

		Other.JointDamaged(Damage, pawn(owner), HitLocation, MomentumTransfer*Normal(Velocity), MyDamageType, 0);

		if(Pawn(Other) != None)
			Explode(Other.Location+vect(0,0,1)*Pawn(Other).EyeHeight, -Normal(Velocity));
		else
			Explode(HitLocation, -Normal(Velocity));
	}
}

simulated function Landed(vector HitNormal, actor HitActor){
	Explode(Location, HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal){
local VolcanoBalls Balls;
local int x;
local BigFire BF;
local JVSP JVSP;
JVSP = spawn(class'JetVasSpells.JVSP',self, , HitLocation);
JVSP.Sound = Sound'OtherSnd.Explosions.explosion10';
//PlaySound(Sound'OtherSnd.Explosions.explosion02', SLOT_None,,,, 1.0 + FRand()*0.4-0.2);

	for(x = 0; x<10; x++){
		Balls = spawn(class'JetVasSpells.VolcanoBalls', Pawn(Owner), , HitLocation + vect(0,0,20), rotator(HitNormal));
		Balls.Damage = (Damage/1.5) * RandRange(0.9, 1.1);
		Balls.OwnerPawn = Pawn(Owner);
	}
	
	BF = spawn(class'BigFire', Pawn(Owner), , HitLocation + vect(0,0,25), rotator(HitNormal));
	BF.LifeSpan = 1.5;

	spawn(class'RuneI.MechRocketExplosion',self, , HitLocation, rotator(HitNormal));
	Destroy();
}

defaultproperties{
	speed=600.000000
	LifeSpan=10.000000
}
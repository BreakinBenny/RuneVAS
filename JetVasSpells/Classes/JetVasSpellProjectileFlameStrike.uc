//=============================================================================
// JetVasSpellProjectileFlameStrike.
//=============================================================================
class JetVasSpellProjectileFlameStrike expands VasCSProjectileFireball;

var ParticleSystem effect;
var ParticleSystem trail_effect;
var bool bBigBall;

simulated function PreBeginPlay(){
	effect = Spawn(class'VasCSEffectFireball', , , , Rotation);
	trail_effect = Spawn(class'VasCSEffectFireballtrail', , , , Rotation);
	effect.SetBase(self);
	effect.drawscale = drawscale;
	trail_effect.SetBase(self);
	trail_effect.drawscale = drawscale;
}

simulated function Destroyed(){
	if(effect != None)
		effect.Destroy();
	if(trail_effect != None)
		trail_effect.Destroy();
}

simulated function ProcessTouch(Actor Other, Vector HitLocation){
	if(other != owner){
		if(Other.IsA('Weapon')){
			Explode(Other.Location+vect(0,0,1)*Pawn(Other).EyeHeight, -Normal(Velocity));
			return;
		}
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
local JVSP JVSP;
local JetVasSpellFlameStrikeFire2 thefire;
	spawn(class'RuneI.MechRocketExplosion',self, , HitLocation, rotator(HitNormal));
	thefire = spawn(class'JetVasSpells.JetVasSpellFlameStrikeFire2',self, , HitLocation, rotator(HitNormal));
	thefire.OwnedBy = Pawn(Owner);
	thefire.DamagePerSecond = Damage / 1.9;
JVSP = spawn(class'JetVasSpells.JVSP',self, , HitLocation);
JVSP.Sound = Sound'JetVasSounds.Package0.flamstrk';
	Destroy();
}

simulated function Debug(Canvas canvas, int mode){
	Super.Debug(canvas,mode);
	Canvas.DrawLine3D(Location, Location + vector(Rotation) * 50, 0,0,250);
}

defaultproperties{
	speed=600.000000
	MaxSpeed=1000.000000
	Damage=15.000000
	SpawnSound=Sound'WeaponsSnd.PowerUps.aalli01'
	ImpactSound=Sound'WeaponsSnd.PowerUps.powerstart26'
	LifeSpan=8.000000
	DrawScale=4.000000
	AmbientGlow=255
	DesiredColorAdjust=(X=255.000000)
	DesiredFatness=77
}
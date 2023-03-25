//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasCSProjectileFireball expands Projectile;

var ParticleSystem effect;
var ParticleSystem trail_effect;
var bool bBigBall;

simulated function PreBeginPlay()
{
	effect = Spawn(class'VasCSEffectFireball', , , , Rotation);
	trail_effect = Spawn(class'VasCSEffectFireballtrail', , , , Rotation);
	effect.SetBase(self);
	effect.drawscale = drawscale;
	trail_effect.SetBase(self);
	trail_effect.drawscale = drawscale;
}


simulated function Destroyed()
{
	if(effect != None)
		effect.Destroy();
	if(trail_effect != None)
		trail_effect.Destroy();
}


simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if(other != owner)
	{
		if(Other.IsA('Weapon'))
			return;

		Other.JointDamaged(Damage, pawn(owner), HitLocation, MomentumTransfer*Normal(Velocity), MyDamageType, 0);

		if(Pawn(Other) != None)
			Explode(Other.Location+vect(0,0,1)*Pawn(Other).EyeHeight, -Normal(Velocity));
		else
			Explode(HitLocation, -Normal(Velocity));
	}
}

simulated function Landed(vector HitNormal, actor HitActor)
{
	Explode(Location, HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
/*	if(bBigBall) {
		spawn(class'VasBigFireBall', owner, , HitLocation);
		Destroy();
	}
	else {
		spawn(class'RuneI.MechRocketExplosion',self, , HitLocation, rotator(HitNormal));
		Destroy();
	}*/
}

simulated function Debug(Canvas canvas, int mode)
{
	Super.Debug(canvas,mode);
	Canvas.DrawLine3D(Location, Location + vector(Rotation) * 50, 0,0,250);
}

defaultproperties
{
	speed=1000.000000
	Damage=10.000000
	MyDamageType=Fire
	RemoteRole=ROLE_None
	LifeSpan=3.000000
	DrawType=DT_None
	ScaleGlow=2.000000
	AmbientGlow=50
	CollisionRadius=20.000000
	CollisionHeight=20.000000
	Skeletal=SkelModel'objects.Rocks'
}
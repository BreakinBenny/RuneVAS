//=============================================================================
// BlastProjectile.
//=============================================================================
class BlastProjectile expands Projectile;

var ParticleSystem effect;

simulated function PreBeginPlay(){
	effect = Spawn(class'BlastProjectileEffect', , , , Rotation);
	effect.SetBase(self);
}

simulated function Destroyed(){
	if (effect != None)
		effect.Destroy();
}


simulated function ProcessTouch(Actor Other, Vector HitLocation){
Local pawn damagefrom;

if(owner != NONE)
	damagefrom = pawn(owner);
else
	damagefrom = NONE;

	if(other != NONE){
		if(other != owner){
			if(Other.IsA('Weapon'))
				return;
			if(Other.IsA('pawn')){
				pawn(Other).JointDamaged(Damage,damagefrom, HitLocation, MomentumTransfer*Normal(Velocity), MyDamageType, 0);
				if(Pawn(Other) != None)
					Explode(Other.Location+vect(0,0,1)*Pawn(Other).EyeHeight, -Normal(Velocity));
				else
					Explode(HitLocation, -Normal(Velocity));
			}
		}
	}
}

simulated function Landed(vector HitNormal, actor HitActor){
	Explode(Location, HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal){
	spawn(class'JetVasSpells.FlamingStone',self, , HitLocation, rotator(HitNormal));
	Destroy();
}

simulated function Debug(Canvas canvas, int mode){
	Super.Debug(canvas,mode);
	Canvas.DrawLine3D(Location, Location + vector(Rotation) * 50, 0,0,250);
}

defaultproperties{
	speed=900.000000
	MaxSpeed=900.000000
	Damage=5.000000
	MyDamageType=magic
	RemoteRole=ROLE_None
}
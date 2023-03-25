//=============================================================================
// JetVasSpellBladeFuryProjectile.
//=============================================================================
class JetVasSpellBladeFuryProjectile expands Projectile;

var ParticleSystem trail_effect;

simulated function PreBeginPlay(){
	trail_effect = Spawn(class'JetVasSpellFlameStrikeTrail', , , , Rotation);
	trail_effect.SetBase(self);
	trail_effect.drawscale = drawscale;
}


simulated function Destroyed(){
	if(trail_effect != None)
		trail_effect.Destroy();
}

simulated function ProcessTouch(Actor Other, Vector HitLocation){
Local pawn damagefrom;

if(owner != NONE)
	damagefrom = pawn(owner);
else
	damagefrom = NONE;

	if(other != NONE){
		if (other != owner){
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
	Destroy();
}

simulated function Debug(Canvas canvas, int mode){
	Super.Debug(canvas,mode);
	Canvas.DrawLine3D(Location, Location + vector(Rotation) * 50, 0,0,250);
}

simulated function Tick(float DeltaTime)
{
local JetVasSpellUOEnergyBoltProj UOB;
local ShockBomb ShockBomb;
	foreach RadiusActors(class'JetVasSpellUOEnergyBoltProj', UOB, 30){
		ShockBomb = spawn(class'JetVasSpells.ShockBomb', Pawn(Owner), ,UOB.Location);
		ShockBomb.OwnerPawn = Pawn(Owner);
		ShockBomb.Damage = (Damage+UOB.Damage)/2;	// Average
		ShockBomb.Damage = ShockBomb.Damage / 3;
		UOB.Destroy();
		Destroy();
	}
}

defaultproperties{
	speed=2100.000000
	MaxSpeed=2100.000000
	Damage=10.000000
	MyDamageType=Sever
	RemoteRole=ROLE_None
	LifeSpan=15.000000
	CollisionRadius=4.000000
	CollisionHeight=4.000000
	Skeletal=SkelModel'weapons.worksword'
}
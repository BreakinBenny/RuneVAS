//=============================================================================
// JetVasSpellMagicMissile.
//=============================================================================
class JetVasSpellMagicMissile expands Seeker;

var Pawn TargetPawn;
var VasCSEffectFireballtrail Trail;
var() float ConvergeFactor;

var float TimeToDamage;

simulated function PreBeginPlay(){
local vector X,Y,Z;

	Trail = Spawn(class'JetVasSpells.MagicMissileTrail');
	Trail.SetBase(self);

	GetAxes(Rotation,X,Y,Z);
	Velocity = X * Speed;
}


simulated function Destroyed(){
	Trail.Destroy();
}

simulated function Tick(float DeltaTime){
	local vector Dir;
	local Pawn aPawn;
	local float dist, bestdist;

	Super.Tick(DeltaTime);
	
	if(TargetPawn==None || TargetPawn.Health<=0 || Rand(100) < 50){
		// Find a new target
		bestdist = 5;
		TargetPawn = None;
		foreach VisibleCollidingActors(class'Pawn', aPawn, 5){
			dist = VSize(aPawn.Location-Location);
			if(aPawn != Instigator && aPawn != Pawn(Owner) && aPawn.Health > 0 && dist < bestdist){
				// Target this pawn
				TargetPawn = aPawn;
				bestdist = dist;
			}
		}
	}
	else{
		Dir = Normal( Normal(Velocity) + DeltaTime * ConvergeFactor * Normal(TargetPawn.Location-(Location * (RandRange(8,12) / 10))));
		Velocity = Dir * MaxSpeed;
		Velocity.X = Velocity.X * (RandRange(87,112) / 100);
		Velocity.Y = Velocity.Y * (RandRange(87,112) / 100);
		Velocity.Z = Velocity.Z * (RandRange(87,112) / 100);
	}

	if(TimeToDamage > 0)
		TimeToDamage -= DeltaTime;

Velocity.X = Velocity.X * (RandRange(85,115) / 100);
Velocity.Y = Velocity.Y * (RandRange(85,115) / 100);
Velocity.Z = Velocity.Z * (RandRange(85,115) / 100);
}

simulated function HitWall (vector HitNormal, actor Wall){
	Explode(Location, HitNormal);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation){
	if(Other.IsA('Weapon'))
		return;

		Other.JointDamaged(Damage, Instigator, HitLocation, Velocity, MyDamageType, 0);
		Explode(Location, vect(0, 0, 1));
}

simulated function Explode(vector HitLocation, vector HitNormal){
	spawn(class'JetVasSpells.JetVasSpellZealEffect',self, , HitLocation, rotator(HitNormal));
	spawn(class'RuneI.EmpathyFlash',self, , HitLocation, rotator(HitNormal));
	Destroy();
}

defaultproperties{
	ConvergeFactor=1.000000
	speed=700.000000
	MaxSpeed=700.000000
	Damage=10.000000
	MyDamageType=magic
	RemoteRole=ROLE_None
	LifeSpan=5.000000
	DrawType=DT_Sprite
	Style=STY_Translucent
	Texture=Texture'RuneFX.odincorona'
	SoundRadius=32
	SoundVolume=0
	AmbientSound=None
}
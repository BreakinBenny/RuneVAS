//=============================================================================
// MagicArrow.
//=============================================================================
class MagicArrow expands JetVasSpellMagicMissile;

var MagicArrowEffect Trail2;
var int CanHit;

simulated function PreBeginPlay(){
local vector X,Y,Z;

	Trail2 = Spawn(class'JetVasSpells.MagicArrowEffect');
	Trail2.SetBase(self);

	GetAxes(Rotation,X,Y,Z);
	Velocity = X * Speed;
	CanHit = 1;
}

simulated function Destroyed(){
	Trail2.Destroy();
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
		Dir = Normal( Normal(Velocity) + DeltaTime * ConvergeFactor * Normal(TargetPawn.Location-Location));
		Velocity = Dir * MaxSpeed;
	}

	if(TimeToDamage > 0)
		TimeToDamage -= DeltaTime;
}

simulated function HitWall(vector HitNormal, actor Wall){
	Explode(Location, HitNormal);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation){
	if(Other.IsA('Weapon') || CanHit == 0)
		return;

	Other.JointDamaged(Damage, Instigator, HitLocation, Velocity, MyDamageType, 0);

	//Explode(Location, vect(0, 0, 1));
	CanHit = 0;
	setTimer(0.5,false);
}

function Timer(){
	CanHit = 1;
}

simulated function Explode(vector HitLocation, vector HitNormal){
	spawn(class'RuneI.EmpathyFlash',self, , HitLocation, rotator(HitNormal));
	Destroy();
}

defaultproperties{
	ConvergeFactor=4.000000
	speed=900.000000
}
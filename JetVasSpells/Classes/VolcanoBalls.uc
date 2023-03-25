//=============================================================================
// VolcanoBalls.
//=============================================================================
class VolcanoBalls expands VasCSProjectileFireball;

var Pawn OwnerPawn;

simulated function PreBeginPlay(){
	effect = Spawn(class'VasCSEffectFireball', , , , Rotation);
	trail_effect = Spawn(class'VasCSEffectFireballtrail', , , , Rotation);
	effect.SetBase(self);
	effect.drawscale = drawscale;
	trail_effect.SetBase(self);
	trail_effect.drawscale = drawscale;
	
	Velocity.Z = RandRange(250.0, 500.0);
	Velocity.X = RandRange(-120.0, 120.0);
	Velocity.Y = RandRange(-120.0, 120.0);
	
	setTimer(0.12, true);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation){
	if (other != OwnerPawn){
		Other.JointDamaged(Damage, OwnerPawn, HitLocation, MomentumTransfer*Normal(Velocity), MyDamageType, 0);

		if(Pawn(Other) != None)
			Explode(Other.Location+vect(0,0,1)*Pawn(Other).EyeHeight, -Normal(Velocity));
		else
			Explode(HitLocation, -Normal(Velocity));
	}
}

function Timer(){
	Velocity.Z -= 42;
	setTimer(0.12, true);
}

defaultproperties{
	LifeSpan=10.000000
}
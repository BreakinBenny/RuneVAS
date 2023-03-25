//=============================================================================
// JetVasSpellIceBallProjectile.
//=============================================================================
class JetVasSpellIceBallProjectile expands VasCSProjectileFireball;

var ParticleSystem effect;
var ParticleSystem trail_effect;
var bool bBigBall;

simulated function PreBeginPlay(){
	effect = Spawn(class'JetVasSpells.JetVasSpellIceballEffect', , , , Rotation);
	trail_effect = Spawn(class'JetVasSpells.JetVasSpellIceBallEffect', , , , Rotation);
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
		if(Other.IsA('Weapon'))
			return;
		if(Damage < Pawn(Other).Health)
			Other.JointDamaged(Damage, pawn(owner), HitLocation, MomentumTransfer*Normal(Velocity), MyDamageType, 0);
		Other.ColorAdjust.Z = 200;
		if(Damage > Pawn(Other).Health || (Damage > 60 && Other.IsA('ScriptPawn'))){
			Pawn(Other).GotoState('IceStatue');
			Pawn(Other).Health = 5;
		}
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
local int x;

	for(x = 0; x<6; x++)
		spawn(class'RuneI.DebrisIce',self, , HitLocation, rotator(HitNormal));
Destroy();
}

simulated function Debug(Canvas canvas, int mode){
	Super.Debug(canvas,mode);
	Canvas.DrawLine3D(Location, Location + vector(Rotation) * 50, 0,0,250);
}

defaultproperties{
	speed=600.000000
	MaxSpeed=600.000000
	MyDamageType=Ice
}
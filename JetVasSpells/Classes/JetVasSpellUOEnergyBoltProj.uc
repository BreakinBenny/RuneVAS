//=============================================================================
// JetVasSpellUOEnergyBoltProj.
//=============================================================================
class JetVasSpellUOEnergyBoltProj expands VasCSLightingBall;

var ParticleSystem effect;

simulated function PreBeginPlay(){
	effect = Spawn(class'VasCSlightingBalleffect', , , , Rotation);
	effect.ScaleDeltaX = 0.400000;
	effect.ScaleDeltaY = 0.400000;
	effect.ScaleMax = 0.450000;
	effect.ScaleMin = 0.200000;
	effect.SetBase(self);
}

simulated function Destroyed(){
	if(effect != None)
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
local JVSP JVSP;
spawn(class'RuneI.EmpathyFlash',self, , HitLocation, rotator(HitNormal));
spawn(class'JetVasSpells.JetVasSpellEnergyBoltExplosion',self, , HitLocation, rotator(HitNormal));
JVSP = spawn(class'JetVasSpells.JVSP',self, , HitLocation);
JVSP.Sound = Sound'JetVasSounds.Package0.nrgywind';
	Destroy();
}

simulated function Debug(Canvas canvas, int mode){
	Super.Debug(canvas,mode);
	Canvas.DrawLine3D(Location, Location + vector(Rotation) * 50, 0,0,250);
}

defaultproperties{
	DrawScale=0.750000
	CollisionRadius=25.000000
	CollisionHeight=25.000000
}
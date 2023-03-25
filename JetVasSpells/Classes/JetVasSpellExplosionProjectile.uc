// JetVasSpellExplosionProjectile.

class JetVasSpellExplosionProjectile expands VasCSProjectileFireball;

var ParticleSystem effect;
var ParticleSystem trail_effect;
var bool bBigBall;
var int hitpawn;
var int hit;
var int mytime;
var vector LocationToHit;
var Pawn WhatToHit;

simulated function PreBeginPlay(){
	effect = Spawn(class'VasCSEffectFireballtrail', , , , Rotation);
	trail_effect = Spawn(class'VasCSEffectFireballtrail', , , , Rotation);
	effect.SetBase(self);
	effect.drawscale = drawscale;
	trail_effect.SetBase(self);
	trail_effect.drawscale = drawscale;
	mytime = 0;
hit = 0;
hitpawn = 0;
}

simulated function Destroyed(){
	if(effect != None)
		effect.Destroy();
	if(trail_effect != None)
		trail_effect.Destroy();
}

simulated function ProcessTouch(Actor Other, Vector HitLocation){
	if(other != owner && hit != 1){
		if(Other.IsA('Weapon'))
			return;

		//Other.JointDamaged(Damage, pawn(owner), HitLocation, MomentumTransfer*Normal(Velocity), MyDamageType, 0);

		if(Pawn(Other) != None){
			hitpawn = 1;
			hit = 1;
			WhatToHit = Pawn(Other);
			trail_effect.Destroy();
			effect.setbase(Pawn(Other));
		}
		else{
			hitpawn = 0;
			hit = 1;
			LocationToHit = HitLocation;
		}
	}
}

simulated function Landed(vector HitNormal, actor HitActor){
	hit = 1;
	LocationToHit = Location;
}

simulated function Explode(vector HitLocation, vector HitNormal){
local int ee;
local RunePlayer P;
local ScriptPawn PP;
local JVSP JVSP;

//if(bBigBall){
//	spawn(class'VasBigFireBall', owner, , HitLocation);
//	Destroy();}
//else{
	spawn(class'JetVasSpells.JetVasSpellExplosionExplosion',self, , HitLocation, rotator(HitNormal));
for(ee = 0; ee<8; ee++)
	spawn(class'JetVasSpells.FlamingStone',self, , HitLocation, rotator(HitNormal));
JVSP = spawn(class'JetVasSpells.JVSP',self, , HitLocation);
JVSP.Sound = Sound'OtherSnd.Explosions.explosion09';
//PlaySound(Sound'OtherSnd.Explosions.explosion09', SLOT_None);
	foreach VisibleActors(class'RunePlayer', P, 250, HitLocation){
		P.ShakeView(1.0, 800, 0.5);
		if(p == Owner)
			continue;
		P.JointDamaged(Damage, pawn(Owner), P.Location, vect(0, 0, 0), 'fire', 0);
	}
	foreach VisibleActors(class'ScriptPawn', PP, 220, HitLocation)
		PP.JointDamaged(Damage, pawn(Owner), P.Location, vect(0, 0, 0), 'fire', 0);

	foreach VisibleActors(class'RunePlayer', P, 160, HitLocation){
		P.ShakeView(1.0, 800, 0.5);
		Blast2(P);
		if(p == Owner)
			continue;
		P.JointDamaged(Damage, pawn(Owner), P.Location, vect(0, 0, 0), 'fire', 0);
	}
	foreach VisibleActors(class'ScriptPawn', PP, 140, HitLocation){
		PP.JointDamaged(Damage, pawn(Owner), P.Location, vect(0, 0, 0), 'fire', 0);
		Blast(PP);
	}
	foreach VisibleActors(class'RunePlayer', P, 80, HitLocation){
		P.ShakeView(1.0, 800, 0.5);
		Blast(P);
		if(p == Owner)
			continue;
		P.JointDamaged(Damage*0.6, pawn(Owner), P.Location, vect(0, 0, 0), 'fire', 0);
	}
	foreach VisibleActors(class'ScriptPawn', PP, 60, HitLocation){
		PP.JointDamaged(Damage*0.9, pawn(Owner), P.Location, vect(0, 0, 0), 'fire', 0);
		Blast(PP);
	}

	Destroy();
}

function Blast(actor A){
	local vector Vel;

	Vel = Normal(A.Location-self.Location);
	Vel.Z = 0.5;
	Vel *= 600;
	A.AddVelocity(Vel);
}

function Blast2(actor A){
	local vector Vel;

	Vel = Normal(A.Location-self.Location);
	Vel.Z = 0.5;
	Vel *= 350;
	A.AddVelocity(Vel);
}

simulated function Debug(Canvas canvas, int mode){
	Super.Debug(canvas,mode);

	Canvas.DrawLine3D(Location, Location + vector(Rotation) * 50, 0,0,250);
}

simulated function Tick(float DeltaTime){
	Super.Tick(DeltaTime);
	if(hit == 1){
	Velocity = vect(0,0,0);
		if (hitpawn == 0 && mytime >= 70)
		   	Explode(LocationToHit, -Normal(Velocity));
		if (hitpawn == 1 && mytime >= 70)
		   	Explode(WhatToHit.Location+vect(0,0,1), -Normal(Velocity));
		if (mytime < 70)
			mytime += 1;
	}
}

defaultproperties{
	speed=900.000000
	MaxSpeed=900.000000
	LifeSpan=20.000000
}
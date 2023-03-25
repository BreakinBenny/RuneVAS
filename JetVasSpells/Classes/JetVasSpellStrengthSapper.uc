//=============================================================================
// JetVasSpellStrengthSapper.
//=============================================================================
class JetVasSpellStrengthSapper expands Projectile;

var ParticleSystem trail_effect;
var bool bBigBall;

simulated function PreBeginPlay(){
	trail_effect = Spawn(class'JetVasSpells.JetVasSpellStrengthSapTrail', , , , Rotation);
	trail_effect.SetBase(self);
	trail_effect.drawscale = drawscale;
}


simulated function Destroyed(){
	if(trail_effect != None)
		trail_effect.Destroy();
}


simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
local int str;
local int str2;
local int drain;
	if(other != owner){
		if(Other.IsA('ScriptPawn'))
			return;
		str = RunePlayer(Other).Strength / 2;
		str2 = RunePlayer(Other).Strength * 0.75;
		if(RunePlayer(Owner).bBloodlust)
			RunePlayer(Owner).Strength += str2;  
		RunePlayer(Owner).BoostStrength(str2);
		if(RunePlayer(Other).bBloodlust && RunePlayer(Other).Strength <= str)
			RunePlayer(Other).bBloodlust = false;
		RunePlayer(Other).Strength -= str;

		drain = RunePlayer(Other).Health / RandRange(2.5,4);
		
		if(RunePlayer(Other).Health > drain){
			if(RunePlayer(Owner).Health < RunePlayer(Owner).MaxHealth)
				RunePlayer(Owner).Health += drain;
			RunePlayer(Other).Health -= drain;
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
	spawn(class'JetVasSpells.JetVasSpellZealEffect',self, , HitLocation, rotator(HitNormal));
	Destroy();
}

simulated function Debug(Canvas canvas, int mode){
	Super.Debug(canvas,mode);
	Canvas.DrawLine3D(Location, Location + vector(Rotation) * 50, 0,0,250);
}

defaultproperties{
	speed=1300.000000
	MaxSpeed=1300.000000
	RemoteRole=ROLE_None
	DrawType=DT_None
	CollisionRadius=10.000000
	CollisionHeight=10.000000
	Skeletal=SkelModel'objects.Rocks'
}
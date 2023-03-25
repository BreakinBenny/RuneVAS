//=============================================================================
// BeamLaser.
//=============================================================================
class BeamLaser expands Electricity;
var float cutoffLength;
var float maxAmplitude;
var float beamThick[4];
var name mydamagetype;
var float maxLength;
var float damage;
var int generation;
var bool bFlicker;
const flickerTime=0.50;
const fastRate=4;
const slowRate=0.1;
const slowDownTime=0.05;

replication{
	unreliable if(Role==ROLE_Authority)
		maxLength, generation, bFlicker; // only change once
}

function init()
{
	local Actor a;
	local Vector hitLocation; // set by trace
	local Vector hitNormal;	// set by trace
	local float scaleBy;
	cutofflength = 10000;
	maxlength = cutofflength;

	a = trace(hitLocation, hitNormal,
		location + vector(rotation) * maxLength, // trace end
		location,	// trace start
		true,	// bTraceActors,
	);

	if(a != none || hitLocation != vect(0, 0, 0)){
		targetLocation = hitLocation;
		if (generation == 0)
			bFlicker = true;
		processHit(a, hitlocation, hitnormal);
	}
	else
		targetLocation = location + vector(rotation) * maxLength;

	beamThickness = 2.0;
		amplitude = 0.3;
}

function processHit(Actor Other, Vector HitLocation, Vector hitNormal)
{
local vector headboxvec;
	if(other != none && other != owner){
		if(Other.IsA('Weapon'))
			return;
		if(Pawn(Other) != None && Other.isA('RunePlayer'))
			headboxvec = Other.Location + vect(0,0,10)*Other.Drawscale;
			
			if(HitLocation.X < headboxvec.X+14
			 && HitLocation.Y < headboxvec.Y+14
			  && HitLocation.Z < headboxvec.Z+14
			   && HitLocation.X > headboxvec.X-14
			    && HitLocation.Y > headboxvec.Y-14
				&& HitLocation.Z > headboxvec.Z-14 && Other.isA('RunePlayer'))
				Other.JointDamaged(50, Pawn(owner), hitLocation, vect(0,0,0), 'sever', 1);
		// HEAD SHOT ^_^
		
		Other.JointDamaged(damage, Pawn(owner), hitLocation, vect(0,0,0) , 'magic', 0);
		if(Pawn(Other) != None){
			Explode(Other.Location+vect(0,0,1)*Pawn(Other).EyeHeight, hitNormal);
			return;
		}
	}
	explode(hitLocation, hitNormal);
}

function explode(vector hitLocation, vector hitNormal)
{
local JVSP JVSP;
JVSP = spawn(class'JVSP', self, ,hitlocation,rotator(hitNormal));
JVSP.Sound = Sound'OtherSnd.Explosions.explosion10';
	spawn(class'PawnFire', self, ,hitlocation,rotator(hitNormal));
	spawn(class'FireRadius', Owner, ,hitlocation,rotator(hitNormal));
}

simulated function Tick(float DeltaSeconds){
	local float newglow;

	if(scaleGlow > slowDownTime)
		newglow = scaleGlow - deltaseconds * fastRate;
	else
		newglow = scaleGlow - deltaseconds * slowRate;

	if(newglow < 0)
		destroy();

	scaleGlow = newGlow;
}

defaultproperties{
	ParticleTexture(0)=Texture'RuneFX.Beam2red'
	BeamThickness=0.000000
	bUseTargetLocation=True
	bTaperStartPoint=True
	bTaperEndPoint=True
	RemoteRole=ROLE_SimulatedProxy
	ScaleGlow=1.500000
	AmbientGlow=200
}
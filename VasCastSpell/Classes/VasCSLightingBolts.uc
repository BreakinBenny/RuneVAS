//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasCSLightingBolts expands Electricity;

var float cutoffLength;
var float maxAmplitude;
var float forkScaleMin;
var float forkScaleMax;
var float forkAngle;
var float forkChance[4];
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

replication {
	unreliable if(Role==ROLE_Authority)
		maxLength, generation, bFlicker; // only change once
}

function init()
{
local Actor a;
local Vector hitLocation; // set by trace
local Vector hitNormal;	// set by trace
local float scaleBy;

	a = trace(hitLocation, hitNormal,
		location + vector(rotation) * maxLength, // trace end
		location,	// trace start
		true,	// bTraceActors,
	);

	if (a != none || hitLocation != vect(0,0,0))
	{
		targetLocation = hitLocation;
		if(generation == 0)
			bFlicker = true;
		processHit(a, hitlocation, hitnormal);
	}
	else
	{
		targetLocation = location + vector(rotation) * maxLength;
		if(frand() < forkChance[generation] && maxLength >= cutoffLength)
		{
			bTaperEndPoint=false;
			fork();
			fork();
		}
	}

	scaleby = fmin(1.0, vsize(targetLocation - location)/default.maxlength) + 0.1; // (at least 10%, at most 110%)
	beamThickness = beamThick[generation];
	amplitude = maxAmplitude * scaleby;

	randomize();
}

function fork()
{
	local Rotator rot;
	local VasCSLightingBolts bolt;

	rot.pitch = rotation.pitch + randrange(-0.5, 0.5)*forkAngle;
	rot.yaw = rotation.yaw + randrange(-0.5, 0.5)*forkAngle;
	rot.roll = rotation.roll;
	bolt = spawn(class'VasCSLightingBolts', owner,, targetLocation, rot);
	if (bolt != none)
	{
		bolt.maxLength = maxLength * randrange(forkscalemin, forkscalemax);
		bolt.bTaperStartPoint = false;
		bolt.generation = generation + 1;
		bolt.init();
	}
}

function processHit(Actor Other, Vector HitLocation, Vector hitNormal)
{
	if(other != none && other != owner)
	{
		if(Other.IsA('Weapon'))
			return;
		Other.JointDamaged(damage, Pawn(owner), hitLocation, vect(0,0,0) , myDamageType, 0);
		if(Pawn(Other) != None)
		{
			Explode(Other.Location+vect(0,0,1)*Pawn(Other).EyeHeight, hitNormal);
			return;
		}
	}
	explode(hitLocation, hitNormal);
}

function explode(vector hitLocation, vector hitNormal)
{
	spawn(class'HitStone', self, ,hitlocation,rotator(hitNormal));
}


simulated function Tick(float DeltaSeconds)
{
	local float newglow;

	if(scaleGlow > slowDownTime)
		newglow = scaleGlow - deltaseconds * fastRate;
	else
		newglow = scaleGlow - deltaseconds * slowRate;

	if(bflicker == true || (scaleGlow > flickerTime && newGlow < flickerTime))
		randomize();

	if (newglow < 0)
		destroy();

	scaleGlow = newGlow;

/*	if(generation == 0)
		setLocation(jointNamed('rwrist'));
*/
}

simulated function randomize()
{
local int i;
local vector X, Y, Z;

	getAxes(rotator(targetLocation-location), X, Y, Z);
	for(i = 1; i < NumConPts-1; i++)
	{
		ConnectionOffset[i] =
			X * ((FRand() - 0.5) * amplitude) +
			Y * ((FRand() - 0.5) * amplitude) +
			Z * ((FRand() - 0.5) * amplitude );
	}
}

defaultproperties
{
	cutoffLength=100.000000
	maxAmplitude=30.000000
	forkScaleMin=0.200000
	forkScaleMax=0.800000
	forkAngle=9000.000000
	forkChance(0)=1.000000
	forkChance(1)=0.500000
	forkChance(2)=0.500000
	beamThick(0)=2.000000
	beamThick(1)=1.750000
	beamThick(2)=1.500000
	beamThick(3)=1.000000
	MyDamageType=magic
	MaxLength=500.000000
	Damage=30.000000
	Amplitude=0.000000
	BeamThickness=0.000000
	bUseTargetLocation=True
	bTaperStartPoint=True
	bTaperEndPoint=True
	RemoteRole=ROLE_SimulatedProxy
	Style=STY_Translucent
	AmbientGlow=100
}
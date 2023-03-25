//=============================================================================
// JetVasSpellFlameStrikeFire.
//=============================================================================
class JetVasSpellFlameStrikeFire expands BigFire;

var() name firedmgtype;
var() float time;
var   float timer;

var() float timetoexpire;
var float timertoexpire;

var bool bDecay;

function Spawned(){
Burn();
}

simulated function Tick(float DeltaTime){
Timer += DeltaTime;
	if(Timer >= Time)
		Burn();

Timertoexpire += DeltaTime;
	if(Timertoexpire >= TimeToExpire){
		bDecay = true;

	if(bDecay){
	Scaleglow = Scaleglow - 0.025;
		if(Scaleglow <= 0)
			Destroy();
	}
}

function Burn(){
//local pawn target;
local actor Victim;

	foreach VisibleActors(class 'Actor', Victim, 120, Location){
		if(Victim != self)
			Victim.JointDamaged(12, Pawn(Owner), Location, vect(0, 0, 0), 'fire', 0);
	}
timer = 0;
}



/*foreach VisibleCollidingActors(class'pawn',Target,150)
	Target.JointDamaged(1,none,Target.Location, Normal(Target.Location-Owner.Location)*50, firedmgtype, 0);Target.PowerupBlaze(Pawn(Owner)); */

defaultproperties{
	firedmgtype=Fire
	Time=3.000000
	timetoexpire=3.000000
	ParticleCount=25
	ScaleMin=3.000000
	ScaleMax=5.000000
	LifeSpanMax=1.000000
	GravityScale=-0.500000
}
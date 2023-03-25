//=============================================================================
// JetVasSpellFlameStrikeFire2.
//=============================================================================
class JetVasSpellFlameStrikeFire2 expands Fire;

var() name firedmgtype;
var() Pawn OwnedBy;
var() float DamagePerSecond;
var() int ActiveDamage;

var() float timetoexpire;
var float timertoexpire;

var bool bDecay;

function Spawned(){
Burn();
}

function Timer(){
	if(timertoexpire >= 3)
		Destroy();
Burn();
}

function Burn(){	
local actor Victim;

	foreach VisibleActors(class 'Actor', Victim, 115, Location){
		if(Victim != self){
			if(Victim != OwnedBy);
				Victim.JointDamaged(DamagePerSecond/9, OwnedBy, Location, vect(0, 0, 0), 'fire', 0);
		}
	}
timertoexpire += 0.12;
setTimer(0.12,true);
}

defaultproperties{
	firedmgtype=Fire
	timetoexpire=2.000000
	ParticleCount=30
	VelocityMin=(X=0.500000,Y=0.500000,Z=50.000000)
	VelocityMax=(X=20.000000,Y=20.000000,Z=350.000000)
	GravityScale=-0.700000
}
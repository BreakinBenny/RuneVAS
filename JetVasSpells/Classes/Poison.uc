//=============================================================================
// Poison.
//=============================================================================
class Poison expands Info;

var Pawn Victim;
var Pawn OwnedBy;
var int DamagePerSec;
var int Rounds;

simulated function PreBeginPlay(){
Rounds = 0;
setTimer(0.4,true);
}

function Timer(){
if(Victim == None || Victim.Health <= 0 || OwnedBy == None || Rounds >= 15)
	Destroy();

Rounds++;
Victim.JointDamaged(DamagePerSec,OwnedBy, Victim.Location, Location, 'blunt', 0);
setTimer(0.4,true);
}

defaultproperties{}
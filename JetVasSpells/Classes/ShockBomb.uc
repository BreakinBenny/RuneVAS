//=============================================================================
// ShockBomb.
//=============================================================================
class ShockBomb expands HealthFruit2;

var() int Started;
var Pawn OwnerPawn;
var() int Damage;

function PickupFunction(Pawn Other){
return;
}
simulated function Tick (Float DeltaTime){
local JVSP JVSP;
	if(Started == 0){
		JVSP = spawn(class'JetVasSpells.JVSP',self, ,Location);
		JVSP.Sound = Sound'OtherSnd.Explosions.explosion06'; 
		Started = 1;
		setTimer(0.05,true);
	}
}

function Timer(){
local Pawn Victim;
Drawscale = Drawscale + 4;
Scaleglow = Scaleglow - 0.05;

ForEach VisibleCollidingActors(class'Pawn', Victim, Drawscale*7){
	if(Victim != OwnerPawn && Victim != None && Victim.Health > 0){
		if(Victim.Health > Damage)
			Victim.JointDamaged(Damage,OwnerPawn, Location, Velocity, 'sever', 0);
		else if(Victim.Health <= Damage)
			Victim.JointDamaged(500,OwnerPawn, Location, Velocity, 'sever', 0);
	}
}

	if  (Drawscale >= 80)
		Destroy();
	
	setTimer(0.05,true);
}

defaultproperties{
	Style=STY_Translucent
	SkelGroupSkins(0)=Texture'RuneFX2.runeshield1'
	SkelGroupSkins(1)=Texture'RuneFX2.runeshield1'
}
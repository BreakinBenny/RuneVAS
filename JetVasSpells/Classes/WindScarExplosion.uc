//=============================================================================
// WindScarExplosion.
//=============================================================================
class WindScarExplosion expands HealthFruit2;

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
local VolcanoBalls V;
Drawscale = Drawscale + 5;
Scaleglow = Scaleglow - 0.02;

ForEach VisibleCollidingActors(class'Pawn', Victim, Drawscale*7)
{
	if(Victim != OwnerPawn && Victim != None && Victim.Health > 0){
		if(Victim.Health > Damage)
			Victim.JointDamaged(Damage,OwnerPawn, Location, Velocity, 'sever', 0);
		else if(Victim.Health <= Damage)
			Victim.JointDamaged(400,OwnerPawn, Location, Velocity, 'sever', 0);
	}
}
spawn(class'JetVasSpells.FlamingStone',self,,Location);
V = spawn(class'VolcanoBalls',OwnerPawn,,Location);
V.OwnerPawn = OwnerPawn;
	if(Drawscale >= 110)
		Destroy();
	
	setTimer(0.05,true);
}

defaultproperties{
	Style=STY_Translucent
	SkelGroupSkins(0)=FireTexture'RuneFX.Flame'
	SkelGroupSkins(1)=FireTexture'RuneFX.Flame'
}
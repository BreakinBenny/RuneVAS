//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasCSFireBreathE expands ZombieBreath;

function PreBeginPlay(){
	LifeCount = 20;
	SetTimer(0.25, true);
}

function Timer(){
local actor Victim;

	foreach VisibleActors(class 'Actor', Victim, 50, Location){
		if((Victim != self) && (Victim != Owner))
			Victim.JointDamaged(10, Pawn(Owner), Location, vect(0, 0, 0), 'fire', 0);
	}

	LifeCount--;
	if(LifeCount <= 0)
		RemoveCloud();
}

defaultproperties{
	ParticleTexture(0)=Texture'RuneFX.flame_orange'
	LifeSpanMin=1.300000
	LifeSpanMax=1.800000
	DrawScale=2.000000
}
class VasLizard expands Lizard;

function PostBeginPlay(){
	SetTimer(20.000000,False);
	Super.PostBeginPlay();
}

function timer(){
Self.destroy();
}

defaultproperties{
	Nutrition=100
	RespawnTime=0.000000
}
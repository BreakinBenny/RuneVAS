class VasLegOMeat expands LegOMeat1;

function PostBeginPlay(){
	SetTimer(20.000000,False);
	Super.PostBeginPlay();
}

function timer(){
Self.destroy();
}

defaultproperties{
	Nutrition=50
	RespawnTime=0.000000
}
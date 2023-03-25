class VasMonsters2Welcome expands Actor;

Var INT TotalMonsters;
Var INT GroupMonsters;
Var String StrGroupMonsters;

function PostBeginPlay(){
	SetTimer(8.000000,true);
}

function Timer(){
	if(GroupMonsters == 1)
		StrGroupMonsters = "GroupMonsters = TRUE";
	else
		StrGroupMonsters = "";
	BroadCastMessage("Powered by VasMonsters2 V1.02 - {Kal Corp} - Http://VasServer.dyndns.org/KalsForums");
	BroadCastMessage("Setting up Monsters for "$ Level.Title $" - TotalMonsters ="$ TotalMonsters $" - MonsterDifficulty="$ Level.Game.Difficulty $" / "$ StrGroupMonsters);
	self.destroy();
}

defaultproperties{}
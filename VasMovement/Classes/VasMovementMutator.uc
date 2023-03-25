//-----------------------------------------------------------
//VasMovement - By Kal-Corp	Kal-Corp@cfl.rr.com
//http://Vasserver.dyndns.org/KalsForums
//-----------------------------------------------------------
class VasMovementMutator expands Mutator config(VasMovement);

var() config int BaseSpeed;
var() config int MinSpeed;

function PostBeginPlay(){
Super.PostBeginPlay();
SetTimer(1.000000,true);
}

function Tick(float DeltaTime){
	Super.Tick(DeltaTime);
}

function Timer(){
local runeplayer runeplayer;

foreach AllActors(class'runeplayer', runeplayer)
	SetGroundSpeed(runeplayer);
}

function SetGroundSpeed(runeplayer runeplayer){
local int temp,temp2;

runeplayer.Groundspeed = BaseSpeed;

if(runeplayer.Weapon != NONE){
	temp = (((runeplayer.Weapon.Mass*10)-60)*0.75);
	if(temp <=0)
		temp=0;
	runeplayer.Groundspeed -= (temp);
}
if(runeplayer.shield != NONE){
	temp2 = (runeplayer.Shield.Mass/5);
	if(temp2 <=0)
		temp2=0;
	runeplayer.Groundspeed -= (temp2);
}

if(runeplayer.Groundspeed < MinSpeed)
	runeplayer.Groundspeed = MinSpeed;

	runeplayer.Mass += temp+temp2;
}

defaultproperties{
	BaseSpeed=315
	MinSpeed=315
}
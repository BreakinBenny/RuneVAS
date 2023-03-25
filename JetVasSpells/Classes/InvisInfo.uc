//=============================================================================
// InvisInfo.
//=============================================================================
class InvisInfo expands Info;

var Pawn Caster;

simulated function PreBeginPlay(){
setTimer(0.5,true);
}

function Timer()
{
local VasCSDMEffect VCE;
if(Caster == None || Caster.Health <= 0 || Caster.RunePower <= 10)
	EndEffect();
setLocation(Caster.Location+vect(0,0,1));
Caster.VisibilityHeight = 150;
Caster.VisibilityRadius = 100;
Caster.Style = STY_Translucent;
if(Caster.Velocity.X > 64 || Caster.Velocity.X < -64 || Caster.Velocity.Y > 64 || Caster.Velocity.Y < -64 || Caster.Velocity.Z > 64 || Caster.Velocity.Z < -64){
	Caster.VisibilityHeight = 10000;
	Caster.VisibilityRadius = 10000;
	Caster.Style = STY_Normal;		
}
Caster.RunePower -= 11;
foreach VisibleActors(class'VasCSDMEffect', VCE, 1500){
	EndEffect();
}

setTimer(0.5,true);
}

function EndEffect(){
Caster.VisibilityHeight = 10000;
Caster.VisibilityRadius = 10000;
Caster.Style = STY_Normal;
RunePlayer(Caster).ClientMessage("You are revealed!", 'subtitle');
Destroy();
}

defaultproperties{}
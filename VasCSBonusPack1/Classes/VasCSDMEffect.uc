//-----------------------------------------------------------
//VasCSBonuspack1 - By Kal-Corp, Kal-Corp@cfl.rr.com
//	http://Vasserver.dyndns.org/KalsFor
//	This Code is from DungeonMaster
//-----------------------------------------------------------
class VasCSDMEffect expands Effects;

const StartRadius=22.0;
const EffectTime=0.75;

var float TimePassed;
var float EndRadius;

simulated function Spawned(){
	TimePassed=0.0;
	ScaleGlow = EffectTime;
}

simulated function Tick(float DeltaTime){
local float newRadius;

	TimePassed += DeltaTime;
	newRadius = StartRadius + (EndRadius-StartRadius) * (TimePassed/EffectTime);
	DrawScale = newRadius/StartRadius;
	ScaleGlow -= DeltaTime;
	if(ScaleGlow <= 0)
		Destroy();
}

defaultproperties{
	EndRadius=125.000000
	RemoteRole=ROLE_SimulatedProxy
	DrawType=DT_VerticalSprite
	Style=STY_Translucent
	Texture=Texture'RuneFX.ripple2'
	AmbientGlow=50
}
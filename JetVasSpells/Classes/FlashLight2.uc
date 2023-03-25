class FlashLight2 expands DanglerLight;

var float TimePassed;
const StartRadius = 10.0;
const EndRadius=200.0;
const EffectTime=4.0;

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
	RemoteRole=ROLE_SimulatedProxy
	DrawScale=2.000000
	AmbientGlow=105
	LightBrightness=0
	LightHue=0
	LightSaturation=0
	LightRadius=0
}
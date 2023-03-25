//=============================================================================
// FlashLight.
//=============================================================================
class FlashLight expands DanglerLight;

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
	if(LightRadius < 250)
		LightRadius += 6;
	if(LightSaturation < 250)
		LightSaturation += 6;
	if(AmbientGlow < 255)
		AmbientGlow += 6;
	if(LightBrightness < 255)
		LightBrightness += 11;

	// Fade the blast radius out
	ScaleGlow -= DeltaTime;
	if(ScaleGlow <= 0)
		Destroy();
//	SetCollisionSize(newRadius, CollisionHeight);
}

defaultproperties{
	RemoteRole=ROLE_SimulatedProxy
	DrawScale=2.000000
	AmbientGlow=105
	ColorAdjust=(X=200.000000)
	LightBrightness=102
	LightHue=0
	LightSaturation=24
	LightRadius=16
}
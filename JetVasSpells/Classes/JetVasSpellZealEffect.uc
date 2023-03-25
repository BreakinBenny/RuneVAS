//=============================================================================
// JetVasSpellZealEffect.
//=============================================================================
class JetVasSpellZealEffect expands Effects;

var float TimePassed;
const StartRadius = 700.0;
const EndRadius=22.0;
const EffectTime=3.0;

simulated function Spawned(){
	TimePassed=0.0;
	ScaleGlow = EffectTime;
}

simulated function Tick(float DeltaTime){
	local float newRadius;

	TimePassed += DeltaTime;
	newRadius = StartRadius + (EndRadius-StartRadius) * (TimePassed/EffectTime);
	DrawScale = newRadius/StartRadius;
	
	// Fade the blast radius out
	ScaleGlow -= DeltaTime;
	if(ScaleGlow <= 0)
		Destroy();
//	SetCollisionSize(newRadius, CollisionHeight);
}

defaultproperties{
	RemoteRole=ROLE_SimulatedProxy
	DrawType=DT_VerticalSprite
	Style=STY_Translucent
	Texture=Texture'RuneFX.explosionring1'
	AmbientGlow=50
}
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasCSlightingBalleffect expands ParticleSystem;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	VelocityMax = -(vector(Rotation) * 50);
}

defaultproperties
{
	ParticleCount=30
	ParticleTexture(0)=FireTexture'RuneFX2.lightningstart'
	ScaleMin=0.300000
	ScaleMax=0.700000
	ScaleDeltaX=0.600000
	ScaleDeltaY=0.600000
	LifeSpanMin=0.050000
	LifeSpanMax=0.100000
	AlphaStart=200
	AlphaEnd=50
	bAlphaFade=True
	SpawnOverTime=1.000000
	bStasis=False
	bDirectional=True
	Style=STY_Translucent
}
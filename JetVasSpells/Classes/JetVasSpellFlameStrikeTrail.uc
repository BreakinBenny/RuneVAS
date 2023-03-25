//=============================================================================
// JetVasSpellFlameStrikeTrail.
//=============================================================================
class JetVasSpellFlameStrikeTrail expands Fire;

function PostBeginPlay(){
	LifeSpan = 3;
}

defaultproperties{
	ParticleCount=50
	ParticleTexture(0)=Texture'RuneFX.Blastring'
	VelocityMin=(X=0.000000,Y=0.000000,Z=0.000000)
	VelocityMax=(X=0.000000,Y=0.000000,Z=0.000000)
	ScaleMin=0.500000
	ScaleMax=1.400000
	LifeSpanMin=0.050000
	LifeSpanMax=0.100000
	GravityScale=0.000000
	LifeSpan=3.000000
	AmbientSound=None
}
//=============================================================================
// JetVasSpellExplosionExplosion.
//=============================================================================
class JetVasSpellExplosionExplosion expands HealthFruit2;
var() int Started;

function PickupFunction(Pawn Other){
return;
}
simulated function Tick (Float DeltaTime)
{
	if(Started == 0){
		Started = 1;
		setTimer(0.05,true);
	}
}

function Timer(){
Drawscale = Drawscale + 3.55;
Scaleglow = Scaleglow - 0.1;

	if(Drawscale >= 75)
		Destroy();
	setTimer(0.05,true);
}

defaultproperties{
	Nutrition=0
	JunkActor=None
	Style=STY_Translucent
	bMeshEnviroMap=True
	SkelGroupSkins(0)=None
	SkelGroupSkins(1)=FireTexture'RuneFX2.FireRing'
}
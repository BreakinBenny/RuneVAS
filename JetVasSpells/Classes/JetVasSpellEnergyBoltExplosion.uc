//=============================================================================
// JetVasSpellEnergyBoltExplosion.
//=============================================================================
class JetVasSpellEnergyBoltExplosion expands JetVasSpellExplosionExplosion;

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

function Timer()
{
Drawscale = Drawscale + 0.75;
Scaleglow = Scaleglow - 0.1;

	if(Drawscale >= 15)
		Destroy();
	
	setTimer(0.05,true);
}

defaultproperties{
	DrawScale=0.250000
	SkelGroupSkins(1)=Texture'RuneFX2.runeshield1'
}
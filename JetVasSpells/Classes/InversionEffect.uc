//=============================================================================
// InversionEffect.
//=============================================================================
class InversionEffect expands JetVasSpellEnergyBoltExplosion;

function PickupFunction(Pawn Other){
return;
}
simulated function Tick(Float DeltaTime){
	if(Started == 0){
		Started = 1;
		setTimer(0.05,true);
	}
}

function Timer(){
Drawscale = Drawscale + 1.0;
Scaleglow = Scaleglow - 0.1;

	if(Drawscale >= 40)
		Destroy();
	
	setTimer(0.05,true);
}

defaultproperties{
	DrawScale=20.000000
	SkelGroupSkins(1)=Texture'RuneFX.odincorona'
}
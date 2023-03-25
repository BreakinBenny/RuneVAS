//==========
// CrabDestroyer.
//==========
class CrabDestroyer extends GiantCrab;

defaultproperties{
	bCamouflage=False
	ThrowZ=1000.00
	StartWeapon=Class'DestroyerPincer'
	Intelligence=2
	DeathRadius=44.00
	DeathHeight=44.00
	DrawScale=2.00
	AmbientGlow=255
	ColorAdjust=(X=0.00,Y=100.00,Z=100.00),
	CollisionRadius=80.00
	CollisionHeight=58.00
	SkelGroupSkins(0)=WetTexture'fluid.liqlavaPROC'
	SkelGroupSkins(1)=WetTexture'fluid.liqlavaPROC'
}
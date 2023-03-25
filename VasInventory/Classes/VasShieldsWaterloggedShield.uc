class VasShieldsWaterloggedShield expands VasShields;

function PlayHitSound(name DamageType){}

defaultproperties{
	Health=10
	DestroyedSound=Sound'WeaponsSnd.Shields.xtroy01'
	PickupMessage="Waterlogged Shield"
	RespawnSound=Sound'OtherSnd.Respawns.respawn01'
	DropSound=Sound'WeaponsSnd.Shields.xdrop01'
	LODCurve=LOD_CURVE_ULTRA_CONSERVATIVE
	CollisionRadius=13.000000
	CollisionHeight=3.000000
	bCollideWorld=True
	Mass=50.000000
	Skeletal=SkelModel'weapons.VikingShield'
}
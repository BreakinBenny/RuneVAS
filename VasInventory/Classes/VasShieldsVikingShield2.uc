class VasShieldsVikingShield2 expands VasShields config(VasShields);

function PlayHitSound(name DamageType){}

defaultproperties{
	Health=65
	rating=2
	DestroyedSound=Sound'WeaponsSnd.Shields.xtroy02'
	PickupMessage="Viking Metal Shield"
	RespawnSound=Sound'OtherSnd.Respawns.respawn01'
	DropSound=Sound'WeaponsSnd.Shields.xdrop02'
	LODCurve=LOD_CURVE_ULTRA_CONSERVATIVE
	CollisionRadius=13.000000
	CollisionHeight=3.000000
	bCollideWorld=True
	Mass=150.000000
	Skeletal=SkelModel'weapons.VikingShield'
	SkelGroupSkins(0)=Texture'weapons.VikingShieldviking_shield3'
	SkelGroupSkins(1)=Texture'weapons.VikingShieldviking_shield3'
}
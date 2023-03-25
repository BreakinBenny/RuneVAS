class VasShieldsDwarfWoodShield expands VasShields config(VasShields);

function PlayHitSound(name DamageType){}

defaultproperties{
	Health=70
	rating=3
	DestroyedSound=Sound'WeaponsSnd.Shields.xtroy05'
	PickupMessage="Dwarven Wooden Shield"
	RespawnSound=Sound'OtherSnd.Respawns.respawn01'
	DropSound=Sound'WeaponsSnd.Shields.xdrop05'
	LODCurve=LOD_CURVE_ULTRA_CONSERVATIVE
	CollisionRadius=13.000000
	CollisionHeight=3.000000
	bCollideWorld=True
	Mass=200.000000
	Skeletal=SkelModel'weapons.WoodShield'
	SkelGroupSkins(0)=Texture'weapons.WoodShielddwarf_wood_shield'
	SkelGroupSkins(1)=Texture'weapons.WoodShielddwarf_wood_shield'
}
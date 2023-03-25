class VasShieldsDwarfBattleShield expands VasShields config(VasShields);

function PlayHitSound(name DamageType){}

defaultproperties{
	Health=100
	rating=4
	DestroyedSound=Sound'WeaponsSnd.Shields.xtroy06'
	PickupMessage="Dwarven Battle Shield"
	RespawnSound=Sound'OtherSnd.Respawns.respawn01'
	DropSound=Sound'WeaponsSnd.Shields.xdrop06'
	LODCurve=LOD_CURVE_ULTRA_CONSERVATIVE
	CollisionRadius=13.000000
	CollisionHeight=3.000000
	bCollideWorld=True
	Mass=250.000000
	Skeletal=SkelModel'weapons.BattleShield'
	SkelGroupSkins(0)=Texture'weapons.BattleShielddwarf_shield'
	SkelGroupSkins(1)=Texture'weapons.BattleShielddwarf_shield'
}
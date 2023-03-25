//=============================================================================
// Demon.
//=============================================================================
class Demon expands ScriptableRagnar;

function Texture PainSkin(int BodyPart){
	return None;
}

defaultproperties{
	StartStowWeapon=Class'RuneI.sigurdaxe'
	Orders=Roaming
	bLungeAttack=True
	LungeRange=200.000000
	bDodgeAfterAttack=True
	AcquireSound=Sound'CreaturesSnd.Various.timetodie3'
	HuntSound=Sound'CreaturesSnd.Taunts.tauntvikingshortsword'
	RoamSound=Sound'CreaturesSnd.Taunts.tauntboneclub'
	FearSound=Sound'CreaturesSnd.Various.protectmother'
	ThreatenSound=Sound'CreaturesSnd.Various.xfacemeboy'
	bIsBoss=True
	StartShield=Class'RuneI.DwarfBattleShield'
	CarcassType=None
	MeleeRange=70.000000
	GroundSpeed=400.000000
	JumpZ=600.000000
	SightRadius=4000.000000
	Health=850
	MaxHealth=850
	BodyPartHealth(1)=500
	BodyPartHealth(3)=500
	BodyPartHealth(5)=500
	GibCount=35
	GibClass=Class'JetVasMonsters.DebrisBone'
	PainDelay=0.100000
	Skill=1.000000
	HitSound1=Sound'CreaturesSnd.Taunts.taunthandaxe'
	HitSound2=Sound'CreaturesSnd.Taunts.tauntsigurdaxe'
	HitSound3=Sound'CreaturesSnd.Taunts.tauntdwarfworkhammer'
	Die=Sound'CreaturesSnd.Various.tortureclose08'
	Die2=Sound'CreaturesSnd.Various.tortureclose06'
	Die3=Sound'CreaturesSnd.Various.tortureclose01'
	DrawScale=1.200000
	CollisionRadius=26.000000
	CollisionHeight=50.000000
	Mass=200.000000
	SkelGroupSkins(0)=Texture'RuneFX.gore'
	SkelGroupSkins(1)=Texture'RuneFX.gore'
	SkelGroupSkins(2)=Texture'RuneFX.gore'
	SkelGroupSkins(3)=Texture'RuneFX.gore'
	SkelGroupSkins(4)=Texture'RuneFX.gore'
	SkelGroupSkins(5)=Texture'RuneFX.gore'
	SkelGroupSkins(6)=Texture'RuneFX.gore'
	SkelGroupSkins(7)=Texture'RuneFX.gore'
	SkelGroupSkins(8)=Texture'RuneFX.gore'
	SkelGroupSkins(9)=Texture'RuneFX.gore'
	SkelGroupSkins(10)=Texture'RuneFX.gore'
	SkelGroupSkins(11)=Texture'RuneFX.gore'
	SkelGroupSkins(12)=Texture'UWindow.Icons.Background'
	SkelGroupSkins(13)=Texture'RuneFX.gore'
	SkelGroupSkins(14)=Texture'RuneFX.gore'
	SkelGroupSkins(15)=Texture'RuneFX.gore'
}
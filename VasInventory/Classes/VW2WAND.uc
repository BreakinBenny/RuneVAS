//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VW2WAND expands VW2Swords;

function PostBeginPlay(){
local int j;
local actor a;
Super(weapon).PostBeginPlay();
a = spawn(class'DanglerLight', self,, Location);
	if(a != None){
		AttachActorToJoint(a, JointNamed('OFFSET'));
		a.DrawScale = 0.5;
	}
Default.Drawscale = 0.60;
Drawscale = 0.60;
}

defaultproperties{
	VasMagicTitle="Magical "
	AutoMagic=False
	MagicPercent=10
	MeleeType=MELEE_AXE
	Damage=10
	DamageType=bluntsever
	ThrownDamageType=thrownweaponbluntsever
	rating=40
	SweepJoint2=0
	ExtendedLength=0.000000
	ThroughAir(0)=Sound'WeaponsSnd.Swings.swing06'
	ThroughAirBerserk(0)=Sound'WeaponsSnd.Swings.bswing06'
	HitFlesh(0)=Sound'WeaponsSnd.ImpFlesh.impfleshsword07'
	HitWood(0)=Sound'WeaponsSnd.ImpWood.impactwood15'
	HitStone(0)=Sound'WeaponsSnd.ImpStone.impactstone07'
	HitMetal(0)=Sound'WeaponsSnd.ImpMetal.impactmetal17'
	HitDirt(0)=Sound'WeaponsSnd.ImpEarth.impactearth03'
	HitShield=Sound'WeaponsSnd.Shields.shield03'
	HitWeapon=Sound'WeaponsSnd.Swords.sword03'
	HitBreakableWood=Sound'WeaponsSnd.ImpWood.impactwood12'
	HitBreakableStone=Sound'WeaponsSnd.ImpStone.impactstone11'
	SheathSound=Sound'WeaponsSnd.Stows.xstow01'
	UnsheathSound=Sound'WeaponsSnd.Stows.xunstow01'
	ThrownSoundLOOP=None
	PitchDeviation=0.080000
	PowerupIcon=Texture'RuneFX2.haxe'
	PowerupIconAnim=Texture'RuneFX2.haxe1a'
	PoweredUpSwipeClass=Class'RuneI.WeaponSwipeGray'
	A_Idle=S2_idle
	A_Backward=H5_Backup
	A_Forward45Right=H5_Walk45Right
	A_Forward45Left=H5_Walk45Left
	A_Backward45Right=H5_BackupRight
	A_Backward45Left=H5_BackupLeft
	A_StrafeRight=H5_StrafeRight
	A_StrafeLeft=H5_StrafeLeft
	A_Jump=H5_Jump
	A_AttackA=T_BackupAttack
	A_AttackAReturn=None
	A_AttackB=None
	A_AttackC=None
	A_AttackCReturn=None
	A_AttackStandA=T_Standingattack
	A_AttackStandAReturn=None
	A_AttackStandB=None
	A_AttackStandBReturn=None
	A_AttackBackupA=T_BackupAttack
	A_AttackBackupAReturn=None
	A_AttackStrafeRight=T_BackupAttack
	A_AttackStrafeLeft=T_BackupAttack
	A_JumpAttack=OneHandJumpAttack
	A_Throw=S2_Throw
	A_Powerup=H5_Powerup
	A_Defend=None
	A_DefendIdle=None
	A_PainFront=H5_painFront
	A_PainBack=H5_painFront
	A_PainLeft=H5_painFront
	A_PainRight=H5_painFront
	A_PickupGroundLeft=H5_PickupLeft
	A_PickupHighLeft=H5_PickupLeftHigh
	A_Taunt=S1_Taunt
	A_PumpTrigger=H5_PumpTrigger
	A_LeverTrigger=H5_LeverTrigger
	bAmbientGlow=True
	PickupMessage="Wand"
	PickupSound=Sound'OtherSnd.Pickups.grab03'
	DropSound=Sound'WeaponsSnd.Drops.sworddrop03'
	AmbientGlow=25
	bMirrored=True
	bMeshEnviroMap=True
	Mass=5.000000
	Buoyancy=0.250000
	Skeletal=SkelModel'weapons.RustyMace'
	SkelGroupSkins(1)=Texture'weapons.sigurdaxesigurds_axe'
}
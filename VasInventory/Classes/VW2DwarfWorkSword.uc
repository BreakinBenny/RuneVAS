//=============================================================================
//
//=============================================================================
class VW2DwarfWorksword expands VW2Swords;

function PowerupInit(){
	DesiredColorAdjust.Y = 255;
	DesiredColorAdjust.Z = 255;
	SpawnPowerupEffect();
	SwipeClass = PoweredUpSwipeClass;

}

function PowerupEndingPulseOn(){
	PlaySound(PoweredUpEndingSound, SLOT_None);
}
function PowerupEndingPulseOff(){
}
function PowerupEnded(){
	DesiredColorAdjust.Y = 0;
	DesiredColorAdjust.Z = 0;
	Super.PowerupEnded();
}

simulated function SpawnPowerupEffect(){
	local EffectSkeleton ES;

	ES = Spawn(class'EffectSkelLightningSword', self);
	if(ES != None)
		AttachActorToJoint(ES, 0);
}
simulated function RemovePowerupEffect(){
	local actor A;

	A = DetachActorFromJoint(0);
	A.Destroy();
}

function WeaponFire(int SwingCount){
	local LightningPowerupBall b;
	local vector X, Y, Z;

	if(!bPoweredUp || SwingCount != 0)
		return;

	GetAxes(PlayerPawn(Owner).ViewRotation, X, Y, Z);

	b = Spawn(class'LightningPowerupBall', Owner,, Location + X * 15);	
	b.Velocity = X * 20 + Z * 35;
	
}

defaultproperties{
	StowMesh=1
	Damage=25
	BloodTexture=Texture'weapons.workswordDwarf_work_swordblood'
	rating=30
	SweepJoint2=6
	RunePowerRequired=75
	RunePowerDuration=10.000000
	PowerupMessage="Lightning!"
	ThroughAir(0)=Sound'WeaponsSnd.Swings.swing19'
	ThroughAirBerserk(0)=Sound'WeaponsSnd.Swings.bswing04'
	HitFlesh(0)=Sound'WeaponsSnd.ImpFlesh.impfleshsword06'
	HitWood(0)=Sound'WeaponsSnd.ImpWood.impactwood08'
	HitStone(0)=Sound'WeaponsSnd.ImpStone.impactstone15'
	HitMetal(0)=Sound'WeaponsSnd.ImpMetal.impactmetal16'
	HitDirt(0)=Sound'WeaponsSnd.ImpEarth.impactearth05'
	HitShield=Sound'WeaponsSnd.Shields.shield04'
	HitWeapon=Sound'WeaponsSnd.Swords.sword04'
	HitBreakableWood=Sound'WeaponsSnd.ImpWood.impactwood12'
	HitBreakableStone=Sound'WeaponsSnd.ImpStone.impactstone13'
	SheathSound=Sound'WeaponsSnd.Stows.xstow04'
	UnsheathSound=Sound'WeaponsSnd.Stows.xunstow04'
	ThrownSoundLOOP=Sound'WeaponsSnd.Throws.throw03L'
	PowerUpSound=Sound'WeaponsSnd.PowerUps.powerstart42'
	PoweredUpSoundLOOP=Sound'WeaponsSnd.PowerUps.power68L'
	PitchDeviation=0.085000
	PowerupIcon=Texture'RuneFX2.wsword'
	PowerupIconAnim=Texture'RuneFX2.wsword1a'
	PoweredUpSwipeClass=Class'RuneI.WeaponSwipeBlue'
	A_Idle=S4_idle
	A_Forward=S4_walk
	A_Backward=S4_backup
	A_Forward45Right=S4_walk45right
	A_Forward45Left=S4_walk45left
	A_Backward45Right=S4_backup45Right
	A_Backward45Left=S4_backup45Left
	A_StrafeRight=S4_strafeRight
	A_StrafeLeft=S4_strafeLeft
	A_AttackA=S4_attackA
	A_AttackAReturn=s4_attackareturn
	A_AttackB=S4_attackB
	A_AttackC=S4_attackC
	A_AttackCReturn=S4_attackCReturn
	A_AttackStandA=S4_standingAttackA
	A_AttackStandAReturn=S4_standingAttackAreturn
	A_AttackStandB=S4_standingAttackB
	A_AttackStandBReturn=S4_standingAttackBreturn
	A_AttackBackupAReturn=S4_backupAttackAreturn
	A_AttackStrafeRight=S4_StrafeRightAttack
	A_AttackStrafeLeft=S4_StrafeLeftAttack
	A_Throw=S4_throw
	A_Powerup=S4_Powerup
	A_Defend=None
	A_DefendIdle=None
	A_PainFront=S4_painFront
	A_PainBack=S4_painBack
	A_PainLeft=S4_painLeft
	A_PainRight=S4_painRight
	A_PickupGroundLeft=S4_pickupleft
	A_PickupHighLeft=S4_pickuplefthigh
	A_Taunt=s4_taunt
	A_PumpTrigger=S4_pumptrigger
	A_LeverTrigger=S4_LeverTrigger
	PickupMessage="Dwarven Work Sword"
	PickupSound=Sound'OtherSnd.Pickups.grab04'
	DropSound=Sound'WeaponsSnd.Drops.sworddrop02'
	Mass=16.000000
	Skeletal=SkelModel'weapons.worksword'
	SkelGroupSkins(0)=Texture'weapons.workswordDwarf_work_sword'
	SkelGroupSkins(1)=Texture'weapons.workswordDwarf_work_sword'
}
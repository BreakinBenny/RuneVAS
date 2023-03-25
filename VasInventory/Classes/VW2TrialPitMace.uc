//
//-----------------------------------------------------------
class VW2TrialPitMace expands VW2Hammers;

var(Sounds) Sound PoweredUpFireSound;
var float FireRadius;

function PowerupInit(){
	Super.PowerupInit();
	DesiredColorAdjust.X = 128;
	DesiredColorAdjust.Y = 70;
}

function PowerupEndingPulseOn(){
	DesiredFatness = 140;
	DesiredColorAdjust.X = 0;
	DesiredColorAdjust.Y = 0;
	PlaySound(PoweredUpEndingSound, SLOT_None);
}
function PowerupEndingPulseOff(){
	DesiredFatness = 128;
	DesiredColorAdjust.X = 128;
	DesiredColorAdjust.Y = 70;
}

function PowerupEnded(){
	Super.PowerupEnded();
	DesiredColorAdjust.X = 0;
	DesiredColorAdjust.Y = 0;
}

simulated function SpawnPowerupEffect(){
	local EffectSkeleton ES;

	// Spawn an EffectSkeleton that will display all powered up effects
	ES = Spawn(class'EffectSkelTrialMace', self);
	if(ES != None)
		AttachActorToJoint(ES, 0);
}
simulated function RemovePowerupEffect(){
	local actor A;
	// Remove Effect skeleton
	A = DetachActorFromJoint(0);
	A.Destroy();
}

function WeaponFire(int SwingCount){
	local FireRadius B;
	local vector loc;

	if(bPoweredUp && SwingCount == 0){
		loc = Location;
		loc.Z -= 10;
		B = Spawn(class'FireRadius', Owner,, loc, rotator(vect(0,0,1)));
		B.Instigator = Pawn(Owner);
		PlaySound(PoweredUpFireSound, SLOT_Interface);
	}
}

defaultproperties{
	PoweredUpFireSound=Sound'WeaponsSnd.PowerUps.afire01'
	FireRadius=300.000000
	VasMagicTitle="Magical Blaze "
	StowMesh=1
	Damage=30
	BloodTexture=Texture'weapons.TrialMacetrialpit_maceblood'
	rating=20
	ExtendedLength=5.000000
	RunePowerRequired=50
	RunePowerDuration=5.000000
	PowerupMessage="Blaze!"
	ThroughAir(0)=Sound'WeaponsSnd.Swings.swing07'
	ThroughAirBerserk(0)=Sound'WeaponsSnd.Swings.bswing08'
	HitFlesh(0)=Sound'WeaponsSnd.ImpFlesh.impfleshhammer04'
	HitWood(0)=Sound'WeaponsSnd.ImpWood.impactwood03'
	HitStone(0)=Sound'WeaponsSnd.ImpStone.impactstone19'
	HitMetal(0)=Sound'WeaponsSnd.ImpMetal.impactmetal09'
	HitDirt(0)=Sound'WeaponsSnd.ImpEarth.impactearth06'
	HitShield=Sound'WeaponsSnd.Shields.shield08'
	HitWeapon=Sound'WeaponsSnd.Swords.sword08'
	HitBreakableWood=Sound'WeaponsSnd.ImpWood.impactwood12'
	HitBreakableStone=Sound'WeaponsSnd.ImpStone.impactstone11'
	SheathSound=Sound'WeaponsSnd.Stows.xstow01'
	UnsheathSound=Sound'WeaponsSnd.Stows.xunstow01'
	PowerUpSound=Sound'WeaponsSnd.PowerUps.powerstart38'
	PoweredUpSoundLOOP=Sound'WeaponsSnd.PowerUps.power02L'
	PitchDeviation=0.080000
	PowerupIcon=Texture'RuneFX2.tmace'
	PowerupIconAnim=Texture'RuneFX2.tmace1a'
	PoweredUpSwipeClass=Class'RuneI.WeaponSwipeFire'
	A_Idle=H3_idle
	A_AttackA=H3_attackA
	A_AttackAReturn=H3_attackAreturn
	A_AttackB=H3_attackB
	A_AttackBReturn=H3_attackBreturn
	A_AttackC=H3_attackC
	A_AttackCReturn=H3_attackCreturn
	A_AttackStandA=H3_StandingattackA
	A_AttackStandAReturn=H3_StandingattackAReturn
	A_AttackStandB=H3_StandingattackB
	A_AttackStandBReturn=H3_StandingattackBReturn
	A_AttackBackupA=H3_BackupAttackA
	A_AttackBackupAReturn=H3_BackupAttackAReturn
	A_AttackBackupB=H3_BackupAttackB
	A_AttackBackupBReturn=H3_BackupAttackBReturn
	A_AttackStrafeRight=S1_StrafeRightAttack
	A_AttackStrafeLeft=S1_StrafeLeftAttack
	A_Throw=H3_throw
	A_Powerup=s2_powerup
	A_PainFront=H3_painFront
	A_PainRight=S1_painBack
	A_Taunt=H3_taunt
	A_PumpTrigger=H3_PumpTrigger
	A_LeverTrigger=H3_LeverTrigger
	PickupMessage="Trial Pit Mace"
	PickupSound=Sound'OtherSnd.Pickups.grab03'
	DropSound=Sound'WeaponsSnd.Drops.hammerdrop03'
	Mass=14.000000
	Skeletal=SkelModel'weapons.TrialMace'
	SkelGroupSkins(0)=Texture'weapons.TrialMacetrialpit_mace'
	SkelGroupSkins(1)=Texture'weapons.TrialMacetrialpit_mace'
}
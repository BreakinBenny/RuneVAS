class VM2ZombieViking expands Viking;

var config string VASStartWeapon[5];
var config string VASStartShield[5];

const DEFAULT_TWEEN = 0.15;

var() name CrucifiedAnim;
var() float LungeChance;
var(Sounds) sound DecapitateSound;
var(Sounds) sound GreenPuffSound;
var(Sounds) sound ZombieGetUpSound;
var ZombieEye Eyes;

function PostBeginPlay(){
local int i,wi,si;
local class<weapon> checkweapon;
local class<Shield> checkShield;

	i=0;
	wi=0;
	for(i=0; i<5; i++){
		if(VASStartWeapon[i] != "")
			wi += 1;
	}
	i=0;
	si=0;
	for(i=0; i<5; i++){
		if(VasStartShield[i] != "")
			si += 1;
	}
	StartStowWeapon = class<weapon>(DynamicLoadObject(VASStartWeapon[rand(wi)], class'Class'));
	if(StartStowWeapon==None)
		StartStowWeapon = default.StartWeapon;

	StartShield = class<shield>( DynamicLoadObject(VASStartShield[rand(si)], class'Class' ));
	if(StartShield==None)
		StartShield = default.StartShield;

	Super.PostBeginPlay();
	Eyes = Spawn(Class'ZombieEye');
	AttachActorToJoint(Eyes, JointNamed('head'));
	default.health =  RandRange(300,400) ;
	Default.maxhealth = default.health;
}

function PlayDyingSound(name damageType){
	if(damageType == 'decapitated')
		PlaySound(DecapitateSound, SLOT_Talk);
	else
		Super.PlayDyingSound(damageType);
}

function bool BodyPartCritical(int BodyPart){
	return false;
}

function SetOnFire(Pawn EventInstigator, int Joint){
	Super.SetOnFire(EventInstigator, Joint);

	GroundSpeed = Default.GroundSpeed * 2;
	LungeChance = Default.LungeChance * 3;
}

function PlayWaiting(optional float tween){
	  LoopAnim('weapon1_idle', 1.0, DEFAULT_TWEEN);
}

function PlayMoving(optional float tween){
	if(bHurrying)
		LoopAnim('S1_Walk', 0.75, DEFAULT_TWEEN);
	else
		LoopAnim('z_walkN', 1.0, DEFAULT_TWEEN);
}

function PlayStrafeLeft(optional float tween){
	LoopAnim('strafeleft', 0.75, DEFAULT_TWEEN);
}

function PlayStrafeRight(optional float tween){
	LoopAnim('straferight', 0.75, DEFAULT_TWEEN);
}

function PlayBackup(optional float tween){
	LoopAnim('weapon1_backup', 0.75, DEFAULT_TWEEN);
}

function PlayJumping(optional float tween){	PlayAnim  ('z_idle', 1.0, tween);	}
function PlayHuntStop(optional float tween){	LoopAnim  ('z_idle', 1.0, tween);	}

function PlayMeleeHigh(optional float tween){
	if(FRand() < 0.3)
		PlayAnim('atk_all_attack3_aa0s', 1.0, DEFAULT_TWEEN);
	else
		PlayAnim('z_breathe', 1.0, DEFAULT_TWEEN);
}
function PlayMeleeLow(optional float tween){
	PlayAnim('atk_all_attack3_aa0s', 1.0, DEFAULT_TWEEN);
}
function PlayTurning(optional float tween){
	PlayAnim('z_idle', 1.0, tween);
}

function PlayCower(optional float tween){	LoopAnim('z_idle', 1.0, tween);	}
function PlayThrowing(optional float tween)
{	//TODO: Switch weapon type for different throws
	PlayAnim('z_idle', 1.0, tween);
}
function PlayTaunting(optional float tween){	PlayAnim('z_idle', 1.0, tween);	}
function PlayInAir(optional float tween){
	LoopAnim  ('z_idle', 1.0, DEFAULT_TWEEN);
}
function LongFall(){
	if(AnimSequence != 'z_idle')
		LoopAnim('z_idle', 1.0, 0.1);
}
function PlayLanding(optional float tween){
	if(AnimSequence == 'z_idle')
		PlayAnim('z_idle', 1.0, 0.1);
	else if(AnimSequence == 'z_idle')
		PlayAnim('z_idle', 1.0, 0.1);
	else
		PlayAnim('z_idle', 1.0, 0.1);
}

function PlayDodgeLeft(optional float tween){	PlayAnim('z_idle', 1.0, tween);	}
function PlayDodgeRight(optional float tween){	PlayAnim('z_idle', 1.0, tween);	}
function PlayDodgeForward(optional float tween){	PlayAnim  ('z_idle', 1.0, tween);	}
function PlayDodgeBack(optional float tween){	PlayAnim('z_idle', 1.0, tween);	}
function PlayDodgeBackflip(optional float tween){	PlayAnim ('z_idle', 1.0, tween);	}
function PlayDodgeDuck(optional float tween){	PlayAnim('z_idle', 1.0, tween);	}
function PlayBlockHigh(optional float tween){	LoopAnim('z_idle', 1.0, tween);	}
function PlayBlockLow(optional float tween){	LoopAnim('z_idle', 1.0, tween);	}

function PlayFrontHit(float tweentime){}
function PlayHeadHit(optional float tween){	/* PlayAnim('pain', 1.0, tween); */	}
function PlayBodyHit(optional float tween){	/*PlayAnim('pain', 1.0, tween); */	}
function PlayLArmHit(optional float tween){	/*PlayAnim('pain', 1.0, tween); */	}
function PlayRArmHit(optional float tween){	/*PlayAnim('pain', 1.0, tween); */	}
function PlayLLegHit(optional float tween){	/*PlayAnim('pain', 1.0, tween); */	}
function PlayRLegHit(optional float tween){	/*PlayAnim('pain', 1.0, tween); */	}
function PlayDrowning(optional float tween){	/*LoopAnim('drown', 1.0, tween); */	}

function PlayDeath(name DamageType){
	PlayAnim('z_deadhead', 1.0, 0.1);
}

function PlayDrownDeath(name DamageType){	PlayAnim('z_idle', 1.0, 0.1);	}

function TweenToThrowing(float time){	TweenAnim('throwA',  time);	}
function TweenToJumping(float time){	TweenAnim('MOV_ALL_jump1_AA0S', time);	}
function TweenToWaiting(float time){
	LoopAnim('weapon1_idle', time);
}

function TweenToMoving(float time){
	TweenAnim('S1_Walk', time);
}
function TweenToTurning(float time){
	TweenAnim('weapon1_idle', time);
}

function Died(pawn Killer, name damageType, vector HitLocation){
	Super.Died(Killer, damageType, HitLocation);
}

function AltWeaponActivate(){
local actor a;
local rotator r;
local vector l;

	if(Enemy == None)
		return;

	r = rotator(Enemy.Location - Location);
	l = GetJointPos(JointNamed('head')) + vector(r) * 10;

	a = Spawn(class'ZombieBreath', self,, l, r);
	a.Velocity = vector(r) * 100;
	a.SetPhysics(PHYS_Projectile);

	PlaySound(GreenPuffSound);
}

function Texture PainSkin(int BodyPart){
	return None;
}

function int BodyPartForPolyGroup(int polygroup){
	switch(polygroup){
		case 1:	case 3:	return BODYPART_RARM1;
		case 2:	return BODYPART_RLEG1;
		case 4:	return BODYPART_TORSO;
		case 5:	return BODYPART_HEAD;
		case 6:	return BODYPART_LLEG1;
		case 7:	case 8:	return BODYPART_LARM1;
	}
	return BODYPART_BODY;
}

function ApplyGoreCap(int BodyPart){}


function class<Actor> SeveredLimbClass(int BodyPart){
	switch(BodyPart){
		case BODYPART_LARM1:
		return class'ZombieLArm';
		case BODYPART_RARM1:
		return class'ZombieRArm';
		case BODYPART_HEAD:
		return class'ZombieHead';
		break;
	  }
	  return None;
}

defaultproperties{
	  VASStartWeapon(0)="RuneI.VikingBroadSword"
	  VASStartWeapon(1)="RuneI.DwarfWorkSword"
	  VASStartShield(0)="RuneI.DarkShield"
	  VASStartShield(1)="RuneI.DwarfBattleShield"
	  VASStartShield(2)="RuneI.DwarfWoodShield"
	  VASStartShield(3)="RuneI.VikingShield"
	  LungeChance=0.200000
	  DecapitateSound=Sound'CreaturesSnd.Zombie.zombiedecap01'
	  GreenPuffSound=Sound'CreaturesSnd.Zombie.zombiepuff01'
	  ZombieGetUpSound=Sound'CreaturesSnd.Zombie.zombiegetup01'
	  HighOrLow=1.000000
	  LatOrVertDodge=1.000000
	  HighOrLowBlock=1.000000
	  AcquireSound=Sound'CreaturesSnd.Zombie.zombiesee01'
	  AmbientWaitSounds(0)=Sound'CreaturesSnd.Zombie.zombieambient01'
	  AmbientWaitSounds(1)=Sound'CreaturesSnd.Zombie.zombieambient02'
	  AmbientWaitSounds(2)=Sound'CreaturesSnd.Zombie.zombieambient03'
	  AmbientFightSounds(0)=Sound'CreaturesSnd.Zombie.zombieattack01'
	  AmbientFightSounds(1)=Sound'CreaturesSnd.Zombie.zombieattack01'
	  AmbientFightSounds(2)=Sound'CreaturesSnd.Zombie.zombieattack01'
	  AmbientFightSoundDelay=8.000000
	  StartShield=None
	  CarcassType=Class'RuneI.ZombieCarcass'
	  CombatRange=140.000000
	  GroundSpeed=170.000000
	  ClassID=10
	  PeripheralVision=-1.000000
	  Health=300
	  BodyPartHealth(1)=100
	  BodyPartHealth(3)=100
	  BodyPartHealth(5)=100
	  HitSound1=Sound'CreaturesSnd.Zombie.zombiehit01'
	  HitSound2=Sound'CreaturesSnd.Zombie.zombiehit02'
	  HitSound3=Sound'CreaturesSnd.Zombie.zombiehit03'
	  Die=Sound'CreaturesSnd.Zombie.zombiedeath01'
	  Die2=Sound'CreaturesSnd.Zombie.zombiedeath02'
	  Die3=Sound'CreaturesSnd.Zombie.zombiedeath03'
	  FootStepWood(0)=Sound'CreaturesSnd.Zombie.zombiefoot01'
	  FootStepWood(1)=Sound'CreaturesSnd.Zombie.zombiefoot02'
	  FootStepWood(2)=Sound'CreaturesSnd.Zombie.zombiefoot01'
	  FootStepMetal(0)=Sound'CreaturesSnd.Zombie.zombiefoot01'
	  FootStepMetal(1)=Sound'CreaturesSnd.Zombie.zombiefoot02'
	  FootStepMetal(2)=Sound'CreaturesSnd.Zombie.zombiefoot01'
	  FootStepStone(0)=Sound'CreaturesSnd.Zombie.zombiefoot01'
	  FootStepStone(1)=Sound'CreaturesSnd.Zombie.zombiefoot02'
	  FootStepStone(2)=Sound'CreaturesSnd.Zombie.zombiefoot01'
	  FootStepFlesh(0)=Sound'CreaturesSnd.Zombie.zombiefoot01'
	  FootStepFlesh(1)=Sound'CreaturesSnd.Zombie.zombiefoot02'
	  FootStepFlesh(2)=Sound'CreaturesSnd.Zombie.zombiefoot01'
	  FootStepIce(0)=Sound'CreaturesSnd.Zombie.zombiefoot01'
	  FootStepIce(1)=Sound'CreaturesSnd.Zombie.zombiefoot02'
	  FootStepIce(2)=Sound'CreaturesSnd.Zombie.zombiefoot01'
	  FootStepEarth(0)=Sound'CreaturesSnd.Zombie.zombiefoot01'
	  FootStepEarth(1)=Sound'CreaturesSnd.Zombie.zombiefoot02'
	  FootStepEarth(2)=Sound'CreaturesSnd.Zombie.zombiefoot01'
	  FootStepSnow(0)=Sound'CreaturesSnd.Zombie.zombiefoot01'
	  FootStepSnow(1)=Sound'CreaturesSnd.Zombie.zombiefoot02'
	  FootStepSnow(2)=Sound'CreaturesSnd.Zombie.zombiefoot01'
	  CombatStyle=1.000000
	  WeaponJoint=rhand
	  MaxMouthRot=7000
	  MaxMouthRotRate=65535
	  DrawScale=1.250000
	  TransientSoundRadius=1200.000000
	  CollisionHeight=51.000000
	  SkelMesh=11
	  SkelGroupSkins(0)=Texture'Players.Ragnarragd_arms'
	  SkelGroupSkins(1)=Texture'Players.Ragnarz_armleg'
	  SkelGroupSkins(2)=Texture'Players.Ragnarz_armleg'
	  SkelGroupSkins(3)=Texture'Players.Ragnarz_armleg'
	  SkelGroupSkins(4)=Texture'Players.Ragnarz_body'
	  SkelGroupSkins(5)=Texture'Players.Ragnarz_head'
	  SkelGroupSkins(6)=Texture'Players.Ragnarz_armleg'
	  SkelGroupSkins(7)=Texture'Players.Ragnarz_armleg'
	  SkelGroupSkins(8)=Texture'Players.Ragnarz_armleg'
	  SkelGroupSkins(9)=Texture'Players.Ragnarz_head'
	  SkelGroupSkins(10)=Texture'Players.Ragnarz_neckgore'
	  SkelGroupSkins(11)=Texture'Players.Ragnarragd_arms'
	  SkelGroupSkins(12)=Texture'Players.Ragnarragd_arms'
	  SkelGroupSkins(13)=Texture'Players.Ragnarragd_arms'
	  SkelGroupSkins(14)=Texture'Players.Ragnarragd_arms'
	  SkelGroupSkins(15)=Texture'Players.Ragnarragd_arms'
}
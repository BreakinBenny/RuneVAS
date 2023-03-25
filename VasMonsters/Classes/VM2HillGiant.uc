class VM2HillGiant expands Viking;

var float tempcollisionsize1;
var float tempcollisionsize2;

var config string VASStartWeapon[5];
var config string VASStartShield[5];

function DoThrow(){
local actor throwitem;
local int traj;
local vector throwloc;
local vector dest;

	if(Enemy != None)
		OrderObject = Enemy;

	throwloc = GetJointPos(JointNamed(WeaponJoint));
	throwitem = DetachActorFromJoint(JointNamed(WeaponJoint));
	if(throwitem != None && OrderObject != None){
		if(throwItem.IsA('inventory'))
			DeleteInventory(Inventory(throwItem));

		traj = ThrowTrajectory;
		dest = OrderObject.Location + OrderObject.Velocity * 0.1;
		throwitem.SetPhysics(PHYS_Falling);
		throwitem.Acceleration = vect(0,0,0);
		throwitem.Velocity = CalcArcVelocity(traj, throwloc, dest);
		throwitem.GotoState('Throw');

		throwitem.SetOwner(self);

		if(Weapon == throwitem)
			Weapon = None;
	}
}

function bool CanPickup(Inventory item){
	if(Health < 1)
		return false;

	if(item.IsA('Weapon') && (BodyPartHealth[BODYPART_RARM1] > 0) && (Weapon == None))
		return (item.IsA('VM2Rock') || item.IsA('Hammer'));
	return(false);
}

function Makerock(){
	local Weapon w;
	if(Weapon == NONE){
		w = Spawn(StartWeapon, self,, Location);
		w.Touch(self);
		W.SetPhysics(PHYS_Falling);
		W.bCollideWorld = true;
		W.bTossedOut = true;
		W.RespawnTime = 0.0;
		W.ExpireTime = 15.0;
		W.lifeSpan = 15.0;
		W.bExpireWhenTossed = true;
	}
}


function PostBeginPlay(){
local int i,wi,si;
local class<weapon> checkweapon;
local class<Shield> checkShield;

	StartWeapon = default.StartWeapon;
	ThrowTrajectory=2500 ;

	if(StartWeapon == Class'VM2Bonuspack1.VM2Rock')
		Makerock();

	Drawscale = 3.0;
	default.Drawscale = 3.0;
	Super.PostBeginPlay();
	default.health =  RandRange(1200,2600);
	Default.maxhealth = default.health;
	health = default.health;
	jumpz = jumpz * DrawScale/Default.DrawScale;
	tempcollisionsize1 = Default.CollisionRadius*DrawScale/Default.DrawScale;
	tempcollisionsize2 = Default.CollisionHeight*DrawScale/Default.DrawScale;
	SetCollisionSize(tempcollisionsize1,tempcollisionsize2);
	GroundSpeed = GroundSpeed * DrawScale/Default.DrawScale;
}

function Texture PainSkin(int BodyPart){
	return None;
}

function int BodyPartForPolyGroup(int polygroup){
	switch(polygroup){
		case 4:	return BODYPART_HEAD;
		case 10:	return BODYPART_LARM1;
		case 11:	return BODYPART_RARM1;
		case 2: case 6:	return BODYPART_LLEG1;
		case 1:	case 5:	return BODYPART_RLEG1;
		case 3: case 7: case 9: case 12:
		case 8: case 13:	return BODYPART_TORSO;
	}
	return BODYPART_BODY;
}

function ApplyGoreCap(int BodyPart){
	switch(BodyPart){
		case BODYPART_LARM1:
			SkelGroupSkins[9] = Texture'runefx.gore_bone';
			SkelGroupFlags[9] = SkelGroupFlags[9] & ~POLYFLAG_INVISIBLE;
			break;
		case BODYPART_RARM1:
			SkelGroupSkins[12] = Texture'runefx.gore_bone';
			SkelGroupFlags[12] = SkelGroupFlags[12] & ~POLYFLAG_INVISIBLE;
			break;
		case BODYPART_HEAD:
			SkelGroupSkins[7] = Texture'runefx.gore_bone';
			SkelGroupFlags[7] = SkelGroupFlags[7] & ~POLYFLAG_INVISIBLE;
			break;
	}
}

function class<Actor> SeveredLimbClass(int BodyPart){
	return None;
}

State Fighting{
ignores EnemyAcquired;

	function BeginState(){
		bAvoidLedges = true;
		LookAt(Enemy);
		SetTimer(0.1, true);
	}
	function EndState(){
		bAvoidLedges = false;

		bSwingingHigh = false;
		bSwingingLow  = false;

		if(Weapon != None){
			Weapon.FinishAttack();
			Weapon.DisableSwipeTrail();
		}

		LookAt(None);
		SetTimer(0, false);
	}

	function AmbientSoundTimer(){
		PlayAmbientFightSound();
	}

	function bool BlockRatherThanDodge(){
		if(Shield == None)
			return false;

		if(EnemyIncidence != INC_FRONT)
			return false;

		return (FRand() < BlockChance);
	}

	function bool CheckStrafeLeft(){
		local vector HitLocation, HitNormal;
		local vector extent, end;

		extent.X = CollisionRadius;
		extent.Y = CollisionRadius;
		extent.Z = CollisionHeight * 0.5;

		CalcStrafePosition();

		end = Normal(Destination - Location) * 75;

		if(Trace(HitLocation, HitNormal, end, Location, true, extent) == None)
			return(true);
		else
			return(false);
	}

	function bool CheckStrafeRight(){
		local vector HitLocation, HitNormal;
		local vector extent, end;

		extent.X = CollisionRadius;
		extent.Y = CollisionRadius;
		extent.Z = CollisionHeight * 0.5;

		CalcStrafePosition2();

		end = Normal(Destination - Location) * 75;

		if(Trace(HitLocation, HitNormal, end, Location, true, extent) == None)
			return(true);
		else
			return(false);
	}

	function Timer(){
		GetEnemyProximity();

		LastAction = AttackAction;

		if(EnemyMovement == MOVE_STRAFE_LEFT && FRand() < 0.8 && CheckStrafeLeft())
			AttackAction = AA_STRAFE_LEFT;
		else if(EnemyMovement == MOVE_STRAFE_RIGHT && FRand() < 0.8 && CheckStrafeRight())
			AttackAction = AA_STRAFE_RIGHT;
		else if((EnemyMovement == MOVE_STANDING && FRand() < 0.65) || FRand() < 0.2)
			AttackAction = AA_LUNGE;
		else if(FRand() < 0.9){
			if(FRand() < 0.5 && LastAction != AA_STRAFE_RIGHT || LastAction == AA_STRAFE_LEFT && CheckStrafeLeft())
				AttackAction = AA_STRAFE_LEFT;
			else if(LastAction != AA_STRAFE_LEFT || LastAction == AA_STRAFE_RIGHT && CheckStrafeRight())
				AttackAction = AA_STRAFE_RIGHT;
			else
				AttackAction = AA_WAIT;
		 }
		else
			AttackAction = AA_WAIT;
	}

	function bool ShouldDefend(){
		return (FRand() > FightOrDefend && InDangerFromAttack());
	}

	function bool InDangerFromAttack(){
		if((!Enemy.bSwingingHigh) && (!Enemy.bSwingingLow))
			return false;

		GetEnemyProximity();

		if(EnemyDist>CollisionRadius+Enemy.CollisionRadius+Enemy.MeleeRange)
			return false;

		return (EnemyVertical==VERT_LEVEL && EnemyFacing==FACE_FRONT);
	}

	function CalcStrafePosition(){
		local vector V;
		local rotator R;
		local vector temp;

		if(Enemy == None){
			Destination = Location;
			return;
		}

		V = Location - Enemy.Location;
		R = rotator(V);

		R.Yaw += 2000;

		temp = Enemy.Location;
		temp.Z = Location.Z;

		Destination = temp + vector(R) * CombatRange;
	}

	function CalcStrafePosition2(){
		local vector V;
		local rotator R;
		local vector temp;

		if(Enemy == None){
			Destination = Location;
			return;
		}

		V = Location - Enemy.Location;
		R = rotator(V);

		R.Yaw -= 2000;

		temp = Enemy.Location;
		temp.Z = Location.Z;

		Destination = temp + vector(R) * CombatRange;
	}

	function CalcJumpVelocity(){
		local float traj;
		local vector adjust;

		traj = (70 + Rand(5)) * 65536 / 360;
		adjust = Enemy.Location - Location;
		AddVelocity(CalcArcVelocity(traj, Location, Enemy.Location + adjust));
	}

Begin:
	if(Enemy == None)
		Goto('BackFromSubState');

	Acceleration = vect(0,0,0);

	DesiredRotation.Yaw = rotator(Enemy.Location-Location).Yaw;

	if(Weapon != None && Weapon.MeleeType == MELEE_NON_STOW && StowWeapon != None){
		PlayAnim('IDL_ALL_drop1_AA0S', 1.0, DEFAULT_TWEEN);
		FinishAnim();
	}

	if(Weapon == None && StowWeapon != None){
		switch(StowWeapon.MeleeType){
		case MELEE_SWORD:
			PlayAnim('IDL_ALL_sstow1_AA0S', 1.0, DEFAULT_TWEEN);
			break;
		case MELEE_AXE:
			PlayAnim('IDL_ALL_xstow1_AA0S', 1.0, DEFAULT_TWEEN);
			break;
		case MELEE_HAMMER:
			PlayAnim('IDL_ALL_hstow1_AA0S', 1.0, DEFAULT_TWEEN);
			break;
		}

		FinishAnim();
	}

Fight:
	if(!ValidEnemy())
		Goto('BackFromSubState');

	if(rand(100) <= 5){
		makerock();
		dothrow();
		Sleep(1.0);
	}

	GetEnemyProximity();

	if(Weapon != None && (InMeleeRange(Enemy) || (EnemyMovement == MOVE_CLOSER && EnemyDist < MeleeRange * 2.5))){
		if(LastAction != AA_LUNGE && FRand() < 0.2){
			PlayMoving();
			if(FRand() < 0.7){
				bStopMoveIfCombatRange = false;
				ActivateShield(true);
				PlayBackup();
				StrafeFacing(Location - vector(Rotation) * (CombatRange - EnemyDist), Enemy);
				ActivateShield(false);
				bStopMoveIfCombatRange = true;
			}
			else{
				bStopMoveIfCombatRange = false;
				ActivateShield(true);
				PlayStrafeRight();
				StrafeFacing(Location + vector(Rotation + rot(0, 16384, 0)) * CombatRange, Enemy);
				ActivateShield(false);
				bStopMoveIfCombatRange = true;
			}
		}
		else{
			WeaponActivate();
			Weapon.EnableSwipeTrail();

			PlayAnim(Weapon.A_AttackStandA, 1.0, 0.1);
			FinishAnim();

			if(Weapon.A_AttackStandB != 'None' && FRand() < 0.5){
				ClearSwipeArray();
				PlayAnim(Weapon.A_AttackStandB, 1.0, 0.01);
				if(Enemy != None)
					TurnToward(Enemy);
				FinishAnim();

				WeaponDeactivate();

				if(Weapon.A_AttackStandBReturn != 'None'){
					PlayAnim(Weapon.A_AttackStandBReturn, 1.0, 0.1);
					FinishAnim();
				}
			}
			else{
				WeaponDeactivate();

				if(Weapon.A_AttackStandAReturn != 'None'){
					PlayAnim(Weapon.A_AttackStandAReturn, 1.0, 0.1);
					FinishAnim();
				}
			}

			Weapon.DisableSwipeTrail();
		}

		Sleep(TimeBetweenAttacks);
	}
	else if(AttackAction == AA_LUNGE){
		PlayMoving();
		bStopMoveIfCombatRange = false;
		MoveTo(Enemy.Location - VecToEnemy * MeleeRange, MovementSpeed);
		bStopMoveIfCombatRange = true;
	}
	else if(AttackAction == AA_STRAFE_LEFT){
		PlayStrafeLeft();
		bStopMoveIfCombatRange = false;
		StrafeFacing(Destination, Enemy);
		bStopMoveIfCombatRange = true;
	}
	else if(AttackAction == AA_STRAFE_RIGHT){
		PlayStrafeRight();
		bStopMoveIfCombatRange = false;
		StrafeFacing(Destination, Enemy);
		bStopMoveIfCombatRange = true;
	}
	else if(AttackAction == AA_JUMP){
		PlayJumping();
		CalcJumpVelocity();
		WaitForLanding();
		FinishAnim();
	}
	else
		PlayWaiting();

	if(InCombatRange(Enemy)){
		Sleep(0.05);
		Goto('Begin');
	}

BackFromSubState:
	GotoState('Charging', 'ResumeFromFighting');
}

defaultproperties{
	StartStowWeapon=Class'RuneI.DwarfWorkHammer'
	AmbientWaitSoundDelay=9.000000
	AmbientFightSoundDelay=6.000000
	StartWeapon=Class'VM2BonusPack.VM2Rock'
	StartShield=None
	MeleeRange=100.000000
	CombatRange=200.000000
	HitSound1=Sound'CreaturesSnd.Vikings.vike2hit01'
	HitSound2=Sound'CreaturesSnd.Vikings.vike2hit02'
	HitSound3=Sound'CreaturesSnd.Vikings.vike2hit03'
	Die=Sound'CreaturesSnd.Vikings.vike2death01'
	Die2=Sound'CreaturesSnd.Vikings.vike2death02'
	Die3=Sound'CreaturesSnd.Vikings.vike2death03'
	FootStepWood(0)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepWood(1)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepWood(2)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepMetal(0)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepMetal(1)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepMetal(2)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepStone(0)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepStone(1)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepStone(2)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepFlesh(0)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepFlesh(1)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepFlesh(2)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepIce(0)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepIce(1)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepIce(2)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepEarth(0)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepEarth(1)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepEarth(2)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepSnow(0)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepSnow(1)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepSnow(2)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepWater(0)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepWater(1)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepWater(2)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepMud(0)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepMud(1)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepMud(2)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepLava(0)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepLava(1)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	FootStepLava(2)=Sound'CreaturesSnd.Dwarves.bossfoot01'
	MaxMouthRot=7000
	MaxMouthRotRate=65535
	DeathRadius=40.000000
	DeathHeight=33.000000
	DrawScale=3.000000
	CollisionRadius=48.000000
	CollisionHeight=120.000000
	SkelMesh=7
}
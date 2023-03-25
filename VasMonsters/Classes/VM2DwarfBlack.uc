class VM2DwarfBlack expands DwarfBlack;
var bool bInitialized;
var private int PowerLevel, loop;
var private DarkDwarfChargeup chargeup;
var private DarkDwarfBolt bolt;
var private actor LightningTarget;
var float SpringMag, HealthMax, MoveRadius;
var(Sounds) sound ChargeupSoundLOOP, ReleaseSoundLOOP,OverchargedSoundLOOP;
function PostBeginPlay(){
Super.PostBeginPlay();
chargeup=spawn(class'DarkDwarfChargeup',,,,);
AttachActorToJoint(chargeup, 28);
bolt=Spawn(class'VM2DarkDwarfBolt',self,'bolt',,);
AttachActorToJoint(bolt, 29);
bolt.bHidden=true;
bolt.Target=None;
chargeup.SetPowerLevel(PowerLevel);
bolt.SetPowerLevel(PowerLevel);
HealthMax=Health;}
function Trigger(actor Other, pawn EventInstigator)
{chargeup.SetPowerLevel(PowerLevel);bolt.SetPowerLevel(PowerLevel);}
State Fighting
{
function EndState(){
	BoltOff();
	AmbientSound=None;
	chargeup.StopExpanding();
	chargeup.Hide();}
	function DoThrow(){
	if(bolt!=None)bolt.DoDamage();}
	function AmbientSoundTimer(){
	PlayAmbientFightSound();}
	function BoltOn(){
	bolt.bHidden = false;
	bolt.ResetTargetting();}
	function BoltOff(){
	bolt.bHidden = true;}
	function bool ShouldShoot(){
	local Actor HitActor;
	local vector HitLocation, HitNormal;
	local vector FireLocation;
	FireLocation = GetJointPos(JointNamed('attach_hand'));
	if(InRange(Enemy, CombatRange)){
		HitActor = Trace(HitLocation, HitNormal, Enemy.Location+(vect(0,0,1)*Enemy.EyeHeight), FireLocation, true, vect(5,5,5));
		if(HitActor != None){
			bolt.SetTarget(HitActor);
			if(HitActor.IsA('LevelInfo'))
				return false;
			else if(HitActor.IsA('PolyObj'))
				return (powerlevel > 1);
			else if(HitActor == Enemy)
				return true;
			else
				return false;}
		return true;}
		return false;}

	function bool PickDestination(){
	
		local int i;
		local actor HitActor;
		local vector HitLocation, HitNormal, newloc;
		bHurrying = false;
		UpdateMovementSpeed();
		Destination = Location;
		for(i=0; i<10; i++){
			newloc = HomeBase + VRand()*MoveRadius;
			newloc.Z = HomeBase.Z;
			HitActor = Trace(HitLocation, HitNormal, newloc, Enemy.Location, false, vect(5,5,5));
			if(HitActor == None){
			Destination = newloc;return true;}}
		return false;}
Begin:
Think:
	Sleep(0.5);
	if(!InRange(Enemy, CombatRange))
		VasAttackOther();
	if(!ValidEnemy()){
		Sleep(0.5);
		GotoState('GoingHome');}
	if(ShouldShoot())
		GotoState('AttackingPlayer');
	AfterAttack:
	if(PickDestination()){
	
		PlayMoving(0.1);
		MoveTo(Destination, MovementSpeed);
		Acceleration=vect(0,0,0);
		TurnToward(Enemy);
	}
	Goto('think');
}

function class<Actor> SeveredLimbClass(int BodyPart){
	return None;}

function bool JointDamaged(int Damage, Pawn EventInstigator, vector HitLoc, vector Momentum, name DamageType, int joint){
	local bool rtn;
	DamageType =('blunt');
	Enemy = EventInstigator;
	if(Health < (HealthMax/5)*4){
		PowerLevel = 2;
		bolt.SetPowerLevel(PowerLevel);
	}
	if(Health < (HealthMax/5)*3){
		PowerLevel = 3;
		bolt.SetPowerLevel(PowerLevel);
	}
	if( Health < (HealthMax/5)*2){
		PowerLevel = 4;
		bolt.SetPowerLevel(PowerLevel);
	}
	if(Health < (HealthMax/5)){
		PowerLevel= 5;
		bolt.SetPowerLevel(PowerLevel);
	}
	GotoState('Fighting');
	rtn = Super(ScriptPawn).JointDamaged(Damage, EventInstigator, HitLoc, Momentum, DamageType, joint);
	return rtn;
}

function VasAttackOther(){
	local Pawn V;
	foreach VisibleActors(class'Pawn', V){
		if(V != self && V.Health > 0 && V.IsA('Pawn')){
			Enemy = V;
			return;}
	}
	return;}

State AttackingPlayer{

ignores JointDamaged;
	function EndState(){
		BoltOff();
		AmbientSound=None;
		chargeup.StopExpanding();
		chargeup.Hide();
	}
	function DoThrow(){
		if(bolt!=None)
			bolt.DoDamage();}

	function AmbientSoundTimer(){
		PlayAmbientFightSound();}

	function BoltOn(){
		bolt.bHidden = false;
		bolt.ResetTargetting();}

	function BoltOff(){
		bolt.bHidden = true;}

Begin:
	if(NeedToTurn(Enemy.Location)){
		PlayTurning(0.1);
		TurnToward(Enemy);}
	AmbientSound=ChargeupSoundLOOP;
	chargeup.StartExpanding();
	PlayAnim('dd_attacka', 1.0, 0.1);
	FinishAnim();
	PlayAnim('dd_fireA', 1.0, 0.1);
	chargeup.StopExpanding();
	AmbientSound=ReleaseSoundLOOP;
	BoltOn();
	Sleep(1);
	BoltOff();
	AmbientSound=None;
	chargeup.Hide();
	FinishAnim();
	PlayWaiting(0.5);
	Sleep(0.5);
	FinishAnim();
	Sleep(0.5);
	GotoState('Fighting', 'AfterAttack');
}

State Overcharged{
ignores SeePlayer, EnemyNotVisible, HearNoise, KilledBy, Trigger, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, Falling, WarnTarget, LongFall, PainTimer, Landed, EnemyAcquired, JointDamaged;
Begin:
GotoState('Dying');
}

State Dying{
ignores SeePlayer, EnemyNotVisible, HearNoise, KilledBy, Trigger, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, Falling, WarnTarget, Died, LongFall, PainTimer, Landed, EnemyAcquired, JointDamaged;

	function BeginState(){
		MakeSpringy();
		Timer();}
	function EndState(){
		SetTimer(0, false);}
	function MakeSpringy(){
		local int i;
		for(i=1; i<NumJoints(); i++)
			JointFlags[i] = JointFlags[i] | JOINT_FLAG_SPRINGPOINT;
	}
	function Spring(){
		local int i;
		for(i=1; i<NumJoints(); i++)
			ApplyJointForce(i, VRand()*Rand(SpringMag));
	}
	function Timer(){
		DesiredFatness=Rand(255);
		if(FRand() < 0.4)
			PlaySound(Sound'OtherSnd.Explosions.explosion10', SLOT_None);
		else
			PlaySound(Sound'OtherSnd.Explosions.explosion11', SLOT_None);

		SetTimer(FRand()*0.5, false);

		Spring();
	}
	function RemoveLightning(){
		local actor A;
		local DarkDwarfLightning B;
		local SparkSystem C;

		foreach AllActors(class 'DarkDwarfLightning', B,)
			B.Target = LightningTarget;

		foreach AllActors(class 'actor', A, 'Concentrator'){
			A.Target = None;
			A.bHidden = true;
		}
	}
	function ResetLightning(){
		local DarkDwarfLightning A;

		foreach AllActors(class 'DarkDwarfLightning', A,){
			if(LightningTarget == None)
				LightningTarget = A.Target;
			A.Target = self;
			A.TargetJointIndex = Rand(NumJoints() - 1);
		}
	}
Begin:
	Acceleration=vect(0,0,0);
	ResetLightning();
	PlayDeath('overcharged');
	AmbientSound=OverchargedSoundLoop;
	Sleep(8);
	AmbientSound=None;
	SetTimer(0, false);
	RemoveLightning();
	spawn(class'DarkDwarfExplosion',,,,);
	spawn(class'DarkDwarfBlast',,,Location + vect(0,0,-50),);
	Destroy();
}
state StakeOut{
	ignores SeePlayer, HearNoise, EnemyAcquired;

	function BeginState(){
		bHurrying = true;
		UpdateMovementSpeed();
		SetTimer(1.0+FRand(), true);
		LastPathTime = Level.TimeSeconds;
	}

	function EndState(){
		SetTimer(0, false);}

	function Timer(){
		CheckReachable();}

	function CheckReachable(){
		if(Level.TimeSeconds - LastPathTime < 1)
			return;
		if(Enemy == None)
			return;

		if(HuntDistance > 0 && VSize(HomeBase-Enemy.Location)>HuntDistance)
		{teststring2 = Enemy.name @"is outside huntdistance";
		 return;}

		if(actorReachable(Enemy)){
			teststring2 = Enemy.name @"is actorreachable";
			GotoState('Charging');
			return;}

		LastPathTime = Level.TimeSeconds;

		if(FindBestPathToward(Enemy)){
			if(HuntDistance > 0 && VSize(HomeBase-Destination)>HuntDistance){
				teststring2 = "path is outside huntdistance";
				return;
			}

			teststring2 = Enemy.name @"is pathable - hunting";
			GotoState('Charging');
			return;
		}

		teststring2 = Enemy.name @"unpathable";
	}

Begin:
	if(debugstates) SLog(name@"Stakeout");
	Acceleration = vect(0,0,0);
	SetPhysics(PHYS_Falling);

Stay:
	if(!ValidEnemy())
		GotoState('GoingHome');

	PlayWaiting(0.1);
	Sleep(2);
	GotoState('GoingHome');
}

defaultproperties{}
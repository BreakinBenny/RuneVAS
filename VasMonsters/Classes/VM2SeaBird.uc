class VM2SeaBird expands SeaBird;
Var Bool bcanattack;
Var int birddamage;

function PostBeginPlay(){
	birddamage = RandRange(3,10);
	bcanattack = true;
	Super.PostBeginPlay();
	default.health =  RandRange(10,50) ;
	Default.maxhealth = default.health;
	SetTimer(2.000000,true);
}

function timer(){
bcanattack = True;}

function Touch(actor other){
	SetTimer(1.000000,false);
	if(other.IsA('VM2SeaBird'))
		Return;
	if(bcanattack){
		PlaySound(HitSound1, Slot_None);
		Other.JointDamaged(birddamage, self, other.Location, vect(0, 0, 0), 'blunt', 0);
		bcanattack = false;
	}
}

State Fleeing{
	function HitWall(vector HitNormal, actor Wall){
		// avoid cowering
		global.HitWall(HitNormal, Wall);
	}

	function PickDestination(){
		Destination = Location + VRand()*50;}

Move:
	PickDestination();
	MoveTo(Destination, MovementSpeed);

	if(Ally != NONE){
		if(rand(100)<= 20)
		GotoState('Follow');}
		if(rand(100)<= 20)
			GotoState('Charging');
			Goto('Move');}

state() Circle{
	singular function ZoneChange(ZoneInfo NewZone){
		if(NewZone.bWaterZone || NewZone.bPainZone){
			SetLocation(OldLocation);
			Velocity = vect(0,0,0);
			Acceleration = vect(0,0,0);
			MoveTimer = -1.0;
		}
	}

begin:
	PlayMoving(0.1);

Move:

	Angle += 1.0484; //2*3.1415/6;
	Destination.X = CircleCenter.X - CircleRadius * Sin(Angle);
	Destination.Y = CircleCenter.Y + CircleRadius * Cos(Angle);
	Destination.Z = CircleCenter.Z + 30 * FRand() - 15;
	MoveTo(Destination, MovementSpeed);
	Goto('Move');
}

State Charging{
ignores EnemyAcquired, SeePlayer, HearNoise;

	function BeginState(){
		StopLookingToward();
		lookAt(Enemy);
		SetTimer(0.1, true);
		bHurrying = true;
		UpdateMovementSpeed();}

	function EndState(){
		LookAt(None);
		SetTimer(0, false);
		if(JumpZ > 0)
			bCanJump = true;
	}

	function Timer(){
		if(!ValidEnemy())
			GotoState('GoingHome');
		else if(Enemy.Region.Zone.bWaterZone && !bCanSwim)
			GotoState('TacticalDecision');
		else if(!Enemy.Region.Zone.bWaterZone && !bCanFly && !bCanWalk)
			GotoState('GoingHome');
		else{
			if((Enemy.bSwingingHigh || Enemy.bSwingingLow) && InMeleeRange(Enemy))
				GotoState('Fighting', 'CheckDefend');
			else if(InAttackRange(Enemy))
				GotoState('Fighting');
		}
	}

	function EnemyNotVisible(){
		GotoState('Hunting');
	}

	function HitWall(vector HitNormal, actor Wall){
		global.HitWall(HitNormal, Wall);

		if(Physics == PHYS_Falling)
			return;

		if(bCanGrabEdges && bCanStrafe){
			SetPhysics(PHYS_Falling);
			return;
		}

		if(Wall.IsA('Mover') && Mover(Wall).HandleDoor(self)){
			if(SpecialPause > 0)
				Acceleration = vect(0,0,0);
			GotoState('Charging', 'SpecialNavig');
			return;
		}
		Focus = Destination;
		if(PickWallAdjust())
			GotoState('Charging', 'AdjustFromWall');
		else
			MoveTimer = -1.0;
	}

	function vector CheckDestination(vector loc){
		if(VSize(loc - HomeBase) > HuntDistance)
			return (Normal(loc-HomeBase)*(HuntDistance*0.95));

		if(HuntDistance > 0 && VSize(HomeBase-Location)>HuntDistance)
			GotoState('Threatening');
		return loc;
	}

AdjustFromWall:
	StrafeTo(Destination, Focus);
	Goto('CheckEnemy');

ResumeFromFighting:
	Timer();
Begin:
	if(debugstates) slog(name@"Charging");
	Goto('Threaten');

Threaten:
	Enemy=Enemy;
	Goto('TweenIn');

TweenIn:
	TweenToMoving(0.15);
	FinishAnim();
	PlayMoving();

Charge:

	MoveTimer = 0.0;
	bFromWall = false;
	if( JumpZ > 0 )
		bCanJump = true;

CheckEnemy:
	Timer();

CloseIn:
	if(Physics == PHYS_Falling){
		if(NeedToTurn(Enemy.Location)){
			DesiredRotation = Rotator(Enemy.Location - Location);
			Focus = Enemy.Location;
			Destination = Enemy.Location;
		}
		WaitForLanding();
	}

	if(actorReachable(Enemy)){

		if(HuntDistance > 0 && VSize(Enemy.Location - HomeBase) > HuntDistance){
			Destination = HomeBase + (Normal(Enemy.Location-HomeBase)*(HuntDistance*0.95));
			if(VSize(Destination-Location) > 50){
				PlayMoving(0.1);
				if(bCanStrafe)
					StrafeFacing(Destination, Enemy);
				else
					MoveTo(Destination, MovementSpeed);

				if(NeedToTurn(Enemy.Location)){
					PlayTurning(0.1);
					TurnTo(Enemy.Location);
				}
				PlayWaiting(0.1);
				Sleep(0.5);
				Acceleration=vect(0,0,0);
			}
			else{
				Acceleration=vect(0,0,0);
				PlayWaiting(0.1);
				Sleep(0.5);
			}
		}
		else if(HuntDistance > 0 && VSize(HomeBase-Location)>HuntDistance){
			Destination = HomeBase + (Normal(Enemy.Location-HomeBase)*(HuntDistance*0.95));
			if(VSize(Destination-Location) > 50){
				PlayMoving(0.1);
				if(bCanStrafe)
					StrafeFacing(Destination, Enemy);
				else
					MoveTo(Destination, MovementSpeed);
				if(NeedToTurn(Enemy.Location)){
					PlayTurning(0.1);
					TurnTo(Enemy.Location);
				}
				PlayWaiting(0.1);
				Sleep(0.5);
				Acceleration=vect(0,0,0);
			}
			else{
				Acceleration=vect(0,0,0);
				PlayWaiting(0.1);
				Sleep(0.5);
			}
		}
		else{
			if(HuntDistance > 0)
				PlayMoving(0.1);

			MoveToward(Enemy, MovementSpeed);
			if(bFromWall){
				bFromWall = false;
				if(PickWallAdjust())
					StrafeFacing(Destination, Enemy);
				else
					GotoState('TacticalDecision');
			}
		}
	}
	else{
		bCanSwing = false;
		bFromWall = false;
		if(!FindBestPathToward(Enemy))
			GotoState('Hunting');

		if(HuntDistance > 0){
			if(VSize(HomeBase-Location)>HuntDistance)
				GotoState('StakeOut');
			else if(VSize(HomeBase-MoveTarget.Location)>HuntDistance)
				GotoState('StakeOut');
		}

		PlayMoving(0.1);
		if(VSize(MoveTarget.Location - Location) < 2.5 * CollisionRadius){
			bCanSwing = true;
			StrafeFacing(MoveTarget.Location, Enemy);
		}
		else{
			if(!bCanStrafe || !LineOfSightTo(Enemy) || (Skill - 2 * FRand() + (Normal(Enemy.Location - Location - vect(0,0,1) * (Enemy.Location.Z - Location.Z)) Dot Normal(MoveTarget.Location - Location - vect(0,0,1) * (MoveTarget.Location.Z - Location.Z))) < 0))
				MoveToward(MoveTarget, MovementSpeed);
			else{
				bCanSwing = true;
				StrafeFacing(MoveTarget.Location, Enemy);
			}
		}
	}
	if(rand(100) <= 20)
		GotoState('Fleeing');
	Goto('Charge');
}

State Fighting{
ignores EnemyAcquired;

	function BeginState(){
		LookAt(Enemy);
		bHurrying = true;
		UpdateMovementSpeed();
	}
	 function EndState(){
		bSwingingHigh = false;
		if(Weapon != None)
			Weapon.FinishAttack();
		LookAt(None);
	}

	function AmbientSoundTimer(){
		PlayAmbientFightSound();
	}

Begin:
	if(debugstates) SLog(name@"Fighting");
	Acceleration = vect(0,0,0);
	GetEnemyProximity();

	DesiredRotation.Yaw = rotator(Enemy.Location-Location).Yaw;

Fight:
	bSwingingHigh = true;
	PlayMeleeHigh(0.1);
	FinishAnim();
	bSwingingHigh = false;
	Sleep(TimeBetweenAttacks);

	GotoState('Charging', 'ResumeFromFighting');

CheckDefend:
	GotoState('Charging', 'ResumeFromFighting');
}

defaultproperties{}
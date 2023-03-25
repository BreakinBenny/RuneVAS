class VM2Dangler expands Dangler;

state Fighting{
ignores SeePlayer, HearNoise;

	function EndState(){
		bAttackBump = false;
		MaxDesiredSpeed = 1.0;
	}

	function AmbientSoundTimer(){
		PlayAmbientFightSound();
	}

	singular function Bump(actor Other){
		if(bAttackBump && Pawn(Other) != None){
			if(Pawn(Other).ReducedDamageType == 'All')
				return;

			Other.JointDamaged(Pawn(Other).Health*2, self, Other.Location, vect(0,0,0), 'gibbed', 0);
			PlaySound(BiteEatSound, SLOT_Interact,,,, 1.0 + FRand()*0.2-0.1);
			Velocity *= 0.5;
			//Other.DrawType = DT_None;
			GotoState('Ripping');
		}
	}

	function SoundNotify1(){
		PlaySound(BiteMissSound, SLOT_Interact,,,, 1.0 + FRand()*0.2-0.1);
		bAttackBump = false;
	}

	function LungeAttack(){
		local vector X,Y,Z;
		local vector ToEnemy;

		GetAxes(Rotation, X,Y,Z);

		Acceleration = X*8000*WaterSpeed;
		Velocity += X*800*WaterSpeed;
	}

Begin:

	DesiredRotation = rotator(Enemy.Location - Location);

	if(ActorInSector(Enemy, ANGLE_1*20) && (Abs(Enemy.Location.Z - Location.Z) < CollisionHeight)){
		PlayAnim('Bite', 1.0, 0.1);
		bAttackBump = true;
		MaxDesiredSpeed = 8.0;

		LungeAttack();

		FinishAnim();
		MaxDesiredSpeed = 1.0;
		bAttackBump = false;
	}
	GotoState('Charging', 'ResumeFromFighting');
}

	function bool JointDamaged(int damage, pawn EventInstigator, vector HitLoc, vector Momentum, name DamageType, int joint){
		Health -= damage;
		if(Health < 1){
			Health = 1;
			if(damage > 10)
				return Super(ScriptPawn).JointDamaged(1000, EventInstigator, HitLoc, Momentum, 'gibbed', 0);
		}
		return Super(ScriptPawn).JointDamaged(Damage, EventInstigator, HitLoc, Momentum, DamageType, joint);
	}

defaultproperties{
	Health=800
	MaxHealth=800
}
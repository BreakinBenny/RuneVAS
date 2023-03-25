class VM2Rock expands NonStow;

function EMatterType MatterForJoint(int joint){
	return MATTER_STONE;
}

function Destroyed(){
	SpawnDebris();
	Super.Destroyed();
}

function Tick(float DeltaTime){
	if(owner != NONE)
		drawscale = default.drawscale/owner.drawscale;
	else
		drawscale = 1.00;
Super.Tick(DeltaTime);
}

function SpawnDebris(){
local EMatterType matter;
local class<debris> debristype;
local int i, numchunks, NumSourceGroups;
local debris d;
local debriscloud c;
local vector loc;
local float scale;
	matter = MatterForJoint(0);
	debristype = class'debrisstone';

	c = Spawn(class'DebrisCloud');
	c.SetRadius(Max(CollisionRadius,CollisionHeight));
	numchunks = Clamp(Mass/10, 3, 15);

	scale = (CollisionRadius*CollisionRadius*CollisionHeight) / (numchunks*500);
	scale = scale ** 0.3333333;
	for(NumSourceGroups=1; NumSourceGroups<16; NumSourceGroups++){
		if(SkelGroupSkins[NumSourceGroups] == None)
			break;
	}

	for(i=0; i<numchunks; i++){
		loc = Location;
		loc.X += (FRand()*2-1)*CollisionRadius;
		loc.Y += (FRand()*2-1)*CollisionRadius;
		loc.Z += (FRand()*2-1)*CollisionHeight;
		d = Spawn(debristype,,,loc);
		if(d != None){
			d.SetSize(scale);
			d.SetTexture(SkelGroupSkins[i%NumSourceGroups]);
			//d.SetMomentum(Momentum);
			d.LifeSpan = 0.5;
		}
	}
}

defaultproperties{
	Damage=60
	A_Idle=H5_Idle
	A_Forward=walkforwardTwohands
	A_Backward=H5_Backup
	A_Forward45Right=H5_Walk45Right
	A_Forward45Left=H5_Walk45Left
	A_Backward45Right=H5_BackupRight
	A_Backward45Left=H5_BackupLeft
	A_StrafeRight=H5_StrafeRight
	A_StrafeLeft=H5_StrafeLeft
	A_Jump=H5_Jump
	A_AttackA=H5_attackA
	A_AttackAReturn=H5_attackAreturn
	A_AttackB=H5_attackB
	A_AttackBReturn=H5_attackBreturn
	A_AttackStandA=H5_StandingattackA
	A_AttackStandAReturn=H5_StandingattackAreturn
	A_AttackStandB=H5_StandingattackB
	A_AttackStandBReturn=H5_StandingattackBReturn
	A_AttackBackupA=H5_Backupattack
	A_AttackBackupAReturn=None
	A_AttackStrafeRight=H5_StrafeRightAttack
	A_AttackStrafeLeft=H5_StrafeLeftAttack
	A_JumpAttack=H5_jumpattack
	A_Throw=H5_Throw
	A_Powerup=H5_Powerup
	A_Defend=None
	A_DefendIdle=None
	A_PainFront=H5_painFront
	A_PainBack=H5_painFront
	A_PainLeft=H5_painFront
	A_PainRight=H5_painFront
	A_PickupGroundLeft=H5_PickupLeft
	A_PickupHighLeft=H5_PickupLeftHigh
	A_Taunt=H5_Taunt
	A_PumpTrigger=H5_PumpTrigger
	A_LeverTrigger=H5_LeverTrigger
	PickupMessage="You have a big rock"
	RespawnTime=0.000000
	PickupSound=None
	RespawnSound=None
	CollisionRadius=16.000000
	CollisionHeight=13.000000
	bCollideWorld=True
	bBounce=True
	Mass=80.000000
	SkelMesh=1
	Skeletal=SkelModel'objects.Rocks'
}
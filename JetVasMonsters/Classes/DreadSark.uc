//=============================================================================
// DreadSark.
//=============================================================================
class DreadSark expands SarkSword;

const DEFAULT_TWEEN = 0.075;

function PostBeginPlay(){
local actor f;

	Super.PostBeginPlay();

	f = Spawn(Class'SarkEyeRagnarRed');
	f.Drawscale *= 0.75;
	AttachActorToJoint(f, JointNamed('head'));
}

function PreBeginPlay(){
	setTimer(1.0, true);
}

function class<Actor> SeveredLimbClass(int BodyPart)
{
	switch(BodyPart)	{
		case BODYPART_LARM1:
		case BODYPART_RARM1:
			return class'pawnfire';
		case BODYPART_HEAD:
			return class'pawnfire';
	}
	return None;
}

function Timer()
{
local RunePlayer R;

	foreach VisibleCollidingActors(Class'RunePlayer', R, 150){
    	R.JointDamaged(15, self, R.Location, vect(0, 0, 0), 'sever', 1);
    	spawn(class'EmpathyFlash', self, , R.Location);
		R.ClientMessage("( - The evil aura damages you - )", 'subtitle');
	}
	DesiredColorAdjust.X = RandRange(10, 200);
	if(Weapon.Drawscale != 2){
		Weapon.Drawscale = 2;
		Weapon.Damage *= 3;
	}
	setTimer(0.65, true);
}

function Died(pawn Killer, name damageType, vector HitLocation){
local actor eyes;

	eyes = DetachActorFromJoint(JointNamed('head'));
	if(eyes != None)
		eyes.Destroy();
		Weapon.Destroy();
	StowWeapon = None;

	Super.Died(Killer, damageType, HitLocation);
}

defaultproperties{
	JumpSound=Sound'CreaturesSnd.Ragnar.ragberzend01'
	Orders=Roaming
	HuntTime=40.000000
	AmbientWaitSounds(0)=Sound'CreaturesSnd.Ragnar.ragchain01'
	AmbientWaitSounds(1)=Sound'CreaturesSnd.Ragnar.ragchain02'
	AmbientWaitSounds(2)=Sound'CreaturesSnd.Ragnar.ragchain03'
	AmbientFightSounds(0)=Sound'CreaturesSnd.Ragnar.ragsarkattack02'
	AmbientFightSounds(1)=Sound'CreaturesSnd.Ragnar.ragattack01'
	AmbientFightSounds(2)=Sound'CreaturesSnd.Ragnar.ragsarkattack05'
	AmbientWaitSoundDelay=3.000000
	FearSound=Sound'CreaturesSnd.Ragnar.drowned01'
	bIsBoss=True
	StartWeapon=Class'RuneI.DwarfWorkSword'
	GroundSpeed=600.000000
	JumpZ=1000.000000
	MaxStepHeight=128.000000
	AirControl=0.500000
	WalkingSpeed=400.000000
	SightRadius=3300.000000
	Health=2000
	MaxHealth=2000
	BodyPartHealth(1)=1000
	BodyPartHealth(3)=1000
	BodyPartHealth(5)=1000
	GibClass=Class'JetVasSpells.FlamingStone'
	HitSound1=Sound'CreaturesSnd.Ragnar.ragsarkattack06'
	HitSound2=Sound'CreaturesSnd.Ragnar.ragsarkattack04'
	HitSound3=Sound'CreaturesSnd.Ragnar.ragsarkattack01'
	DrawScale=1.000000
	CollisionRadius=18.000000
	CollisionHeight=42.000000
	Mass=150.000000
	SkelGroupSkins(0)=Texture'rock.Rock14_d'
	SkelGroupSkins(1)=Texture'RuneFX.gore'
	SkelGroupSkins(2)=Texture'RuneFX.gore'
	SkelGroupSkins(4)=Texture'RuneFX.gore'
	SkelGroupSkins(5)=Texture'RuneFX.gore'
	SkelGroupSkins(6)=Texture'RuneFX.gore'
	SkelGroupSkins(7)=Texture'RuneFX.gore'
	SkelGroupSkins(9)=Texture'RuneFX.gore'
	SkelGroupSkins(11)=Texture'RuneFX.gore'
	SkelGroupSkins(12)=Texture'RuneFX.gore'
	SkelGroupSkins(13)=Texture'RuneFX.gore'
	SkelGroupSkins(14)=Texture'RuneFX.gore'
}
//==================
// golem.
//==================
class golem expands LokiGuard;

//==========================
// PainSkin
//
// returns the pain skin for a given polygroup
//==========================
function Texture PainSkin(int BodyPart)
{
	switch(BodyPart)
	{
		case BODYPART_TORSO:
			SkelGroupSkins[2] = Texture'golem.body';
			break;
		case BODYPART_HEAD:
			SkelGroupSkins[10] = Texture'golem.head';
			break;
		case BODYPART_LARM1:
			SkelGroupSkins[8] = Texture'golem.body';
			SkelGroupSkins[11] = Texture'golem.body';
			break;
		case BODYPART_RARM1:
			SkelGroupSkins[5] = Texture'golem.body';
			SkelGroupSkins[4] = Texture'golem.body';
			break;
		case BODYPART_LLEG1:
			SkelGroupSkins[3] = Texture'golem.body';
			break;
		case BODYPART_RLEG1:
			SkelGroupSkins[1] = Texture'golem.body';
			break;
	}
	return None;
}

//===============
// BodyPartForPolyGroup
//===============
function int BodyPartForPolyGroup(int polygroup)
{
	switch(polygroup)
	{
		case 10:			return BODYPART_HEAD;
		case 11:			return BODYPART_LARM1;
		case 4: 			return BODYPART_RARM1;
		case 3:			return BODYPART_LLEG1;
		case 1:			return BODYPART_RLEG1;
		case 2: case 5: case 6: case 7:
			case 8: case 9:	return BODYPART_TORSO;
	}
	return BODYPART_BODY;
}

//==========
// ApplyGoreCap
//==========
function ApplyGoreCap(int BodyPart)
{
	switch(BodyPart)
	{
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

//============
// SeveredLimbClass
//============
function class<Actor> SeveredLimbClass(int BodyPart)
{
	switch(BodyPart)
	{
		case BODYPART_LARM1:
			return class'GuardLArm';
		case BODYPART_RARM1:
			return class'GuardRArm';
		case BODYPART_HEAD:
			return class'GuardHead';
			break;
	}

	return None;
}

//=====
// Statue
//=====
State() Statue
{
ignores HearNoise, EnemyAcquired, Bump;

	function CreatureStatue()
	{
		//arms
		SkelGroupSkins[1] = texture'statues.lg_rckleg';
		SkelGroupSkins[3] = texture'statues.lg_rckleg';

		//legs
		SkelGroupSkins[4] = texture'statues.lg_rckarm';
		SkelGroupSkins[11] = texture'statues.lg_rckarm';

		//body
		SkelGroupSkins[2] = texture'statues.lg_rckbody';
		SkelGroupSkins[5] = texture'statues.lg_rckbody';
		SkelGroupSkins[6] = texture'statues.lg_rckbody';
		SkelGroupSkins[7] = texture'statues.lg_rckbody';
		SkelGroupSkins[8] = texture'statues.lg_rckbody';
		SkelGroupSkins[9] = texture'statues.lg_rckbody';

		//head
		SkelGroupSkins[10] = texture'statues.lg_rckhead';
	}
}

defaultproperties
{
	StartStowWeapon=Class'golemfist'
	BreathSound=Sound'CreaturesSnd.Dwarves.breath02'
	AmbientWaitSounds(0)=Sound'CreaturesSnd.Vikings.conrak2ambient01'
	AmbientWaitSounds(1)=Sound'CreaturesSnd.Vikings.conrak2ambient02'
	AmbientWaitSounds(2)=Sound'DoorsSnd.Stone.doorstoneslam01'
	AmbientFightSounds(0)=Sound'DoorsSnd.Stone.doorstoneslam01'
	AmbientFightSounds(1)=Sound'CreaturesSnd.Vikings.conrak2ambient02'
	AmbientFightSounds(2)=Sound'CreaturesSnd.Vikings.conrak2ambient01'
	StartShield=None
	Health=200
	GibClass=Class'RuneI.DebrisStone'
	HitSound1=Sound'WeaponsSnd.ImpStone.impactstone11'
	HitSound2=Sound'WeaponsSnd.ImpStone.impactstone12'
	HitSound3=Sound'WeaponsSnd.ImpStone.impactstone13'
	Die=Sound'CreaturesSnd.Dwarves.bossdeath01'
	Die2=Sound'CreaturesSnd.Dwarves.bossdeath01'
	Die3=Sound'CreaturesSnd.Dwarves.bossdeath01'
	FootStepWood(0)=Sound'WeaponsSnd.Shields.shield15'
	FootStepWood(1)=Sound'WeaponsSnd.Shields.shield15'
	FootStepWood(2)=Sound'WeaponsSnd.Shields.shield15'
	FootStepMetal(0)=Sound'WeaponsSnd.Shields.shield15'
	FootStepMetal(1)=Sound'WeaponsSnd.Shields.shield15'
	FootStepMetal(2)=Sound'WeaponsSnd.Shields.shield15'
	FootStepStone(0)=Sound'WeaponsSnd.Shields.shield15'
	FootStepStone(1)=Sound'WeaponsSnd.Shields.shield15'
	FootStepStone(2)=Sound'WeaponsSnd.Shields.shield15'
	FootStepFlesh(0)=Sound'WeaponsSnd.Shields.shield15'
	FootStepFlesh(1)=Sound'WeaponsSnd.Shields.shield15'
	FootStepFlesh(2)=Sound'WeaponsSnd.Shields.shield15'
	FootStepIce(0)=Sound'WeaponsSnd.Shields.shield15'
	FootStepIce(1)=Sound'WeaponsSnd.Shields.shield15'
	FootStepIce(2)=Sound'WeaponsSnd.Shields.shield15'
	FootStepEarth(0)=Sound'WeaponsSnd.Shields.shield15'
	FootStepEarth(1)=Sound'WeaponsSnd.Shields.shield15'
	FootStepEarth(2)=Sound'WeaponsSnd.Shields.shield15'
	FootStepSnow(0)=Sound'WeaponsSnd.Shields.shield15'
	FootStepSnow(1)=Sound'WeaponsSnd.Shields.shield15'
	FootStepSnow(2)=Sound'WeaponsSnd.Shields.shield15'
	FootStepMud(0)=Sound'WeaponsSnd.Shields.shield15'
	FootStepMud(1)=Sound'WeaponsSnd.Shields.shield15'
	FootStepMud(2)=Sound'WeaponsSnd.Shields.shield15'
	FootStepLava(0)=Sound'WeaponsSnd.Shields.shield15'
	FootStepLava(1)=Sound'WeaponsSnd.Shields.shield15'
	FootStepLava(2)=Sound'WeaponsSnd.Shields.shield15'
	LandSoundWood=Sound'WeaponsSnd.Shields.shield15'
	LandSoundMetal=Sound'WeaponsSnd.Shields.shield15'
	LandSoundStone=Sound'WeaponsSnd.Shields.shield15'
	LandSoundFlesh=Sound'WeaponsSnd.Shields.shield15'
	LandSoundIce=Sound'WeaponsSnd.Shields.shield15'
	LandSoundSnow=Sound'WeaponsSnd.Shields.shield15'
	LandSoundEarth=Sound'WeaponsSnd.Shields.shield15'
	LandSoundWater=Sound'WeaponsSnd.Shields.shield15'
	LandSoundMud=Sound'WeaponsSnd.Shields.shield15'
	LandSoundLava=Sound'WeaponsSnd.Shields.shield15'
	SkelMesh=0
	SubstituteMesh=SkelModel'golem'
	SkelGroupSkins(0)=Texture'body'
	SkelGroupSkins(1)=Texture'Head'
}
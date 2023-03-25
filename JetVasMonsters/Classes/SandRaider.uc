//=============================================================================
// SandRaider.
//=============================================================================
class SandRaider expands Sigurd;

function Texture PainSkin(int BodyPart)
{
	switch(BodyPart){}
	return None;
}

defaultproperties{
	StartStowWeapon=Class'RuneI.DwarfWorkSword'
	Orders=Roaming
	bLungeAttack=True
	LungeRange=120.000000
	bDodgeAfterAttack=True
	TimeBetweenAttacks=0.050000
	bStatueDestructible=False
	AcquireSound=Sound'CreaturesSnd.Various.xnowarriarsdeath'
	AmbientWaitSounds(0)=Sound'CreaturesSnd.Various.whisper04'
	AmbientWaitSounds(1)=Sound'CreaturesSnd.Various.whisper05'
	AmbientWaitSounds(2)=Sound'CreaturesSnd.Dwarves.breath02'
	AmbientFightSounds(0)=Sound'CreaturesSnd.Various.xlostboy'
	AmbientFightSounds(1)=Sound'CreaturesSnd.Various.xfightlikewoman'
	AmbientFightSounds(2)=Sound'CreaturesSnd.Various.farfromstable'
	HuntSound=Sound'CreaturesSnd.Various.tortureclose05'
	FearSound=Sound'CreaturesSnd.Various.wonderwoman'
	ThreatenSound=Sound'CreaturesSnd.Various.torturefar05'
	StartShield=None
	MeleeRange=65.000000
	GroundSpeed=400.000000
	AirSpeed=100.000000
	JumpZ=600.000000
	AirControl=0.900000
	Health=400
	MaxHealth=400
	BodyPartHealth(1)=290
	BodyPartHealth(3)=290
	BodyPartHealth(5)=290
	GibCount=14
	PainDelay=0.200000
	HitSound1=Sound'CreaturesSnd.Various.tortureclose01'
	HitSound2=Sound'CreaturesSnd.Various.tortureclose07'
	HitSound3=Sound'CreaturesSnd.Various.tortureclose02'
	Die=Sound'CreaturesSnd.Various.zdscream4'
	Die2=Sound'CreaturesSnd.Various.zdscream5'
	Die3=Sound'CreaturesSnd.Various.zdscream1'
	Mass=80.000000
	SkelGroupSkins(0)=Texture'JetDesert.sand'
	SkelGroupSkins(1)=Texture'JetDesert.sand'
	SkelGroupSkins(2)=Texture'JetDesert.sand'
	SkelGroupSkins(3)=Texture'JetDesert.sand'
	SkelGroupSkins(4)=Texture'JetDesert.sand'
	SkelGroupSkins(5)=Texture'objects.Chunkswood'
	SkelGroupSkins(11)=Texture'objects.Chunkswood'
}
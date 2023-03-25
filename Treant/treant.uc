//=====
// treant.
//=====
class treant expands Berserker;

function bool CanPickup(Inventory item){
	if(Health <= 0)
		return false;

	if(item.IsA('Weapon') && (BodyPartHealth[BODYPART_RARM1] > 0) && (Weapon == None))
		return (item.IsA('axe') || item.IsA('hammer') || item.IsA('Sword') || item.IsA('Torch'));
	else if(item.IsA('Shield') && (BodyPartHealth[BODYPART_LARM1] > 0) && (Shield == None))
		return item.IsA('Shield');
	return(false);
}

defaultproperties
{
	StartStowWeapon=Class'RuneI.handaxe'
	AcquireSound=Sound'CreaturesSnd.Vikings.conrak2ambient01'
	AmbientWaitSounds(0)=Sound'CreaturesSnd.Vikings.conrak2ambient01'
	AmbientWaitSounds(1)=Sound'CreaturesSnd.Vikings.conrak2ambient02'
	AmbientWaitSounds(2)=Sound'CreaturesSnd.Vikings.conrak2ambient03'
	AmbientFightSounds(0)=Sound'CreaturesSnd.Vikings.conrak2attack01'
	AmbientFightSounds(1)=Sound'CreaturesSnd.Vikings.conrak2attack02'
	AmbientFightSounds(2)=Sound'CreaturesSnd.Vikings.conrak2attack03'
	GroundSpeed=150.00
	AccelRate=500.00
	WalkingSpeed=75.00
	Health=500
	BodyPartHealth(1)=300
	BodyPartHealth(3)=300
	BodyPartHealth(5)=250
	GibCount=12
	GibClass=Class'RuneI.DebrisWood'
	HitSound1=Sound'WeaponsSnd.ImpWood.impactwood06'
	HitSound2=Sound'WeaponsSnd.ImpWood.impactwood04'
	HitSound3=Sound'WeaponsSnd.ImpWood.impactwood12'
	LandGrunt=Sound'WeaponsSnd.ImpWood.impactwood17'
	Style=2
	SkelMesh=0
	SubstituteMesh=SkelModel'treant'
	SkelGroupSkins(0)=Texture'Head'
	SkelGroupSkins(1)=Texture'leaves'
	SkelGroupSkins(2)=Texture'body'
	SkelGroupSkins(3)=Texture'eyes'
}
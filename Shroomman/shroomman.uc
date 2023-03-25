//====================
// shroomman.
//====================
class shroomman expands Berserker;

function bool CanPickup(Inventory item){
	if(Health <= 0)
		return false;

	if(item.IsA('Weapon') && (BodyPartHealth[BODYPART_RARM1] > 0) && (Weapon == None))
		return (item.IsA('axe') || item.IsA('hammer') || item.IsA('Sword') || item.IsA('Torch'));
	else if(item.IsA('Shield') && (BodyPartHealth[BODYPART_LARM1] > 0) && (Shield == None))
		return item.IsA('Shield');
	return(false);
}

defaultproperties{
	StartStowWeapon=Class'RuneI.VikingShortSword'
	SkelMesh=0
	SubstituteMesh=SkelModel'shroomman.shroomman'
	SkelGroupSkins(0)=Texture'shroomman.mushroom'
	SkelGroupSkins(1)=Texture'shroomman.mushroom'
	SkelGroupSkins(2)=Texture'shroomman.mushroom'
	SkelGroupSkins(3)=Texture'shroomman.mushroom'
}
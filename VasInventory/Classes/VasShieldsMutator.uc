//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasShieldsMutator expands Mutator;

Var() pawn TempOwner;
Var int tickcount;
Var Travel bool bplayerarrived;
var runeplayer newplayer;

function PostBeginPlay(){
SetTimer(3.000000,false);
}

function timer(){

	foreach AllActors(class 'Inventory', Inventory)
	{
		if((Inventory.getstatename() == 'Pickup') || (Inventory.getstatename() == 'Sleeping')){

			if(Inventory.IsA('Shield')){
				if(Inventory.IsA('DarkShield') && !Inventory.IsA('VasShieldsDarkShield')){
					ReplaceWith(Inventory, "VasInventory.VasShieldsDarkShield");
					Continue ;}
				if(Inventory.IsA('DwarfBattleShield') && !Inventory.IsA('VasShieldsDwarfBattleShield')){
					ReplaceWith(Inventory, "VasInventory.VasShieldsDwarfBattleShield");
				Continue ;}
				if(Inventory.IsA('DwarfWoodShield') && !Inventory.IsA('VasShieldsDwarfWoodShield')&& !Inventory.IsA('VasGlassSword')){
					ReplaceWith(Inventory, "VasInventory.VasShieldsDwarfWoodShield");
				Continue;}
				if(Inventory.IsA('GoblinShield') && !Inventory.IsA('VasShieldsGoblinShield')){
					ReplaceWith(Inventory, "VasInventory.VasShieldsGoblinShield");
				Continue ;}
				if(Inventory.IsA('VikingShield') && !Inventory.IsA('VasShieldsVikingShield')){
					ReplaceWith(Inventory, "VasInventory.VasShieldsVikingShield");
				Continue ;}
				if(Inventory.IsA('VikingShield2') && !Inventory.IsA('VasShieldsVikingShield2')){
					ReplaceWith(Inventory, "VasInventory.VasShieldsVikingShield2");
				Continue ;}
				if(Inventory.IsA('WaterloggedShield') && !Inventory.IsA('VasShieldsWaterloggedShield')){
					ReplaceWith(Inventory, "VasInventory.VasShieldsWaterloggedShield");
				Continue ;}
			}
		}
	}
}

function bool ReplaceWith(actor Other, string aClassName){
	local actor A;
	local class<Actor> aClass;
	//Other.bhidden = true;
	aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
	if(aClass != None){
		A = Spawn(aClass,,Other.tag,Other.Location, Other.Rotation);
		Inventory(A).MyMarker = Inventory(Other).MyMarker;
		A.SetLocation(A.Location + (A.CollisionHeight - Other.CollisionHeight) * vect(0,0,1));
		}
	if(A != None){
		A.event = Other.event;
		A.tag = Other.tag;
		inventory(A).bTossedOut = inventory(Other).bTossedOut;
		inventory(A).RespawnTime = inventory(Other).RespawnTime;
		inventory(A).ExpireTime = inventory(Other).ExpireTime;
		inventory(A).lifeSpan = inventory(Other).LifeSpan;
		inventory(A).bExpireWhenTossed = inventory(Other).bExpireWhenTossed;
		Other.Destroy();
		return true;
	}
	return false;
}

defaultproperties{}
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasInventoryMutator expands Mutator;

Var() pawn TempOwner;
Var int tickcount;
Var Travel bool bplayerarrived;
var runeplayer newplayer;
var Inventory Inventory;
Var bool btimercheck;


function PostBeginPlay(){
	SetTimer(5.000000,true);
	Super.PostBeginPlay();
}

function timer(){
	foreach AllActors(class 'Inventory', Inventory){
		if(!btimercheck){
			if((Inventory.getstatename() == 'Pickup') || (Inventory.getstatename() == 'Sleeping')){
				if(Inventory.IsA('Sword')){
					if(Inventory.IsA('RomanSword')){
						ReplaceWith(Inventory, "VasInventory.VW2RomanSword");
						Continue;
					}
					if(Inventory.IsA('VikingShortSword')){
						ReplaceWith(Inventory, "VasInventory.VW2VikingShortSword");
						Continue;
					}
					if(Inventory.IsA('VikingBroadSword')){
						ReplaceWith(Inventory, "VasInventory.VW2VikingBroadSword");
						Continue;
					}
					if(Inventory.IsA('DwarfWorkSword')){
						ReplaceWith(Inventory, "VasInventory.VW2DwarfWorkSword");
						Continue;
					}
					if(Inventory.IsA('DwarfBattleSword')){
						ReplaceWith(Inventory, "VasInventory.VW2DwarfBattleSword");
						Continue;
					}
				}
				if(Inventory.IsA('Hammer')){
					if(Inventory.IsA('DwarfBattleHammer')){
						ReplaceWith(Inventory, "VasInventory.VW2DwarfBattleHammer");
						Continue;
					}
					if(Inventory.IsA('BoneClub') && !Inventory.IsA('VW2BoneClub')){
						ReplaceWith(Inventory, "VasInventory.VW2BoneClub");
						Continue;
					}
					if(Inventory.IsA('DwarfWorkHammer')){
						ReplaceWith(Inventory, "VasInventory.VW2DwarfWorkHammer");
						Continue;
					}
					if(Inventory.IsA('RustyMace')){
						ReplaceWith(Inventory, "VasInventory.VW2RustyMace");
						Continue;
					}
					if(Inventory.IsA('TrialPitMace')){
						ReplaceWith(Inventory, "VasInventory.VW2TrialPitMace");
						Continue;
					}
				}
				if(Inventory.IsA('axe')){
					if(Inventory.IsA('VikingAxe')){
						ReplaceWith(Inventory, "VasInventory.VW2VikingAxe");
						Continue;
					}
					if(Inventory.IsA('SigurdAxe')){
						ReplaceWith(Inventory, "VasInventory.VW2SigurdAxe");
						Continue;
					}
					if(Inventory.IsA('HandAxe')){
						ReplaceWith (Inventory, "VasInventory.VW2HandAxe");
						Continue;
					}
					if(Inventory.IsA('GoblinAxe') && !Inventory.Isa('GoblinAxePowerup')){
						ReplaceWith (Inventory, "VasInventory.VW2GoblinAxe");
						Continue;
					}
					if(Inventory.IsA('DwarfBattleAxe')){
						ReplaceWith (Inventory, "VasInventory.VW2DwarfBattleAxe");
						Continue;
					}
				}
			}
		}
	}
	btimercheck = true;
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant){
	if(Other.IsA('weapon')){
		if(!Other.IsA('VW2RomanSword') || !Other.IsA('VW2VikingShortSword') || !Other.IsA('VW2VikingBroadSword') || !Other.IsA('VW2DwarfWorkSword') || !Other.IsA('VW2DwarfBattleSword') || !Other.IsA('VW2DwarfBattleHammer') || !Other.IsA('VW2DwarfWorkHammer')  || !Other.IsA('VW2RustyMace') || !Other.IsA('VW2TrialPitMace') || !Other.IsA('VW2VikingAxe') || !Other.IsA('VW2SigurdAxe') || !Other.IsA('HandAxe') || !Other.Isa('VW2GoblinAxePowerup') || !Other.IsA('VW2GoblinAxe') || !Other.IsA('VasDwarfBattleAxe')){
			weapon(Other).bCanBePoweredUp = False;
			weapon(Other).lifeSpan *= 0.75;
		}
	}
	return true;
}

function bool ReplaceWith(actor Other, string aClassName){
local actor A;
local class<Actor> aClass;

//Other.bhidden = true;
aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
	if(aClass != None){
		A = Spawn(aClass,,Other.tag,Other.Location, Other.Rotation);
		Inventory(A).MyMarker = Inventory(Other).MyMarker;
		//A.SetLocation(A.Location + (A.CollisionHeight - Other.CollisionHeight) * vect(0,0,1));
	}
	if(A != None){
		A.event = Other.event;
		A.tag = Other.tag;
		inventory(A).bTossedOut = inventory(Other).bTossedOut;
		inventory(A).RespawnTime = inventory(Other).RespawnTime;
		inventory(A).ExpireTime = inventory(Other).ExpireTime;
		inventory(A).lifeSpan = inventory(Other).LifeSpan;
		inventory(A).bExpireWhenTossed = inventory(Other).bExpireWhenTossed;
		inventory(A).bInstantRespawn = inventory(Other).bInstantRespawn;
		inventory(A).bRotatingPickup = inventory(Other).bRotatingPickup;
		Other.Destroy();
		return true;
	}
return false;
}

defaultproperties{}
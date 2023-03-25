class VasSackMutator expands Mutator config(VasSack);

Var() config Bool SackForPlayers, RemoveWeaponsForMap;
Var() config string VasDefaultWeapon, VasDefaultShield;
Var String Vasinfo;
Var config int VasDebuglevel;

function PreBeginPlay(){
local class<weapon> checkweapon;
local class<Shield> checkShield;

VasDebug(" PreBeginPlay Started ",2);

VasDebug(" PreBeginPlay SackForPlayers="$SackForPlayers$" RemoveWeaponsForMap="$RemoveWeaponsForMap, 1);
VasDebug(" PreBeginPlay VasDefaultWeapon="$VasDefaultWeapon$" VasDefaultShield="$VasDefaultShield, 1);

	if(VasDefaultWeapon != "")
		checkweapon = class<weapon>(DynamicLoadObject(VasDefaultWeapon, class'Class'));
	if(checkweapon != None){
		VasDebug (" PreBeginPlay checkweapon="$checkweapon,1);
		DefaultWeapon = checkweapon;
	}
	else{
		DefaultWeapon = default.DefaultWeapon;
		VasDebug(" PreBeginPlay DefaultWeapon="$DefaultWeapon, 1);
	}
	if(VasDefaultShield != "")
		checkShield = class<shield>( DynamicLoadObject(VasDefaultShield, class'Class'));

	if(checkShield !=None){
		VasDebug (" PreBeginPlay checkShield="$checkShield, 1);
		DefaultShield = checkShield;
	}
	else
		DefaultShield = default.DefaultShield;

	VasDebug(" PreBeginPlay DefaultShield="$DefaultShield, 1);
}

function PostBeginPlay(){
VasDebug(" PostBeginPlay Started ",2);
	broadcastmessage("Powered by VasSack -  Kal Corp");
	LOG("Powered by VasSack -  Kal Corp");

	VasDebug(" PreBeginPlay RemoveWeaponsForMap="$RemoveWeaponsForMap,1);

if(RemoveWeaponsForMap){
	foreach AllActors(class 'Inventory', Inventory){
		if((Inventory.IsA('weapon')) || (Inventory.IsA('Shield')) || (Inventory.IsA('Food'))){
			VasDebug(" PreBeginPlay destroy "$Inventory,3);
			Inventory.destroy();
		}
	}
}
	Super.PostBeginPlay();
}

function ScoreKill(Pawn Killer, Pawn Other){
local scriptPawn P;
local int i, temp;
Local int PlayerNumber;
local string PlayerName;

local class<Actor> LoadInventory;
local Actor Inventory;
local vector newLocation;

VasDebug (" ScoreKill Started ",2);
super.ScoreKill(Killer,Other);

VasDebug (" ScoreKill Killer="$Killer$" Other="$Other,2);
if(Killer != none){
	if(killer.isa('playerpawn')){
		if(Other != NONE){
			if(other.isa('playerpawn')){
				if(!SackForPlayers)
					Return;
			}
		if(rand(100) <=75){
			LoadInventory = class<Actor>( DynamicLoadObject("VasSack.VasSacks", class'Class' ));
			if(LoadInventory==None){
				VasDebug(" ScoreKill LoadInventory=NONE", 1);
				return;
			}
			Inventory = Spawn(LoadInventory,Other,,Other.Location);
			if(Inventory==None){
				VasDebug (" ScoreKill Inventory=NONE", 1);
				return;
			}
		newLocation = Inventory.Location;
		newLocation.x += FRand()*CollisionRadius*2 - CollisionRadius;
		newLocation.y += FRand()*CollisionRadius*2 - CollisionRadius;
		newLocation.z += FRand()*CollisionHeight*2 - CollisionHeight;
		Inventory.SetLocation(newLocation);
		Inventory.RemoteRole = ROLE_DumbProxy;
		Inventory.SetPhysics(PHYS_Falling);
		Inventory.bCollideWorld = true;
			if(inventory(Inventory) != None)
				inventory(Inventory).GotoState('Pickup', 'Dropped');
		}
		if(Other.Default.health >=150){
			if(rand(100) <=75){
				LoadInventory = class<Actor>( DynamicLoadObject("VasSack.VasSacks", class'Class' ));
				if(LoadInventory==None){
					VasDebug(" ScoreKill LoadInventory=NONE",1);
					return;
				}
			Inventory = Spawn(LoadInventory,Other,,Other.Location);
			if(Inventory==None){
				VasDebug(" ScoreKill Inventory=NONE", 1);
				return;
			}
		newLocation = Inventory.Location;
		newLocation.x += FRand()*CollisionRadius*2 - CollisionRadius;
		newLocation.y += FRand()*CollisionRadius*2 - CollisionRadius;
		newLocation.z += FRand()*CollisionHeight*2 - CollisionHeight;
		Inventory.SetLocation(newLocation);
		Inventory.RemoteRole = ROLE_DumbProxy;
		Inventory.SetPhysics(PHYS_Falling);
		Inventory.bCollideWorld = true;
		if(inventory(Inventory) != None)
			inventory(Inventory).GotoState('Pickup', 'Dropped');
		}
	}
	if(Other.Default.health >=250){
		if(rand(100) <=75){
			LoadInventory = class<Actor>( DynamicLoadObject("VasSack.VasSacks", class'Class'));
			if(LoadInventory==None){
				VasDebug(" ScoreKill LoadInventory=NONE", 1);
				return;
			}
			Inventory = Spawn(LoadInventory,Other,,Other.Location);
			if(Inventory==None){
				VasDebug(" ScoreKill Inventory=NONE",1);
				return;
			}
		newLocation = Inventory.Location;
		newLocation.x += FRand()*CollisionRadius*2 - CollisionRadius;
		newLocation.y += FRand()*CollisionRadius*2 - CollisionRadius;
		newLocation.z += FRand()*CollisionHeight*2 - CollisionHeight;
		Inventory.SetLocation(newLocation);
		Inventory.RemoteRole = ROLE_DumbProxy;
		Inventory.SetPhysics(PHYS_Falling);
		Inventory.bCollideWorld = true;
	if(inventory(Inventory) != None)
		inventory(Inventory).GotoState('Pickup', 'Dropped');
	}
	}
		if(Other.Default.health >=400){
			if(rand(100) <=75){
				LoadInventory = class<Actor>( DynamicLoadObject("VasSack.VasSacks", class'Class' ));
				if(LoadInventory==None){
					VasDebug(" ScoreKill LoadInventory=NONE", 1);
					return;
				}
				Inventory = Spawn(LoadInventory,Other,,Other.Location);
				if(Inventory==None){
					VasDebug (" ScoreKill Inventory=NONE", 1);
					return;
				}
				newLocation = Inventory.Location;
				newLocation.x += FRand()*CollisionRadius*2 - CollisionRadius;
				newLocation.y += FRand()*CollisionRadius*2 - CollisionRadius;
				newLocation.z += FRand()*CollisionHeight*2 - CollisionHeight;
				Inventory.SetLocation(newLocation);
				Inventory.RemoteRole = ROLE_DumbProxy;
				Inventory.SetPhysics(PHYS_Falling);
				Inventory.bCollideWorld = true;
				if(inventory(Inventory) != None)
					inventory(Inventory).GotoState('Pickup', 'Dropped');
			}
		}
		if(Other.Default.health >=500){
			if(rand(100) <=75){
				LoadInventory = class<Actor>(DynamicLoadObject("VasSack.VasSacks", class'Class'));
				if(LoadInventory==None){
					VasDebug (" ScoreKill LoadInventory=NONE", 1);
					return;
				}
				Inventory = Spawn(LoadInventory,Other,,Other.Location);
				if(Inventory==None){
					VasDebug(" ScoreKill Inventory=NONE", 1);
					return;
				}
				newLocation = Inventory.Location;
				newLocation.x += FRand()*CollisionRadius*2 - CollisionRadius;
				newLocation.y += FRand()*CollisionRadius*2 - CollisionRadius;
				newLocation.z += FRand()*CollisionHeight*2 - CollisionHeight;
				Inventory.SetLocation(newLocation);
				Inventory.RemoteRole = ROLE_DumbProxy;
				Inventory.SetPhysics(PHYS_Falling);
				Inventory.bCollideWorld = true;
				if(inventory(Inventory) != None)
						inventory(Inventory).GotoState('Pickup', 'Dropped');
			}
		}
	}
}
}
}

function VasDebug(String Text, int level){
Local String text1,test2;

if(VasDebuglevel > 0){
	if(level <= VasDebuglevel){
		if(level == 1)
			text1 = "* VasDebug L1 * ";
		if( level == 2)
			text1 = "** VasDebug L2 ** ";
		if(level == 3)
			text1 = "*** VasDebug L3 *** ";
		Log (text1$" "$Class.name$" - "$Text);
	}
}
}

defaultproperties{
	  SackForPlayers=True
	  VasDefaultWeapon="VasWeapons2.VW2DwarfWorkSword"
	  VasDefaultShield="NONE"
	  VasDebuglevel=1
	  DefaultWeapon=Class'RuneI.handaxe'
}
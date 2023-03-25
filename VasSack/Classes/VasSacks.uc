class VasSacks expands GrainSack config(VasSack);

Var config int VasDebuglevel;

var() config int GroupApercent;
var() config int GroupBpercent;
var() config int GroupCpercent;
var() config int GroupDpercent;
var() config int GroupEpercent;
var() config int GroupFpercent;
var() config int GroupGpercent;

var() config string A[20];
var() config int APercent[20];
var() config string B[20];
var() config int BPercent[20];
var() config string C[20];
var() config int CPercent[20];
var() config string D[20];
var() config int DPercent[20];
var() config string E[20];
var() config int EPercent[20];
var() config string F[20];
var() config int FPercent[20];
var() config string G[20];
var() config int GPercent[20];


function Destroyed(){
local int randnumber;
local Inventory Inventory;
local class<Inventory> LoadInventory;
local vector X,Y,Z;
local vector newLocation;
local int Tempint,I;

VasDebug(" Destroyed Started ",2);

	if(bDestroyable){
		SpawnDebris();
		PlayDestroyedSound();
	}
Tempint = Rand(100);
VasDebug (" Destroyed Tempint="$Tempint$" GroupApercent="$GroupApercent,3);
if((Tempint <= GroupApercent) && (GroupApercent > 0))
{
	for(i=0; i<19; i++){
		if(APercent[i] > 0)
		{
			Tempint = Rand(100);
			if(Tempint <= APercent[i]){
				VasDebug (" Destroyed Load A Item="$A[i],3);
				LoadInventory = class<Inventory>(DynamicLoadObject(A[i], class'Class'));
				if(LoadInventory != none)
					Spawnsackshit(LoadInventory, False);
				else
					VasDebug(" Destroyed LoadInventory = None A Item="$A[i],1);
			}
		}
	}
}
Tempint = Rand(100);
if((Tempint <= GroupBpercent) && (GroupBpercent > 0)){
	for(i=0; i<19; i++){
		if(BPercent[i] > 0){
			Tempint = Rand(100);
			if(Tempint <= BPercent[i]){
				VasDebug (" Destroyed Load B Item="$b[i],3);
				LoadInventory = class<Inventory>( DynamicLoadObject(B[i], class'Class' ));
				if(LoadInventory != none)
					Spawnsackshit(LoadInventory, False);
				else
					VasDebug(" Destroyed LoadInventory = None B Item="$b[i],1);
			}
		}
	}
}

Tempint = Rand(100);
if((Tempint <= GroupCpercent) && (GroupCpercent > 0)){
	for(i=0; i<19; i++){
		if(CPercent[i] > 0){
			Tempint = Rand(100);
			if(Tempint <= CPercent[i]){
				VasDebug(" Destroyed Load C Item="$c[i],3);
				LoadInventory = class<Inventory>( DynamicLoadObject(C[i], class'Class' ));
				if(LoadInventory != none)
					Spawnsackshit(LoadInventory, False);
				else
					VasDebug(" Destroyed LoadInventory = None C Item="$b[i],1);
			}
		}
	}
}

Tempint = Rand(100);
if((Tempint <= Groupdpercent) && (Groupdpercent > 0)){
	Tempint =0;
	for(i=0; i<19; i++){
		if((DPercent[i] > 0) && (d[i] != ""))
			Tempint +=1;
	}
	switch(Rand(Tempint)){
		case 0:	loadInventory = class<Inventory>( DynamicLoadObject(d[0], class'Class' ));	break;
		case 1:	loadInventory = class<Inventory>( DynamicLoadObject(d[1], class'Class' ));	break;
		case 2:	loadInventory = class<Inventory>( DynamicLoadObject(d[2], class'Class' ));	break;
		case 3:	loadInventory = class<Inventory>( DynamicLoadObject(d[3], class'Class' ));	break;
		case 4:	loadInventory = class<Inventory>( DynamicLoadObject(d[4], class'Class' ));	break;
		case 5:	loadInventory = class<Inventory>( DynamicLoadObject(d[5], class'Class' ));	break;
		case 6:	loadInventory = class<Inventory>( DynamicLoadObject(d[6], class'Class' ));	break;
		case 7:	loadInventory = class<Inventory>( DynamicLoadObject(d[7], class'Class' ));	break;
		case 8:	loadInventory = class<Inventory>( DynamicLoadObject(d[8], class'Class' ));	break;
		case 9:	loadInventory = class<Inventory>( DynamicLoadObject(d[9], class'Class' ));	break;
		case 10:	loadInventory = class<Inventory>( DynamicLoadObject(d[10], class'Class' ));	break;
		case 11:	loadInventory = class<Inventory>( DynamicLoadObject(d[11], class'Class' ));	break;
		case 12:	loadInventory = class<Inventory>( DynamicLoadObject(d[12], class'Class' ));	break;
		case 13:	loadInventory = class<Inventory>( DynamicLoadObject(d[13], class'Class' ));	break;
		case 14:	loadInventory = class<Inventory>( DynamicLoadObject(d[14], class'Class' ));	break;
		case 15:	loadInventory = class<Inventory>( DynamicLoadObject(d[15], class'Class' ));	break;
		case 16:	loadInventory = class<Inventory>( DynamicLoadObject(d[16], class'Class' ));	break;
		case 17:	loadInventory = class<Inventory>( DynamicLoadObject(d[17], class'Class' ));	break;
		case 18:	loadInventory = class<Inventory>( DynamicLoadObject(d[18], class'Class' ));	break;
		case 19:	loadInventory = class<Inventory>( DynamicLoadObject(d[19], class'Class' ));	break;
		case 20:	loadInventory = class<Inventory>( DynamicLoadObject(d[20], class'Class' ));	break;
	}
	if(LoadInventory != none)
		Spawnsackshit(LoadInventory, TRUE);
	else
		VasDebug(" Destroyed LoadInventory = None ",1);
}

Tempint = Rand(100);
if((Tempint <= GroupEpercent) && (GroupEpercent > 0)){
	Tempint = -1;
	for(i=0; i<19; i++){
		if((EPercent[i] > 0) && (e[i] != ""))
			Tempint +=1;
	}
	switch(Rand(Tempint))
	{
		case 0:	loadInventory = class<Inventory>( DynamicLoadObject(e[0], class'Class' ));	break;
		case 1:	loadInventory = class<Inventory>( DynamicLoadObject(e[1], class'Class' ));	break;
		case 2:	loadInventory = class<Inventory>( DynamicLoadObject(e[2], class'Class' ));	break;
		case 3:	loadInventory = class<Inventory>( DynamicLoadObject(e[3], class'Class' ));	break;
		case 4:	loadInventory = class<Inventory>( DynamicLoadObject(e[4], class'Class' ));	break;
		case 5:	loadInventory = class<Inventory>( DynamicLoadObject(e[5], class'Class' ));	break;
		case 6:	loadInventory = class<Inventory>( DynamicLoadObject(e[6], class'Class' ));	break;
		case 7:	loadInventory = class<Inventory>( DynamicLoadObject(e[7], class'Class' ));	break;
		case 8:	loadInventory = class<Inventory>( DynamicLoadObject(e[8], class'Class' ));	break;
		case 9:	loadInventory = class<Inventory>( DynamicLoadObject(e[9], class'Class' ));	break;
		case 10:	loadInventory = class<Inventory>( DynamicLoadObject(e[10], class'Class' ));	break;
		case 11:	loadInventory = class<Inventory>( DynamicLoadObject(e[11], class'Class' ));	break;
		case 12:	loadInventory = class<Inventory>( DynamicLoadObject(e[12], class'Class' ));	break;
		case 13:	loadInventory = class<Inventory>( DynamicLoadObject(e[13], class'Class' ));	break;
		case 14:	loadInventory = class<Inventory>( DynamicLoadObject(e[14], class'Class' ));	break;
		case 15:	loadInventory = class<Inventory>( DynamicLoadObject(e[15], class'Class' ));	break;
		case 16:	loadInventory = class<Inventory>( DynamicLoadObject(e[16], class'Class' ));	break;
		case 17:	loadInventory = class<Inventory>( DynamicLoadObject(e[17], class'Class' ));	break;
		case 18:	loadInventory = class<Inventory>( DynamicLoadObject(e[18], class'Class' ));	break;
		case 19:	loadInventory = class<Inventory>( DynamicLoadObject(e[19], class'Class' ));	break;
		case 20:	loadInventory = class<Inventory>( DynamicLoadObject(e[20], class'Class' ));	break;
	}
	if(LoadInventory != none)
		Spawnsackshit(LoadInventory, TRUE);
	else
		VasDebug(" Destroyed LoadInventory = None ", 1);
}

Tempint = Rand(100);
if((Tempint <= GroupFpercent) && (GroupFpercent > 0)){
	Tempint =0;
	for(i=0; i<19; i++){
	If ((FPercent[i] > 0) && (f[i] != ""))
		Tempint +=1;
	}
	switch(Rand(Tempint)){
		case 0:	loadInventory = class<Inventory>( DynamicLoadObject(f[0], class'Class' ));	break;
		case 1:	loadInventory = class<Inventory>( DynamicLoadObject(f[1], class'Class' ));	break;
		case 2:	loadInventory = class<Inventory>( DynamicLoadObject(f[2], class'Class' ));	break;
		case 3:	loadInventory = class<Inventory>( DynamicLoadObject(f[3], class'Class' ));	break;
		case 4:	loadInventory = class<Inventory>( DynamicLoadObject(f[4], class'Class' ));	break;
		case 5:	loadInventory = class<Inventory>( DynamicLoadObject(f[5], class'Class' ));	break;
		case 6:	loadInventory = class<Inventory>( DynamicLoadObject(f[6], class'Class' ));	break;
		case 7:	loadInventory = class<Inventory>( DynamicLoadObject(f[7], class'Class' ));	break;
		case 8:	loadInventory = class<Inventory>( DynamicLoadObject(f[8], class'Class' ));	break;
		case 9:	loadInventory = class<Inventory>( DynamicLoadObject(f[9], class'Class' ));	break;
		case 10:	loadInventory = class<Inventory>( DynamicLoadObject(f[10], class'Class' ));	break;
		case 11:	loadInventory = class<Inventory>( DynamicLoadObject(f[11], class'Class' ));	break;
		case 12:	loadInventory = class<Inventory>( DynamicLoadObject(f[12], class'Class' ));	break;
		case 13:	loadInventory = class<Inventory>( DynamicLoadObject(f[13], class'Class' ));	break;
		case 14:	loadInventory = class<Inventory>( DynamicLoadObject(f[14], class'Class' ));	break;
		case 15:	loadInventory = class<Inventory>( DynamicLoadObject(f[15], class'Class' ));	break;
		case 16:	loadInventory = class<Inventory>( DynamicLoadObject(f[16], class'Class' ));	break;
		case 17:	loadInventory = class<Inventory>( DynamicLoadObject(f[17], class'Class' ));	break;
		case 18:	loadInventory = class<Inventory>( DynamicLoadObject(f[18], class'Class' ));	break;
		case 19:	loadInventory = class<Inventory>( DynamicLoadObject(f[19], class'Class' ));	break;
		case 20:	loadInventory = class<Inventory>( DynamicLoadObject(f[20], class'Class' ));	break;
	}
	if(LoadInventory != none)
		Spawnsackshit(LoadInventory, TRUE);
	else
		VasDebug(" Destroyed LoadInventory = None ", 1);
}

Tempint = Rand(100);
if((Tempint <= GroupGpercent) && (GroupGpercent > 0)){
Tempint =0;
	for(i=0; i<19; i++){
		if((GPercent[i] > 0) && (g[i] != ""))
			Tempint +=1;
	}
	switch(Rand(Tempint))
	{
		case 0:	loadInventory = class<Inventory>( DynamicLoadObject(G[0], class'Class' ));	break;
		case 1:	loadInventory = class<Inventory>( DynamicLoadObject(G[1], class'Class' ));	break;
		case 2:	loadInventory = class<Inventory>( DynamicLoadObject(G[2], class'Class' ));	break;
		case 3:	loadInventory = class<Inventory>( DynamicLoadObject(G[3], class'Class' ));	break;
		case 4:	loadInventory = class<Inventory>( DynamicLoadObject(G[4], class'Class' ));	break;
		case 5:	loadInventory = class<Inventory>( DynamicLoadObject(G[5], class'Class' ));	break;
		case 6:	loadInventory = class<Inventory>( DynamicLoadObject(G[6], class'Class' ));	break;
		case 7:	loadInventory = class<Inventory>( DynamicLoadObject(G[7], class'Class' ));	break;
		case 8:	loadInventory = class<Inventory>( DynamicLoadObject(G[8], class'Class' ));	break;
		case 9:	loadInventory = class<Inventory>( DynamicLoadObject(G[9], class'Class' ));	break;
		case 10:	loadInventory = class<Inventory>( DynamicLoadObject(G[10], class'Class' ));	break;
		case 11:	loadInventory = class<Inventory>( DynamicLoadObject(G[11], class'Class' ));	break;
		case 12:	loadInventory = class<Inventory>( DynamicLoadObject(G[12], class'Class' ));	break;
		case 13:	loadInventory = class<Inventory>( DynamicLoadObject(G[13], class'Class' ));	break;
		case 14:	loadInventory = class<Inventory>( DynamicLoadObject(G[14], class'Class' ));	break;
		case 15:	loadInventory = class<Inventory>( DynamicLoadObject(G[15], class'Class' ));	break;
		case 16:	loadInventory = class<Inventory>( DynamicLoadObject(G[16], class'Class' ));	break;
		case 17:	loadInventory = class<Inventory>( DynamicLoadObject(G[17], class'Class' ));	break;
		case 18:	loadInventory = class<Inventory>( DynamicLoadObject(G[18], class'Class' ));	break;
		case 19:	loadInventory = class<Inventory>( DynamicLoadObject(G[19], class'Class' ));	break;
		case 20:	loadInventory = class<Inventory>( DynamicLoadObject(G[20], class'Class' ));	break;
	}
	Spawnsackshit(LoadInventory, True);
}

Super.Destroyed();
}

function Spawnsackshit(class<Inventory> LoadInventory, bool BChangefirstspawn){
local int randnumber;
local Inventory Inventory;
local vector X,Y,Z;
local vector newLocation;

VasDebug(" Destroyed Started ", 2);

	if(LoadInventory==None){
		VasDebug (" Spawnsackshit LoadInventory = NONE ",1);
		return;
	}
	Inventory = Spawn(LoadInventory,self,,Location);
	if(Inventory==None){
		VasDebug(" Spawnsackshit Inventory = NONE ",1);
		return;
	}
	newLocation = Inventory.Location;
	newLocation.x += FRand()*CollisionRadius*2 - CollisionRadius;
	newLocation.y += FRand()*CollisionRadius*2 - CollisionRadius;
	newLocation.z += FRand()*CollisionHeight*2 - CollisionHeight;
	Inventory.SetLocation(newLocation);
	if(Inventory.IsA('weapon')){
		weapon(Inventory).RunePowerRequired = 1024;
		//Inventory.RemoteRole = ROLE_DumbProxy;
		Inventory.SetPhysics(PHYS_Falling);
		Inventory.bCollideWorld = true;
		Inventory.ExpireTime = 30.0;
		Inventory.lifeSpan = 30.0;
		Inventory.bExpireWhenTossed = true;
		Inventory.GotoState('Drop');
	}
	Inventory.bTossedOut = true;
	Inventory.RespawnTime = 0.0;

}

function EMatterType MatterForJoint(int joint){
	return MATTER_EARTH;
}

function VasDebug(String Text, int level){
Local String text1,test2;

if(VasDebuglevel > 0){
	if(level <= VasDebuglevel){
	if(level == 1)
		text1 = "* VasDebug L1 * ";
	if(level == 2)
		text1 = "** VasDebug L2 ** ";
	if(level == 3)
		text1 = "*** VasDebug L3 *** ";
	Log (text1$" "$Class.name$" - "$Text);
	}
}
}

defaultproperties{
	VasDebuglevel=1
	GroupApercent=20
	GroupEpercent=25
	GroupGpercent=25
	A(0)="VasSack.VasLizard"
	A(1)="VasSack.vasLegOMeat"
	A(2)="VasSack.VasHealthFruit"
	A(3)="VasGveCrossBow.VW2GVECrossBow"
	A(4)="runei.torch"
	A(5)="runei.Heltorch"
	APercent(0)=5
	APercent(1)=5
	APercent(2)=5
	APercent(3)=3
	APercent(4)=2
	APercent(5)=3
	B(14)="V"
	E(0)="VasShieldS2.VasShieldsDarkShield"
	E(1)="VasShieldS2.VasShieldsDwarfBattleShield"
	E(2)="VasShieldS2.VasShieldsDwarfWoodShield"
	E(3)="VasShieldS2.VasShieldsGoblinShield"
	E(4)="VasShieldS2.VasShieldsVikingShield"
	E(5)="VasShieldS2.VasShieldsVikingShield2"
	E(6)="VasShieldS2.VasShieldsWaterloggedShield"
	EPercent(0)=1
	EPercent(1)=1
	EPercent(2)=1
	EPercent(3)=1
	EPercent(4)=1
	EPercent(5)=1
	EPercent(6)=1
	F(10)="V"
	FPercent(0)=1
	FPercent(1)=1
	FPercent(2)=1
	FPercent(3)=1
	FPercent(4)=1
	FPercent(5)=1
	G(0)="VasWeapons2.VW2HandAxe"
	G(1)="VasWeapons2.VW2GoblinAxe"
	G(2)="VasWeapons2.VW2VikingAxe"
	G(3)="VasWeapons2.VW2VikingShortSword"
	G(4)="VasWeapons2.VW2Romansword"
	G(5)="VasWeapons2.VW2VikingBroadSword"
	G(6)="VasWeapons2.VW2DwarfWorkSword"
	G(7)="VasWeapons2.VW2BoneClub"
	G(8)="VasWeapons2.VW2RustyMace"
	G(9)="VasWeapons2.VW2TrialPitMace"
	G(10)="VasWeapons2.VW2DwarfWorkHammer"
	G(11)="VasWeapons2.VW2DwarfBattleAxe"
	G(12)="VasWeapons2.VW2DwarfBattleSword"
	G(13)="VasWeapons2.VW2DwarfBattleHammer"
	G(14)="VasGveCrossBow.VW2GVECrossBow"
	G(15)="VasWeapons2.VW2SigurdAxe"
	G(16)="VasGveCrossBow.VW2GVECrossBow"
	GPercent(0)=1
	GPercent(1)=1
	GPercent(2)=1
	GPercent(3)=1
	GPercent(4)=1
	GPercent(5)=1
	GPercent(6)=1
	GPercent(7)=1
	GPercent(8)=1
	GPercent(9)=1
	GPercent(10)=1
	GPercent(11)=1
	GPercent(12)=1
	GPercent(13)=1
	GPercent(14)=1
	GPercent(15)=1
	GPercent(16)=1
	DrawScale=0.500000
	CollisionRadius=15.000000
	CollisionHeight=5.000000
	SkelMesh=2
}
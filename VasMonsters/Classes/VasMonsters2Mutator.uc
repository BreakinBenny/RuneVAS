class VasMonsters2Mutator expands Mutator config (VasMonsters2);

Var() config Bool bVasDebug;

Var bool bInitialized,bInitialized2;
Var int MapNumber;

Var config bool UseScriptpoints;
Var config int GameDifficulty;
Var config string MapTitle[99];
Var config int TotalMonsters[100];
Var config int GroupMonsters[100];
var config string MonsterInfo[100];
var string MonsterClass[100];
var string MonsterClassIsA[100];
var int MonsterPercentToSpawn[100];
var config int MonsterRangeLow[100];
var config int MonsterRangeHigh[100];

Var Config String MonsterChangescale[50];
Var Config String MonsterChangeFat[50];
Var Config int NOfMonsterChangeFat;
Var Config int NOfMonsterChangeScale;

Var int IgnoreEnemytimer;
Var int MonsterCounter;

Var NavigationPoint Candidate[256];
Var NavigationPoint Candidate2[256];
Var int num;

function bool VasMonsterPlus(ScriptPawn Monster){
	if(Rand(100) <= 5){
		Monster.Gotostate('Statue');
		Monster.bStatueCanWake = True;
		Return True;
	}
	Return False;
}

function PostBeginPlay(){
	VasDebug("PostBeginPlay - Called");

	if(bInitialized)
	return;
	bInitialized = True;
	Level.Game.Difficulty = GameDifficulty;
	Level.Game.RegisterDamageMutator( Self );
	VasDebug("Game Difficulty set to "$GameDifficulty);
}

function MutatorJointDamaged(out int ActualDamage, Pawn Victim, Pawn InstigatedBy, out Vector HitLocation, out Vector Momentum, name DamageType, out int joint)
{

if(Victim != NONE){
	if(Victim.IsA('scriptpawn')){
		scriptpawn(Victim).IgnoreEnemy = NONE;
		Victim.Enemy =	InstigatedBy;
		if(!Victim.IsA('DwarfMech')){
			Victim.GotoState('Fighting');
		}
	}
}
Super.MutatorJointDamaged(ActualDamage, Victim, InstigatedBy, HitLocation, Momentum, DamageType, joint);
}

function FindMap(){
local int Map;
MapNumber=0;

VasDebug("Reading Maps From VasMonsters2.ini File");

	for(Map=0;Map<100;Map++){
		if(MapTitle[Map] != ""){
			VasDebug("Map listed in VasMonsters2.ini file - "$MapTitle[Map]);
			if(MapTitle[Map] == Level.Title){
				MapNumber=Map;
				VasDebug("Current Map Match - Loading settings for this map!");
				VasDebug("Current Map Match - GroupMonsters-"$GroupMonsters[MapNumber]);
			}
		}
		else{
			VasDebug("End of Map list. "$Map-1$" Map's listed");
			return;
		}
	}
}

function ModifyPlayer(Pawn Other){
local VasMonsters2Welcome VM2W;

VasDebug("ModifyPlayer - Called Pawn="$Other);

Super.ModifyPlayer(Other);
	if(!bInitialized2){
		bInitialized2=true;
		FindMap();
		SetTimer(2.000000,true);
		VM2W=Spawn(class'VasMonsters2Welcome');
		if(VM2W != NONE){
			VM2W.TotalMonsters = TotalMonsters[MapNumber];
			VM2W.GroupMonsters = GroupMonsters[MapNumber];
		}
		 SpawnInitialMonsters();
	}
}

function SpawnInitialMonsters(){
Local Int Monster;

	VasDebug("SpawnInitialMonsters - Started");
	VasDebug("MonsterRangeLow="$MonsterRangeLow[MapNumber]);
	VasDebug("MonsterRangeHigh="$MonsterRangeHigh[MapNumber]);
	
	for(Monster=MonsterRangeLow[MapNumber];Monster<=MonsterRangeHigh[MapNumber];Monster++){
		if(MonsterInfo[Monster] != ""){
			VasDebug("Monster Info loaded from INI File - "$MonsterInfo[Monster]);
			ConverMonsterInfo(MonsterInfo[Monster], Monster);
		}
		else
			return;
	}
	VasDebug("SpawnInitialMonsters - End");
}

Function SpawnMonster(){
Local Int Monster,randnumber, temp;
local ScriptPawn MonsterSP;
local vector StartingLocation;
local class<ScriptPawn> LoadMonster;
local VM2MonsterUpDater MonsterUD;
local class<VM2MonsterUpDater> LoadMonsterUpDater;
Local string strTemp;
Local VM2Nothing VM2Nothing;

VasDebug("SpawnMonster Start");
strTemp = "VasMonsters2.VM2MonsterUpDater";

	if(MonsterCounter < TotalMonsters[MapNumber]){
		for(Monster=MonsterRangeLow[MapNumber];Monster<=MonsterRangeHigh[MapNumber];Monster++){
			randnumber = rand(100);
			if(randnumber <= MonsterPercentToSpawn[Monster]){
				LoadMonster = class<ScriptPawn>( DynamicLoadObject(MonsterClass[Monster], class'Class' ));
				if(LoadMonster==None)
					VasDebug("SpawnMonster - Monster "$ MonsterClass[Monster] $" did not Spawn - ERROR on Load");
				else{
					StartingLocation=GetStartingLocation(MonsterClassIsA[Monster]);
					VM2Nothing=Spawn(class'VM2Nothing',,,StartingLocation);
					if(VM2Nothing.PlayerCanSeeMe()){
						VasDebug("SpawnMonster - Monster "$ MonsterClass[Monster] $" did not Spawn - Someone looking at location!");
						VM2Nothing.destroy();
						return;
					}

					MonsterSP=Spawn(LoadMonster,,,StartingLocation);
					if(MonsterSP == None){
						VasDebug("SpawnMonster - Monster "$ MonsterClass[Monster] $" did not Spawn - ERROR on Spawn");
					}
					else{
						MonsterSP.SetCollision(false, false, false);
						VasDebug("SpawnMonster - Spawning Monster -"$ MonsterClass[Monster] $" randnumber="$randnumber);
						LoadMonsterUpDater = class<VM2MonsterUpDater>( DynamicLoadObject(strTemp, class'Class' ));
						if(LoadMonsterUpDater==None)
							VasDebug("SpawnMonster - LoadMonsterUpDater did not Spawn - ERROR on Load");
						MonsterUD=Spawn(LoadMonsterUpDater,,,);
						if(MonsterUD == None)
							 VasDebug("SpawnMonster - MonsterUD did not Spawn - ERROR on Spawn");
						else
						{
							MonsterUD.Monster = MonsterSP;
							MonsterUD.bVasDebug = bVasDebug;
						}
						if(!VasMonsterPlus(MonsterSP))
						{
							MonsterSP.Orders = 'Roaming';
							MonsterSP.bRoamHome=true;
							if(CheckMonsterChangeFat(string(MonsterSP.Class)))
								ChangeFat(MonsterSP);
							if(CheckMonsterChangescale(string(MonsterSP.Class)))
								Changescale(MonsterSP);
						}
						MonsterCounter += 1;
						if(MonsterCounter >= TotalMonsters[MapNumber])
							return;
					}
				}
			}
		}
	}
}

function bool CheckMonsterChangeFat(string NewMonster){
local int i;
	if(NOfMonsterChangefat == 0)
		 return False;
	for(i=0;i<NOfMonsterChangefat; i++){
		if(MonsterChangeFat[i]~=NewMonster)
			return true;
	}
	return false;
}

function bool CheckMonsterChangescale(string NewMonster){
local int i;

	if(NOfMonsterChangeScale == 0)
		 return False;
	for(i=0;i<NOfMonsterChangeScale; i++){
		if(MonsterChangescale[i]~=NewMonster)
			return true;
	}
	return false;
}

Function ScriptPawn ChangeFat(scriptPawn NewMonster)
{
local int RandNumber, RandNumber2,tempINT;
Local VM2MonsterUpDater VM2MonsterUpDater;

	Randnumber = Rand(100);
	Randnumber2 = Rand(50);
	tempINT = 0;

	if(RandNumber > 70)
		tempINT += Randnumber2;
	if(RandNumber < 30)
		tempINT -= Randnumber2;

	VasDebug("ChangeFat - Monster="$NewMonster$" Bonus="$Randnumber2);

	foreach AllActors(class'VM2MonsterUpDater', VM2MonsterUpDater){
		if(VM2MonsterUpDater.Monster == NewMonster){
			VasDebug("ChangeFat - Monster Found "$VM2MonsterUpDater$"="$NewMonster);
			VM2MonsterUpDater.fatbonus = tempINT;
			Break;}
	}
}

Function ScriptPawn Changescale(scriptPawn NewMonster){
local int RandNumber;
local int RandNumber2;
local Float temp;
	Local VM2MonsterUpDater VM2MonsterUpDater;
	temp = 1.0;
	RandNumber = Rand(100);
	if(RandNumber >= 95)
		temp = 1.50;
	if((RandNumber > 70) && (RandNumber < 90))
		temp = 1.25;
	if(RandNumber <= 5)
		temp = 0.50;
	if((RandNumber > 5) && (RandNumber < 30))
		temp = 0.75;
	VasDebug("Changescale - Called - Bonus="$temp);
	foreach AllActors(class'VM2MonsterUpDater', VM2MonsterUpDater){
		if(VM2MonsterUpDater.Monster == NewMonster){
			VasDebug("Changescale - Monster Found "$VM2MonsterUpDater$"="$NewMonster);
			VM2MonsterUpDater.SizeBonus = temp;
			break;
		}
	}
}

function bool CheckMonsterlist(ScriptPawn ScriptPawn){
Local Int Monster;

	for(Monster=MonsterRangeLow[MapNumber];Monster<=MonsterRangeHigh[MapNumber];Monster++){
		if(ScriptPawn.IsA(Name(MonsterClassIsA[Monster])))
			return True;
	}
	return False;
}

function ConverMonsterInfo(string info, int MonsterNumber){
Local int temp1, Temp2, Temp3, MPTS;
Local string StrTemp, Package, MIsA;

temp1 = InStr(info, ".");
Package = Left(info , temp1);
Temp2 = InStr(info, "-");
MIsA = Mid(info , temp1+1,(Temp2 -(temp1+1)));
Temp3 = InStr(info, "%");
MPTS = INT(Mid(info , temp2+1,(Temp3 -(temp2+1))));
MonsterClassIsA[MonsterNumber]= MIsA;
MonsterClass[MonsterNumber]= Package$"."$MIsA;
MonsterPercentToSpawn[MonsterNumber]= MPTS;
VasDebug("ConverMonsterInfo - Monster="$ MonsterClass[MonsterNumber] $" MonsterPercentToSpawn="$ MPTS);
}

function vector GetStartingLocation(string Monster){
local NavigationPoint N;
local NavigationPoint LastPoint;
local ScriptPoint sp;
local vector test;
local int Tempint;
Local scriptPawn p,pp;
local int num2;
local bool foundstart;

	VasDebug("GetStartingLocation UseScriptpoints="$UseScriptpoints);
	if(Num <= 0){
		foreach AllActors(class'NavigationPoint', N){
			if(N!=None && !N.Region.Zone.bWaterZone){
				if((n.IsA('AutoLink')) || (n.IsA('ButtonMarker')) || (n.IsA('LiftCenter')) || (n.IsA('LiftExit')) || (n.IsA('ScriptPoint')) || (n.IsA('TriggerMarker')) || (n.IsA('WarpZoneMarker')))
					Continue;

				if(num<255)
					Candidate[num] = N;
				num++;
			}
		}
		if(Num > 255){
			VasDebug("Over 255 cap for Monster spawnpoints");
			Num=255;
		}
	}

	if(UseScriptpoints){
		foreach AllActors(class'ScriptPoint', sp){
			if(sp!=None){
				VasDebug("ScriptPoint found monster="$sp.NextOrder);
				if(string(sp.NextOrder) == Monster){
					VasDebug("ScriptPoint match monster="$sp.NextOrder);
					if(num2<255){
						foundstart =true;
						Candidate2[num2] = sp;
					}
					num2++;
				}
			}
		}
		if(foundstart){
			if(num2 > 255){
				VasDebug("Over 255 cap for Monster spawnpoints");
				num2=255;
			}
			return Candidate2[Rand(num2)].Location;
		}
	}

	VasDebug("GetStartingLocation GroupMonster ="$GroupMonsters[MapNumber]);
	if(GroupMonsters[MapNumber] == 1){
		VasDebug("GetStartingLocation GroupMonster for this map is ON! monster="$monster);
		Tempint = 0;
		foreach AllActors(class'scriptPawn', p){
			if((p.IsA(Name(Monster))) && (!p.IsA('TubeStriker'))){
				VasDebug("GetStartingLocation - Start location next to Other monster");
				return P.Location + 72 * Vector(P.Rotation) + vect(0,0,1) * 15;
			}
		}
	}
	VasDebug("GetStartingLocation - Start location is Random");
	return Candidate[Rand(num)].Location;
}

function timer(){
local scriptpawn p;
local int Counter;

Counter = 0;

	foreach AllActors(class'scriptpawn', P){
		if(CheckMonsterlist(P))
			Counter +=1;
		MonsterCounter = Counter;

		if(P.getstatename() == 'StakeOut'){
			P.CheckForEnemies();
			P.IgnoreEnemy = p.Enemy;
			p.Enemy=none;
			//p.Gotostate('fighting');
		}

		if(IgnoreEnemytimer > 2){
			P.IgnoreEnemy = none;
			P.CheckForEnemies();
		}
	}
		if(IgnoreEnemytimer > 3)
			IgnoreEnemytimer = 0;

	SpawnMonster();
	IgnoreEnemytimer +=1;
}

function VasDebug(string logtxt){
	if(bVasDebug)
		Log("**** VasMonsters2 - "$LogTXT);
}

defaultproperties{
	UseScriptpoints=True
	GameDifficulty=3
	MapTitle(0)="Default for All Maps"
	MapTitle(1)="The Blood of the Trickster"
	MapTitle(2)="Ain't Got Time to Bleed"
	MapTitle(3)="DM-Hildir"
	MapTitle(4)="Ice Cavern"
	MapTitle(5)="DM-Geothermal"
	MapTitle(6)="DM-DEMOHel"
	MapTitle(7)="DM-DEMOThorstadt"
	MapTitle(8)="DM-Seaside"
	MapTitle(9)="DM-VUR-MAP3"
	TotalMonsters(0)=7
	TotalMonsters(1)=10
	TotalMonsters(2)=3
	TotalMonsters(3)=8
	TotalMonsters(4)=10
	TotalMonsters(5)=25
	TotalMonsters(6)=12
	TotalMonsters(7)=14
	TotalMonsters(8)=12
	TotalMonsters(9)=50
	GroupMonsters(0)=1
	GroupMonsters(1)=1
	GroupMonsters(3)=1
	GroupMonsters(7)=1
	GroupMonsters(8)=1
	GroupMonsters(9)=1
	MonsterInfo(1)="JetVasMonsters.SandRaider-5%"
	MonsterInfo(2)="RuneI.Elder-4%"
	MonsterInfo(3)="RuneI.GoblinWarrior-8%"
	MonsterInfo(4)="RuneI.DarkViking-4%"
	MonsterInfo(5)="RuneI.DwarfWarA-8%"
	MonsterInfo(6)="RuneI.SarkSword-3%"
	MonsterInfo(7)="RuneI.DwarfWoodlandBig-6%"
	MonsterInfo(8)="RuneI.Zombie-4%"
	MonsterInfo(9)="VM2BonusPack1.VM2ZombieViking-3%"
	MonsterInfo(10)="RuneI.SnowBeastBoss-8%"
	MonsterInfo(11)="RuneI.LokiGuard-4%"
	MonsterInfo(12)="RuneI.Berserker-2%"
	MonsterInfo(13)="Dragons.RedDragon-3%"
	MonsterInfo(14)="RuneI.DwarfMech-2%"
	MonsterInfo(15)="RuneI.SarkConrack-2%"
	MonsterInfo(16)="RuneI.SarkHammer-2%"
	MonsterInfo(17)="RuneI.SarkAxe-2%"
	MonsterInfo(18)="RuneI.SarkSpawn-2%"
	MonsterInfo(19)="VM2BonusPack1.VM2DwarfBlack-3%"
	MonsterInfo(20)="VM2BonusPack2.VM2Dangler-2%"
	MonsterInfo(21)="Dragons.Dragons-4%"
	MonsterInfo(22)="VasGVEBeholder2.VasBeholder-3%"
	MonsterInfo(23)="RuneI.GiantCrab-5%"
	MonsterInfo(24)="JetVasMonsters.Demon-3%"
	MonsterInfo(25)="JetVasMonsters.IceDaemon-2%"
	MonsterInfo(26)="RuneI.babycrab"
	MonsterInfo(27)="JetVasMonsters.DreadSark-1%"
	MonsterInfo(28)="RuneI.Sarksword-15%"
	MonsterInfo(29)="RuneI.DarkViking-20%"
	MonsterInfo(30)="VM2BonusPack1.VM2SeaBird-5%"
	MonsterInfo(35)="RuneI.DwarfMech-2%"
	MonsterInfo(36)="RuneI.LokiGuard-20%"
	MonsterInfo(37)="RuneI.BerSerker-20%"
	MonsterInfo(38)="RuneI.DwarfWarA-20%"
	MonsterInfo(39)="RuneI.DarkViking-20%"
	MonsterInfo(40)="VM2BonusPack1.VM2DwarfBlack-2%"
	MonsterInfo(41)="RuneI.SarkHammer-15%"
	MonsterInfo(42)="RuneI.SarkAxe-15%s"
	MonsterInfo(43)="RuneI.SarkSpawn-5%"
	MonsterInfo(44)="VM2BonusPack1.VM2TubeStriker-10%"
	MonsterInfo(45)="RuneI.BerSerker-20%"
	MonsterInfo(46)="RuneI.Zombie-40%"
	MonsterInfo(47)="RuneI.goblin-70%"
	MonsterInfo(48)="RuneI.Sarksword-15%"
	MonsterInfo(49)="RuneI.DarkViking-20%"
	MonsterInfo(50)="VM2BonusPack1.VM2SeaBird-5%"
	MonsterInfo(51)="RuneI.DwarfWarA-20%"
	MonsterInfo(52)="RuneI.Zombie-40%"
	MonsterInfo(53)="RuneI.DarkViking-20%"
	MonsterInfo(54)="VM2BonusPack1.VM2SeaBird-5%"
	MonsterInfo(60)="RuneI.DwarfWarA-30%"
	MonsterInfo(61)="RuneI.LokiGuard-30%"
	MonsterInfo(62)="RuneI.SnowBeast-20%"
	MonsterInfo(63)="RuneI.goblin-70%"
	MonsterInfo(64)="VM2BonusPack1.VM2DwarfBlack-2%"
	MonsterInfo(65)="VM2BonusPack1.VM2SeaBird-5%"
	MonsterInfo(70)="RuneI.goblin-100%"
	MonsterInfo(71)="RuneI.LokiGuard-5%"
	MonsterInfo(72)="RuneI.SnowBeast-2%"
	MonsterInfo(73)="VM2BonusPack1.VM2TubeStriker-10%"
	MonsterInfo(74)="VM2BonusPack1.VM2DwarfBlack-2%"
	MonsterInfo(75)="VM2BonusPack1.VM2SeaBird-5%"
	MonsterInfo(80)="RuneI.GiantCrab;-5%"
	MonsterInfo(81)="RuneI.BabyCrab-10%"
	MonsterInfo(82)="RuneI.SnowBeast-10%"
	MonsterInfo(83)="RuneI.goblin-50%"
	MonsterInfo(84)="RuneI.Berserker-20%"
	MonsterInfo(85)="RuneI.LokiGuard-5%"
	MonsterInfo(86)="RuneI.SnowBeast-2%"
	MonsterInfo(87)="VM2BonusPack1.VM2TubeStriker-10%"
	MonsterInfo(88)="VM2BonusPack1.VM2DwarfBlack-2%"
	MonsterInfo(89)="VM2BonusPack1.VM2SeaBird-5%"
	MonsterInfo(90)="RuneI.GiantCrab;-5%"
	MonsterInfo(91)="RuneI.BabyCrab-10%"
	MonsterInfo(92)="RuneI.SnowBeast-10%"
	MonsterInfo(93)="RuneI.goblin-50%"
	MonsterInfo(94)="RuneI.Berserker-20%"
	MonsterInfo(95)="RuneI.DarkViking-20%"
	MonsterInfo(96)="RuneI.GoblinCrazy-20%"
	MonsterInfo(97)="RuneI.GoblinWarrior-20%"
	MonsterInfo(98)="RuneI.Zombie-20%"
	MonsterInfo(99)="RuneI.Zombie2-20%"
	MonsterRangeLow(0)=1
	MonsterRangeLow(1)=40
	MonsterRangeLow(2)=35
	MonsterRangeLow(3)=1
	MonsterRangeLow(4)=60
	MonsterRangeLow(5)=70
	MonsterRangeLow(6)=90
	MonsterRangeLow(7)=90
	MonsterRangeLow(8)=1
	MonsterRangeLow(9)=1
	MonsterRangeHigh(0)=26
	MonsterRangeHigh(1)=50
	MonsterRangeHigh(2)=39
	MonsterRangeHigh(3)=20
	MonsterRangeHigh(4)=65
	MonsterRangeHigh(5)=75
	MonsterRangeHigh(6)=99
	MonsterRangeHigh(7)=99
	MonsterRangeHigh(8)=20
	MonsterRangeHigh(9)=20
	MonsterChangescale(0)="RuneI.goblin"
	MonsterChangescale(1)="RuneI.SnowBeast"
	MonsterChangescale(2)="RuneI.BerSerker"
	MonsterChangeFat(0)="RuneI.goblin"
	MonsterChangeFat(1)="RuneI.SnowBeast"
	MonsterChangeFat(2)="RuneI.BerSerker"
	MonsterChangeFat(3)="RuneI.Sven"
	MonsterChangeFat(4)="Dragons.RedDragon"
	MonsterChangeFat(5)="RuneI.Elder"
	MonsterChangeFat(6)="Dragons.Dragons"
	NOfMonsterChangeFat=6
}
//-----------------------------------------------------------
//	VasExperience - By Kal-Corp, Kal-Corp@cfl.rr.com
//	http://Vasserver.dyndns.org/KalsForums
//-----------------------------------------------------------
class VasExperienceMutator expands Mutator config(VasExperience);

Var Bool bInitialized;
Var config int StatAdjust;
Var config bool AttackothersDefault;
Var config int skillAdjust;
var  int playerloaded[1001];

var() Config int Cleanuplevel;
var() Config int CleanupTimer;
var() Config int CleanupTime;
var() Config int attackotherscounter;

var Config string Saveplayer[1001];
var string SavePlayerName[1001];
var int SaveplayerExperiencePoints[1001];
var int SaveplayerLevel[1001];
var int SaveSTR[1001];
var int SaveINT[1001];
var int SaveDEX[1001];
var int SavePlayerMagicSkill[1001];
var int SavePlayerSwordSkill[1001];
var int SavePlayeraxeSkill[1001];
var int SavePlayermaceSkill[1001];
var int SavePlayerbowSkill[1001];
var int SaveMurderCount[1001];
var string Savepassword[1001];

var string TSavePlayerName[1001];
var int TSaveplayerExperiencePoints[1001];
var int TSaveplayerLevel[1001];
var int TSaveSTR[1001];
var int TSaveINT[1001];
var int TSaveDEX[1001];
var int TSavePlayerMagicSkill[1001];
var int TsavePlayerSwordSkill[1001];
var int TSavePlayeraxeSkill[1001];
var int TSavePlayermaceSkill[1001];
var int TSavePlayerbowSkill[1001];
var int TSaveMurderCount[1001];
var string TSavepassword[1001];


Var bool bGotPlayers;
Var VasEXPReplicationInfo REPLINFO[64];
var config float timerInterval;
var int Timercounter;
Var config int VasDebuglevel;
Var config bool TurnOnNOPVP;

function PreBeginPlay(){
	local int i;

	VasDebug(" PreBeginPlay Started Timer set to 1",2);
	setTimer(1, true);
	VasDebug(" PreBeginPlay bGotPlayers="$bGotPlayers,3);
		if(!bGotPlayers){
			bGotPlayers=true;
			getallplayers();
			if(CleanupTimer >= CleanupTime)
				VasEXPCleanUp();
			CleanupTimer += 1;
		}
	Super.PreBeginPlay();
}

function getallplayers(){
	local int i;

	for(i=1;i<=1000; i++)
		getplayerinfo(i);
}

function timer(){
	Local int PlayerNumber;
	local Runeplayer Player;
	local scriptpawn scriptpawn;
	local VasEXPallyRepl VasEXPallyRepl;
	local bool bcheck;
  
VasDebug(" Timer Timercounter="$Timercounter$" timerInterval="$timerInterval,2);
	if(Timercounter >= timerInterval){
		Timercounter =0;
		foreach allActors(class'runeplayer', Player){
			PlayerNumber = getplayerID(Player);
			if(playerloaded[PlayerNumber] == 0)
				VasGetplayerStats(Player, PlayerNumber);
			VasAutoSave(Player, PlayerNumber, true);
		}
		VasDebug(" Timer Saveconfig",1);
		Saveconfig();
	}
	Timercounter +=1;
}

function int totalplayers(){
	local int i;

	VasDebug(" totalplayers Started ",2);
		for(i=1;i<=1000; i++){
			if(SavePlayerName[i] == ""){
				VasDebug(" totalplayers total="$i,2);
				return i;
			}
		}
	VasDebug(" totalplayers total="$i,2);
	return i;
}

function int GetREPLINFONumber(pawn pawn){
	local int I;

	VasDebug(" GetREPLINFONumber Started pawn="$pawn,3);
	if(pawn != none){
		for(i=0; i<64; i++){
			if(REPLINFO[i] != none){
				if(REPLINFO[i].Owner == Pawn){
					VasDebug(" GetREPLINFONumber REPLINFO[i].owner = pawn ", 2);
					return i;
				}
			}
		}
	}
}

function int getplayerID(pawn other){
	local int PlayerNumber;
	local int i;
	local string PlayerName;

	VasDebug(" getplayerID Started for "$other,3);
	PlayerName = CAPS(Other.PlayerReplicationInfo.PlayerName);
	VasDebug(" getplayerID PlayerName="$PlayerName,3);
		for(i=1; i<=1000; i++){
			VasDebug(" getplayerID SavePlayerName="$caps(SavePlayerName[i]),3);
			if((caps(SavePlayerName[i]) == PlayerName) || (SavePlayerName[i] == "")){
				VasDebug(" getplayerID PlayerName found or end",2);
				PlayerNumber=i;
				SavePlayerName[i] = PlayerName;
				return PlayerNumber;
			}
		}
	return PlayerNumber;
}

Function GetVasEXPReplicationInfo(pawn Other){
	local VasEXPReplicationInfo VasRInfo, temp;
	local int I;

	VasDebug(" GetVasEXPReplicationInfo Started for "$other, 2);
	for(i=0; i<64; i++)
		REPLINFO[i] = None;
	i=0;
	foreach AllActors(class'VasEXPReplicationInfo', VasRInfo){
		VasDebug(" GetVasEXPReplicationInfo ALL VasRInfo="$VasRInfo,3);
		if(VasRInfo.owner != none){
			VasDebug(" GetVasEXPReplicationInfo VasRInfo.owner = other ", 2);
			REPLINFO[i] = VasRInfo;
			i +=1;
		}
		else
			VasDebug(" GetVasEXPReplicationInfo VasRInfo.owner == NONE", 1);
	}
}

function ModifyPlayer(Pawn Other){
	local int PlayerNumber;
	local string PlayerName,PlayerName2;

VasDebug(" ModifyPlayer Started for "$other,2);

PlayerNumber = getplayerID(other);
VasDebug(" ModifyPlayer PlayerNumber="$PlayerNumber,3);
PlayerName = caps(Other.PlayerReplicationInfo.PlayerName);
VasDebug(" ModifyPlayer PlayerName="$PlayerName,3);

INITVasExperienceINFO(Other);
INITVasEXPReplicationInfo(Other);
GetVasEXPReplicationInfo(Other);

	if((playerloaded[PlayerNumber] == 0) || (Other.bHiddenEd)){
		VasDebug(" ModifyPlayer playerloaded=0 or Other.bHiddenEd",2);
		VasGetplayerStats(Other, PlayerNumber) ;
	}
	else
		VasDebug(" ModifyPlayer playerloaded != 0 or !Other.bHiddenEd other="$other,2);
	Super.ModifyPlayer(Other);
}

Function INITVasExperienceINFO(Pawn Other){
local Pawn P;
local VasExperienceINFO VasExperienceINFO;

VasDebug(" INITVasExperienceINFO Started for "$other,2);

	foreach AllActors(class'VasExperienceINFO', VasExperienceINFO)	{
		VasDebug(" INITVasExperienceINFO All VasExperienceINFO "$VasExperienceINFO,3);
		if(VasExperienceINFO.owner == Other){
			VasDebug(" INITVasExperienceINFO VasExperienceINFO.owner = "$other,2);
			return;
		}
	}
	VasDebug(" INITVasExperienceINFOStart spawn VasExperience.VasExperienceINFO",2);
	VasExperienceINFO = Spawn(Class'VasExperience.VasExperienceINFO',other);
	if(VasExperienceINFO == none)
		VasDebug(" INITVasExperienceINFOStart spawn VasExperience.VasExperienceINFO Failed",1);
}

Function VasEXPReplicationInfo INITVasEXPReplicationInfo(Pawn Other){
Local int PlayerNumber;
local string PlayerName;
local VasEXPReplicationInfo VasEXPReplicationInfo;

VasDebug(" INITVasEXPReplicationInfo Started for "$other,2);

PlayerNumber = getplayerID(other);
VasDebug(" INITVasEXPReplicationInfo PlayerNumber="$PlayerNumber,3);
PlayerName = caps(Other.PlayerReplicationInfo.PlayerName);
VasDebug(" INITVasEXPReplicationInfo PlayerName="$PlayerName,3);

	foreach AllActors(class'VasEXPReplicationInfo', VasEXPReplicationInfo){
		VasDebug(" INITVasExperienceINFO All VasEXPReplicationInfo "$VasEXPReplicationInfo, 3);
		if(VasEXPReplicationInfo.owner == Other){
			VasDebug(" INITVasExperienceINFO VasEXPReplicationInfo.owner = "$other, 2);
			return VasEXPReplicationInfo;
		}
	}
VasDebug(" INITVasExperienceINFOStart spawn VasExperience.VasEXPReplicationInfo",2);
VasEXPReplicationInfo = Spawn(Class'VasExperience.VasEXPReplicationInfo',other);
	if(VasEXPReplicationInfo != none){
		VasEXPReplicationInfo.StatAdjust=StatAdjust;
		VasEXPReplicationInfo.skillAdjust=skillAdjust;
		VasEXPReplicationInfo.TotalServerSaves = totalplayers();
		VasEXPReplicationInfo.attackothers = AttackothersDefault ;
		VasEXPReplicationInfo.Playername = PlayerName;
		playerloaded[PlayerNumber] = 0;
		VasDebug(" INITVasExperienceINFOStart return "$VasEXPReplicationInfo,2);
		return VasEXPReplicationInfo;
	}
	else
		VasDebug(" INITVasExperienceINFOStart spawn VasExperience.VasEXPReplicationInfo Failed",1);
}

function PostBeginPlay(){
VasDebug(" PostBeginPlay Started ",2);

BroadcastMessage("Powered by VasExperience -  Kal Corp");
LOG("Powered by VasExperience -  Kal Corp");

VasDebug(" PostBeginPlay bInitialized="$bInitialized,3);
	if(bInitialized)
		return;
	bInitialized = True;
Level.Game.RegisterDamageMutator( Self );
}


function MutatorJointDamaged( out int ActualDamage, Pawn Victim, Pawn InstigatedBy, out Vector HitLocation, out Vector Momentum, name DamageType, out int joint){
Local weapon weapon;
Local int swordskill,axeskill ,maceskill,BowSkill;
local int tempint,REPLINFONumber,REPLINFONumber2,REPLINFONumber3,REPLINFONumber4;
local VasEXPReplicationInfo VasRInfo,VasRInfo2,VasRInfo3,VasRInfo4;

VasDebug(" MutatorJointDamaged Started ",3);
VasDebug(" (IN) ActualDamage="$ActualDamage$" Victim="$Victim$" InstigatedBy="$InstigatedBy$" DamageType="$DamageType,3);

	if(InstigatedBy != none){
		if(InstigatedBy.IsA('playerpawn')){
			REPLINFONumber = GetREPLINFONumber(InstigatedBy);
			VasRInfo = REPLINFO[REPLINFONumber];
		}
		if(InstigatedBy.IsA('scriptpawn')){
			if(scriptpawn(InstigatedBy).ally != NONE)
				REPLINFONumber4 = GetREPLINFONumber(scriptpawn(InstigatedBy).ally);
			VasRInfo4 = REPLINFO[REPLINFONumber4];
		}
	}

	if(Victim != none){
		if(Victim.IsA('playerpawn')){
			REPLINFONumber2 = GetREPLINFONumber(Victim);
			VasRInfo2 = REPLINFO[REPLINFONumber2];
		}
		if(Victim.IsA('scriptpawn')){
			if(scriptpawn(Victim).ally != NONE)
				REPLINFONumber3 = GetREPLINFONumber(scriptpawn(Victim).ally);
			VasRInfo3 = REPLINFO[REPLINFONumber3];
		}
	}

	if((Victim != NONE) && (InstigatedBy != none)){
	// *****************	PVP
	if((Victim.IsA('playerpawn')) && (InstigatedBy.IsA('playerpawn'))){
		if((VasRInfo.NOPVP) || (VasRInfo2.NOPVP)){
			ActualDamage = 0;
			VasDebug(" (OUT) ActualDamage="$ActualDamage$" Victim="$Victim$" InstigatedBy="$InstigatedBy$" DamageType="$DamageType,3);
			Super.MutatorJointDamaged(ActualDamage, Victim, InstigatedBy, HitLocation, Momentum, DamageType, joint);
		}
		ActualDamage *= 0.40;
		if((!VasRInfo.attackothers) && (!VasRInfo2.attackothers))
			ActualDamage = 0;
	}

	// *****************	PVS
	if((Victim.IsA('scriptpawn')) && (InstigatedBy.IsA('playerpawn'))){
		ActualDamage *= 0.5;
		if(scriptpawn(Victim).ally != NONE){
			ActualDamage *= 0.5;
			if((!VasRInfo.attackothers) && (!VasRInfo3.attackothers))
				ActualDamage = 0;
		}
	}
	// *****************	SVP
	if((InstigatedBy.IsA('scriptpawn')) && (Victim.IsA('playerpawn'))){
		if(scriptpawn(InstigatedBy).ally != NONE){
			if((!VasRInfo2.attackothers) && (!VasRInfo4.attackothers))
				ActualDamage = 0;
		}
	}
}

	if(InstigatedBy != none){
		if(InstigatedBy.ScaleGlow == 0.002){
			ActualDamage=0;
			VasDebug(" (OUT) ActualDamage="$ActualDamage$" Victim="$Victim$" InstigatedBy="$InstigatedBy$" DamageType="$DamageType,3);
			Super.MutatorJointDamaged(ActualDamage, Victim, InstigatedBy, HitLocation, Momentum, DamageType, joint);
		}
	if(InstigatedBy.isa('scriptpawn')){
		if(scriptpawn(InstigatedBy).ally != NONE){
			if(VasRInfo4 != NONE)
				VasRInfo4.EXP += ActualDamage;
		}
	}

	if(InstigatedBy.isa('RunePlayer'))
		VasRInfo.EXP += ActualDamage;

	if((InstigatedBy.weapon != NONE ) && (InstigatedBy.IsA('runeplayer')) && (DamageType != 'fire')){
	weapon =  instigatedBy.weapon;
	VasDebug(" MutatorJointDamaged weapon="$weapon,3);
		if((InstigatedBy.weapon.IsA('Sword')) || (InstigatedBy.weapon.IsA('VW2Swords'))){
			swordskill = 1;
			if((weapon.IsA('RomanSword')) ||(weapon.IsA('VW2RomanSword')))
				swordskill = 2;
			if((weapon.IsA('VikingBroadSword')) || (weapon.IsA('VW2VikingBroadSword')))
				swordskill = 3;
			if((weapon.IsA('DwarfWorkSword')) || (weapon.IsA('VW2DwarfWorkSword')))
				swordskill = 4;
			if((weapon.IsA('DwarfBattleSword')) || (weapon.IsA('VW2DwarfBattleSword')))
				swordskill = 5;
			if(ActualDamage > 0)
				VasDebug(" MutatorJointDamaged SwordSkillUP called swordskill="$swordskill,3);
	VasRInfo.SwordSkillUP(swordskill);
	ActualDamage *= ((INITVasEXPReplicationInfo(InstigatedBy).VasSwordskill+100)/100);
	}
	else if((weapon.IsA('axe')) || (weapon.IsA('VW2axes')))
		axeskill =1;
		if((weapon.IsA('GoblinAxe')) || (weapon.IsA('VW2GoblinAxe')))
 			axeskill =2;
		if((weapon.IsA('VikingAxe')) ||(weapon.IsA('VW2VikingAxe')))
			axeskill =3;
		if((weapon.IsA('SigurdAxe')) || (weapon.IsA('Vw2SigurdAxe')))
			axeskill =4;
		if((weapon.IsA('DwarfBattleAxe')) || (weapon.IsA('VW2DwarfBattleAxe')))
			axeskill =5;
		if(ActualDamage > 0)
			VasDebug(" MutatorJointDamaged axeSkillUP called axeskill="$axeskill,3);
		VasRInfo.axeSkillUP(axeskill);
		ActualDamage *= ((INITVasEXPReplicationInfo(InstigatedBy).Vasaxeskill+100)/100);
	}
	else if((weapon.IsA('Hammer')) || (weapon.IsA('VW2Hammers'))){
		maceskill =1;
		if((weapon.IsA('BoneClub')) || (weapon.IsA('VW2BoneClub')))
			maceskill =2;
		if( (weapon.IsA('TrialPitMace'))|| (weapon.IsA('VW2TrialPitMace')))
			maceskill =3;
		if((weapon.IsA('DwarfWorkHammer')) || (weapon.IsA('VW2DwarfWorkHammer')))
			maceskill =4;
		if((weapon.IsA('DwarfBattleHammer')) || (weapon.IsA('VW2DwarfBattleHammer')))
			maceskill =5;
		if(ActualDamage > 0)
			VasDebug(" MutatorJointDamaged maceSkillUP called maceskill="$maceskill,3);
		VasRInfo.maceSkillUP(maceskill);
		ActualDamage *= ((INITVasEXPReplicationInfo(InstigatedBy).Vasmaceskill+100)/100);
	}
	else if((InstigatedBy.weapon.IsA('VasGVECrossBow'))||(InstigatedBy.weapon.IsA('VW2GVECrossBow'))){
		Bowskill = rand(4)+1;
		if(ActualDamage > 0)
			VasDebug(" MutatorJointDamaged BowSkillUP called Bowskill="$Bowskill,3);
		VasRInfo.BowSkillUP(Bowskill);
		ActualDamage *= ((INITVasEXPReplicationInfo(InstigatedBy).VasBowskill+100)/100);
	}
	else if(InstigatedBy.weapon.IsA('Sword')){
		swordskill = rand(4)+1;
		if(ActualDamage > 0)
			VasDebug(" MutatorJointDamaged SwordSkillUP called swordskill="$swordskill,3);
		VasRInfo.SwordSkillUP(swordskill);
		ActualDamage *= ((INITVasEXPReplicationInfo(InstigatedBy).VasSwordskill+100)/100);
	}
	else if(weapon.IsA('axe')){
		axeskill = rand(4)+1;
		if(ActualDamage > 0)
			VasDebug(" MutatorJointDamaged axeSkillUP called axeskill="$axeskill,3);
		VasRInfo.axeSkillUP(axeskill);
		ActualDamage *= ((INITVasEXPReplicationInfo(InstigatedBy).Vasaxeskill+100)/100);
	}
	else if(weapon.IsA('Hammer')){
		maceskill = rand(4)+1;
		if(ActualDamage > 0)
			VasDebug(" MutatorJointDamaged maceSkillUP called maceskill="$maceskill,3);
		VasRInfo.maceSkillUP(maceskill);
		ActualDamage *= ((INITVasEXPReplicationInfo(InstigatedBy).Vasmaceskill+100)/100);
	}
	else
		ActualDamage *= 0.65;
	VasDebug(" (OUT) ActualDamage="$ActualDamage$" Victim="$Victim$" InstigatedBy="$InstigatedBy$" DamageType="$DamageType,3);
	Super.MutatorJointDamaged(ActualDamage, Victim, InstigatedBy, HitLocation, Momentum, DamageType, joint);
}

function ScoreKill(Pawn Killer, Pawn Other){
Local int PlayerNumber;

VasDebug(" ScoreKill Started - Killer="$killer$" other="$other,2);

	if(other != NONE){
		if(Other.IsA('runeplayer')){
			PlayerNumber = getplayerID(Other);
			VasAutoSave(runeplayer(Other), PlayerNumber, False);
		}
	}
	else
		VasDebug(" ScoreKill other == none ", 1);

	if(Killer != NONE){
		if(Killer.IsA('runeplayer')){
			PlayerNumber = getplayerID(Killer);
			VasAutoSave(runeplayer(Killer), PlayerNumber, False);
			if(other != NONE){
				VasDebug(" ScoreKill Killer EXP + "$Other.Default.health,2);
				INITVasEXPReplicationInfo(Killer).EXP += Other.Default.health;
			}
		}
		if(Killer.IsA('Scriptpawn')){
			if(Scriptpawn(Killer).ally != NONE){
				if(other != NONE)
					INITVasEXPReplicationInfo(Scriptpawn(Killer).ally).EXP += Other.Default.health*0.3;
			}
		}
	}
	else
		VasDebug(" ScoreKill Killer == none ",1);

	if(NextMutator != None)
		NextMutator.ScoreKill(Killer, Other);
}

function getplayerinfo(int i){
local string saveinfo,temp;
local int I1,I2,I3,I4,I5,I6,I7,I8,I9,I10,I11,I12,I13,I14,I15,I16,I17,I18,I19,I20,I21,I22;

VasDebug(" getplayerinfo Started i="$i,3);

saveinfo = Saveplayer[i];

I1 = InStr(saveinfo, "@1#");
temp = caps(Left(saveinfo , I1));

	if(temp == "VASEXPV1.02"){
	VasDebug(" getplayerinfo VasEXPv1.02 Player! saveinfo="$saveinfo,2);
	I1 = InStr(saveinfo, "@1#");
	I2 = InStr(saveinfo, "@2#");
	SavePlayerName[i] = caps(Mid(saveinfo , I1+3,(I2 -(I1+3))));
	I3 = InStr(saveinfo, "@3#");
	SaveplayerExperiencePoints[i] = INT(Mid(saveinfo, I2+3,(I3-(I2+3))));
	I4 = InStr(saveinfo, "@4#");
	SaveplayerLevel[i] = INT(Mid(saveinfo, I3 +3,(I4 -(I3+3))));
	I5 = InStr(saveinfo, "@5#");
	SaveMurderCount[i] = INT(Mid(saveinfo, I4 +3,(I5 -(I4 +3))));
	I6 = InStr(saveinfo, "@6#");
	Savepassword[i] = caps(Mid(saveinfo, I5 +3,(I6 -(I5 +3))));
	I7 = InStr(saveinfo, "@7#");
	SaveSTR[i] = INT(Mid(saveinfo, I6 +3,(I7 -(I6 +3))));
	I8 = InStr(saveinfo, "@8#");
	SaveINT[i] = INT(Mid(saveinfo, I7 +3,(I8 -(I7 +3))));
	I9 = InStr(saveinfo, "@9#");
	SaveDEX[i] = INT(Mid(saveinfo, I8 +3,(I9 -(I8 +3))));
	I10 = InStr(saveinfo, "@10#");
	SavePlayerMagicSkill[i] = INT(Mid(saveinfo, I9 +3,(I10 -(I9 +3))));
	I11 = InStr(saveinfo, "@11#");
	SavePlayerSwordSkill[i] = INT(Mid(saveinfo, I10 +4,(I11 -(I10 +4))));
	I12 = InStr(saveinfo, "@12#");
	SavePlayeraxeSkill[i] = INT(Mid(saveinfo, I11 +4,(I12 -(I11+4))));
	I13 = InStr(saveinfo, "@13#");
	SavePlayermaceSkill[i] = INT(Mid(saveinfo, I12+4,(I13 -(I12+4))));
	I14 = InStr(saveinfo, "@14#");
	SavePlayerbowSkill[i] = INT(Mid(saveinfo, I13 +4,(I14 -(I13 +4))));
	}
	else if(temp == "VASEXPV1.03"){
	VasDebug(" getplayerinfo VasEXPv1.03 Player! saveinfo="$saveinfo,2);
	I1 = InStr(saveinfo, "@1#");
	I2 = InStr(saveinfo, "@2#");
	SavePlayerName[i] = caps(Mid(saveinfo , I1+3,(I2 -(I1+3))));
	I3 = InStr(saveinfo, "@3#");
	SaveplayerExperiencePoints[i] = INT(Mid(saveinfo, I2+3,(I3-(I2+3))));
	I4 = InStr(saveinfo, "@4#");
	SaveplayerLevel[i] = INT(Mid(saveinfo, I3 +3,(I4 -(I3+3))));
	I5 = InStr(saveinfo, "@5#");
	SaveMurderCount[i] = INT(Mid(saveinfo, I4 +3,(I5 -(I4 +3))));
	I6 = InStr(saveinfo, "@6#");
	Savepassword[i] = Caps(Mid(saveinfo, I5 +3,(I6 -(I5 +3))));
	I7 = InStr(saveinfo, "@7#");
	SaveSTR[i] = INT(Mid(saveinfo, I6 +3,(I7 -(I6 +3))));
	I8 = InStr(saveinfo, "@8#");
	SaveINT[i] = INT(Mid(saveinfo, I7 +3,(I8 -(I7 +3))));
	I9 = InStr(saveinfo, "@9#");
	SaveDEX[i] = INT(Mid(saveinfo, I8 +3,(I9 -(I8 +3))));
	I10 = InStr(saveinfo, "@10#");
	SavePlayerMagicSkill[i] = INT(Mid(saveinfo, I9 +3,(I10 -(I9 +3))));
	I11 = InStr(saveinfo, "@11#");
	SavePlayerSwordSkill[i] = INT(Mid(saveinfo, I10 +4,(I11 -(I10 +4))));
	I12 = InStr(saveinfo, "@12#");
	SavePlayeraxeSkill[i] = INT(Mid(saveinfo, I11 +4,(I12 -(I11+4))));
	I13 = InStr(saveinfo, "@13#");
	SavePlayermaceSkill[i] = INT(Mid(saveinfo, I12+4,(I13 -(I12+4))));
	I14 = InStr(saveinfo, "@14#");
	SavePlayerbowSkill[i] = INT(Mid(saveinfo, I13 +4,(I14 -(I13 +4))));
	}
	else{
	VasDebug(" getplayerinfo OlderSaved player! saveinfo="$saveinfo,2);
	I1 = InStr(saveinfo, "@1#");
	SavePlayerName[i] = caps(Left(saveinfo , I1));
	I2 = InStr(saveinfo, "@2#");
	SaveplayerExperiencePoints[i] = INT(Mid(saveinfo , I1+3,(I2 -(I1+3))));
	I3 = InStr(saveinfo, "@3#");
	SaveplayerLevel[i] = INT(Mid(saveinfo, I2+3,(I3-(I2+3))));
	I4 = InStr(saveinfo, "@4#");
	SaveSTR[i] = INT(Mid(saveinfo, I3 +3,(I4 -(I3+3))));
	I5 = InStr(saveinfo, "@5#");
	SaveINT[i] = INT(Mid(saveinfo, I4 +3,(I5 -(I4 +3))));
	I6 = InStr(saveinfo, "@6#");
	SaveDEX[i] = INT(Mid(saveinfo, I5 +3,(I6 -(I5 +3))));
	I7 = InStr(saveinfo, "@7#");
//	SaveSTRLocked[i] = INT(Mid(saveinfo, I6 +3,(I7 -(I6 +3))));
	I8 = InStr(saveinfo, "@8#");
//	SaveINTLocked[i] = INT(Mid(saveinfo, I7 +3,(I8 -(I7 +3))));
	I9 = InStr(saveinfo, "@9#");
//	SaveDEXlocked[i] = INT(Mid(saveinfo, I8 +3,(I9 -(I8 +3))));
	I10 = InStr(saveinfo, "@10#");
	SavePlayerMagicSkill[i] = INT(Mid(saveinfo, I9 +3,(I10 -(I9 +3))));
	I11 = InStr(saveinfo, "@11#");
	SavePlayerSwordSkill[i] = INT(Mid(saveinfo, I10 +4,(I11 -(I10 +4))));
	I12 = InStr(saveinfo, "@12#");
	SavePlayeraxeSkill[i] = INT(Mid(saveinfo, I11 +4,(I12 -(I11+4))));
	I13 = InStr(saveinfo, "@13#");
	SavePlayermaceSkill[i] = INT(Mid(saveinfo, I12+4,(I13 -(I12+4))));
	I14 = InStr(saveinfo, "@14#");
	I15 = InStr(saveinfo, "@15#");
	I16 = InStr(saveinfo, "@16#");
	I17 = InStr(saveinfo, "@17#");
	I18 = InStr(saveinfo, "@18#");
	I19 = InStr(saveinfo, "@19#");
	SaveMurderCount[i] = INT(Mid(saveinfo, I18 +4,(I19 -(I18 +4))));
	I20 = InStr(saveinfo, "@20#");
//	Savepassword[i] = Mid(saveinfo, I19 +4,(I20 -(I19 +4)));
	Savepassword[i] = "PW-NONE";
	I21 = InStr(saveinfo, "@21#");
	SavePlayerbowSkill[i] = INT(Mid(saveinfo, I20 +4,(I21 -(I20 +4))));
	I22 = InStr(saveinfo, "@22#");
	}
}

function SavePlayerToString(int PlayerNumber){
local string saveinfo;

VasDebug(" SavePlayerToString Started PlayerNumber="$PlayerNumber,2);

saveinfo =
	"VASEXPV1.03@1#"$
	caps(SavePlayerName[PlayerNumber])$"@2#"$
	SaveplayerExperiencePoints[PlayerNumber]$"@3#"$
	SaveplayerLevel[PlayerNumber]$"@4#"$
	SaveMurderCount[PlayerNumber]$"@5#"$
	caps(Savepassword[PlayerNumber])$"@6#"$
	SaveSTR[PlayerNumber]$"@7#"$
	SaveINT[PlayerNumber]$"@8#"$
	SaveDEX[PlayerNumber]$"@9#"$
	SavePlayerMagicSkill[PlayerNumber]$"@10#"$
	SavePlayerSwordSkill[PlayerNumber]$"@11#"$
	SavePlayeraxeSkill[PlayerNumber]$"@12#"$
	SavePlayermaceSkill[PlayerNumber]$"@13#"$
	SavePlayerbowSkill[PlayerNumber]$"@14#"
	;

if(SavePlayerName[PlayerNumber] == ""){
	{saveinfo = "";}
Saveplayer[PlayerNumber]= saveinfo;
VasDebug(" SavePlayerToString saveinfo="$saveinfo,3);
}

function bool VasAutoSave(runeplayer SavePlayer, int PlayerNumber, bool Massage){
local string PlayerName;
local int tempint,REPLINFONumber;
local VasEXPReplicationInfo VasRInfo;

VasDebug(" VasAutoSave Started SavePlayer="$SavePlayer$" PlayerNumber="$PlayerNumber,2);

	REPLINFONumber = GetREPLINFONumber(SavePlayer);
	PlayerName = caps(SavePlayer.PlayerReplicationInfo.PlayerName);
	VasRInfo = REPLINFO[REPLINFONumber] ;

	if(VasRInfo != none){
		if((SavePlayerName[PlayerNumber] == caps(PlayerName)) && (Savepassword[PlayerNumber] == caps(VasRInfo.VasSavePlayerpassword)) && (!VasRInfo.StopVasEXP)){
			if(VasRInfo.EXP == 0){
				VasGetplayerStats(SavePlayer, PlayerNumber );
				return false;
			}
			if(SaveplayerExperiencePoints[PlayerNumber] < VasRInfo.EXP)
				SaveplayerExperiencePoints[PlayerNumber] = VasRInfo.EXP;
			Saveplayerlevel[PlayerNumber] = VasRInfo.PLevel;
			if(SaveSTR[PlayerNumber] < (VasRInfo.vasSTR))
				SaveSTR[PlayerNumber] = VasRInfo.vasSTR;
			if(SaveINT[PlayerNumber] < (VasRInfo.vasINT))
				SaveINT[PlayerNumber] = VasRInfo.vasINT;
			if(SaveDEX[PlayerNumber] < (VasRInfo.vasDEX))
				SaveDEX[PlayerNumber] = VasRInfo.vasDEX;
			if(SavePlayerMagicSkill[PlayerNumber] < (VasRInfo.VasMagicSkill))
				SavePlayerMagicSkill[PlayerNumber] = VasRInfo.VasMagicSkill;
			if(SavePlayerSwordSkill[PlayerNumber] < (VasRInfo.VasSwordSkill))
				SavePlayerSwordSkill[PlayerNumber] = VasRInfo.VasSwordSkill;
			if(SavePlayeraxeSkill[PlayerNumber] < (VasRInfo.VasaxeSkill))
				SavePlayeraxeSkill[PlayerNumber] = VasRInfo.VasaxeSkill;
			if(SavePlayermaceSkill[PlayerNumber] < (VasRInfo.VasmaceSkill))
				SavePlayermaceSkill[PlayerNumber] = VasRInfo.VasmaceSkill;
			if(SavePlayerbowSkill[PlayerNumber] < (VasRInfo.VasbowSkill))
				SavePlayerbowSkill[PlayerNumber] = VasRInfo.VasbowSkill;
			SaveMurderCount[PlayerNumber] = VasRInfo.MurderCount;
			SavePlayerToString(PlayerNumber);
			if(Massage)
				SavePlayer.ClientMessage("{VasExperience} Your player has been saved on the server",'Subtitle');
			return true;
		}
	 if(Massage){
		SavePlayer.ClientMessage("{VasExperience} Your player was not saved",'Subtitle');}
	return false;
	}
	return false;
}

function VasGetplayerStats(pawn Player, int  PlayerNumber){
local string PlayerName;
local int tempint,REPLINFONumber;
local VasEXPReplicationInfo VasRInfo;

VasDebug(" VasGetplayerStats Started Player="$Player$" PlayerNumber="$PlayerNumber, 2);

	REPLINFONumber = GetREPLINFONumber(Player);
	PlayerName = caps(Player.PlayerReplicationInfo.PlayerName);
	VasRInfo = REPLINFO[REPLINFONumber] ;

	if(VasRInfo != none){
	if(caps(pawn(VasRInfo.owner).PlayerReplicationInfo.PlayerName) != caps(PlayerName))
	return;

	VasRInfo.VasSavePlayerNumber = PlayerNumber;

	if(SaveplayerExperiencePoints[PlayerNumber] > VasRInfo.Exp)
		VasRInfo.Exp = SaveplayerExperiencePoints[PlayerNumber];

	if(VasRInfo.Exp == 0)
		VasRInfo.Exp = 1;

	if(VasRInfo.StartExperiencePoints == 0 )
		VasRInfo.StartExperiencePoints = SaveplayerExperiencePoints[PlayerNumber];
	VasRInfo.PLevel = SavePlayerLevel[PlayerNumber];
	if(SaveSTR[PlayerNumber] > VasRInfo.vasSTR)
		VasRInfo.vasSTR = SaveSTR[PlayerNumber];
	if(SaveINT[PlayerNumber] > VasRInfo.vasINT)
		VasRInfo.vasINT = SaveINT[PlayerNumber];
	if(SaveDEX[PlayerNumber] > VasRInfo.vasDEX)
		VasRInfo.vasDEX = SaveDEX[PlayerNumber];
	if(SavePlayerMagicSkill[PlayerNumber] > VasRInfo.VasMagicSkill)
		VasRInfo.VasMagicSkill = SavePlayerMagicSkill[PlayerNumber];
	if(SavePlayerSwordSkill[PlayerNumber] > VasRInfo.VasSwordSkill)
		VasRInfo.VasSwordSkill = SavePlayerSwordSkill[PlayerNumber];
	if(SavePlayeraxeSkill[PlayerNumber] > VasRInfo.VasaxeSkill)
		VasRInfo.VasaxeSkill = SavePlayeraxeSkill[PlayerNumber];
	if(SavePlayermaceSkill[PlayerNumber] > VasRInfo.VasmaceSkill)
		VasRInfo.VasmaceSkill = SavePlayermaceSkill[PlayerNumber];
	if(SavePlayermaceSkill[PlayerNumber] > VasRInfo.VasmaceSkill)
		VasRInfo.VasmaceSkill = SavePlayermaceSkill[PlayerNumber];
	if(SavePlayerbowSkill[PlayerNumber] > VasRInfo.VasbowSkill)
		VasRInfo.VasbowSkill = SavePlayerbowSkill[PlayerNumber];
	VasRInfo.MurderCount = SaveMurderCount[PlayerNumber];

	if((caps(VasRInfo.VasSavePlayerpassword) == caps(Savepassword[PlayerNumber])) || (Savepassword[PlayerNumber] == "") || (Caps(Savepassword[PlayerNumber]) == "PW-NONE")){
		playerloaded[PlayerNumber] = 1;
		VasRInfo.PWGOOD = true;
	}
	else{
		VasRInfo.PWGOOD = false;
		Player.ScaleGlow = 0.002;
	}
	}
}

function Mutate(string MutateString, PlayerPawn Sender){
local int tempint,REPLINFONumber;
local VasEXPReplicationInfo VasRInfo;
Local int PlayerNumber;
local Runeplayer Player;

VasDebug(" Mutate Started Sender="$Sender$" MutateString="$MutateString,2);

	REPLINFONumber = GetREPLINFONumber(Sender);
	VasRInfo = REPLINFO[REPLINFONumber] ;
	PlayerNumber = getplayerID(Sender);

if(Caps(left(MutateString,3)) == "PW-"){
	if((caps(Savepassword[PlayerNumber]) == caps(MutateString)) || (Savepassword[PlayerNumber] == "") || (Caps(Savepassword[PlayerNumber]) == caps("PW-NONE")) || (Playerloaded[PlayerNumber] == 1)){
		VasRInfo.VasSavePlayerpassword = caps(MutateString);
		Savepassword[PlayerNumber] = caps(MutateString);
		VasRInfo.PWGOOD = True;
		Sender.ScaleGlow = Sender.Default.ScaleGlow;
		PlayerNumber = getplayerID(Sender);
		VasGetplayerStats(Sender, PlayerNumber);
	}
	else{
		VasDebug(" Mutate Password not entered! Sender="$Sender,1);
		sender.ClientMessage("Enter currect password to load this player", 'Subtitle');
		sender.ClientMessage("Enter currect password to load this player");
	}
}

	if(playerloaded[PlayerNumber] == 0){
		Sender.ClientMessage("Need to Enter Password First!",'subtitle');
		Sender.ClientMessage("Need to Enter Password First!");
		return;
	}

	if(Caps(MutateString) == "ATTACKOTHERS"){
		if(VasRInfo.attackotherscounter == 0)
			SetAttackothers(VasRInfo);
		else
			Sender.ClientMessage("Can Not Change Attackothers until timer is out!", 'Subtitle');
	}

	if(Caps(MutateString) == "NOPVP"){
		if(TurnOnNOPVP){
			if(!VasRInfo.NOPVP)
				VasRInfo.NOPVP = true;
			else
				Sender.ClientMessage("Once Player v Player is set it can not be changed again until next map!", 'Subtitle');
		}
		else
			Sender.ClientMessage("NOPVP is not turned on - See the admin!", 'Subtitle');
	}

	if(Caps(MutateString) == "CLEANUP"){
		if(sender.bAdmin){
			sender.ClientMessage("Cleanup Started");
			VasEXPCleanUp();
		}
	}

Super.Mutate(MutateString, Sender);
}

Function SetAttackothers(VasEXPReplicationInfo VasRInfo){
local bool temp;

VasDebug(" SetAttackothers Started VasRInfo="$VasRInfo,2);

temp = VasRInfo.attackothers;
	if(temp){
		VasRInfo.attackothers = false;
		VasRInfo.attackotherscounter = attackotherscounter;
	}
	else{
		VasRInfo.attackothers = true;
		VasRInfo.attackotherscounter = attackotherscounter;
	}
}

function VasEXPCleanUp(){
local int i;
local int t;

CleanupTimer = 0;
t = 1;

	for(i=1; i<=1000; i++){
		if(SaveplayerLevel[i] > Cleanuplevel){
			VasDebug("VasEXPCleanUp tSavePlayer="$SavePlayerName[i],3);
			tSavePlayerName[t] = SavePlayerName[i];
			tSavePassword[t] = SavePassword[i];
			tSaveplayerExperiencePoints[t] = SaveplayerExperiencePoints[i];
			tSavePlayerMagicSkill[t] = SavePlayerMagicSkill[i];
			tSavePlayerSwordSkill[t] = SavePlayerSwordSkill[i];
			tSavePlayeraxeSkill[t] = SavePlayeraxeSkill[i];
			tSavePlayermaceSkill[t] = SavePlayermaceSkill[i];
			tSavePlayerbowSkill[t] = SavePlayerbowSkill[i];
			tSaveMurderCount[t] = SaveMurderCount[i];
			tSaveplayerlevel[t] = Saveplayerlevel[i];
			tSaveSTR[t] = SaveSTR[i];
			tSaveINT[t] = SaveINT[i];
			tSaveDEX[t] = SaveDEX[i];
			t +=1;
		}
		else
			if(SavePlayerName[i] != "" )
				VasDebug("VasEXPCleanUp Player Removed "$SavePlayerName[i],1);
	}

	for(i=1;i<=1000; i++){
		if(tSavePlayerName[i] == ""){
			VasDebug("VasEXPCleanUp Cleanup Save Number "$i,3);
			tSavePlayerName[i] = "";
			tSavePassword[i] = "PW-NONE";
			tSaveplayerExperiencePoints[i] = 0;
			tSavePlayerMagicSkill[i] = 0;
			tSavePlayerSwordSkill[i] = 0;
			tSavePlayeraxeSkill[i] = 0;
			tSavePlayermaceSkill[i] = 0;
			tSavePlayerbowSkill[i] = 0;
			tSaveMurderCount[i] = 0;
			tSaveplayerlevel[i] = 0;
			tSaveSTR[i] = 0;
			tSaveINT[i] = 0;
			tSaveDEX[i] = 0;
		}
	}
	t = 0;
	for(i=1; i<=1000; i++){
		SavePlayerName[i] = tSavePlayerName[t];
		SavePassword[i] = tSavePassword[t];
		SaveplayerExperiencePoints[i] = tSaveplayerExperiencePoints[t];
		SavePlayerMagicSkill[i] = tSavePlayerMagicSkill[t];
		SavePlayerSwordSkill[i] = tSavePlayerSwordSkill[t];
		SavePlayeraxeSkill[i] = tSavePlayeraxeSkill[t];
		SavePlayermaceSkill[i] = tSavePlayermaceSkill[t];
		SavePlayerbowSkill[i] = tSavePlayerbowSkill[t];
		SaveMurderCount[i] = tSaveMurderCount[t];
		Saveplayerlevel[i] = tSaveplayerlevel[t];
		SaveSTR[i] = tSaveSTR[t];
		SaveINT[i] = tSaveINT[t];
		SaveDEX[i] = tSaveDEX[t];
		t +=1;
		SavePlayerToString(i);
		VasDebug("VasEXPCleanUp SavePlayer="$SavePlayerName[i],3);
	}
SortEXP();
getallplayers();
saveconfig();
broadcastmessage("VasExperience Auto CleanUp completed. All saved players <= level "$Cleanuplevel$" where removed.");
VasDebug("VasExperience Auto CleanUp completed. All saved players <= level "$Cleanuplevel$" where removed.",1);
}

function SortEXP(){
	  local int i,j,Max;
	  local string TempSaveplayer;

	  for(i=1; i<=1000; i++)  {
	  VasDebug("SortEXP * #="$i,3);

			 Max = i;
			 for(j=i+1; j<1000; j++){
				if(SaveplayerExperiencePoints[j] > SaveplayerExperiencePoints[Max]){
					VasDebug("SortEXP *** #="$j$" "$SaveplayerExperiencePoints[j]$" > #="$max$" "$SaveplayerExperiencePoints[Max],3);
					Max=j;
				}
			}

			VasDebug("SortEXP *****  "$i$" changed with "$max,3);
			TempSaveplayer = Saveplayer[Max];
			Saveplayer[Max] = Saveplayer[i];
			Saveplayer[i] = TempSaveplayer;
			getplayerinfo(i);
			getplayerinfo(Max);
	  }
}

function VasDebug(String Text, int level){
Local String text1,test2;

	if(VasDebuglevel > 0){
		if( level <= VasDebuglevel){
			if(level == 1)
				text1 = "* VasDebug L1 * ";
			if(level == 2)
				text1 = "** VasDebug L2 ** ";
			if(level == 3)
				text1 = "*** VasDebug L3 *** ";
			Log(text1$" "$Class.name$" - "$Text);
		}
	}
}

defaultproperties{
	  StatAdjust=10
	  AttackothersDefault=True
	  skillAdjust=20
	  Cleanuplevel=1
	  CleanupTimer=1
	  CleanupTime=1
	  attackotherscounter=30
	  Saveplayer(1)="VASEXPV1.03@1#BREAKINBENNY@2#1317@3#2@4#0@5#PW-THIS@6#120@7#120@8#120@9#120@10#120@11#120@12#120@13#120@14#"
	  timerInterval=60.000000
}
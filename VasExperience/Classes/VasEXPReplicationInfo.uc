//-----------------------------------------------------------
//	VasExperience -  By Kal-Corp, Kal-Corp@cfl.rr.com
//	http://Vasserver.dyndns.org/KalsForums
//-----------------------------------------------------------
class VasEXPReplicationInfo expands ReplicationInfo;

Var int EXP;
Var int VasSTR;
Var int VasINT;
Var int VasDEX;
Var int VasMagicSkill,VasAxeSkill,VasmaceSkill,VasSwordSkill,Vasmagic,VasBowSkill,PLevel;
Var bool bNewBie;
Var int Murdercount;
Var bool Murderer;
Var bool Criminal;
Var int Criminalcounter;
var int VasRunePowerBonus;
var int PointsForNextLevel, PointsForthisLevel;
var int newExperiencePoints;
var int StartExperiencePoints;
Var int VasSTRbonus;
Var int VasINTbonus;
Var int VasDEXbonus;
Var bool VasSTRLocked;
Var bool VasINTLocked;
Var bool VasDEXLocked;
Var bool VasMagicSkillLocked;
Var bool VasSwordSkillLocked;
Var bool VasAxeSkillLocked;
Var bool VasMaceSkillLocked;
Var bool VasbowSkillLocked;
Var int VasCurrentSpellLevel;
Var String Title;
Var int skillAdjust,StatAdjust;
VAR VasExperienceINFO veinfo;
var int VasSavePlayerNumber;
var string VasSavePlayerpassword;
var bool PWGOOD;
var int TotalServerSaves;
Var bool attackothers;
Var int attackotherscounter;
Var string Playername;
var bool StopVasEXP;
var bool NOPVP;
var int tempmagic;

replication{
reliable if(Role == ROLE_Authority)
	EXP,VasSTR,VasINT,VasDEX,NOPVP,
	VasMagicSkill,VasAxeSkill,VasmaceSkill,VasSwordSkill,VasBowSkill,
	Vasmagic,PLevel,bNewBie,Title,skillAdjust,StatAdjust,VasSavePlayerNumber,VasSavePlayerpassword,
	TotalServerSaves,attackothers,attackotherscounter,PWGOOD,Playername,StopVasEXP;
}

function PostBeginPlay(){
	VasCurrentSpellLevel = RandRange(20,100);
	SetTimer(1.0, true);
}

Function GETVasExperienceINFO(Pawn Other){
local Pawn P;
local VasExperienceINFO VasExperienceINFO;
	 foreach AllActors(class'VasExperienceINFO', VasExperienceINFO){
		if(VasExperienceINFO.owner == Other){
			veinfo = VasExperienceINFO;
			return;
		}
	}
}

function Timer(){
local PlayerReplicationInfo PRI;
local int TotalVasMagic;

	if(attackothers)
		pawn(owner).ScaleGlow = pawn(owner).default.ScaleGlow;
	else
		pawn(owner).ScaleGlow = 2;

	if(owner == none){
		Log ("************** VasEXPReplicationInfo "$self$"  - NO Owner - Destroy  ");
		self.destroy();
	}

	if(pawn(owner).PlayerReplicationInfo != none){
		if(CAPS(PlayerName) != caps(pawn(owner).PlayerReplicationInfo.PlayerName)){
			pawn(owner).clientmessage("You can not change name in game! - You must now exit and come back!");
			pawn(owner).clientmessage("You can not change name in game! - You must now exit and come back!",'Subtitle');
			StopVasEXP = true;
		}
	}

	if(attackotherscounter > 0)
		attackotherscounter -=1;

	if(Pawn(owner) != none){
		PRI = pawn(owner).PlayerReplicationInfo;
		if(PRI.bIsABot){
			PRI.bIsABot = False;
			MagicSkillUP();
		}

getskilltitle();

// ********************* DEX
if(VasDEX >120)
	VasDEX = 120;
if(VasDEX <10)
	VasDEX =10;

newExperiencePoints = EXP - StartExperiencePoints;
PointsForthisLevel = ((350*PLevel-2)*((PLevel-2)+(PLevel-2)));
PointsForNextLevel = ((350*PLevel)*(PLevel+PLevel));
if(EXP <= PointsForthisLevel)
	PLevel -= 1;
if(EXP >= PointsForNextLevel)
	PLevel += 1;
if(PLevel < 1)
	PLevel = 1;

	if(PLevel < 4)
		bNewBie = true;
	else
		bNewBie = false;

	if(VasMagicSkill > 120)
		VasMagicSkill = 120;
	if(VasSwordSkill > 120)
		VasSwordSkill = 120;
	if(VasAxeSkill > 120)
		VasAxeSkill = 120;
	if(VasMaceSkill > 120)
		VasMaceSkill = 120;
	if(VasbowSkill > 120)
		VasbowSkill = 120;

// ********************* STR
if(VasSTR >120)
	VasSTR =120;
if(VasSTR <30)
	VasSTR =30;
	if(VasStr >= VasINT){
		pawn(owner).MaxHealth=(VasSTR*3);
		if(pawn(owner).MaxHealth >250)
			pawn(owner).MaxHealth = 250;
		if(pawn(owner).MaxHealth <75)
		pawn(owner).MaxHealth = 75;
}
	if(VasStr < 26)
		pawn(owner).DamageScaling=0.600000;
	if((VasStr > 25) && (VasSTR < 51))
		pawn(owner).DamageScaling=0.700000;
	if((VasStr > 50) && (VasSTR < 76))
		pawn(owner).DamageScaling=0.900000;
	if((VasStr > 75) && (VasSTR < 91) || (bNewBie))
		pawn(owner).DamageScaling=1.00000;
	if(VasStr > 90)
		pawn(owner).DamageScaling=1.250000;
	if(VasStr == 100)
		pawn(owner).DamageScaling=1.500000;
	if(VasStr > 109)
		pawn(owner).DamageScaling=1.600000;
	if(VasStr > 119)
		pawn(owner).DamageScaling=1.700000;

// ********************* INT
if(VasINT >120)
	VasINT = 120;
if(VasINT <10)
	VasINT = 10;
pawn(owner).MaxPower=((VasINT)*2);
if(pawn(owner).MaxPower >250)
	pawn(owner).MaxPower = 250;
if(pawn(owner).MaxPower <27)
	pawn(owner).MaxPower = 25;

if(VasINT >= VasSTR){
	pawn(owner).MaxHealth=(VasINT*3);
		if(pawn(owner).MaxHealth > 250)
			pawn(owner).MaxHealth = 250;
		if(pawn(owner).MaxHealth < 75)
			pawn(owner).MaxHealth = 75;
}

if(VasMagicskill < 1)
	VasMagicskill = 0;
if(VasAXEskill < 1)
	VasAXEskill = 0;
if(Vasswordskill < 1)
	Vasswordskill = 0;
if(Vasmaceskill < 1)
	Vasmaceskill = 0;
if(Vasbowskill < 1)
	Vasbowskill = 0;

Vasmagic = ((VasINT+VasMagicskill)/2);
TotalVasMagic = Vasmagic + (PLevel/10);

tempmagic = VasMagic-120;
	if(tempmagic < 0)
		tempmagic = 0;

	VasRunePowerBonus = (VasMagic/10)+(tempmagic);
	if(VasRunePowerBonus < 4)
		VasRunePowerBonus = 4;

	pawn(owner).RunePower+=VasRunePowerBonus;
	PRI = pawn(owner).PlayerReplicationInfo;
	PRI.OldName = string(TotalVasMagic);
}

	if(pawn(owner).health < pawn(owner).maxhealth)
		pawn(owner).health += 2;
}

Function MagicSkillUP(){
Local int randomNumber;

if((Rand(100) <=50) && (!bNewBie))
	Return;

	INTUP(RandRange(20,100));
	RandomNumber = rand(VasmagicSkill*skillAdjust);

	if(RandomNumber <=(RandRange(20,100))){
		if(!VasMagicSkillLocked)
			VasmagicSkill += 1;
	}
}

Function SwordSkillUP(int Swordlevel){
Local int randomNumber;

if((Rand(100) <=50) && (!bNewBie))
	Return;

	STRUP(Swordlevel);
	if(Rand(100) <=20)
		DEXUP(Swordlevel);

	RandomNumber = rand(VasSwordSkill*7);

	if(RandomNumber <=(Swordlevel*skillAdjust)){
		if(!VasSwordSkillLocked)
			VasSwordSkill += 1;
	}
}

Function axeSkillUP(int axelevel){
Local int randomNumber;

if((Rand(100) <=50) && (!bNewBie))
	Return;

STRUP(axelevel);

	if(Rand(100) <=20)
		DEXUP(axelevel);

	RandomNumber = rand(VasaxeSkill*skillAdjust);

	if(RandomNumber <=(axelevel*10)){
		if(!VasaxeSkillLocked)
			VasaxeSkill += 1;
	}
}

Function maceSkillUP(int macelevel){
Local int randomNumber;

if((Rand(100) <=50) && (!bNewBie))
	Return;

STRUP(macelevel);
	if(Rand(100) <=20)
		DEXUP(macelevel);

	RandomNumber = rand(VasmaceSkill*skillAdjust);

	if(RandomNumber <=(macelevel*10)){
		if(!VasmaceSkillLocked)
			VasmaceSkill += 1;
	}
}

Function BowSkillUP(int Bowlevel)
{
Local int randomNumber;

if((Rand(100) <=50) && (!bNewBie))
	Return;

	if(Rand(100) <=20)
		DEXUP(bowlevel);

	RandomNumber = rand(VasbowSkill*skillAdjust);

	if(RandomNumber <=(bowlevel*10)){
		if(!VasbowSkillLocked)
			VasbowSkill += 1;
	}
}

Function STRUP(int WeaponLevel){
Local int randomNumber;

if((Rand(100) <=50) && (!bNewBie))
	Return;

	RandomNumber = rand(VasSTR*StatAdjust);

	if(RandomNumber <=(WeaponLevel*10)){
		if(!VasSTRLocked)
			VasSTR += 1;
	}
}

Function DEXUP(int Level){
Local int randomNumber;

if((Rand(100) <=50) && (!bNewBie))
	Return;

	RandomNumber = rand(VasDEX*StatAdjust);

	if(RandomNumber <=(Level*10)){
		if(!VasDEXLocked)
			VasDEX+=1;
	}
}

Function INTUP(int MagicLevel){
Local int randomNumber;

if((Rand(100) <=50) && (!bNewBie))
	Return;

RandomNumber = rand(VasINT*StatAdjust);

	if(RandomNumber <=(RandRange(20,100))){
		if(!VasINTLocked)
			VasINT += 1;
	}
}

simulated function string gettitle(int skill){
local string temp;
	if((skill > 19) && (skill < 40))
		temp = "Apprentice ";
	if((skill > 39) && (skill < 60))
		temp = "Journeymen ";
	if((skill > 59) && (skill < 80))
		temp = "Expert " ;
	if((skill > 79) && (skill < 90))
		temp = "Adept " ;
	if((skill > 89) && (skill < 100))
		temp = "Master ";
	if(skill >= 100)
		temp = "Grand Master ";
	if(skill > 119)
		temp = "Lord Grand Master ";
	else
		temp = "Novice ";
return temp;
}

simulated function getskilltitle(){
local string temp;

	if(PWGOOD)
		Title = "Checking title...";
		if((VasAxeSkill > Vasmagicskill) && (VasAxeSkill > VasSwordSkill) && (VasAxeSkill > VasbowSkill)  && (VasAxeSkill > VasMaceSkill)){
			Temp = "Axe Fighter";
			if(VasAxeSkill > 99)
				Temp = "Axe Knight";
			if((Vasswordskill > 49) || (Vasaxeskill > 49) || (Vasmaceskill > 49) || (VasBowskill > 49))
				Temp = "Battle "$Temp;
			if((Vasswordskill > 49) && (Vasaxeskill > 49) && (Vasmaceskill > 49) && (VasBowskill > 49))
				Temp = "ArchBattle "$Temp;
			if(VasAxeSkill > 79)
				Temp = "Axe Warrior";
			Title = gettitle(VasAXEskill)$Temp;
		}
		if((VasmaceSkill > Vasmagicskill) && (VasmaceSkill > VasSwordSkill) && (VasmaceSkill > VasbowSkill)&& (VasmaceSkill > VasaxeSkill)){
			Temp = "Mace Fighter";
			if(VasMaceSkill > 99)
				Temp = "Mace Knight";
			if((Vasswordskill > 49) || (Vasaxeskill > 49) || (Vasmaceskill > 49) || (VasBowskill > 49))
				Temp = "Battle "$Temp;
			if((Vasswordskill > 49) && (Vasaxeskill > 49) && (Vasmaceskill > 49) && (VasBowskill > 49))
				Temp = "ArchBattle "$Temp;
			if(VasMaceSkill > 79)
				Temp = "Mace Warrior";
			Title = gettitle(VasMaceSkill)$Temp;
		}
		if((VasswordSkill > Vasmagicskill) && (VasswordSkill > Vasaxeskill) && (VasswordSkill > Vasbowskill)&& (VasswordSkill > VasmaceSkill)){
			Temp = "Sword Fighter";
			if(VasswordSkill > 99)
				Temp = "Sword Knight";
			if((Vasswordskill > 49) || (Vasaxeskill > 49) || (Vasmaceskill > 49) || (VasBowskill > 49))
				Temp = "Battle "$Temp;
			if((Vasswordskill > 49) && (Vasaxeskill > 49) && (Vasmaceskill > 49) && (VasBowskill > 49))
				Temp = "ArchBattle "$Temp;
			if(VasswordSkill > 79)
				Temp = "Sword Warrior";
			Title = gettitle(VasswordSkill)$Temp;
		}
		if((VasbowSkill > Vasmagicskill) && (VasbowSkill > Vasaxeskill) && (VasbowSkill > Vasswordskill)&& (VasswordSkill > VasmaceSkill)){
			Temp = "Bow Fighter";
			if(VasbowSkill > 99)
				Temp = "Bow Knight";
			if((Vasswordskill > 49) || (Vasaxeskill > 49) || (Vasmaceskill > 49) || (VasBowskill > 49))
				Temp = "Battle "$Temp;
			if((Vasswordskill > 49) && (Vasaxeskill > 49) && (Vasmaceskill > 49) && (VasBowskill > 49))
				Temp = "ArchBattle "$Temp;
			if(VasbowSkill > 79)
				Temp = "Bow Warrior";
			Title = gettitle(VasbowSkill)$Temp;
		}
		if((VasmagicSkill > Vasswordskill) && (VasmagicSkill > Vasaxeskill) && (VasmagicSkill > Vasbowskill)&& (VasmagicSkill > VasmaceSkill)){
			Temp = "Mage";
			if(VasmagicSkill > 99)
				Temp = "Warlock";
			if((Vasswordskill > 49) || (Vasaxeskill > 49) || (Vasmaceskill > 49) || (VasBowskill > 49))
				Temp = "Battle "$Temp;
			if((Vasswordskill > 49) && (Vasaxeskill > 49) && (Vasmaceskill > 49) && (VasBowskill > 49))
				Temp = "ArchBattle "$Temp;
			if(VasmagicSkill > 79)
				Temp = "Wizard";
			Title = gettitle(VasmagicSkill)$Temp;
		}
	else
		Title = "Call the VasGods! - I did not enter the correct password!";
	return;
}

defaultproperties{
	skillAdjust=20
	StatAdjust=20
	Attackothers=True
}
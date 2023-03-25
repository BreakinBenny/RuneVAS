//-----------------------------------------------------------
//  VasExperience -  By Kal-Corp	Kal-Corp@cfl.rr.com
//	http://Vasserver.dyndns.org/KalsForums
//-----------------------------------------------------------
class VasExperienceINFO expands Mutator;

var color GreenColor,WhiteColor,LightCyanColor,BlueColor,RedColor;
var bool init;
Var int Vastime;
Var Bool bInitialized;
Var int EXP;
Var bool foundREPL;
Var VasEXPReplicationInfo REPLINFO, REPLINFO2[16];
var int PLevel;
Var String title;
Var int VasSTR,VasINT,VasDEX,VasMagicSkill,VasAxeSkill,VasmaceSkill,VasSwordSkill,vasbowskill;
var int PointsForNextLevel;
var String playerTitles[50];
Var int TitleCounter;
Var int SaveCounter;
var string Saveplayer[100];
var int SaveSTR;
var int SaveINT;
var int SaveDEX;
var int SaveplayerExperiencePoints;
var int SavePlayerMagicSkill;
var int SavePlayerSwordSkill;
var int SavePlayeraxeSkill;
var int SavePlayermaceSkill;
var int SavePlayerbowSkill;
var int totalsavedplayers;
var string SavePlayerName;
var int VasSavePlayerNumber;
var string VasSavePlayerpassword;
var int TotalServerSaves,attackotherscounter;
Var bool LoadPlayer;
var bool attackothers;
var bool StopVasEXP;
Var bool PWGOOD;
Var Bool NOPVP;

simulated function Tick(float DeltaTime){
Super.Tick(DeltaTime);
if((!init) && (Level.NetMode != NM_DedicatedServer)){
	Vastime +=1;
	if(Vastime > 9){
		Vastime = 0;
		RegisterHUDMutator();
	}
}
}

simulated Function VasEXPReplicationInfo GetVasEXPReplicationInfo(pawn pawn){
local VasEXPReplicationInfo VasRInfo, temp;
local int I;

for(i=0; i<ArrayCount(REPLINFO2); i++)
	REPLINFO2[i] = None;
temp = none;
i=0;
foreach AllActors(class'VasEXPReplicationInfo', VasRInfo){
	REPLINFO2[i] = VasRInfo;
	i +=1;
	if(VasRInfo.owner == pawn)
		temp = VasRInfo;
}
return temp;
}

simulated function RegisterHUDMutator(){
local HUD MyHud;
local Pawn P;
local playerpawn playerpawn;

	if(Level.NetMode == NM_DedicatedServer)
	return;
        
log ("************************ RegisterHUDMutator started");

	SetTimer(1.000000,true);
	if(!init){
		foreach AllActors(class'HUD', MyHud){
			init = true;
			If(MyHud.owner != none){
				If(MyHud.owner == owner){
					NextHUDMutator = MyHud.HUDMutator;
					MyHud.HUDMutator = Self;
					bHUDMutator = True;
				}
				else{
					init = true;
					return;
				}
			}
			else{
				init = true;
				return;
			}
		}
	}
}

simulated event PostRender(canvas Canvas){
VasExpInfo(canvas);
RenderNames(Canvas);
if(nextHUDMutator != None)
	nextHUDMutator.PostRender(Canvas);
}

simulated function VasExpInfo(Canvas canvas){
local int i;
local float XL, YL;
local float ypos, xpos;
local playerpawn player;
local string temp1;
local string PName,PName2;

PName = caps(pawn(Owner).PlayerReplicationInfo.PlayerName);
player = playerpawn(Owner);
Canvas.DrawColor = Whitecolor;
Canvas.bCenter = false;
Canvas.Font = Canvas.SmallFont;
Canvas.StrLen("TEST", XL, YL);
ypos = Canvas.ClipY - YL*2;
xpos = 90;

PName2  = caps(Left (PName, 6));

	if(PName2 == "APLYER"){
		Canvas.DrawColor = Redcolor;
		Canvas.Font = Canvas.LargeFont;
		Canvas.SetPos(0,Canvas.ClipY-500);
		Canvas.bCenter = True;
		canvas.drawText("Your Player Name is Missing");
		canvas.Font = Canvas.MedFont;
		Canvas.DrawColor = whiteColor;
		canvas.drawText("You are in game as -"$PName$"- Need to Exit and come back to reset name");
		canvas.drawText("Might need to wait for your player to time out before you get in");
		Canvas.bCenter = False;
		pawn(owner).gotostate('Scripting');
		pawn(owner).groundspeed= 0;
		pawn(owner).style = STY_Translucent;
		return;
	}

	if(StopVasEXP){
	Canvas.DrawColor = Redcolor;
	Canvas.Font = Canvas.LargeFont;
	Canvas.SetPos(0,Canvas.ClipY-500);
	Canvas.bCenter = True;
	canvas.drawText("Name Change Detected");
	Canvas.Font = Canvas.MedFont;
	Canvas.DrawColor = whiteColor;
	canvas.drawText("You must now exit the server and come back to Play");
	canvas.drawText("Remember That you name was now changed in RUNE. Please set it correctly first");
	Canvas.bCenter = False;
	pawn(owner).gotostate('Scripting');
	pawn(owner).groundspeed= 0;
	pawn(owner).style = STY_Translucent;
	return;
	}

if(!PWGOOD){
	Canvas.DrawColor = Redcolor;
	Canvas.Font = Canvas.LargeFont;
	Canvas.SetPos(0,Canvas.ClipY-500);
	Canvas.bCenter = True;
	canvas.drawText("Enter a password for this playername!");
	Canvas.Font = Canvas.MedFont;
	Canvas.DrawColor = whiteColor;
	if((VasSavePlayerpassword == "") || (caps(VasSavePlayerPassword) == "PW-NONE"))
		canvas.drawText("This player name "$PName$" doesn't have a password set!");
	else
		canvas.drawText("This player name "$PName$" has a password set");
	canvas.drawText("In Console Type Mutate PW-XXXX, where XXX is password. Set to PW-NONE to Remove");
	Canvas.bCenter = False;
	return;
}
else{
	canvas.setpos(xpos, ypos);
	canvas.drawText("Your Rank #: "$VasSavePlayerNumber$" of "$TotalServerSaves);
	ypos -= yl;

	Canvas.DrawColor = GreenColor;
	canvas.setpos(xpos, ypos);
	canvas.drawText("Password: "$VasSavePlayerpassword);
	ypos -= yl;
	Canvas.DrawColor = whiteColor;

if(attackotherscounter > 0){
	canvas.setpos(xpos, ypos);
	canvas.drawText("AttackOthers change cooldown: "$attackotherscounter);
	ypos -= yl;
}

if(attackothers)
	Canvas.DrawColor = REDColor;
canvas.setpos(xpos, ypos);
if(NOPVP)
	canvas.drawText("NO PVP Damage: "$NOPVP);
else
	canvas.drawText("PVP Damage: "$attackothers);
ypos -= yl;

	Canvas.DrawColor = GreenColor;
	canvas.setpos(xpos, ypos);
	Canvas.DrawText("Misc: ");
	ypos -= yl;
	Canvas.DrawColor = whiteColor;

	canvas.setpos(xpos, ypos);
	canvas.drawText("CrossBow: "$VasbowSkill);
	ypos -= yl;

	canvas.setpos(xpos, ypos);
	canvas.drawText("Mace: "$VasMaceSkill);
	ypos -= yl;

	canvas.setpos(xpos, ypos);
	canvas.drawText("Axe: "$VasAxeSkill);
	ypos -= yl;

	canvas.setpos(xpos, ypos);
	canvas.drawText("Sword: "$VasSwordSkill);
	ypos -= yl;

	canvas.setpos(xpos, ypos);
	canvas.drawText("Magic: "$VasmagicSkill);
	ypos -= yl;

	Canvas.DrawColor = GreenColor;
	canvas.setpos(xpos, ypos);
	Canvas.DrawText("Skills: "$(VasMagicSkill+VasAxeSkill+VasmaceSkill+VasSwordSkill)$" / 480");
	ypos -= yl;

	Canvas.DrawColor = whiteColor;
	canvas.setpos(xpos, ypos);
	Canvas.DrawText("DEX="$vasdex);
	Canvas.DrawText(temp1);
	ypos -= yl;

	Canvas.DrawColor = whiteColor;
	canvas.setpos(xpos, ypos);
	Canvas.DrawText("INT="$vasint);
	Canvas.DrawText(temp1);
	ypos -= yl;

	Canvas.DrawColor = whiteColor;
	canvas.setpos(xpos, ypos);
	Canvas.DrawText("STR="$vasstr);
	Canvas.DrawText(temp1);
	ypos -= yl;

	Canvas.DrawColor = GreenColor;
	canvas.setpos(xpos, ypos);
	Canvas.DrawText("Stats: "$(vasSTR+vasINT+vasDEX)$" / 360");
	ypos -= yl;
	Canvas.DrawColor = whiteColor;

	canvas.setpos(xpos, ypos);
	canvas.drawText("XP: "$EXP$" / "$PointsForNextLevel);
	ypos -= yl;

	canvas.setpos(xpos, ypos);
	canvas.drawText("level: "$PLevel);
	ypos -= yl;

	canvas.setpos(xpos, ypos);
	Canvas.DrawText("" $PName$": " $title);
	ypos -= yl;
}
}

simulated function string gettitle(int skill){
local string temp;
if((skill > 19) && (skill <40))
	temp = "Apprentice ";
if((skill > 39) && (skill <60))
	temp = "Journeymen ";
if((skill > 59)&& (skill <60))
	temp = "Expert " ;
if((skill > 79) && (skill <90))
	temp = "Adept " ;
if((skill > 89) && (skill <98))
	temp = "Master ";
if(skill > 99)
	temp = "Grand Master ";
if(skill > 119)
	temp = "Lord Grand Master ";
else
	temp = "Novice ";
return temp;
}

simulated function getskilltitle(){
local string temp;

	if(PWGOOD){
		Title = "Checking title...";
		if((VasAxeSkill > 119) && (VasMaceSkill > 119) && (VasSwordSkill > 119) && (VasBowSkill > 119) && (VasMagicSkill > 119))
			Title = "Lord Grand Master of Arms and Magic";
		else if((VasAxeSkill > Vasmagicskill) && (VasAxeSkill > VasSwordSkill) && (VasAxeSkill > VasbowSkill)  && (VasAxeSkill > VasMaceSkill)){
			Temp = "Axe Fighter";
			if(VasAxeSkill > 99)
				Temp = "Axe Knight";
			if((Vasswordskill > 49) || (Vasaxeskill > 49) || (Vasmaceskill > 49) || (VasBowskill > 49))
				Temp = "Battle-"$Temp;
			if((Vasswordskill > 49) && (Vasaxeskill > 49) && (Vasmaceskill > 49) && (VasBowskill > 49))
				Temp = "ArchBattle-"$Temp;
			if(VasAxeSkill > 79)
				Temp = "Axe Warrior";
		Title = gettitle(VasAXEskill)$Temp;
		}
		else if((VasmaceSkill > Vasmagicskill) && (VasmaceSkill > VasSwordSkill) && (VasmaceSkill > VasbowSkill)&& (VasmaceSkill > VasaxeSkill)){
		Temp = "Mace Fighter";
			if(VasMaceSkill > 99)
				Temp = "Mace Knight";
			if((Vasswordskill > 49) || (Vasaxeskill > 49) || (Vasmaceskill > 49) || (VasBowskill > 49))
				Temp = "Battle-"$Temp;
			if((Vasswordskill > 49) && (Vasaxeskill > 49) && (Vasmaceskill > 49) && (VasBowskill > 49))
				Temp = "ArchBattle-"$Temp;
			if(VasMaceSkill > 79)
				Temp = "Mace Warrior";
		Title = gettitle(VasMaceSkill)$Temp;
		}
		else if((VasswordSkill > Vasmagicskill) && (VasswordSkill > Vasaxeskill) && (VasswordSkill > Vasbowskill)&& (VasswordSkill > VasmaceSkill)){
		Temp = "Sword Fighter";
			if( VasswordSkill> 99)
				Temp = "Sword Knight";
			if((Vasswordskill > 49) || (Vasaxeskill > 49) || (Vasmaceskill > 49) || (VasBowskill > 49))
				Temp = "Battle-"$Temp;
			if((Vasswordskill > 49) && (Vasaxeskill > 49) && (Vasmaceskill > 49) && (VasBowskill > 49))
				Temp = "ArchBattle-"$Temp;
			if(VasswordSkill > 79)
				Temp = "Sword Warrior";
		Title = gettitle(VasswordSkill)$Temp;
		}
		else if((VasbowSkill > Vasmagicskill) && (VasbowSkill > Vasaxeskill) && (VasbowSkill > Vasswordskill)&& (VasswordSkill > VasmaceSkill)){
		Temp = "Bow Fighter";
			if( VasbowSkill > 99)
				Temp = "Bow Knight";
			if((Vasswordskill > 49) || (Vasaxeskill > 49) || (Vasmaceskill > 49) || (VasBowskill > 49))
				Temp = "Battle-"$Temp;
			if((Vasswordskill > 49) && (Vasaxeskill > 49) && (Vasmaceskill > 49) && (VasBowskill > 49))
				Temp = "ArchBattle-"$Temp;
			if(VasbowSkill > 79)
				Temp = "Bow Warrior";
		Title = gettitle(VasbowSkill)$Temp;
		}
		else if((VasmagicSkill > Vasswordskill) && (VasmagicSkill > Vasaxeskill) && (VasmagicSkill > Vasbowskill)&& (VasmagicSkill > VasmaceSkill)){
		Temp = "Mage";
			if(VasmagicSkill > 99)
				Temp = "Warlock";
			if((Vasswordskill > 49) || (Vasaxeskill > 49) || (Vasmaceskill > 49) || (VasBowskill > 49))
				Temp = "Battle-"$Temp;
			if((Vasswordskill > 49) && (Vasaxeskill > 49) && (Vasmaceskill > 49) && (VasBowskill > 49))
				Temp = "ArchBattle-"$Temp;
			if(VasmagicSkill > 79)
				Temp = "Wizard";
		Title = gettitle(VasmagicSkill)$Temp;
		}
	}
	else
		Title = "Call the VasGods! - I did not enter the correct password!";
	return;
}

simulated function Timer(){
	if(!foundREPL){
		if(getVasEXPReplicationInfo(pawn(Owner)) != NONE){
			REPLINFO = getVasEXPReplicationInfo(pawn(Owner));
			foundREPL=true;
		}
	}
	else{
	getskilltitle();
	EXP=REPLINFO.EXP;
	VasStr=REPLINFO.VasStr;
	VasINT=REPLINFO.VasINT;
	VasDEX=REPLINFO.VasDEX;
	VasMagicSkill=REPLINFO.VasMagicSkill;
	VasAxeSkill=REPLINFO.VasAxeSkill;
	VasmaceSkill=REPLINFO.VasmaceSkill;
	VasSwordSkill=REPLINFO.VasSwordSkill;
	VasbowSkill=REPLINFO.VasbowSkill;
	VasSavePlayerNumber=REPLINFO.VasSavePlayerNumber;
	VasSavePlayerpassword=caps(REPLINFO.VasSavePlayerpassword);
	TotalServerSaves=REPLINFO.TotalServerSaves;
	plevel=REPLINFO.plevel;
	StopVasEXP=REPLINFO.StopVasEXP;
	attackothers = REPLINFO.attackothers;
	PWGOOD = REPLINFO.PWGOOD;
	NOPVP = REPLINFO.NOPVP;
	attackotherscounter = REPLINFO.attackotherscounter;
	PointsForNextLevel = ((350*PLevel)*(PLevel+PLevel));
	}
	TitleCounter += 1;
	if(TitleCounter > 30){
		TitleCounter = 0;
		getVasEXPReplicationInfo(pawn(owner));
	}
}

simulated function string GetplayerTitle(pawn pawn){
	local int I;
	if(pawn != none){
		for(i=0; i<ArrayCount(REPLINFO2); i++)
		{
			if(REPLINFO2[i] != none){
				if(REPLINFO2[i].Owner == Pawn)
					return REPLINFO2[i].title;
			}
		}
	}
	return "";
}
simulated function bool GetplayerAOinfo(pawn pawn){
local int I;
	if(pawn != none){
		for(i=0; i<ArrayCount(REPLINFO2); i++){
			if(REPLINFO2[i] != none)
				if(REPLINFO2[i].Owner == Pawn)
			Return REPLINFO2[i].attackothers;
		}
	}
return false;
}

simulated function bool GetplayerNOPVP(pawn pawn){
local int I;
	if(pawn != none){
		for(i=0; i<ArrayCount(REPLINFO2); i++){
			if(REPLINFO2[i] != none)
				if(REPLINFO2[i].Owner == Pawn)
			Return REPLINFO2[i].NOPVP;
		}
	}
return false;
}

simulated function RenderNames(canvas Canvas){
local pawn P;
local int SX,SY;
local float scale, dist;
local vector pos;
local string PName;
local int Plevel;
local string PTitle;
local bool opattackothers;
local runeplayer playerCheck;
local pawn temp;
Local VasEXPallyRepl VasEXPallyRepl ;
Local string Ally;

	Canvas.DrawColor = LightCyanColor;

	foreach AllActors(class'pawn', P){
		ally = "";
		foreach AllActors(class'VasEXPallyRepl', VasEXPallyRepl){
			if(VasEXPallyRepl.NewMonster == p){
				ally  =  "Protecting "$VasEXPallyRepl.ally.PlayerReplicationInfo.PlayerName;
				temp = VasEXPallyRepl.Ally;
			}
		}

	pos = P.Location+vect(0,0,1.2)*P.CollisionHeight;
	if(!FastTrace(pos, Canvas.ViewPort.Actor.ViewLocation) || P.IsA('CTTSpectator') || P.Health < 1)
	continue;

	Canvas.TransformPoint(pos, SX, SY);
	if(SX > 0 && SX < Canvas.ClipX && SY > 0 && SY < Canvas.ClipY){
		dist = VSize(P.Location-Canvas.ViewPort.Actor.ViewLocation);
		dist = FClamp(dist, 1, 10000);
		scale = 500.0/dist;
		scale = FClamp(scale, 0.01, 2.0);

	if(P.IsA('playerpawn'))
		PName = caps(P.PlayerReplicationInfo.PlayerName);

	Canvas.SetPos(SX-(32*scale)*0.5, SY-(32*scale));
	if(scale>0.3)
		Canvas.Font = Canvas.MedFont;
	else
	return;

	if(P.IsA('playerpawn')){
		playerCheck=runeplayer(P);
		if(playerCheck.bHidden)
		{continue;}
		PTitle = GetplayerTitle(P);
	}

	Canvas.DrawColor = BlueColor ;
	if(GetplayerAOinfo(p))
		Canvas.DrawColor = redColor;
	if(GetplayerNOPVP(p))
		Canvas.DrawColor = greenColor;

	if(P != Canvas.ViewPort.Actor){
		if(P.IsA('playerpawn'))
			Canvas.DrawText(PName$", "$PTitle);
		if(P.IsA('scriptpawn'))
			if(ally != ""){
				Canvas.DrawColor = BlueColor;
				if(GetplayerAOinfo(temp))
					Canvas.DrawColor = redColor;
				Canvas.DrawText(ally);
				}
			}
		}
	}
}

simulated function int getplayerID(){
Local int PlayerNumber;
local int i;
local string PlayerName, temp;

PlayerName = caps(pawn(owner).PlayerReplicationInfo.PlayerName);

	if(VasSavePlayerNumber < 1){
		for(i=1; i<=ArrayCount(Saveplayer); i++){
 			if((caps(SavePlayerName) == PlayerName) || (SavePlayerName == "") || (caps(SavePlayerName) == "NONE")){
				PlayerNumber=i;
				VasSavePlayerNumber = PlayerNumber;
				SavePlayerName = PlayerName;
				return PlayerNumber;
			}
		}
	}
	else{
		PlayerNumber = VasSavePlayerNumber;
		if(caps(SavePlayerName) != PlayerName){
			for(i=1;i<=ArrayCount(Saveplayer); i++){
				if((caps(SavePlayerName) == PlayerName) || (SavePlayerName == "") || (caps(SavePlayerName) =="NONE")){
					PlayerNumber=i;
					VasSavePlayerNumber = PlayerNumber;
					SavePlayerName = PlayerName;
					return PlayerNumber;
 				}
			}
		}
	}
return PlayerNumber;
}

defaultproperties{
GreenColor=(G=255)
WhiteColor=(R=255,G=255,B=255)
LightCyanColor=(R=128,G=255,B=255)
BlueColor=(B=255)
RedColor=(R=255)
bAlwaysRelevant=True
RemoteRole=ROLE_AutonomousProxy
}
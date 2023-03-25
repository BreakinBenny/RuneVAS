//-----------------------------------------------------------
// VasCast - By Kal-Corp	Kal-Corp@cfl.rr.com
//	http://Vasserver.dyndns.org:88/KalsForums
//-----------------------------------------------------------
class VasCastMutator expands Mutator;

var color LightBlueColor,GrayColor,GreenColor,LightCyanColor, LightGreenColor, RedColor, WhiteColor, bluecolor,GoldColor;
var bool init;
Var int Vastime;
Var bool bVassinfo;
Var Bool spellactive;
var int activetimer;
Var String CurrentSpell;
Var int PointsRequired,CastPercent,Spellnumber;
Var() bool INITKeyBind;
var() float FadeOutTime;

replication
{
reliable if(Role==ROLE_Authority)
	CurrentSpell,PointsRequired,CastPercent,Spellnumber;

//reliable if(Role < ROLE_Authority)
//spellactive;
}

function timer()
{
if(spellactive)
	activetimer += 1;
if(activetimer > 1)
{
	spellactive = false;
	activetimer = 0;
}
}

simulated function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	 if (Other.IsA('Weapon'))
		  Weapon(Other).bCanBePoweredUp = false;
	 return true;
}


simulated function VasInfo( Canvas canvas )
{
local int i,Vasmagic;
local float XL, YL;
local float ypos, xpos;
local playerpawn player;
local string temp1;
local string PName;
local PlayerReplicationInfo PRI;

	PRI = pawn(owner).PlayerReplicationInfo;
	Vasmagic = INT(PRI.OldName);
	if((Vasmagic < 1) || (Vasmagic > 150))
		Vasmagic = 50;

	PName = pawn(Owner).PlayerReplicationInfo.PlayerName;
	player = playerpawn(Owner);
	Canvas.SetPos(0,Canvas.ClipY-50);
	Canvas.DrawColor = Whitecolor;
	Canvas.bCenter = false;
	Canvas.Font = Canvas.SmallFont;
	Canvas.StrLen("TEST", XL, YL);
	ypos = Canvas.ClipY - YL*2;
	xpos = Canvas.ClipX-60;

	if(player.Weapon == None)
	{
		Canvas.DrawColor = whiteColor;
		canvas.setpos(xpos, ypos);
		canvas.DrawTextRightJustify(Vasmagic$": Magic Ability", xpos , ypos);
		ypos -= yl;

		canvas.setpos(xpos, ypos);
		canvas.DrawTextRightJustify(CurrentSpell$" / VasCast "$Spellnumber $ ": Current Spell", xpos , ypos);
		ypos -= yl;

		canvas.setpos(xpos, ypos);
		canvas.DrawTextRightJustify(CastPercent$"%: CastPercent",xpos , ypos);
		ypos -= yl;
	 }
}

simulated function DrawPower(Canvas Canvas, int X, int Y)
{
local int i;
local float XL, YL;
local float ypos, xpos;
local playerpawn player;
local string temp1;
local string PName;
local Texture TexTick,TexEmpty,TexIcon;
local float PixelsPerPowerUnit;
local float curY;

	TexTick = Texture'PowerTick';
	TexEmpty = Texture'SarkRuneEmpty';
	TexIcon = Texture'SarkRuneIcon';

	Y -= TexIcon.VSize;
	curY = Y;
	PName = pawn(Owner).PlayerReplicationInfo.PlayerName;
	player = playerpawn(Owner);
	Canvas.SetPos(0,Canvas.ClipY-50);
	Canvas.DrawColor = Whitecolor;
	Canvas.bCenter = false;
	Canvas.Font = Canvas.SmallFont;
	Canvas.StrLen("TEST", XL, YL);
	ypos = Canvas.ClipY - YL*2;
	xpos = Canvas.ClipX-50;

	if(player.Weapon == None)
	{
		PixelsPerPowerUnit = (TexEmpty.VSize) / 20.0;
		curY = Y;
		curY -= TexIcon.VSize *  2;
		curY -= float(PointsRequired)*PixelsPerPowerUnit;
		curY += 2.0* 1;
		curY -= TexTick.VSize/2;
		Canvas.SetPos(X-20, curY);
		Canvas.DrawIcon(TexTick,  2);
	}
}

simulated function Tick(float DeltaTime)
{
Super.Tick(DeltaTime);
if(!init)
	Vastime +=1;
if(Vastime >= 10)
{
	Vastime =0;
	RegisterHUDMutator();
}
FadeOutTime = FMax(0.0, FadeOutTime - DeltaTime * 55);
}

simulated function PreBeginPlay()
{
CurrentSpell = "NONE";
CastPercent = 0;
PointsRequired = 5;
bVassinfo = true;
FadeOutTime = 1600;
}

function PostBeginPlay()
{
SetTimer(1.000000,true);
Super.PostBeginPlay();
}

simulated function RegisterHUDMutator()
{
local HUD MyHud;
local Pawn P;
local playerpawn playerpawn;

	if(!init)
	{
		foreach AllActors(class'HUD', MyHud) {
			init = true;
			if(MyHud.owner != none)
			{
				if(MyHud.owner == owner)
				{
					NextHUDMutator = MyHud.HUDMutator;
					MyHud.HUDMutator = Self;
					bHUDMutator = True;
				}
				else
				{
					init = true;
					return;
				}
			}
			else
			{
				init = true;
				return;
			}
		}
	}
}

simulated event PostRender( canvas Canvas )
{
	if(bVassinfo)
		Vasinfo(canvas);
	DrawPower(Canvas, Canvas.ClipX - 36, Canvas.ClipY - 4);

	if(!INITKeyBind)
	{
		INITKeyBind= true;
		owner.ConsoleCommand("set input m MUTATE NEXTSPELL");
		owner.ConsoleCommand("set input n MUTATE CASTSPELL");
	}
	if(FadeOutTime > 0.0)
		DrawKeyINFO(Canvas);

	if(nextHUDMutator != None)
		nextHUDMutator.PostRender( Canvas );
}

simulated function DrawKeyINFO(Canvas canvas)
{
	Canvas.DrawColor = GreenColor;
	Canvas.SetPos(0,Canvas.ClipY-100);
	Canvas.bCenter = True;
	Canvas.Font = Canvas.BigFont;
	Canvas.DrawText("VasCastSpells - Hit M to select a spell and N to cast!");
	Canvas.DrawColor = Whitecolor;
	Canvas.bCenter = False;
}

defaultproperties
{
	LightBlueColor=(B=128)
	GrayColor=(R=128,G=128,B=128)
	GreenColor=(G=255)
	LightCyanColor=(R=128,G=255,B=255)
	LightGreenColor=(G=128,B=128)
	RedColor=(R=255)
	WhiteColor=(R=255,G=255,B=255)
	BlueColor=(B=255)
	GoldColor=(R=255,G=255)
	bAlwaysRelevant=True
	RemoteRole=ROLE_SimulatedProxy
}
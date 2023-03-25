//-----------------------------------------------------------
//	VasArena - Kal Corp
//
//
//	Http://VasServer.dyndns.org/Kalsforums
//
//-----------------------------------------------------------
class VasArenaHud expands ArenaHUD;

#exec TEXTURE IMPORT NAME=TexZero FILE=Textures\0.pcx MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT NAME=TexOne FILE=Textures\1.pcx MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT NAME=TexTwo FILE=Textures\2.pcx MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT NAME=TexThree FILE=Textures\3.pcx MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT NAME=TexFour FILE=Textures\4.pcx MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT NAME=TexFive FILE=Textures\5.pcx MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT NAME=TexSix FILE=Textures\6.pcx MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT NAME=TexSeven FILE=Textures\7.pcx MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT NAME=TexEight FILE=Textures\8.pcx MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT NAME=TexNine FILE=Textures\9.pcx MIPS=OFF FLAGS=2

var Texture DisplayNumbers[10];
var float BackgroundFade;
var color lightCyanColor, LightGreenColor, RedColor, WhiteColor, bluecolor;
var ArenaScoreboard ArenaScoreboard;
var PlayerReplicationInfo Ordered[32];
var PlayerReplicationInfo OrderedD[32];
var PlayerReplicationInfo PRI;
var GameReplicationInfo GameReplicationInfo;

simulated function PostRender( canvas Canvas )
{
local PlayerPawn thePlayer;
local PlayerReplicationInfo PRI;
local PlayerReplicationInfo ChampionPRI, ChallengerPRI;
local ArenaGameReplicationInfo ArenaGRI;
local int PlayerCount, I;
local float XL, YL;
local float YOffset, YStart;

	// Sort the PRIs
	for(i=0; i<ArrayCount(Ordered); i++)
		Ordered[i] = None;
	for(i=0; i<32; i++)
	{
		if(PlayerPawn(Owner).GameReplicationInfo.PRIArray[i] != None)
		{
			PRI = PlayerPawn(Owner).GameReplicationInfo.PRIArray[i];
			if( !PRI.bIsSpectator || PRI.bWaitingPlayer )
			{
				Ordered[PlayerCount] = PRI;
				Orderedd[PlayerCount] = PRI;
				PlayerCount++;
				if(PlayerCount == ArrayCount(Ordered))
					break;
			}
		}
	}
	SortScores(PlayerCount);
	Sortdeaths(PlayerCount);

	Super.PostRender(Canvas);

	thePlayer = PlayerPawn(Owner);

	if(thePlayer == None || HudMode == 0 || thePlayer.bShowMenu || thePlayer.bShowScores || Level.Pauser != "" || thePlayer.RendMap == 0)
		return;

	DrawCountdownTimer(Canvas);
	DrawQueueNumbers(Canvas);
	RenderNames(Canvas);

	//Reset
	Canvas.Style = ERenderStyle.STY_Normal;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;

	Canvas.bCenter = false;

	Canvas.Font = Canvas.BigFont;
	Canvas.DrawColor = WhiteColor;
	Canvas.SetPos(50,Canvas.ClipY-50);

	Canvas.DrawText("Title="$Playertitle(PlayerPawn(Owner)));

	Canvas.DrawColor = WhiteColor;
	Canvas.SetPos(0,Canvas.ClipY-50);
	Canvas.bCenter = True;
	Canvas.DrawText("VasArena - Current Champion "$Ordered[0].PlayerName$" / Life Champion "$Orderedd[0].PlayerName);
	Canvas.bCenter = False;
}

simulated function DrawFragCount(canvas Canvas, int x, int y)
{
	local float textwidth, textheight;
	local int score, loses;
	local string text;
	local PlayerPawn PlayerOwner;

	PlayerOwner = PlayerPawn(Owner);

	if(PlayerOwner.PlayerReplicationInfo == None)
		return;

	score = int(PlayerOwner.PlayerReplicationInfo.Score);
	loses = int(PlayerOwner.PlayerReplicationInfo.Deaths);


	text = score$"-"$loses$" ";
	
	if(MyFonts != None)
		Canvas.Font = MyFonts.GetStaticLargeFont();
	else
		Canvas.Font = Canvas.LargeFont;

	Canvas.DrawTextRightJustify(text, X, Y);
}

simulated function DrawCountdownTimer(canvas Canvas)
{
local PlayerPawn PlayerOwner;
local ArenaGameReplicationInfo ArenaRepInfo;
local string strTime;
local float XL, YL;

	PlayerOwner = PlayerPawn(Owner);

	if(PlayerOwner == None || PlayerOwner.GameReplicationInfo==None)
		return;

	if(PlayerOwner.PlayerReplicationInfo.Team == 255)
		return;

	ArenaRepInfo = ArenaGameReplicationInfo(PlayerOwner.GameReplicationInfo);
	if(ArenaRepInfo == None)
		return;

	if(!ArenaRepInfo.bDrawTimer)
		return;

	strTime = TwoDigitString(ArenaRepInfo.curTimer);
	if(ArenaRepInfo.curTimer <= 3)
		Canvas.SetColor(255, 0, 0);
	else
		Canvas.SetColor(255,255,255);
	
	Canvas.StrLen(strTime, XL, YL);
	Canvas.SetPos((Canvas.ClipX * 0.5) - (XL * 0.5), (Canvas.ClipY * 0.3) - (YL * 0.5));
	Canvas.DrawText(strTime, false);

	Canvas.SetColor(255,255,255);
}

simulated function DrawQueueNumbers(canvas Canvas)
{
local RunePlayer P;
local PlayerPawn PlayerOwner;
local int SX,SY;
local float scale, dist;
local Texture Tex;
local vector pos;
local int i, dispNumber;
local int onesDigit, tensDigit;
local ArenaGameReplicationInfo ArenaRepInfo;

	PlayerOwner = PlayerPawn(Owner);

	if(PlayerOwner == None)
		return;

	//Never want to draw the numbers if Player is in the Arena...
	if(!PlayerOwner.Region.Zone.IsA('QueueZone'))
		return;
	
	Canvas.Style = ERenderStyle.STY_AlphaBlend;
	Canvas.AlphaScale = BackgroundFade;

	foreach AllActors(class'RunePlayer', P)
	{
		if(P.PlayerReplicationInfo == None || P.PlayerReplicationInfo.TeamID > 16)
			continue;

		dispNumber = P.PlayerReplicationInfo.TeamID;

		pos = P.Location + vect(0, 0, 1.3) * P.CollisionHeight;
		if(!FastTrace(pos, PlayerOwner.ViewLocation))
			continue;

		Canvas.TransformPoint(pos, SX, SY);
		if(SX > 0 && SX < Canvas.ClipX && SY > 0 && SY < Canvas.ClipY)
		{
			dist = VSize(P.Location - PlayerOwner.ViewLocation);
			if(dist > 600)
				continue;

			dist = FClamp(dist, 1, 600);
			scale = 500.0/dist * 0.75;
			scale = FClamp(scale, 0.01, 0.75);

			if(dispNumber > 9)
			{
				//Special Handling for multi-digits
				onesDigit = dispNumber % 10;
				tensDigit = dispNumber / 10;
				
				Canvas.SetPos(SX-(DisplayNumbers[0].USize*scale*0.5)*0.5, SY-DisplayNumbers[0].VSize*scale*0.5);
				Canvas.DrawIcon(DisplayNumbers[tensDigit], scale * 0.5);
				Canvas.SetPos(SX+(DisplayNumbers[0].USize*scale*0.5)*0.5, SY-DisplayNumbers[0].VSize*scale*0.5);
				Canvas.DrawIcon(DisplayNumbers[onesDigit], scale * 0.5);
			}
			else
			{
				Canvas.SetPos(SX-(DisplayNumbers[0].USize*scale*0.5)*0.5, SY-DisplayNumbers[0].VSize*scale*0.5);
				Canvas.DrawIcon(DisplayNumbers[dispNumber], scale * 0.5);
			}		
		}
	}

	Canvas.Style = ERenderStyle.STY_Normal;
	Canvas.AlphaScale = 1.0;

}//end-function

simulated function RenderNames(canvas Canvas)
{
local RunePlayer P;
local int SX,SY;
local float scale, dist;
local vector pos;
local string PName;
Local bool bArena;
Local bool bGM;

	 foreach AllActors(class'RunePlayer', P)
	 {
		pos = P.Location+vect(0,0,1.2)*P.CollisionHeight;
		if(!FastTrace(pos, Canvas.ViewPort.Actor.ViewLocation) || P == Canvas.ViewPort.Actor || P.IsA('CTTSpectator') || P.Health <= 0)
			continue;

		Canvas.TransformPoint(pos, SX, SY);
		if (SX > 0 && SX < Canvas.ClipX && SY > 0 && SY < Canvas.ClipY)
		{
			dist = VSize(P.Location-Canvas.ViewPort.Actor.ViewLocation);
			dist = FClamp(dist, 1, 10000);
			scale = 500.0/dist;
			scale = FClamp(scale, 0.01, 2.0);


			Canvas.SetPos(SX-(32*scale)*0.5, SY-(32*scale));
			if(scale>0.3)
				Canvas.Font = Canvas.MedFont;
			else
				return;

		  Canvas.DrawColor = LightCyanColor;

		  PName = P.PlayerReplicationInfo.PlayerName;
		  PName = PName$Playertitle(p);

		if(P != Canvas.ViewPort.Actor)
		{
			if(Owner.Region.Zone.IsA('ArenaZone'))
			{
				if(P.Region.Zone.IsA('ArenaZone'))
				{
					if(P.style != STY_Translucent)
						Canvas.DrawText(PName);
				}
			}
			else
				 Canvas.DrawText(PName);
			}
		}
	 }
}

function SortScores(int N)
{
local int i,j,Max;
local PlayerReplicationInfo TempPRI;

	for(i=0; i<N-1; i++)
	{
		Max = i;
		for(j=i+1; j<N; j++)
		{
			if(Ordered[j].Score > Ordered[Max].Score)
				Max=j;
			else if((Ordered[j].Score == Ordered[Max].Score) && (Ordered[j].Deaths < Ordered[Max].Deaths))
				Max=j;
			else if((Ordered[j].Score == Ordered[Max].Score) && (Ordered[j].Deaths == Ordered[Max].Deaths) && (Ordered[j].PlayerID < Ordered[Max].Score))
				Max=j;
		}

		TempPRI = Ordered[Max];
		Ordered[Max] = Ordered[i];
		Ordered[i] = TempPRI;
	}
}

function Sortdeaths(int N)
{
local int i,j,Max;
local PlayerReplicationInfo TempPRI;

	for(i=0; i<N-1; i++)
	{
		Max = i;
		for(j=i+1; j<N; j++)
		{
			if(Orderedd[j].deaths > Orderedd[Max].deaths)
				Max=j;
		}

		TempPRI = Orderedd[Max];
		Orderedd[Max] = Orderedd[i];
		Orderedd[i] = TempPRI;
	}
}

function string Playertitle (playerpawn p)
{
local string Title;
	if(P.PlayerReplicationInfo.deaths <= 5)
	{Title = " -Novice Warrior";}
	if((P.PlayerReplicationInfo.deaths >= 6) && (P.PlayerReplicationInfo.deaths <= 20))
	{Title = " -Apprentice Warrior";}
	if((P.PlayerReplicationInfo.deaths >= 21) && (P.PlayerReplicationInfo.deaths <= 50))
	{Title = " -Journeymen Warrior";}
	if((P.PlayerReplicationInfo.deaths >= 51) && (P.PlayerReplicationInfo.deaths <= 75))
	{Title = " -Expert Warrior";}
	if((P.PlayerReplicationInfo.deaths >= 76) && (P.PlayerReplicationInfo.deaths <= 100))
	{Title = " -Adept Warrior";}
	if((P.PlayerReplicationInfo.deaths >= 100) && (P.PlayerReplicationInfo.deaths <= 199))
	{Title = " -Master Warrior";}
	if((P.PlayerReplicationInfo.deaths >= 200))
	{Title = " -Grand Master Warrior";}
return  Title;
}

defaultproperties
{
	DisplayNumbers(0)=Texture'Arena.TexZero'
	DisplayNumbers(1)=Texture'Arena.TexOne'
	DisplayNumbers(2)=Texture'Arena.TexTwo'
	DisplayNumbers(3)=Texture'Arena.TexThree'
	DisplayNumbers(4)=Texture'Arena.TexFour'
	DisplayNumbers(5)=Texture'Arena.TexFive'
	DisplayNumbers(6)=Texture'Arena.TexSix'
	DisplayNumbers(7)=Texture'Arena.TexSeven'
	DisplayNumbers(8)=Texture'Arena.TexEight'
	DisplayNumbers(9)=Texture'Arena.TexNine'
	BackgroundFade=0.500000
	LightCyanColor=(R=128,G=255,B=255)
	RedColor=(R=255)
	WhiteColor=(R=255,G=255,B=255)
	BlueColor=(B=255)
}

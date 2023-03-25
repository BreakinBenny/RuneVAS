//-----------------------------------------------------------
// VasArena - Kal Corp
// http://VasServer.dyndns.org/Kalsforums
//-----------------------------------------------------------
class VasArenaScoreboard expands ArenaScoreboard;

var localized string ChampionString;
var localized string CurrentMatch;
var localized string QueueText;
var localized string VsString;
var localized string InMatchMsg;
var localized string ServerText;
var localized string XOnXText;
var localized string ChampionsText;
var localized string ChallengersText;
var localized string MatchText;

function DrawTableHeadings(canvas Canvas)
{
local float XL, YL;
local float YOffset;
local float recordString;
local string CurMatchString;

	YOffset = Canvas.CurY;

	Canvas.DrawColor = GoldColor;
	Canvas.StrLen("00", XL, YL);
	YOffset = Canvas.CurY + YL;

	// Name
	Canvas.SetPos(Canvas.ClipX*0.1, YOffset);
	Canvas.DrawText(NameText, false);

	// Score
	Canvas.SetPos(Canvas.ClipX*0.3, YOffset);
	Canvas.DrawText(FragsText, false);

	// Draw Deaths
	Canvas.SetPos(Canvas.ClipX*0.5, YOffset);
	Canvas.DrawText(DeathsText, false);

	//Draw Queue Number - replaced Awards
	Canvas.SetPos(Canvas.ClipX * 0.8, YOffset);
	Canvas.DrawText(QueueText, false);

	if(Canvas.ClipX > 512)
	{
		// Ping
		Canvas.SetPos(Canvas.ClipX*0.7, YOffset);
		Canvas.DrawText(PingText, false);
	}

	// Draw seperator
	YOffset += YL*2.25;
	Canvas.DrawColor = WhiteColor;
	Canvas.SetPos(Canvas.ClipX*0.1, YOffset);
	Canvas.DrawTile(Seperator, Canvas.ClipX*0.8, YL*0.5, 0, 0, Seperator.USize, Seperator.VSize);
	YOffset += YL*0.75;
	Canvas.SetPos(Canvas.ClipX*0.1, YOffset);

}

function DrawPlayerInfo( canvas Canvas, PlayerReplicationInfo PRI, float XOffset, float YOffset)
{
local bool bLocalPlayer;
local PlayerPawn PlayerOwner;
local float XL,YL;
local ArenaGameReplicationInfo GRI;
local int i;

	PlayerOwner = PlayerPawn(Owner);
	bLocalPlayer = (PRI.PlayerName == PlayerOwner.PlayerReplicationInfo.PlayerName);
	GRI = ArenaGameReplicationInfo(PlayerOwner.GameReplicationInfo);
	if(MyFonts != None)
		Canvas.Font = MyFonts.GetStaticMedFont();
	else
		Canvas.Font = RegFont;

	// Draw Ready
	if(PRI.bReadyToPlay)
	{
		Canvas.StrLen("R ", XL, YL);
		Canvas.SetPos(Canvas.ClipX*0.1-XL, YOffset);
		Canvas.DrawText(ReadyText, false);
	}

	if(bLocalPlayer)
		Canvas.DrawColor = VioletColor;
	else
	{
		if(PRI.Team != 255 && GRI.matchSize != 1)
			Canvas.DrawColor = GetTeamColor(GRI.TeamColor[PRI.Team]);
		else
			Canvas.DrawColor = WhiteColor;
	}

	// Draw Name
	if (PRI.bAdmin)
	{
		if(MyFonts != None)
			Canvas.Font = MyFonts.GetStaticSmallFont();
		else
			Canvas.Font = Font'SmallFont';
	}
	else
	{
		if(MyFonts != None)
			Canvas.Font = MyFonts.GetStaticMedFont();
		else
			Canvas.Font = RegFont;
	}

	Canvas.SetPos(Canvas.ClipX*0.1, YOffset);
	Canvas.DrawText(PRI.PlayerName, false);
	
	if(MyFonts != None)
		Canvas.Font = MyFonts.GetStaticMedFont();
	else
		Canvas.Font = RegFont;

	// Draw Score
	Canvas.SetPos(Canvas.ClipX*0.3, YOffset);
	Canvas.DrawText(int(PRI.Score), false);

	// Draw Deaths
	Canvas.SetPos(Canvas.ClipX*0.5, YOffset);
	Canvas.DrawText(int(PRI.Deaths), false);

	if(Canvas.ClipX > 512 && Level.Netmode != NM_Standalone)
	{
		// Draw Ping
		Canvas.SetPos(Canvas.ClipX*0.7, YOffset);
		Canvas.DrawText(PRI.Ping, false);
	}

	if(PRI.TeamID <= 16)
	{
		Canvas.SetPos(Canvas.ClipX * 0.8, YOffset);
		Canvas.DrawText(TwoDigitString(PRI.TeamID), false);
	}
}

function ShowScores(canvas Canvas)
{
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
			if(!PRI.bIsSpectator || PRI.bWaitingPlayer)
			{
				Ordered[PlayerCount] = PRI;
				PlayerCount++;
				if(PlayerCount == ArrayCount(Ordered))
					break;
			}
		}
	}
	SortScores(PlayerCount);

	if(MyFonts != None)
		Canvas.Font = MyFonts.GetStaticMedFont();
	else
		Canvas.Font = RegFont;

	Canvas.DrawColor = WhiteColor;

	// Calculate vertical spacing
	Canvas.StrLen("TEST", XL, YL);

	// Header

	ArenaGRI = ArenaGameReplicationInfo(PlayerPawn(Owner).GameReplicationInfo);
	DrawHeader(Canvas);
	DrawArenaChampion(Canvas, Ordered[0], 0, Canvas.CurY + YL);

	if(ArenaGRI != None && ArenaGRI.matchSize > 1)
		DrawTeamMatchInfo(Canvas, 0, Canvas.CurY);
	else
	{
		for(i = 0; i < 32; i++)
		{
			if(PlayerPawn(Owner).GameReplicationInfo.PRIArray[i] != None)
			{
				if(PlayerPawn(Owner).GameReplicationInfo.PRIArray[i].Team == 0)
					ChampionPRI = PlayerPawn(Owner).GameReplicationInfo.PRIArray[i];
				else if(PlayerPawn(Owner).GameReplicationInfo.PRIArray[i].Team == 1)
					ChallengerPRI = PlayerPawn(Owner).GameReplicationInfo.PRIArray[i];
			}

			if(ChallengerPRI != None && ChampionPRI != None)
			{
				DrawMatchInfo(Canvas, ChampionPRI, ChallengerPRI, 0, Canvas.CurY);
				break;
			}

		}
	}
		
	DrawTableHeadings(Canvas);

	Canvas.StrLen("TEST", XL, YL);
	YStart = Canvas.CurY + YL;

	//TODO: Calculate continuous spacing based on screensize available

	if(PlayerCount < 15)
		YL *= 2;
	else if (PlayerCount < 20)
		YL *= 1.5;
	if(PlayerCount > 15)
		PlayerCount = FMin(PlayerCount, (Canvas.ClipY - YStart)/YL - 1);

	DrawBackground(Canvas, 0.1*Canvas.ClipX, YStart-YL*0.25+2, 0.8*Canvas.ClipX, PlayerCount*YL);

	//YStart += YL;
	YOffset = YStart;

	for(I=0; I<PlayerCount; I++)
	{
		YOffset = YStart + I*YL;
		DrawPlayerInfo(Canvas, Ordered[I], 0, YOffset);
	}

	// Draw bottom seperator
	Canvas.StrLen("TEST", XL, YL);
	YOffset += YL;
	Canvas.SetPos(0, YOffset);

	// Trailer
	DrawTrailer(Canvas);

	Canvas.DrawColor = WhiteColor;
	Canvas.SetPos(0, YOffset);

	Canvas.DrawColor = WhiteColor;
	Canvas.bCenter = True;
	Canvas.Font = Canvas.BigFont;
	Canvas.SetPos(0,Canvas.ClipY-100);
	Canvas.DrawText("VasArena Development Forum @ Http://VasServer.dyndns.org/KalsForums");
	Canvas.bCenter = false;
}

defaultproperties
{
	DeathsText="Life Victories"
}
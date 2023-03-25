//-----------------------------------------------------------
//	VasMOTD -  By Kal-Corp		Kal-Corp@cfl.rr.com
//		http://Vasserver.dyndns.org/KalsForums
//-----------------------------------------------------------
class VasMOTD expands Mutator;

var float MOTDFadeOutTime;
var color GreenColor,WhiteColor;
var bool init;
Var int Vastime;

simulated function Tick(float DeltaTime){
	Super.Tick(DeltaTime);
	If (!init)
		Vastime +=1;
	if(Vastime >= 10){
		Vastime =0;
		RegisterHUDMutator();
	}
	MOTDFadeOutTime = FMax(0.0, MOTDFadeOutTime - DeltaTime * 55);
}

simulated function PreBeginPlay(){
	  MOTDFadeOutTime = 800;
}

simulated function RegisterHUDMutator(){
	local HUD MyHud;
	local Pawn P;
	local playerpawn playerpawn;

	if(!init){
		foreach AllActors(class'HUD', MyHud){
			init = true;
			if(MyHud.owner != none){
				if(MyHud.owner == owner){
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
	if(MOTDFadeOutTime > 0.0){
		DrawMOTD(Canvas);
		DrawVasInfo(Canvas);
	}
	if(nextHUDMutator != None)
		nextHUDMutator.PostRender(Canvas);
}

simulated function DrawMOTD(Canvas Canvas){
	local GameReplicationInfo GRI;
	local float XL, YL;
	local float InitialY;
	local float scale;

	if(PlayerPawn(Owner) == none)
		return;

	GRI = PlayerPawn(Owner).GameReplicationInfo;
	if((GRI == None) || (GRI.GameName == "Game") || (MOTDFadeOutTime <= 0))
		return;

	Canvas.Font = Canvas.BigFont;
	Canvas.Style = Style;
	Canvas.bCenter = true;
	Canvas.DrawColor = GreenColor;
	InitialY = 64;
	Canvas.SetPos(0.0, InitialY);
	Canvas.StrLen("TEST", XL, YL);

	Canvas.DrawText(GRI.ServerName);
	Canvas.SetPos(0.0, InitialY + 1*YL);
	Canvas.DrawText("Admin: "$GRI.AdminName);
	Canvas.SetPos(0.0, InitialY + 2*YL);
	Canvas.DrawText("Admin E-Mail: "$GRI.AdminEmail);

	if(Canvas.ClipY >= 300){
		Canvas.SetPos(0.0, InitialY + 6*YL);
		Canvas.DrawText(GRI.MOTDLine1, true);
		Canvas.SetPos(0.0, InitialY + 7*YL);
		Canvas.DrawText(GRI.MOTDLine2, true);
		Canvas.SetPos(0.0, InitialY + 8*YL);
		Canvas.DrawText(GRI.MOTDLine3, true);
		Canvas.SetPos(0.0, InitialY + 9*YL);
		Canvas.DrawText(GRI.MOTDLine4, true);
	}
}

simulated function DrawVasInfo(Canvas canvas){
	Canvas.DrawColor = WhiteColor;
	Canvas.SetPos(0,Canvas.ClipY-50);
	Canvas.bCenter = True;
	Canvas.Font = Canvas.BigFont;
	Canvas.DrawText("Message Of The Day powered by {VasMOTD} v1.0");
	Canvas.DrawColor = Whitecolor;
	Canvas.bCenter = False;
}

defaultproperties{
	GreenColor=(R=0,G=255,B=0,A=0),
	WhiteColor=(R=255,G=255,B=255,A=0),
	bAlwaysRelevant=True
	RemoteRole=2
}

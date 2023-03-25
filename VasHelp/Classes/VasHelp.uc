//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasHelp expands Mutator;

Var() Bool ShowHelp,bShowHelp2,bShowHelp3;
Var() string Url;
var() bool init;
Var() int Vastime;
Var() bool INITKeyBind;
var() color GreenColor,WhiteColor;
var() float FadeOutTime;
Var() string HelpMessage;
Var() int HelpMessageTimer;

replication
{
	reliable if(Role == ROLE_Authority)
		ShowHelp,Url,HelpMessage;
}

simulated function PreBeginPlay()
{
	pawn(owner).clientmessage("Powered by VasHelp -  Kal Corp");
	LOG("Powered by VasHelp -  Kal Corp");
	FadeOutTime = 1600;
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

	if(((showhelp) && (!bShowHelp3)) || ((!showhelp) && (bShowHelp3)))
	{
		bShowHelp3 = showhelp;
		if(HelpMessageTimer > 0)
		{
			bShowHelp2=true;
			HelpMessageTimer = 0;
			return;
		}
		HelpMessageTimer = 200;
	}

	if(HelpMessageTimer > 0)
		HelpMessageTimer -=1;

	FadeOutTime = FMax(0.0, FadeOutTime - DeltaTime * 55);
}

simulated function RegisterHUDMutator()
{
	local HUD MyHud;
	local Pawn P;
	local playerpawn playerpawn;

	if (!init)
	{
		foreach AllActors(class'HUD', MyHud)
		{
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

simulated event PostRender(canvas Canvas)
{
	if((FadeOutTime > 0.0 ) || (HelpMessageTimer > 0))
	{
		DrawVasHelp(Canvas);
	}
	if(!INITKeyBind)
	{
		INITKeyBind= true;
		owner.ConsoleCommand("set input F1 MUTATE HELP");
}

	if (bShowHelp2)
	{
		bShowHelp2= false;
		owner.ConsoleCommand("start "$URL);
	}
	if(nextHUDMutator != None)
		nextHUDMutator.PostRender(Canvas);
}

simulated function DrawVasHelp(Canvas canvas)
{
	Canvas.DrawColor = GreenColor;
	Canvas.SetPos(0,Canvas.ClipY-75);
	Canvas.bCenter = True;
	Canvas.Font = Canvas.BigFont;
	if(HelpMessageTimer > 0)
		Canvas.DrawText("VasHelp - Hit F1 Again for "$HelpMessage);
	else
		Canvas.DrawText("VasHelp - Hit F1 two times for "$HelpMessage);
	Canvas.DrawColor = Whitecolor;
	Canvas.bCenter = False;
}

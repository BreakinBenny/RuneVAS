//-----------------------------------------------------------
//	VasHelpStart -  By Kal-Corp      Kal-Corp@cfl.rr.com
//		http://Vasserver.dyndns.org:88/KalsForums
//-----------------------------------------------------------
class VasHelpStart expands Mutator Config (VasHelp);

Var() config string URL;
Var() config string HelpMessage ;
Var() config int VasDebuglevel;

function PreBeginPlay()
{
	VasDebug(" PreBeginPlay Started ",2);
	broadcastmessage("Powered by VasHelp -  Kal Corp");
	LOG("Powered by VasHelp -  Kal Corp");
}

function ModifyPlayer(Pawn Other)
{
	local Pawn P;
	local VasHelp VasHelp;

	VasDebug(" ModifyPlayer Started ",2);

	Super.ModifyPlayer(Other);

	foreach AllActors(class'VasHelp', VasHelp)
	{
		VasDebug(" ModifyPlayer All VasHelp="$VasHelp,3);
		if(VasHelp.owner == Other)
		{
			VasDebug(" ModifyPlayer VasHelp.owner == other -"$other,2);
			return;
		}
	}
	VasDebug(" ModifyPlayer VasHelp not found spawning",2);
	VasHelp = Spawn(Class'VasHelp.VasHelp',other);
	if(VasHelp != none)
	{
		VasHelp.URl = url;
		VasHelp.HelpMessage = HelpMessage;
	}
        else
		VasDebug (" ModifyPlayer VasHelp == NONE",1);
}

function Mutate(string MutateString, PlayerPawn Sender)
{
	local VasHelp VasHelp;

	VasDebug(" Mutate Started Sender="$Sender$" MutateString="$MutateString,2);
	if(Caps(MutateString) == "HELP")
	{
		foreach AllActors(class'VasHelp', VasHelp)
		{
			VasDebug(" Mutate All VasHelp="$VasHelp,3);
			if(VasHelp.owner == Sender)
			{
				VasDebug(" ModifyPlayer VasHelp.owner == Sender -"$Sender,2);
				Sender.clientmessage("VasHelp - Hit F1 Again for "$HelpMessage,'pickup');
				if(VasHelp.ShowHelp)
					VasHelp.ShowHelp=False;
				else if(!VasHelp.ShowHelp)
					VasHelp.ShowHelp=true;
				Sender.clientmessage("VasHelp - Hit F1 Again for "$HelpMessage,'pickup');
			}
		}
	}
}

function VasDebug(String Text, int level)
{
	local String text1,test2;

	if(VasDebuglevel > 0)
	{
		if(level <= VasDebuglevel)
		{
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

//-----------------------------------------------------------
//  VasCastSpellsArena -  By Kal-Corp      Kal-Corp@cfl.rr.com
//                 http://Vasserver.dyndns.org/KalsFor
//-----------------------------------------------------------
class VasCSArenaMutator expands Mutator config(VasCSArena);

Var() config int RunepowerBonus;

function PostBeginPlay()
{
BroadcastMessage ("Powered by VasCastSpellsArena -  Kal Corp");
LOG("Powered by VasCastSpellsArena -  Kal Corp");
if(RunepowerBonus == 0)
	RunepowerBonus = 2;

SetTimer(1.000000,True);
}

function timer()
{
local ScriptPawn ScriptPawn;
Local Runeplayer Runeplayer;
local int MonsterNumber;

foreach AllActors(class'Runeplayer', Runeplayer)
{
	Runeplayer.runepower += RunepowerBonus;
	if(Runeplayer.runepower > Runeplayer.maxpower)
		Runeplayer.runepower = Runeplayer.maxpower;
}
}

defaultproperties
{
}
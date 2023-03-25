//-----------------------------------------------------------
//VasCSBonuspack1 - By Kal-Corp	Kal-Corp@cfl.rr.com
//	http://Vasserver.dyndns.org/KalsFor
//-----------------------------------------------------------
class VASCSDispelMagic expands VasCastSpell;

function SpellRUN(){
Local INT i;
local Vector teleportSpot;
local NavigationPoint nav;

	CastSuccess = True;
	CastMassage="You Cast Magic Dispel";

	if(CastSuccess){
		findmagic();
		spawn(class'RespawnFire',,, caster.location, rotator(vect(0,0,1)));
		Caster.PlaySound(Sound'OtherSnd.Pickups.pickup01', Slot_None);
	}
	if(bPostSpell)
		PostSpell();
}

function bool findmagic(){
local VasCastSpell Spell;
local pawn pawn;

	foreach AllActors(class'VasCastSpell', Spell){
		Foreach VisibleActors(class'pawn', pawn, 1500, caster.location){
			if((Spell.caster == Pawn) && (Spell != self)){
				Spell.EndSpell();
				spawn(class'VasCSDMEffect',,, Pawn.location,);
			}
		}
	}
}

defaultproperties{
	StrTaunt=X3_Taunt
}
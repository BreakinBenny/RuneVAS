//-----------------------------------------------------------
//	VasShowNames -  By Kal-Corp	Kal-Corp@cfl.rr.com
//		http://Vasserver.dyndns.org/KalsForums
//-----------------------------------------------------------
class VasShowNamesStart expands Mutator;

function ModifyPlayer(Pawn Other){
	local Pawn P;
	local VasShowNames VasShowNames;
	Super.ModifyPlayer(Other);
	foreach AllActors(class'VasShowNames', VasShowNames){
		if(VasShowNames.owner == Other)
			Return;
	}
	Spawn(Class'VasShowNames.VasShowNames',other);
}
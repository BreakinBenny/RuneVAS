//-----------------------------------------------------------
//	VasMOTD -  By Kal-Corp      Kal-Corp@cfl.rr.com
//		http://Vasserver.dyndns.org/KalsForums
//-----------------------------------------------------------
class VasMOTDStart expands Mutator;

function ModifyPlayer(Pawn Other){
	local Pawn P;
	local VasMOTD VasMOTD;
	Super.ModifyPlayer(Other);
	foreach AllActors(class'VasMOTD', VasMOTD){
		if(VasMOTD.owner == Other)
			return;
	}
	Spawn(Class'VasMOTD.VasMOTD', other);
}

//===============================
// JetVasAutoChar.
// No longer will we make characters over and over!!
//===============================
class JetVasAutoChar expands Mutator;

function PreBeginPlay(){
	setTimer(10.0,true);
	Super.PreBeginPlay();
}
function Timer(){
	local VasEXPReplicationInfo VERI;
	foreach AllActors(class'VasEXPReplicationInfo', VERI){
		VERI.VasSTR = 120;
		VERI.VasINT = 120;
		VERI.VasDEX = 120;
		VERI.VasMagicSkill = 120;
		VERI.VasAxeSkill = 120;
		VERI.VasmaceSkill = 120;
		VERI.VasSwordSkill = 120;
		VERI.VasBowSkill = 120;
	}
	setTimer(10.0,true);
	Super.PreBeginPlay();
}
//=============================================================================
// JetVasSpellMark.
// A less lame version of recall similair to Ultima Online
//=============================================================================
class JetVasSpellMark expands VasCastSpell;

var bool marked;
function SpellRUN()
{
local MarkLocation Marker;
local MarkLocation M;
local MarkLocation NewMarker;

ForEach AllActors(Class'JetVasSpells.MarkLocation',M)
{
	if(M.Owner == Pawn(Caster)){
		marked=true;
		Marker = M;
	}
}

	CastSuccess = True;
	if(marked){
		CastMassage="You replace your old marker with this one.";
		Marker.Destroy();
	}
	else
		CastMassage = "You mark this location. Use Ultima Recall to teleport here.";

	VasCastEffect(pawn(caster));
	NewMarker = Spawn(class'JetVasSpells.MarkLocation',Caster,,Pawn(Caster).Location-vect(0,0,8),pawn(Caster).Rotation);
	NewMarker.Owner = Pawn(Owner);
	PostSpell();
}

defaultproperties{}
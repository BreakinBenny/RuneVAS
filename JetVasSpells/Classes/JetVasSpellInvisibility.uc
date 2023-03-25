//=============================================================================
// JetVasSpellInvisibility.
//=============================================================================
class JetVasSpellInvisibility expands VasCastSpell;

function SpellRUN(){
local InvisInfo IV;
	CastSuccess = True;
	CastMassage="You blend with the shadows";
	VasCastEffect(pawn(caster));
	IV = spawn(class'JetVasSpells.InvisInfo',self, , Caster.Location);
	IV.Caster = Pawn(Caster);
	if(bPostSpell)
		PostSpell();
}

defaultproperties{}
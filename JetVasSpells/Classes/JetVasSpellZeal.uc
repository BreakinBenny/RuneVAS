//=============================================================================
// JetVasSpellZeal.
//=============================================================================
class JetVasSpellZeal expands VasCastSpell;

function SpellRUN(){
local INT i;
local JetVasSpellZealEffect VasSpell;
local vector loc;
loc = Caster.Location;
loc.Z -= 10;
	if(pawn(Caster).Health <= pawn(Caster).MaxHealth - 75){
		CastMassage="Your body is too weak and needs healing!";
		PostSpell();
		return;
	}
	if(RunePlayer(Caster).bBloodlust){
		CastMassage="You already are in a Zeal effect!";
		PostSpell();
		return;
	}
	CastSuccess = True;
	CastMassage="You cast Zeal";
	VasSpell = Spawn(class'JetVasSpells.JetVasSpellZealEffect',Caster,,loc, rotator(vect(0,0,1)));
	pawn(Caster).health = 1;
	VasCastEffect(pawn(caster));
	pawn(Caster).BoostStrength(101);
	pawn(Caster).Strength = 75;
	pawn(Caster).RunePower = -180;
	if(bPostSpell)
		PostSpell();
}

defaultproperties{}
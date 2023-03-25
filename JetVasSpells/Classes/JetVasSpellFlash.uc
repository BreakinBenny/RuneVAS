//=============================================================================
// JetVasSpellFlash.
//=============================================================================
class JetVasSpellFlash expands VasCastSpell;

function SpellRUN(){
Local INT i;
local runeplayer P;
local scriptpawn PP;
local FlashLight VasSpell;
local vector loc;
loc = Caster.Location;
loc.Z -= 1;

	CastMassage="You cast ~Flash~";
	VasSpell = Spawn(class'JetVasSpells.FlashLight',Caster,,loc, rotator(vect(0,0,1)));
	VasSpell.Instigator = pawn(Caster);
	Spawn(class'JetVasSpells.FlashLight2',Caster,,loc, rotator(vect(0,0,1)));
	Spawn(class'JetVasSpells.FlashLight2',Caster,,loc, rotator(vect(0,0,1))); 
	PlaySound(Sound'WeaponsSnd.PowerUps.apowerrocks01', SLOT_Interface);
	CastSuccess = True;

	if(bPostSpell)
		PostSpell();
}

defaultproperties{}
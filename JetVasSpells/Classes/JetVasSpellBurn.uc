//=============================================================================
// JetVasSpellBurn.
//=============================================================================
class JetVasSpellBurn expands VasCastSpell;

function SpellRUN(){
Local INT i;
local runeplayer P;
local scriptpawn PP;
local FireRadius VasSpell;
local PawnFire VasSpellFire;
local vector loc;
loc = Caster.Location;
loc.Z -= 1;

	 DamagePoints = RandRange(Casterlevel/4, Casterlevel/2);
	 CastMassage="You cast Burn @ "$DamagePoints$" Powerlevel ";
	 VasSpell = Spawn(class'RuneI.FireRadius',Caster,,loc, rotator(vect(0,0,1)));
		 VasSpell.Instigator = pawn(Caster);
	 VasSpell = Spawn(class'RuneI.FireRadius',Caster,,loc, rotator(vect(0,0,0)));
		 VasSpell.Instigator = pawn(Caster);
	 VasSpell = Spawn(class'RuneI.FireRadius',Caster,,loc, rotator(vect(0,1,0)));
		 VasSpell.Instigator = pawn(Caster);

	 PlaySound(Sound'WeaponsSnd.PowerUps.apowerrocks01', SLOT_Interface);

	foreach RadiusActors(class'RunePlayer', P, 175, caster.Location){
		P.ShakeView(1.0, 800, 0.5);
		if(p == Caster)
			continue;
		P.JointDamaged(DamagePoints, pawn(Caster), P.Location, vect(0, 0, 0), 'Fire', 0);
	}
	foreach RadiusActors(class'ScriptPawn', PP, 175, caster.Location){
		if(Rand(100) < 75)
		PP.JointDamaged(DamagePoints*1.5, pawn(Caster), P.Location, vect(0, 0, 0), 'Fire', 0);
	}
	CastSuccess = True;

	if(bPostSpell)
	PostSpell();
}

defaultproperties{}
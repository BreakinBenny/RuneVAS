//=============================================================================
// JetVasSpellInversion.
//=============================================================================
class JetVasSpellInversion expands VasCastSpell;

function SpellRUN(){
Local INT i;
local Projectile P;
	CastMassage="You cast Inversion ";
	setLocation(Caster.Location);
	self.PlaySound(Sound'OtherSnd.Regens.regen08', SLOT_None,,,, 1.0 + FRand()*0.4-0.2);
	Spawn(class'JetVasSpells.InversionEffect',Caster,,Caster.Location, rotator(vect(0,0,1)));
	foreach RadiusActors(class'Projectile', P, 300, caster.Location){
		if(P.Owner != Caster){
			Spawn(class'EmpathyFlash',Caster,,P.Location, rotator(vect(0,0,1)));
			P.PlaySound(Sound'OtherSnd.Regens.regen02', SLOT_None,,,, 1.0 + FRand()*0.4-0.2);
			P.Velocity.Z *= -1;
			P.Velocity.X *= -1;
			P.Velocity.Y *= -1;
			P.setOwner(Caster);
			if(P.isA('JetVasSpellMagicMissile')){
				JetVasSpellMagicMissile(P).TargetPawn = None;
				JetVasSpellMagicMissile(P).Instigator = Pawn(Caster);
			}
			if(P.isA('MagicArrow')){
				MagicArrow(P).TargetPawn = None;
				MagicArrow(P).Instigator = Pawn(Caster);
			}
		}
	}
	CastSuccess = True;

	if(bPostSpell)
		PostSpell();
}

defaultproperties{}
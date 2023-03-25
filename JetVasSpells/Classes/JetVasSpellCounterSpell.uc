//=============================================================================
// JetVasSpellCounterSpell.
//=============================================================================
class JetVasSpellCounterSpell expands VasCastSpell;

function SpellRUN(){
Local INT i;
local Projectile P;
local VasCSTelProjectile T;
	 CastMassage="You cast Counter Spell ";
	 setLocation(Caster.Location);
	 self.PlaySound(Sound'JetVasSounds.Package0.sfx01', SLOT_None,,,, 1.0 + FRand()*0.4-0.2);

	foreach RadiusActors(class'Projectile', P, 600, caster.Location){
		Spawn(class'EmpathyFlash',Caster,,P.Location, rotator(vect(0,0,1)));
		P.PlaySound(Sound'MurmurSnd.Rocks.rock01', SLOT_None,,,, 1.0 + FRand()*0.4-0.2);
		P.Destroy();
	}
	foreach RadiusActors(class'VasCSTelProjectile', T, 1000, caster.Location){
		Spawn(class'EmpathyFlash',Caster,,T.Location, rotator(vect(0,0,1)));
		T.PlaySound(Sound'MurmurSnd.Rocks.rock01', SLOT_None,,,, 1.0 + FRand()*0.4-0.2);
		T.Destroy();
	}
	CastSuccess = True;

	if(bPostSpell)
	PostSpell();
}

defaultproperties{}
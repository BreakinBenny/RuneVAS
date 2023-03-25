//=============================================================================
// JetVasSpellConfusion.
//=============================================================================
class JetVasSpellConfusion expands VasCastSpell;

function SpellRUN(){
Local INT i;
local runeplayer P;
	CastMassage="You cast Confusion ";

	foreach RadiusActors(class'RunePlayer', P, 220, caster.Location){
		P.ShakeView(1.0, 800, 0.5);
		if(p == Caster)
			continue;
		P.Dropweapon();
		if(Rand(100) < 50){
			P.ConsoleCommand("say BLAH BLAH * CONFUSED * BLAH BLAH");
			P.ConsoleCommand("Jump");
		}
		P.ShakeView(1.0, 2900, 0.9);
	}
	CastSuccess = True;

if(bPostSpell)
PostSpell();
}

defaultproperties{}
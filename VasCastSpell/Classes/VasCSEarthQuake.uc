//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasCSEarthQuake expands VasCastSpell;

function SpellRUN()
{
Local INT i;
local runeplayer P;
local scriptpawn PP;

	DamagePoints = RandRange(Casterlevel/4, Casterlevel/2);
	CastMassage="You cast Earthquake @ "$DamagePoints$" Powerlevel ";

	foreach RadiusActors(class'RunePlayer', P, 500, caster.Location)
	{
		P.ShakeView(1.0, 800, 0.5);
		if(p == Caster)
			continue;
		if(Rand(100) < 25)
			p.Dropweapon();
		P.JointDamaged(DamagePoints, pawn(Caster), P.Location, vect(0, 0, 0), 'MAGIC', 0);
	}
	foreach RadiusActors(class'ScriptPawn', PP, 500, caster.Location)
	{
		if (Rand(100) < 75)
			PP.JointDamaged(DamagePoints*1.5, pawn(Caster), P.Location, vect(0, 0, 0), 'blunt', 0);
	}
	CastSuccess = True;

	if(bPostSpell)
		PostSpell();
}

defaultproperties
{
	StrTaunt=X3_Taunt
	SpellLevel=6
}
//=============================================================================
// JetVasSpellBeam.
//=============================================================================
class JetVasSpellBeam expands VasCastSpell;

function SpellRUN(){
	local BeamLaser bolt;
	local Projectile ball;

	DamagePoints = RandRange(Casterlevel, Casterlevel/0.8);
	if(DamagePoints < 40)
		DamagePoints = 40;
	if(Pawn(Caster).isA('RunePlayer'))
		bolt = spawn(class'BeamLaser', caster,, caster.location, Pawn(caster).viewrotation);
	else
		bolt = spawn(class'BeamLaser', caster,, caster.location, Pawn(caster).rotation);

	if(bolt != none)	{
		Bolt.damage = DamagePoints;
		CastMassage="You cast Beam @ "$DamagePoints$" Powerlevel ";
		bolt.init();
		caster.playSound(Sound'OtherSnd.Explosions.explosion12', SLOT_Misc);
	}
PostSpell();
}

defaultproperties{}
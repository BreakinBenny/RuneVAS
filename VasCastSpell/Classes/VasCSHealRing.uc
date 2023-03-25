//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasCSHealRing expands VasCSHeal;

Var string Caston;

function SpellRUN()
{
local VasCSEffectHealRing VasSpell;
local vector loc;
	CastMassage="You Cast HealRing";
	loc = Caster.Location;
	loc.Z -= 10;
	VasSpell = Spawn(class'VasCSEffectHealRing',Caster,,loc, rotator(vect(0,0,1)));
	VasSpell.Instigator = pawn(Caster);
	VasSpell.Healpoints = RandRange(50,100);
	VasSpell.Caster = Caster;
	VasSpell.CasterLevel = CasterLevel;
	PlaySound(Sound'OtherSnd.Pickups.pickup01', SLOT_Interface);

bPostSpell=False;
Super.spellRUN();
CastMassage="You cast HealRing";
PostSpell();
}

defaultproperties
{
	SpellLevel=4
}
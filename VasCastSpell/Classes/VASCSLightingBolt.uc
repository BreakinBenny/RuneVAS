//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VASCSLightingBolt expands VasCastSpell;

var Sound LightningFireSound[3];

function SpellRUN()
{
local VasCSLightingBolts bolt;
local Projectile ball;

	DamagePoints = RandRange(Casterlevel/4, Casterlevel/2);
	if(DamagePoints < 10)
		DamagePoints = 10;

	bolt = spawn(class'VasCSLightingBolts', caster,, caster.location, caster.rotation);

	if (bolt != none)
	{
		Bolt.damage = DamagePoints*1.25 ;
		CastMassage="You cast Lighting @ "$DamagePoints$" Powerlevel ";
		bolt.init();
		caster.playSound(LightningFireSound[Rand(3)], SLOT_Misc);
	}
PostSpell();
}

defaultproperties
{
	LightningFireSound(0)=Sound'WeaponsSnd.PowerUps.aelec01'
	LightningFireSound(1)=Sound'WeaponsSnd.PowerUps.aelec02'
	LightningFireSound(2)=Sound'WeaponsSnd.PowerUps.aelec03'
	SpellLevel=6
}
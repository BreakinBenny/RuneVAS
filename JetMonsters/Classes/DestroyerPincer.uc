//===========
// DestroyerPincer.
//===========
class DestroyerPincer extends CrabPincer;

defaultproperties{
	Damage=25
	ThroughAir(0)=Sound'CreaturesSnd.Mech.mechimpactplayer'
	ThroughAir(1)=Sound'CreaturesSnd.Mech.mechcrash01'
	ThroughAir(2)=Sound'CreaturesSnd.TubeStriker.tubedeath02'
	HitFlesh(0)=Sound'WeaponsSnd.ImpFlesh.impfleshaxe01'
	HitFlesh(1)=Sound'WeaponsSnd.ImpFlesh.impfleshhammer01'
	HitFlesh(2)=Sound'WeaponsSnd.ImpFlesh.impfleshsword10'
	ColorAdjust=(X=255.00,Y=0.00,Z=0.00),
	DesiredColorAdjust=(X=255.00,Y=0.00,Z=0.00),
	bMeshEnviroMap=True
}
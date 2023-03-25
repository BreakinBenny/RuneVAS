//=============================================================================
// WindScar.
//=============================================================================
class WindScar expands Projectile;

var ParticleSystem effect;

simulated function PreBeginPlay(){
	effect = Spawn(class'BigFire', , , , Rotation);
	effect.SetBase(self);
}

simulated function Destroyed(){
	if(effect != None)
		effect.Destroy();
}

simulated function ProcessTouch(Actor Other, Vector HitLocation){
	if(Other != None && Other != Instigator)
		Other.JointDamaged(Damage, Instigator, HitLocation, MomentumTransfer*Normal(Velocity), MyDamageType, 0);
}

simulated function Landed(vector HitNormal, actor HitActor){
	Explode(Location, HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal){
	local WindScarExplosion WSE;
	WSE = spawn(class'WindScarExplosion',Instigator,,HitLocation);
	WSE.OwnerPawn = Instigator;
	WSE.Damage = Damage;
	Destroy();
}

defaultproperties{
	speed=900.000000
	MaxSpeed=900.000000
	Damage=40.000000
	MyDamageType=Sever
	RemoteRole=ROLE_None
	DrawType=DT_Sprite
	Style=STY_Translucent
	Texture=Texture'RuneFX.explosion1'
	DrawScale=12.000000
	CollisionRadius=30.000000
	CollisionHeight=30.000000
}
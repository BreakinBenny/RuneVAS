//=============================================================================
// FlamingStone.
//=============================================================================
class FlamingStone expands DebrisStone;

var ParticleSystem trail_effect;

simulated function PreBeginPlay(){
	trail_effect = Spawn(class'RuneI.TrailFire', , , , Rotation);
	trail_effect.SetBase(self);
	trail_effect.drawscale = drawscale;
}


simulated function Destroyed(){
	if(trail_effect != None)
		trail_effect.Destroy();
}

defaultproperties{
	RemoteRole=ROLE_None
}
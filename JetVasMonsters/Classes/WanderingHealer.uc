//=============================================================================
// WanderingHealer.
//=============================================================================
class WanderingHealer expands Elder;

function PreBeginPlay(){
	setTimer(2.5,true);
}

function Timer(){
local GhostInfo GI;
local JetVasSpellRessurection JVSR;
	ForEach RadiusActors(class'GhostInfo', GI, 200){
		if(GI.bisDead){
			JVSR = spawn(class'JetVasSpellRessurection',self, , Location);
			JVSR.Caster = self;
		}
	}
}

defaultproperties{
	SightRadius=0.000000
	MaxPower=500
	ReducedDamageType=All
	ReducedDamagePct=1.000000
	AttitudeToPlayer=ATTITUDE_Ignore
	Intelligence=BRAINS_NONE
	AmbientGlow=255
	bIsKillGoal=False
	SkelGroupSkins(4)=Texture'RuneFX.swipe'
	SkelGroupSkins(5)=Texture'RuneFX.swipe'
	SkelGroupSkins(6)=Texture'RuneFX.swipe'
}
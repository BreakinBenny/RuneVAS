//=============================================================================
// JetVasSpellRessurection.
// For use with the Ghost System
//=============================================================================
class JetVasSpellRessurection expands VasCastSpell;

function SpellRUN(){
local GhostInfo GI;
local int resurrect;
local JVSP JVSP;
local JVSP JVSP2;
local GraySmoke GS;
setLocation(Caster.Location);
ForEach RadiusActors(Class'GhostInfo', GI, 200)
{
	if(GI.bisDead){
		GI.RunePlayer.ClientMessage("You have been brought back to life!", 'subtitle');
		GI.RunePlayer.Health = GI.RunePlayer.MaxHealth/2;
		if(GI.RunePlayer.DrawType != DT_SkeletalMesh)
			GI.RunePlayer.DrawType = DT_SkeletalMesh;
		GI.RunePlayer.Style = STY_Normal;
		GI.RunePlayer.ReducedDamageType = 'None';
		GI.RunePlayer.ReducedDamagePct = 0.0;
		GI.RunePlayer.RunePower = 0;
		GI.RunePlayer.StartWalk();
		GI.bisDead = false;
		GI.bfirstphys = false;
		GI.DeadTime = 0;
		GI.RunePlayer.Taunt();
		GS = spawn(class'RuneI.GraySmoke',self, , GI.RunePlayer.Location);
		GS.LifeSpan = 1.5;
		JVSP2 = spawn(class'JetVasSpells.JVSP',self, , GI.RunePlayer.Location);
		JVSP2.Sound = Sound'OtherSnd.Pickups.pickup03';
		ressurect = true;
	}
}
	CastSuccess = True;
	if(ressurect > 0)
		CastMassage = "You bring back the dead.";
	else
		CastMassage = "No spirits around...";

JVSP = spawn(class'JetVasSpells.JVSP',self, , Caster.Location);
JVSP.Sound = Sound'OtherSnd.Regens.regen09';
	VasCastEffect(pawn(caster));
	PostSpell();
}

defaultproperties{}
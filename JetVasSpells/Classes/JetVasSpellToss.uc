//=============================================================================
// JetVasSpellToss.
//=============================================================================
class JetVasSpellToss expands VasCastSpell;

function SpellRUN(){
Local INT i;
local runeplayer P;
local scriptpawn PP;
local vector Vel;
local vector Veltwo;
	DamagePoints = RandRange(Casterlevel/4, Casterlevel/2);
	CastMassage="You cast Toss";

	foreach RadiusActors(class'RunePlayer', P, 200, caster.Location){
		if(P == caster)
			continue;
		P.ShakeView(1.0, 200, 0.5);
		Vel.Z = 2.4;
		Vel *= 700 - P.Mass;
		P.AddVelocity(Vel);
	}
	foreach RadiusActors(class'ScriptPawn', PP, 200, caster.Location){
		Veltwo.Z = 2.5;
		Veltwo *= 600 - PP.Mass;
		PP.AddVelocity(Veltwo);
	}
	CastSuccess = True;

if(bPostSpell)
	PostSpell();
}

defaultproperties{}
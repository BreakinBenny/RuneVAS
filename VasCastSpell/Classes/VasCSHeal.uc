//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasCSHeal expands VasCastSpell;

Var int HealPoints;

function SpellRUN()
{
Local INT i;

	Healpoints = RandRange(Casterlevel/2, Casterlevel);
	if( Healpoints < 25 )
		Healpoints = 25;
	if(pawn(Caster).Health >= (pawn(Caster).MaxHealth-25))
	{
		CastMassage="You are already healthy!";
		PostSpell();
		return;
	}
		CastSuccess = True;
		CastMassage="You cast Heal for "$HealPoints$" points";
		pawn(Caster).health += HealPoints;
		if (pawn(Caster).Health>pawn(Caster).MaxHealth)
			pawn(Caster).Health=pawn(Caster).MaxHealth;
		if(pawn(Caster).BodyPartMissing(BODYPART_LARM1))
			pawn(Caster).RestoreBodyPart(BODYPART_LARM1);
		if(pawn(Caster).BodyPartMissing(BODYPART_RARM1))
			pawn(Caster).RestoreBodyPart(BODYPART_RARM1);
		for (i=0; i<pawn(Caster).NUM_BODYPARTS; i++)
			pawn(Caster).BodyPartHealth[i] = pawn(Caster).Default.BodyPartHealth[i];
		pawn(Caster).PlaySound(Sound'OtherSnd.Pickups.pickup01', Slot_None);
		VasCastEffect(pawn(caster));

if(bPostSpell)
	PostSpell();
}

defaultproperties
{
	  StrTaunt=X3_Taunt
}
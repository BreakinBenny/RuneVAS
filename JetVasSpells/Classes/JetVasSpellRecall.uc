//=============================================================================
// JetVasSpellRecall.
//=============================================================================
class JetVasSpellRecall expands VasCastSpell;

var int lasthealth;
var int lastrunepower;
function SpellRUN(){
	CastSuccess = True;
	
	RunePlayer(Caster).ClientMessage("You cast Ultima Recall. Recalling...", 'Subtitle');
	lasthealth = Pawn(Caster).Health;
	lastrunepower = RunePlayer(Caster).RunePower;
	RunePlayer(Caster).RunePower = -100;
	Caster.PlaySound(Sound'OtherSnd.Pickups.pickup01', Slot_None);
	VasCastEffect(pawn(caster));
	VasCastEffect(pawn(caster));
	setTimer(2.5,true);
}

function Timer(){
local MarkLocation Marker;
local MarkLocation GoodMarker;
local bool Foundmarker;

	if(Pawn(Owner) == None)
		return;

RunePlayer(Caster).RunePower = lastrunepower;
	if(Pawn(Caster).Health < Lasthealth){
		RunePlayer(Caster).ClientMessage("Your recall attempt was interrupted!", 'Subtitle');
		Destroy();
		return;
	}
	// Else the person recalls we look for their mark.
	// If none found, they stay where they are.
	ForEach AllActors(class'JetVasSpells.MarkLocation', Marker)
	{
		if(Marker.Owner == Pawn(Caster)){
			GoodMarker = Marker;
			Foundmarker = true;
		}
	}
	if(!Foundmarker){
		RunePlayer(Caster).ClientMessage("You do not have a marked place.", 'Subtitle');
		Destroy();
		return;
	}
	// If everything is good, we recall.
	VasCastEffect(pawn(caster));
	Pawn(Owner).setLocation(GoodMarker.Location+vect(0,0,5));
	VasCastEffect(pawn(caster));
	RunePlayer(Caster).ClientMessage("Recall successful. Marker destroyed.", 'Subtitle');
	GoodMarker.Tele = true;
	GoodMarker.Destroy();
	Destroy();
}

defaultproperties{}
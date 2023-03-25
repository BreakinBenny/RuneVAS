//-----------------------------------------------------------
//VasCSBonuspack1 - By Kal-Corp, Kal-Corp@cfl.rr.com
//	http://Vasserver.dyndns.org/KalsFor
//Base Code and Spell Idea from DungeonMaster
//-----------------------------------------------------------
class VASCSDMCameleon expands VasCastSpell;

var Texture lastTexture;
var int temp;
var float tempspeed;
var int Scriptpawncounter;

function SpellRUN(){
Local INT i;
local Vector teleportSpot;
local NavigationPoint nav;

if(pawn(Caster).SkelGroupSkins[0] != pawn(Caster).default.SkelGroupSkins[0]){
	CastSuccess = false;
	CastMassage="You can't cast this now";
	bEndSpell=TRUE;
}
	CastSuccess = True;
	CastMassage="You cast Chameleon";
	lastTexture=none;
	setTimer(0.3, true);
	Counter=50;
	Scriptpawncounter = RandRange(10, 50);
	Temp = pawn(Caster).RunePower;
	if(bPostSpell)
		PostSpell();
}

Function EndSpell(){
	local int ix;
	if(CastSuccess)
		restoreTexture();
	bEndSpell=TRUE;
}

simulated function timer(){
local int i;
local Texture texture;

	if(!bEndSpell){
		if(!fastTrace(caster.location - vect(50,0,0), caster.location))
			matterTrace(caster.location - vect(50,0,0),	caster.location,, texture);
		else if(!fastTrace(caster.location - vect(-50,0,0), caster.location))
			matterTrace(caster.location - vect(-50,0,0), caster.location,, texture);
		else if(!fastTrace(caster.location - vect(0,50,0),	caster.location))
			matterTrace(caster.location - vect(0,50,0),	caster.location,, texture);
		else if(!fastTrace(caster.location - vect(0,-50,0), caster.location))
			matterTrace(caster.location - vect(0,-50,0), caster.location,, texture);
		else
			matterTrace(caster.location - vect(0,0,50),	caster.location,, texture);

		lastTexture = texture;

		if(texture == none)
			restoreTexture();
		else
			applyTexture(texture);
	}
	else
		restoreTexture();

if(pawn(Caster).RunePower > temp)
	pawn(Caster).RunePower = temp;
	 
pawn(Caster).RunePower -=2;
Temp = pawn(Caster).RunePower;
Scriptpawncounter -= 1;
}

function restoreTexture(){
local int ix;
	for(ix=0; ix<16; ix++)
		pawn(Caster).SkelGroupSkins[ix] = pawn(Caster).Default.SkelGroupSkins[ix];
}

function applyTexture(Texture tex){
local int ix;
	for(ix=0; ix<16; ix++)
		pawn(caster).SkelGroupSkins[ix] = tex;
}

function Tick(float DeltaTime){
if (Caster.IsA('playerPawn'))
{
	if((pawn(Caster).Health<=0) || (pawn(Caster).RunePower<=0))
		EndSpell();
}
if(Caster.IsA('ScriptPawn')){
	if((pawn(Caster).Health<=0) || (Scriptpawncounter<=0))
		EndSpell();
	Super.Tick(DeltaTime);
}

defaultproperties{
	StrTaunt=X3_Taunt
	bEndWithTimer=True
}
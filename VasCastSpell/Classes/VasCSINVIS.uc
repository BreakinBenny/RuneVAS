//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasCSINVIS expands VasCastSpell;

var int oldHealth;
var int temp;
var bool invson;
var int Scriptpawncounter;

function SpellRUN()
{
local Inventory inv;

	if(Caster.style == STY_Translucent)
	{
		CastMassage="You Can not cast this now!";
		PostSpell();
		return;
	}
	invson = true;
	CastSuccess = True;
	CastMassage="You cast Invisibility";
	Caster.style = STY_Translucent;
	Caster.scaleGlow = 0.1;
	pawn(Caster).bInvisible = true;
	Caster.bHidden = false;

	for(inv=pawn(Caster).inventory; inv!=none; inv=inv.inventory)
	{
		inv.style = STY_Translucent;
		inv.scaleGlow = 0.1;
	}
	Scriptpawncounter = RandRange(10, 50);
	Counter=50;
	Temp = pawn(Caster).RunePower;
	SetTimer(1.000000,true);
	if(bPostSpell)
		PostSpell();
}

Function EndSpell()
{
	local Inventory inv;
	invson=False;
	pawn(Caster).bInvisible = false;
	Caster.bHidden = false;
	Caster.style = Caster.default.style;
	Caster.scaleGlow = Caster.default.scaleGlow;

	for(inv=pawn(Caster).inventory; inv!=none; inv=inv.inventory)
	{
		inv.style = inv.default.style;
		inv.scaleGlow = inv.default.scaleGlow;
	}
	bEndSpell=TRUE;
}

function timer()
{
if( pawn(Caster).RunePower > temp )
	pawn(Caster).RunePower = temp;
pawn(Caster).RunePower -=1;
Temp = pawn(Caster).RunePower;
Scriptpawncounter -= 1 ;
}

function Tick(float DeltaTime)
{
local Inventory inv;
local Name stateName;

if (invson)
{
	if(caster !=NONE)
	{
		if(Caster.scaleGlow > 0.0)
		{
			pawn(Caster).bInvisible = false;
			Caster.bHidden = false;
			Caster.scaleGlow -= deltaTime * 2;
			if(Caster.scaleGlow < 0.0)
				Caster.scaleGlow = 0.0;

			for(inv=pawn(Caster).inventory; inv!=none; inv=inv.inventory)
			{
				inv.style = STY_Translucent;
				inv.scaleGlow = Caster.scaleGlow;
			}
		}
		else
		{
			Caster.bHidden = true;
			pawn(Caster).bInvisible = true;
		}

		if(Caster.location != Caster.oldLocation)
		{
			if(pawn(Caster).bduck == 0)
				Caster.scaleGlow = 1.0;
		}

		if (pawn(Caster).weapon != none)
		{
			stateName = pawn(Caster).weapon.getStateName();
			if(pawn(Caster).weapon.isInState('swinging'))
				Caster.scaleGlow = 1.0;
		}

		if(pawn(Caster).health != oldHealth)
		{
			Caster.scaleGlow = 1.0;
			oldHealth = pawn(Caster).health;
		}
	}
	else
		bEndSpell=TRUE;
}
if(Caster != NONE)
{
	if(Caster.IsA('playerPawn'))
	{
		if((pawn(Caster).Health<=0) || (pawn(Caster).RunePower<=0))
			EndSpell();
	}
	if(Caster.IsA('ScriptPawn'))
	{
		if((pawn(Caster).Health<=0) || (Scriptpawncounter<=0))
			EndSpell();
	}
}
else
	bEndSpell=TRUE;

Super.Tick(DeltaTime);
}

defaultproperties
{
	  bEndWithTimer=True
	  SpellLevel=6
}
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasCSGiant expands VasCastSpell;

var int temp;
var float tempspeed;
var float tempcollisionsize1;
var float tempcollisionsize2;
Var weapon weapon, Weapon2;
var int Scriptpawncounter;

function SpellRUN()
{
	if (Caster.drawscale != Caster.Default.Drawscale)
	{
		if((Caster.drawscale == Caster.Default.Drawscale*1.50) && (!Caster.IsA('RunePlayer')))
		{
			EndSpell();
			return;
		}
		CastMassage="You can't cast this now!";
		PostSpell();
		return;
		}

	tempspeed = pawn(Caster).GroundSpeed;
	PlaySound(Sound'OtherSnd.Pickups.pickup01', Slot_None);
	CastMassage="You are Now Big";
	Caster.drawscale = Caster.Drawscale*1.50;
	pawn(Caster).jumpz = pawn(Caster).jumpz * Caster.DrawScale/Caster.Default.DrawScale;
	tempcollisionsize1 = Caster.Default.CollisionRadius*Caster.DrawScale/Caster.Default.DrawScale;
	tempcollisionsize2 = Caster.Default.CollisionHeight*Caster.DrawScale/Caster.Default.DrawScale;
	Caster.SetCollisionSize(tempcollisionsize1,tempcollisionsize2);
	pawn(Caster).GroundSpeed = pawn(Caster).GroundSpeed * Caster.DrawScale/Caster.Default.DrawScale;
	Counter=50;
	Scriptpawncounter = RandRange(10, 50);
	Temp = pawn(Caster).RunePower;
	SetTimer(1.000000,true);
	if(bPostSpell)
		PostSpell();
}

Function EndSpell()
{
if (CastSuccess)
{
	Caster.drawscale = Caster.Default.Drawscale;
	pawn(Caster).jumpz = pawn(Caster).default.jumpz;
	Caster.SetCollisionSize(Caster.default.CollisionRadius, Caster.default.CollisionHeight);
	pawn(Caster).GroundSpeed = tempspeed;
}
	bEndSpell=TRUE;
}

function timer()
{

if ((CastSuccess) && (!bEndSpell))
{
	if(pawn(Caster).weapon != none)
	{
		if(pawn(Caster).weapon != Weapon)
		{
			weapon = pawn(Caster).weapon;
			weapon.Damage = weapon.default.Damage*1.5;
		}
		else
		{
			if(weapon != none)
				weapon.Damage = weapon.default.Damage;
			weapon2 = weapon;
			weapon = pawn(Caster).weapon;
			weapon.Damage = weapon.default.Damage*1.5;
		}
	}
	else
	{
		if(weapon != none)
			weapon.Damage = weapon.default.Damage;
		if(weapon2 != none)
			weapon2.Damage = weapon2.default.Damage;
	}
}

if( pawn(Caster).RunePower > temp )
	pawn(Caster).RunePower = temp;
pawn(Caster).RunePower -=3;
Temp = pawn(Caster).RunePower;
Scriptpawncounter -= 1;
}

function Tick(float DeltaTime)
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
	Super.Tick(DeltaTime);
}

defaultproperties
{
	bEndWithTimer=True
	SpellLevel=6
}
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasArenaVasGodAxe expands DwarfBattleAxe;

var() bool bflameup;

function PostBeginPlay()
{
	DesiredColorAdjust.X = 140;
	SpawnPowerupEffect();
	SwipeClass = PoweredUpSwipeClass;
	bPoweredUp = True;
}

function PowerupEnded(){}

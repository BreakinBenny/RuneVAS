class VM2MonsterUpDater expands Actor;

Var ScriptPawn Monster;
Var Float  sizebonus, fatbonus;
Var int Counter,RandNumber;
Var Bool bVasDebug, INIT;

function PostBeginPlay(){
	Randnumber = Rand(50);
	SizeBonus = 1.0;
	bHidden = true;
	SetTimer(1.000000,true);
}

function timer(){
Local Float tempcollisionsize1,tempcollisionsize2;
local RespawnFire F;

	if(!INIT){
		if(Monster != NONE){
			VasDebug("VM2MonsterUpDater - Monster="$Monster$" SizeBonus="$SizeBonus$" fatbonus="$fatbonus$"  Updater="$self);

			Monster.Drawscale = Monster.Default.Drawscale*SizeBonus;
			Monster.health = Monster.Default.health*SizeBonus;
			Monster.MaxHealth = Monster.Default.health*sizebonus;
			Monster.DesiredFatness += fatbonus;
			//Monster.Mass = Monster.Default.Mass*sizebonus;

 			Monster.Orders = 'Roaming';
			Monster.SetCollision(True, True, True);
			INIT = True;
		}
	}

	if(Counter > 4){
		Counter = 0;
		if(Monster != NONE){
			VasDebug("VM2MonsterUpDater TIMER- Monster="$Monster$" SizeBonus="$SizeBonus$" fatbonus="$fatbonus$"  Updater="$self);

			Monster.jumpz = Monster.jumpz * Monster.DrawScale/Monster.Default.DrawScale;
			tempcollisionsize1 = Monster.Default.CollisionRadius*Monster.DrawScale/Monster.Default.DrawScale;
			tempcollisionsize2 = Monster.Default.CollisionHeight*Monster.DrawScale/Monster.Default.DrawScale;
			Monster.SetCollisionSize(tempcollisionsize1,tempcollisionsize2);
			Monster.GroundSpeed = Monster.GroundSpeed * Monster.DrawScale/Monster.Default.DrawScale;
			//Monster.Mass = Monster.Default.Mass*sizebonus;
			if(Monster.Weapon != none){
				VasDebug("VM2MonsterUpDater - Updating monster Weapon Before damage="$Monster.Weapon.damage$" Monster="$Monster);
				Monster.Weapon.damage = (Monster.Weapon.default.damage*sizebonus)*0.5;
				VasDebug("VM2MonsterUpDater - Updating monster Weapon After damage="$Monster.Weapon.damage$" Monster="$Monster);
			}
		}
		else
			Self.Destroy();
	}
	Counter +=1;
}

function VasDebug(string logtxt){
	if(bVasDebug)
		Log("**** VasMonsters2 VM2MonsterUpDater - "$LogTXT);
}

defaultproperties{}
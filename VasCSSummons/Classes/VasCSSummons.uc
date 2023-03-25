//
//-----------------------------------------------------------
class VasCSSummons expands VasCastSpell Config (VasCSSummon);

Var string SummonName;
Var config string Summons[10];
Var config int NeedtoCast[10];
Var ScriptPawn NewMonster;
Var pawn ally;
var bool canend;
var() config int NumberOfSummons;
Var string SummonState;
Var VasCSSummonRepl VasCSSummonRepl;
Var float summonscalling,summonscalling2;

function SpellRUN()
{
	local int i,ii,temp;
	local rotator RotationDeviation;
	local scriptpawn scriptpawn;
	local bool cancast;

	SummonState = "ATTACK";

	CastSuccess = True;
	if(currentsummon())
	{
		CastMassage="Your summoning power is currently in use";
		CastSuccess = false;
		canend = true;
		PostSpell();
		return;
	}

	temp = Casterlevel;
	SummonName = "";
	cancast = false;
	for(i=0;i<9;i++)
	{
		if((temp > NeedtoCast[i]) && (NeedtoCast[i] != 0))
		{
			if((temp - NeedtoCast[i]) > 20){
				ii=i;
				cancast = true;
				if(Rand(100) < 50)
					ii = i - 1;
				if(Rand(100) < 40)
					ii = i - 2;
				if(Rand(100) < 30)
					ii = i - 3;
				if(Rand(100) < 20)
					ii = i - 4;
				if(Rand(100) < 10)
					ii = i - 5;
			}
		}
		if(!cancast)
		{
			CastMassage="You don't have the ability to summon this!";
			CastSuccess = false;
			canend = true;
			PostSpell();
			return;
		}
		if(ii < 0)
			ii = 0;
		SummonName = Summons[ii];
		if(SummonName == "")
		{
			CastMassage="You fail to cast Summon ";
			CastSuccess = false;
			canend = true;
			PostSpell();
			return;
		}

	CastMassage="You try to Summon "$Summons[ii]$" At Power level "$Casterlevel;
	RotationDeviation.Pitch=800;
	SpawnTheMonster(SummonName, DummyLocation);
	if(CastSuccess)
		SetTimer(1.000000,true);

	if(bPostSpell)
		PostSpell();
	}
}

function bool currentsummon()
{
	local scriptpawn scriptpawn;
	local int temp;

	temp = 0;

	foreach AllActors(class'scriptpawn', scriptpawn)
	{
		if(scriptpawn.Ally == pawn(caster))
			temp += 1;
	}
	if (temp >= NumberOfSummons)
		Return True;
	else
		return false;
}

function ScriptPawn SpawnTheMonster(string MonsterClassString,vector StartingLocation)
{
	local class<ScriptPawn> MonsterClass;

	summonscalling  = casterlevel/20;
	summonscalling2 = summonscalling-3;


	if(summonscalling2 < 1)
		summonscalling2 = 1;
	if(summonscalling2 > 3)
		summonscalling2 = 3;
	if(summonscalling < 1)
		summonscalling = 1;

	MonsterClass=class<ScriptPawn>(DynamicLoadObject(MonsterClassString,class'Class'));

	if(MonsterClass==None)
	{
		CastMassage="Vasgods will not let you summon this!";
		CastSuccess = false;
		return None;
	}

	NewMonster=Spawn(MonsterClass,,,Caster.Location + 150 * Vector(Rotation) + vect(0,0,1) * 15 );

	if(NewMonster==None)
	{
		CastMassage="You summon but nothing happened! - Might not be room for summon?";
		CastSuccess = false;
		return None;
	}

	NewMonster.IgnoreEnemy = pawn(Caster);
	NewMonster.ally = pawn(Caster);
	NewMonster.AttitudeToPlayer = ATTITUDE_Follow;
	NewMonster.ProtectionTimer = 99999;
	NewMonster.AllyMaxTime = 99999;
	NewMonster.bDisableCheckForEnemies = TRUE;
	NewMonster.maxhealth *= summonscalling;
	NewMonster.health *= summonscalling;
	NewMonster.DamageScaling = summonscalling2;

	foreach AllActors(class'VasCSSummonRepl', VasCSSummonRepl)
	{
		if(VasCSSummonRepl.NewMonster == NewMonster)
			return NewMonster;
	}
	VasCSSummonRepl = Spawn(Class'VasCSSummons.VasCSSummonRepl',caster) ;
	if (VasCSSummonRepl != NONE)
	{
		VasCSSummonRepl.NewMonster = NewMonster;
		VasCSSummonRepl.ally = pawn(caster);
		VasCSSummonRepl.SummonState = "ATTACK";
	}
	return NewMonster;
}

Function EndSpell()
{
	if(!canend)
		return;

	//If(NewMonster != none)
	//{
	//	NewMonster.Died(none, 'gibbed', NewMonster.Location);
	//}

	//if(VasCSSummonRepl != NONE)
	//	VasCSSummonRepl.Destroyed();

	canend = true;
	bEndSpell=TRUE;
}

function timer()
{
	local scriptpawn scriptpawn;
	local Pawn P;
	local bool masterfound;
	local float radius;
	local vector newLocation;
	local VasCSSummonNothing VasCSSummonNothing;
	local RespawnFire F;

	if(NewMonster == none)
	{
		EndSpell();
		return;
	}

	masterfound = false;
	radius = 1500;
	foreach NewMonster.RadiusActors(class'Pawn', P, radius)
	{
		if(P==NewMonster)
			continue;
		if(P==caster)
		{
			masterfound = true;
			continue;
		}
		if(p.isa('Scriptpawn'))
			if(Scriptpawn(p).ally == pawn(caster))
				if(Scriptpawn(p).enemy == none)
					Scriptpawn(p).Enemy = NewMonster.enemy;
	}

	ally = pawn(caster);
	if(NewMonster.Health > 0)
	{
		NewMonster.ally = pawn(caster);

		if(pawn(caster).ScaleGlow == 2)
			VasCSSummonRepl.Attackothers = False;
		else
			VasCSSummonRepl.Attackothers = True;

		SummonState = VasCSSummonRepl.SummonState;
		NewMonster.Intelligence = BRAINS_HUMAN;
		NewMonster.IgnoreEnemy = pawn(caster);
		NewMonster.bRoamHome = false;
		NewMonster.bDisableCheckForEnemies = TRUE;
		NewMonster.groundspeed = NewMonster.default.groundspeed*1.5;
		NewMonster.AccelRate = NewMonster.default.AccelRate*1.5;
		NewMonster.WalkingSpeed = NewMonster.default.WalkingSpeed*1.5;
		NewMonster.CombatRange = NewMonster.default.CombatRange;
		if((NewMonster.health < NewMonster.Maxhealth) &&(NewMonster.enemy == NONE))
			NewMonster.health += 2;

		if(NewMonster.enemy != none)
			if((NewMonster.enemy.ScaleGlow == 2) && (pawn(caster).ScaleGlow == 2))
				NewMonster.enemy= none;

		switch(SummonState)
		{
			case "STAY":
				NewMonster.AttitudeToPlayer = ATTITUDE_Follow;
				NewMonster.HuntDistance = 0;
				NewMonster.bHurrying = false;
				NewMonster.ProtectionTimer = 0;
				NewMonster.SightRadius = 0;
				NewMonster.AllyMaxTime = 0;
				if((NewMonster.health < NewMonster.Maxhealth) &&(NewMonster.enemy == NONE))
					NewMonster.health += 10;
			break;
			case "ATTACK":
			case "GUARD":
				NewMonster.AttitudeToPlayer = ATTITUDE_Follow;
				NewMonster.HuntDistance = 99999;
				NewMonster.bHurrying = TRUE;
				newLocation = NewMonster.Ally.location - ( (100+rand(200)) * (Vector(caster.Rotation)) + vect(0,0,1) * 15);
				NewMonster.ProtectionTimer = 999;
				NewMonster.SightRadius = NewMonster.default.SightRadius;
				NewMonster.HomeBase = newLocation;
				NewMonster.AllyMaxTime = 999;
				CheckForEnemies();
			break;
			case "FOLLOW":
				NewMonster.AttitudeToPlayer = ATTITUDE_Ignore;
				NewMonster.HuntDistance = 99999;
				NewMonster.bHurrying = TRUE;
				newLocation = NewMonster.Ally.location - ( (100+rand(200)) * (Vector(caster.Rotation)) + vect(0,0,1) * 15);
				NewMonster.ProtectionTimer = 999;
				NewMonster.SightRadius = NewMonster.default.SightRadius;
				NewMonster.HomeBase = newLocation;
				NewMonster.AllyMaxTime = 999;
				NewMonster.enemy = none;
				NewMonster.CombatRange = 0;

				/*	if(!masterfound){
						VasCSSummonNothing=Spawn(class'VasCSSummonNothing',,,newLocation);
						if(VasCSSummonNothing != NONE)
							if(!VasCSSummonNothing.PlayerCanSeeMe()){
								VasCSSummonNothing.destroy();
								F = Spawn(class'RespawnFire',,,NewMonster.location);
								NewMonster.SetLocation(newLocation);
								F = Spawn(class'RespawnFire',,,newLocation);
							}
					}
				*/
				NewMonster.GotoState('GoingHome');

			break;
		}
	}

	if(Caster != NONE){
		//if (pawn(Caster).Health<=0){
		//	canend = true;
		//	EndSpell();
		//}
	}
	else{
		canend = true;
		EndSpell();
	}
}

function CheckForEnemies()
{
	local Pawn P, ClosestEnemy;
	local float Dist,LeastDist;
	local float radius;
	local VasCSSummonRepl VasCSSummonRepl ;
	local bool attackothers,btemp;

	if(NewMonster == none)
		return;

	LeastDist=9999999.0;
	radius = 2000.000000;
	foreach NewMonster.RadiusActors(class'Pawn', P, radius)
	{
		if(P==NewMonster || P==caster)
			continue;
		if (P.IsA('FlockPawn'))
			continue;
		if(P.ISA('scriptpawn'))
			if(scriptpawn(P).Ally != NONE)
			{
				if(scriptpawn(P).Ally == pawn(caster))
					continue;
				btemp = false;
				foreach AllActors(class'VasCSSummonRepl', VasCSSummonRepl)
				{
					if(VasCSSummonRepl.NewMonster == p)
					{
						btemp = true;
						attackothers = VasCSSummonRepl.attackothers;
					}
				}
				if((btemp) && (!attackothers) && (pawn(caster).ScaleGlow == 2))
					continue;
			}
			dist = VSize(P.Location-NewMonster.Location);

			if((SummonState == "GUARD") && (P.bIsPlayer))
				continue;
			if((p.ScaleGlow == 2) && (pawn(caster).ScaleGlow == 2))
				continue;

			if(P.bIsPlayer)
				dist *= 0.50;
			if(attackothers)
				dist *= 0.25;

			if (dist<LeastDist){
				if (NewMonster.actorReachable(P) || NewMonster.FindBestPathToward(P)){
					LeastDist=Dist;
					ClosestEnemy=P;
				}
			}
	}

	if (ClosestEnemy != None){
		if(ClosestEnemy.bisplayer){
			NewMonster.Enemy = ClosestEnemy;
			NewMonster.EnemyAcquired();
		}
		else
			NewMonster.SetEnemy(ClosestEnemy);
	}
	else
		NewMonster.GotoState('GoingHome');
}

defaultproperties{
	NumberOfSummons=1
	StrTaunt=X3_Taunt
	bEndWithTimer=True
}
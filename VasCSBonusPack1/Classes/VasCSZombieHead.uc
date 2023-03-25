//-----------------------------------------------------------
//VasCSBonuspack1 - By Kal-Corp, Kal-Corp@cfl.rr.com
//	http://Vasserver.dyndns.org/KalsFor
//-----------------------------------------------------------
class VasCSZombieHead expands VasCastSpell;

Var string SummonName;
Var head head;
Var ScriptPawn NewMonster;
var bool monsterspawned;

function PostBeginPlay(){
bCastwithWeapon = true;
Super.PostBeginPlay();
}

function SpellRUN(){
	CastSuccess = True;

	if(pawn(Caster).Weapon != NONE){
		if(!pawn(Caster).Weapon.isa('head'))
			CastMassage="You need a Head to summon from";
		else if(pawn(Caster).Weapon.isa('ZombieHead'))
			CastMassage="You need a FRESH head, not a Zombie head";
		CastSuccess = false;
		head = head(pawn(Caster).weapon);
	}
	else{
		CastMassage="You need a Head to summon from";
		CastSuccess = false;
	}

	if(CastSuccess){
		SetTimer(1.000000,true);
		CastMassage="You summon the undead from this head. Now release it!";
		SummonName = "RuneI.Zombie";
	}

	if(bPostSpell)
		PostSpell();
}

function SpawnTheMonster(string MonsterClassString){
local class<ScriptPawn> MonsterClass;

	MonsterClass=class<ScriptPawn>(DynamicLoadObject(MonsterClassString,class'Class'));

	if(MonsterClass==None)
		return;

	NewMonster=Spawn(MonsterClass,,,head.Location);

	if(NewMonster==None)
		 return;
	NewMonster.health = 3*Casterlevel;
	NewMonster.IgnoreEnemy = pawn(Caster);
	NewMonster.ally = pawn(Caster);
	VasCastEffect(head);
	monsterspawned = true;
}

function Timer(){
if(head != none){
	if(Head.LifeSpan > 0){
		SpawnTheMonster(SummonName);
		Head.Destroy();
	}
}

if(monsterspawned){
	if(NewMonster != none)
		bEndSpell=TRUE;
	else{
		NewMonster.IgnoreEnemy = pawn(Caster);
		NewMonster.ally = pawn(Caster);
		NewMonster.AttitudeToPlayer = ATTITUDE_Hate;
		NewMonster.gotostate('Roaming');
		if(NewMonster.enemy != none)
			NewMonster.PowerupFriend(pawn(Caster));
	}
}
}

defaultproperties{
	StrTaunt=X3_Taunt
	bCastwithWeapon=True
	bEndWithTimer=True
}
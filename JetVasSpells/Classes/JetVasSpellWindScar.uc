//=============================================================================
// JetVasSpellWindScar.
//=============================================================================
class JetVasSpellWindScar expands VasCastSpell;


function PostBeginPlay(){
bCastwithWeapon = true;
StrTaunt = 'S5_AttackA';
Super.PostBeginPlay();
}

function SpellRUN(){
	if(Pawn(Caster).Weapon.skeletal != SkelModel'weapons.battlesword' || Pawn(Caster).Weapon.Drawscale < Caster.Drawscale*1.1){
		RunePlayer(Caster).ClientMessage("You fail to harness the power of the Wind Scar!", 'subtitle');
		Destroy();
		return;
	}
	DamagePoints = RandRange(Casterlevel/2, Casterlevel);
	if(DamagePoints < 40)
		DamagePoints = 40;
	CastMassage="Wind Scar!";
	ThrowFireball();
	PostSpell();
}

Function ThrowFireball(){
local Projectile ball;
local vector FireLocation;
local int ballspeed;

	CastSuccess = True;
	if(!Caster.isa('Dragons'))
		FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('rwrist'));
	else
		FireLocation = pawn(Caster).GetJointPos(pawn(Caster).JointNamed('llip'));

	ball = Spawn(class'WindScar',Caster,,FireLocation,pawn(Caster).ViewRotation);
	ball.SetPhysics(PHYS_Projectile);
	ball.Velocity = DummyLocation * ball.Speed;
	ball.Velocity.Z = 0;
	ball.Damage = DamagePoints;
	ball.Instigator = Pawn(Caster);
	setLocation(Caster.Location);
	PlaySound(Sound'OtherSnd.Explosions.explosion05', SLOT_Misc,,,, 1.0 + FRand()*0.4-0.2);
}

defaultproperties{}
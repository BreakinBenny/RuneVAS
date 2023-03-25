//=============================================================================
// JetVasSpellPoisonProj.
//=============================================================================
class JetVasSpellPoisonProj expands Projectile;

var ParticleSystem effect;

simulated function PreBeginPlay()
{
	effect = Spawn(class'JetVasSpells.PoisonTrail', , , , Rotation);
	effect.LifeSpan = 100;
	effect.SetBase(self);
}

simulated function Destroyed()
{
	if(effect != None)
		effect.Destroy();
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	local pawn damagefrom;
	local Poison PA;

	if(owner != NONE)
		damagefrom = pawn(owner);
	else
		damagefrom = NONE;

	if(other != NONE)
	{
		if(other != owner)
		{
			if(Other.IsA('Weapon'))
				return;
			if(Other.IsA('pawn'))
			{
				pawn(Other).JointDamaged(Damage,damagefrom, HitLocation, MomentumTransfer*Normal(Velocity), MyDamageType, 0);
				if(Pawn(Other) != None)
				{
					PA = spawn(class'JetVasSpells.Poison',self, , HitLocation);
					PA.Victim = Pawn(Other);
					PA.OwnedBy = Pawn(Owner);
					PA.DamagePerSec = Damage;
					if (Other.isA('RunePlayer'));
						RunePlayer(Other).ClientMessage("You feel a bit ill", 'subtitle');
					//PlaySound(Sound'JetVasSounds.Package0.Poison', SLOT_None);
					Explode(Other.Location+vect(0,0,1)*Pawn(Other).EyeHeight, -Normal(Velocity));
				}
				else
					Explode(HitLocation, -Normal(Velocity));
			}
		}
	}
}

simulated function Landed(vector HitNormal, actor HitActor)
{
	Explode(Location, HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local JVSP JVSP;
	JVSP = spawn(class'JetVasSpells.JVSP',self, , HitLocation);
	JVSP.Sound = Sound'JetVasSounds.Package0.Poison';
	Destroy();
}

simulated function Debug(Canvas canvas, int mode)
{
	Super.Debug(canvas,mode);
	Canvas.DrawLine3D(Location, Location + vector(Rotation) * 50, 0,0,250);
}

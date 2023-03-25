//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasShields expands Shield config(VasShields);

var bool bFireshield,bStone,bice;
var() string VasPickupMessage;
var() string VasMagicTitle;
Var() Bool bVasNewItem;
Var() Bool bVASBreakable;
var() int vasrating;
var() float vasmass;
var() float vasDrawscale;
var() float vasHealth;
var() int RandNumber;
Var() Config int SmallPercent;
Var() Config int NormalPercent;
Var() Config int LargePercent;
Var() Config int MagicPercent;
Var() Config int Normal;
Var() Config int Durable;
Var() Config int Substantial;
Var() Config int Massive;
Var() Config int Fortified;
Var() Config int Indestructible;
Var bool bFixMonsterSpawn;
var bool bChanged;

var int ShieldHealthBonus;
var int ShieldSTRBonus;
var int ShieldDexBonus;
var int ShieldINTBonus;
var int ShieldFireRes;

Var int DestroyCounter;


replication{
reliable if(Role==ROLE_Authority)
	VasChangeItem,VasPickupMessage,DestroyCounter;
}

function timer(){
bFixMonsterSpawn=false;

if((bFireshield) && (!Bhidden))
	fireshield();

if(!bChanged)
	VasChangeItem();
if(DestroyCounter > 10){
	if(bStone)
		Owner.JointDamaged(5, pawn(Owner), owner.Location, vect(0, 0, 0), 'stone', 0);
	if(bICE)
		Owner.JointDamaged(5000, pawn(Owner), owner.Location, vect(0, 0, 0), 'ICE', 0);
	pawn(Owner).PowerupStone(pawn(owner));
	pawn(owner).Clientmessage("You have over used the power from your shield!");
	Self.Destroy();
}

if(owner != none){
	if(owner.isa('pawn')){
		if(pawn(owner).shield != none){
			if(ShieldSTRBonus > 0){
				if(pawn(owner).Strength < ShieldSTRBonus)
					pawn(owner).Strength = ShieldSTRBonus;
			}
			if(ShieldSTRBonus < 0){
				if(pawn(owner).weapon != none){
					pawn(owner).Strength = 0;
					if(pawn(owner).Health > (pawn(owner).maxhealth*0.5) )
						pawn(owner).Health -= 4;
				}
			}

/*if(ShieldDexBonus != 0)
	pawn(owner).GroundSpeed = pawn(owner).default.GroundSpeed+(ShieldDexBonus*4);
*/

	if(ShieldINTBonus != 0){
		if(pawn(owner).RunePower < ShieldINTBonus)
			pawn(owner).RunePower += 1;
		if((ShieldINTBonus < 0) && (pawn(owner).RunePower > 0))
			pawn(owner).RunePower -= 4;
/*		if((ShieldINTBonus < 0) && (pawn(owner).maxPower > (pawn(owner).Default.maxPower*0.5) ))
			pawn(owner).Maxpower -= 4; */
	}
	if(ShieldHealthBonus > 0){
		if(pawn(owner).Health < pawn(owner).MaxHealth)
			pawn(owner).Health += 2;
	}
	if(ShieldHealthBonus == -99){
		if(pawn(owner).Health > 2)
			pawn(owner).Health -= 3;
	}
	}
	}
	}
}

function DestroyEffect(){
	local int i, numchunks, NumSourceGroups;
	local debris d;
	local debriscloud c;
	local vector loc;
	local float scale;

	c = Spawn(class'DebrisCloud');
	if(c != None)
		c.SetRadius(Max(CollisionRadius,CollisionHeight));

	numchunks = Clamp(Mass/10, 2, 15);

	scale = (CollisionRadius*CollisionRadius*CollisionHeight) / (numchunks*500);
	scale = scale ** 0.3333333;
	for(NumSourceGroups=1; NumSourceGroups<16; NumSourceGroups++){
		if(SkelGroupSkins[NumSourceGroups] == None)
			break;
	}

	for(i=0; i<numchunks; i++){
		loc = Location;
		loc.X += (FRand()*2-1)*CollisionRadius;
		loc.Y += (FRand()*2-1)*CollisionRadius;
		loc.Z += (FRand()*2-1)*CollisionHeight;
		d = Spawn(class'debriswood',,,loc);
		if(d != None){
			d.SetSize(scale);
			d.SetTexture(SkelGroupSkins[i%NumSourceGroups]);
		}
	}
}

function PostBeginPlay(){
	bChanged=false;
	bfixMonsterSpawn=true;
	SetTimer(1.000000,true);
	bVasNewItem = True;
	Super(Shield).PostBeginPlay();
	Self.Respawntime= Default.Respawntime;
}

function VasChangeItem(){
local int randnumber;
local actor A;

	bChanged=true;
	VasPickupMessage = "";
	vasmass = Default.Mass;
	vasRating = Default.Rating;
	vasHealth = Default.Health;
	vasDrawscale = Default.Drawscale ;
	bVASBreakable = Self.bBreakable;
	bFireshield = Default.bFireshield;
	bStone = Default.bStone;
	bice = Default.bice;
	bFireshield = False;
	bStone = false;
	bice = false;

	randnumber = Rand(100);
		if(Randnumber<=SmallPercent){
			VasPickupMessage = VasPickupMessage$"Small " ;
			vasDrawscale = 0.75;
			vasmass =  (vasmass*0.50);
			vasRating =  (vasRating*0.75);
			vasHealth = (vasHealth*0.75);
		}
		if((Randnumber>SmallPercent) && (Randnumber<=(SmallPercent+NormalPercent)))
			vasDrawscale = 1.0;
		if((Randnumber>(SmallPercent+NormalPercent)) && (Randnumber<=(SmallPercent+NormalPercent+LargePercent))){
			VasPickupMessage = VasPickupMessage$"Large " ;
			vasDrawscale = 1.50;
			vasmass =  (Vasmass*1.50);
			vasRating =  (VasRating*2);
			vasHealth = (vasHealth*2);
		}

		RandNumber=Rand(100);
		if(Randnumber<=Normal){}
		if((Randnumber>Normal) && (Randnumber<=(Normal+Durable))){VasPickupMessage = VasPickupMessage$"Durable " ;
			vasRating =  (vasRating*1.30);
			vasHealth = (vasHealth*2);}
		if((Randnumber>(Normal+Durable)) && (Randnumber<=(Normal+Durable+Substantial))){VasPickupMessage = VasPickupMessage$"Substantial " ;
			asHealth = (vasHealth*3);
			asRating =  (vasRating*1.60);}
		if((Randnumber>(Normal+Durable+Substantial)) && (Randnumber<=(Normal+Durable+Substantial+Massive))){VasPickupMessage = VasPickupMessage$"Massive " ;
			vasRating =  (vasRating*1.85);
			vasHealth = (vasHealth*4);}
		if((Randnumber>(Normal+Durable+Substantial+Massive)) && (Randnumber<=(Normal+Durable+Substantial+Massive+Fortified))){VasPickupMessage = VasPickupMessage$"Fortified " ;
			vasRating =  (vasRating*2.5);
			vasHealth = (vasHealth*5);}
		if((Randnumber>(Normal+Durable+Substantial+Massive+Fortified)) && (Randnumber<=(Normal+Durable+Substantial+Massive+Fortified+Indestructible))){VasPickupMessage = VasPickupMessage$"Indestructible " ;
			vasRating =  (vasRating*5);
			vasHealth = 100;
			bVASBreakable=False;}

	VasPickupMessage = VasPickupMessage$Default.PickupMessage;

	randnumber = Rand(100);
		if(Randnumber<=MagicPercent){
		randnumber = Rand(15);
		switch(randnumber){
			case 0:
			case 1:
			VasMagicTitle=" of Strength";
			ShieldSTRBonus = RandRange(20,60);
			ShieldDexBonus = 0;
			ShieldINTBonus = 0;
			ShieldHealthBonus = 0;
			break;
			case 2:
			case 3:
			VasMagicTitle=" of Life Steal";
			ShieldDexBonus = 0;
			ShieldINTBonus = 0;
			ShieldSTRBonus = 0;
			ShieldHealthBonus = -99;
			break;
			case 4:
			case 5:
			VasMagicTitle=" of Power";
			ShieldINTBonus = RandRange(20,60);
			ShieldDEXBonus = 0;
			ShieldSTRBonus = 0;
			ShieldHealthBonus = 0;
			break;
			case 6:
			VasMagicTitle=" of Weakness";
			ShieldSTRBonus = RandRange(-20,-60);
			ShieldDEXBonus = 0;
			ShieldINTBonus = 0;
			ShieldHealthBonus = 0;
			break;
			case 7:
			VasMagicTitle=" of RunePowerDrain";
			ShieldINTBonus = RandRange(-20,-60);
			ShieldDEXBonus = 0;
			ShieldSTRBonus = 0;
			ShieldHealthBonus = 0;
			break;
			case 8:
			case 9:
			VasMagicTitle=" of Fire";
			ShieldINTBonus = 0;
			ShieldDEXBonus = 0;
			ShieldSTRBonus = 0;
			ShieldHealthBonus = 0;
			bFireshield = True;
			break;
			case 10:
			VasMagicTitle=" of the VasGods";
			randnumber = RandRange(20,100);
			ShieldINTBonus = randnumber;
			ShieldDEXBonus = randnumber;
			ShieldSTRBonus = randnumber;
			ShieldHealthBonus = randnumber;
			break;
			case 12:
			case 12:
			case 13:
			randnumber = RandRange(20,100);
			VasMagicTitle=" of Life";
			ShieldINTBonus = 0;
			ShieldDEXBonus = 0;
			ShieldSTRBonus = 0;
			ShieldHealthBonus = randnumber;
			break;
			case 14:
			randnumber = RandRange(20,100);
			VasMagicTitle=" of Stone";
			ShieldINTBonus = 0;
			ShieldDEXBonus = 0;
			ShieldSTRBonus = 0;
			ShieldHealthBonus = 0;
			bStone = True;
			break;
			case 15:
			randnumber = RandRange(20,100);
			VasMagicTitle=" of ICE";
			ShieldINTBonus = 0;
			ShieldDEXBonus = 0;
			ShieldSTRBonus = 0;
			ShieldHealthBonus = 0;
			bice = True;
			break;
			}

		VasPickupMessage = VasPickupMessage$VasMagicTitle;
		vasRating = (Rating*1.25);
		}

Self.Pickupmessage = VasPickupMessage;
Self.Mass = vasmass;
Self.Rating = vasRating;
Self.Health = vasHealth;
Self.Drawscale = vasDrawscale;
Self.bBreakable = bVASBreakable;
Self.bFireshield = bFireshield;
Self.bStone = bStone;
Self.bice = bice;

bVasNewItem = False;
}

State Sleeping{
ignores Touch;

	function BeginState(){
		bSweepable=false;
		SetCollision( false, false, false );
		SetPhysics(PHYS_None);
		bLookFocusPlayer = false;
		bLookFocusCreature = false;
		bHidden = true;
	}
	function EndState(){
		local int i;

		bSweepable=Default.bSweepable;
		BecomePickup();
		bSleepTouch = false;
		for(i=0; i<4; i++)
			if((Touching[i] != None) && Touching[i].IsA('Pawn'))
				bSleepTouch = true;
	}			
Begin:
	if(bFixMonsterSpawn)
		self.Destroy();

	Sleep(Default.ReSpawnTime);
	VasChangeItem();
	PlaySound(RespawnSound);
	Sleep(Level.Game.PlaySpawnEffect(self));
	GoToState('Pickup');
}

auto state Pickup{
	function BeginState(){
		if(bFireshield)
			fireshield();
		bSweepable=false;
		BecomePickup();
		bCollideWorld = true;
		if(bTossedOut && bExpireWhenTossed)
			LifeSpan=ExpireTime;
	}
	
	function EndState(){
		bSweepable=Default.bSweepable;
		BecomeItem();
		bCollideWorld = false;
		LifeSpan=0;
	}
	
	function Touch(Actor Other){
		local Inventory Copy;

		if(Other.IsA('Pawn')){
			if(Pawn(Other).Health > 0 && Pawn(Other).CanPickUp(self)){
				if(Level.Game.LocalLog != None)
					Level.Game.LocalLog.LogPickup(Self, Pawn(Other));
				if(Level.Game.WorldLog != None)
					Level.Game.WorldLog.LogPickup(Self, Pawn(Other));
				Copy = SpawnCopy(Pawn(Other));
				
				if(bVasNewItem){VasPickupMessage=Self.Pickupmessage;}
				if(Other.IsA('Playerpawn')){
					Pawn(Other).ClientMessage("You pick up a "$VasPickupMessage, 'Subtitle');
					Copy.PlaySound(PickupSound);
				}
				if(bVasNewItem){
				if(Shield(Copy) != NONE){
				VasPickupMessage=Self.Pickupmessage;
				Shield(Copy).Drawscale = Self.Drawscale;
				Shield(Copy).Rating = self.Rating;
				Shield(Copy).Health = Self.Health;
				Shield(Copy).mass = self.mass;
				Shield(Copy).bBreakable = self.bBreakable;
				VasShields(Copy).ShieldSTRBonus = Self.ShieldSTRBonus;
				VasShields(Copy).ShieldDexBonus = Self.ShieldDexBonus;
				VasShields(Copy).ShieldINTBonus = Self.ShieldINTBonus;
				VasShields(Copy).ShieldHealthBonus = Self.ShieldHealthBonus;
				VasShields(Copy).bFireshield = Self.bFireshield;
				VasShields(Copy).bStone = Self.bStone;
				VasShields(Copy).bChanged = Self.bChanged ;
				VasShields(Copy).DestroyCounter = Self.DestroyCounter ;
				VasShields(Copy).bice = Self.bice;

				//VasShields(Copy).VasPickupMessage = Self.VasPickupMessage;
				}
				}
				Else
					if(Shield(Copy) != NONE)
				VasShields(Copy).ShieldSTRBonus = ShieldSTRBonus;
				VasShields(Copy).ShieldDexBonus = ShieldDexBonus;
				VasShields(Copy).ShieldINTBonus = ShieldINTBonus;
				VasShields(Copy).ShieldHealthBonus = ShieldHealthBonus;
				Shield(Copy).Drawscale = vasDrawscale;
				Shield(Copy).Rating = vasRating;
				Shield(Copy).Health = vasHealth;
				Shield(Copy).mass = vasmass;
				Shield(Copy).bBreakable = bBreakable;
				VasShields(Copy).bFireshield = bFireshield;
				VasShields(Copy).bStone = bStone;
				VasShields(Copy).bChanged = bChanged;
				VasShields(Copy).DestroyCounter = DestroyCounter;
				VasShields(Copy).bice = bice;

				// VasShields(Copy).VasPickupMessage = VasPickupMessage;
				}
				}
				if(Shield(Copy) != NONE)
					Shield(Copy).Pickupmessage = VasPickupMessage;
				if(Level.Game.Difficulty > 1)
					Other.MakeNoise(0.1 * Level.Game.Difficulty);
				Pawn(Other).AcquireInventory(Copy);
				if(!Pawn(Other).IsInState('PlayerSwimming'))
					Copy.GotoState('Idle');
			}
		}
	}
	
begin:
	AmbientGlow = 0;
	SkelMesh = Default.SkelMesh;
}

function inventory SpawnCopy( pawn Other ){
	local inventory Copy;
	if(!self.bTossedOut){
		Copy = spawn(Class,Other,,,rot(0,0,0));
		if(Copy == None){
			log(name@"cannot be spawned in spawncopy");
			return(Copy);
		}
		Copy.Tag	 = Tag;
		Copy.Event	= Event;
		GotoState('Sleeping');
	}
	else
		Copy = self;

	Copy.bTossedOut = true;
	Copy.RespawnTime = 0.0;
	Copy.GiveTo(Other);
	return Copy;
}

state Active{
	function BeginState(){
		SetPhysics(PHYS_None);
	}
	
	function EndState(){}
begin:
}

state Drop{
	ignores JointDamaged;

	function BeginState(){
		SetPhysics(PHYS_Falling);
		SetCollision(true, false, false);
		bCollideWorld = true;
		bBounce = true;
		bFixedRotationDir = true;
		DesiredRotation.Yaw = Rotation.Yaw + Rand(2000) - 1000;
		RotationRate.Yaw = 60000;
		DesiredRotation.Pitch = Rotation.Pitch + Rand(2000) - 1000;
		RotationRate.Pitch = 60000;
		bMadeDropSound = false;
	}
	
	function EndState(){
		bBounce = false;
		SetCollision(false, false, false);
		bCollideWorld = false;
		bBounce = false;		
		bFixedRotationDir = false;
	}
	
	function Landed(vector HitNormal, actor HitActor){
		HitWall(HitNormal, HitActor);
	}
	
	function HitWall(vector HitNormal, actor HitActor){
		local float speed;

		if(!bMadeDropSound && !Region.Zone.bWaterZone){
			bMadeDropSound=true;
			PlaySound(DropSound, SLOT_Interact);
			MakeNoise(1.0);
		}

		speed = VSize(velocity);
		if((HitNormal.Z > 0.8) && (speed < 60)){
			if(DesiredRotation.Roll ~= Rotation.Roll && DesiredRotation.Pitch ~= Rotation.Pitch){
				SetPhysics(PHYS_None);
				bBounce = false;
				bFixedRotationDir = false;
			
				GotoState('Pickup');
			}
			else{
				DesiredRotation.Roll = 0;
				DesiredRotation.Pitch = 32768;
				RotationRate.Roll = 60000;
				RotationRate.Pitch = 80000;
				bRotateToDesired = true;
				bFixedRotationDir = false;

				Velocity.Z = 60;
			}
		}
		else{			
			SetPhysics(PHYS_Falling);
			RotationRate.Yaw = VSize(Velocity) * 150;
			RotationRate.Pitch = VSize(Velocity) * 100;
			
			Velocity = 0.7 * (Velocity - 2 * HitNormal * (Velocity Dot HitNormal));
			DesiredRotation = rotator(HitNormal);
		}
	}

	function Touch(Actor Other){
		local inventory Copy;

		if(Other.IsA('Pawn')){
			if(Pawn(Other).Health > 0 && Pawn(Other).CanPickUp(self)){
				if(Level.Game.LocalLog != None)
					Level.Game.LocalLog.LogPickup(Self, Pawn(Other));
				if(Level.Game.WorldLog != None)
					Level.Game.WorldLog.LogPickup(Self, Pawn(Other));
				Copy = SpawnCopy(Pawn(Other));

				if(PickupMessageClass == None)
					Pawn(Other).ClientMessage(PickupMessage, 'Pickup');
				else
					Pawn(Other).ReceiveLocalizedMessage( PickupMessageClass, 0, None, None, Self.Class);

				Copy.PlaySound (PickupSound);
				if(Level.Game.Difficulty > 1)
					Other.MakeNoise(0.1 * Level.Game.Difficulty);
				Pawn(Other).AcquireInventory(Copy);

				if(!Pawn(Other).IsInState('PlayerSwimming'))
					Copy.GotoState('Active');
			}
		}
	}
}

state Smashed{
	ignores JointDamaged;

	function BeginState(){
		local int joint;
		local Pawn ThePawn;

		ThePawn = Pawn(Owner);
		if(ThePawn != None){
			joint = ThePawn.JointNamed(ThePawn.ShieldJoint);
			if(joint != 0){
				ThePawn.DetachActorFromJoint(joint);
				ThePawn.DeleteInventory(self);
			}
		}

		DestroyEffect();
		PlaySound(DestroyedSound, SLOT_Pain);
		Destroy();
	}

begin:
}

state Idle{
	function BeginState(){
	 if(bFireshield)
		fireshield();
	}
begin:
}

function bool JointDamaged(int Damage, Pawn EventInstigator, vector HitLoc, vector Momentum, name DamageType, int joint){
	local vector AdjMomentum;
	local Pawn P;

	PlayHitSound(DamageType);

	if(bBreakable){
		if(Pawn(Owner)!=None && PlayerPawn(Owner)==None && FRand()*Level.Game.Difficulty < 0.2){
			Pawn(Owner).DropShield();
			return false;
		}
			
		Health -= Damage * 0.4;
	}

	if(Owner != None){
		AdjMomentum = momentum / Owner.Mass;
		if(Owner.Mass < VSize(AdjMomentum) && Owner.Velocity.Z <= 0)
			AdjMomentum.Z += (VSize(AdjMomentum) - Owner.Mass) * 0.5;

		P = Pawn(Owner);
		P.AddVelocity(AdjMomentum);
	}

	if(bFireshield){
		DamageType = 'fire';
		Damage = 10;
		EventInstigator.JointDamaged(Damage, EventInstigator, EventInstigator.Location, vect(0, 0, 0), DamageType, 0);
	}

	if(bStone){
		DamageType = 'stone';
		Damage = 10;
		EventInstigator.JointDamaged(Damage, EventInstigator, EventInstigator.Location, vect(0, 0, 0), DamageType, 0);
		EventInstigator.PowerupStone(pawn(owner));
		DestroyCounter += 1;
	}
	if(bice){
		DamageType = 'ICE';
		Damage = 10;
		EventInstigator.JointDamaged(Damage, EventInstigator, EventInstigator.Location, vect(0, 0, 0), DamageType, 0);
		EventInstigator.PowerupStone(pawn(owner));
		DestroyCounter += 1;
	}

	if(Health < 1){
		GotoState('Smashed');
		return(true);
	}
	return(false);
}

function fireshield(){
local PawnFire F;

	if(bFireshield){
		F = Spawn(class'PawnFire',self);
		if(F != None)
			AttachActorToJoint(F, 1);
	}
}

defaultproperties{
	SmallPercent=30
	NormalPercent=60
	LargePercent=10
	MagicPercent=2
	Normal=30
	Durable=20
	Substantial=20
	Massive=10
	Fortified=10
	Indestructible=10
	PickupMessageClass=Class'RuneI.PickupMessage'
}
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VW2Weapons expands Weapon config(VasWeapons2);

var string VasPickupMessage;
var() string VasMagicTitle;
Var() Bool bVasNewItem;
var() int vasrating;
var() float vasmass;
var() float vasDrawscale;
var() float vasDamage;
Var() Bool vasbCanBePoweredUp;
var() int RandNumber;
var() int VasRunePowerRequired;
Var() Config Bool AutoMagic;
Var() Config int SmallPercent;
Var() Config int NormalPercent;
Var() Config int LargePercent;
Var() Config int MagicPercent;
Var() Config int NormalDamage;
Var() Config int RuinDamage;
Var() Config int MightDamage;
Var() Config int ForceDamage;
Var() Config int PowerDamage;
Var() Config int Vaqdamage;
Var() Bool bVasPoweredUp;
var bool bChangeonfirstspawn;
Var int DestroyCounter;

var int WeaponHealthBonus,WeaponINTBonus,WeaponSTRBonus;
var bool bStone,bice;

replication{
reliable if(Role==ROLE_Authority)
	WeaponHealthBonus,WeaponINTBonus,WeaponSTRBonus,bStone,bice,
bVasPoweredUp,VasPickupMessage,VasMagicTitle;
}

function timer(){
	if(DestroyCounter > 10){
		if(bStone)
			Owner.JointDamaged(5, pawn(Owner), owner.Location, vect(0, 0, 0), 'stone', 0);
		if(bICE)
			Owner.JointDamaged(5000, pawn(Owner), owner.Location, vect(0, 0, 0), 'ICE', 0);
	pawn(Owner).PowerupStone(pawn(owner));
	pawn(owner).Clientmessage("You have overused the power from your weapon!");
	Self.Destroy();
}

	if(RunePowerRequired == 1024){
		bChangeonfirstspawn = true;
		RunePowerRequired = default.RunePowerRequired;
		GoToState( 'Sleeping' );
	}

	if(owner != none){
		if(owner.isa('playerpawn')){
			if(pawn(owner).weapon != none){
				if(WeaponSTRBonus > 0){
					if(pawn(owner).Strength < WeaponSTRBonus)
						pawn(owner).Strength = WeaponSTRBonus;
				}
				if(WeaponSTRBonus < 0){
					if(pawn(owner).weapon != none){
						pawn(owner).Strength = 0;
						if(pawn(owner).Health > (pawn(owner).maxhealth*0.5) )
							pawn(owner).Health -= 4;
					}
				}
				if(WeaponINTBonus != 0){
					if(pawn(owner).RunePower < WeaponINTBonus)
						pawn(owner).RunePower += 1;
						if((WeaponINTBonus < 0) && (pawn(owner).RunePower > 0))
							pawn(owner).RunePower -= 4;
				}
				if(WeaponHealthBonus > 0){
					if(pawn(owner).Health < pawn(owner).MaxHealth)
						pawn(owner).Health += 2;
				}
				if(WeaponHealthBonus == -99){
					if(pawn(owner).Health > 16)
						pawn(owner).Health -= 15;
					if(pawn(owner).Health > 6)
						pawn(owner).Health -= 5;
				}
			}
		}
	}
}

function PostBeginPlay(){
	SetTimer(1.000000,true);
	bVasNewItem = True;
	Super(weapon).PostBeginPlay();
	Self.Respawntime= Default.Respawntime;
}

function VasChangeItem(){
local int randnumber;
local actor A;

	VasPickupMessage = "";
	vasmass = Default.Mass;
	vasRating = Default.Rating;
	vasDamage = Default.Damage;
	vasDrawscale = Default.Drawscale ;
	VasRunePowerRequired = Default.RunePowerRequired;
	bStone = Default.bStone;
	bice = Default.bStone;
	WeaponHealthBonus = Default.WeaponHealthBonus;
	WeaponINTBonus = Default.WeaponINTBonus;
	WeaponSTRBonus = Default.WeaponSTRBonus;
	bStone = false;
	bice = false;

	randnumber = Rand(100);
	if(Randnumber<=SmallPercent){
		VasPickupMessage = VasPickupMessage$"Small " ;
		vasDrawscale = 0.75;
		vasmass =	(vasmass*0.75);
		vasRating =	(vasRating*0.75);
		vasDamage = (vasdamage*0.75);
	}
	if((Randnumber>SmallPercent) && (Randnumber<=(SmallPercent+NormalPercent))){
		vasDrawscale = 1.0;
	}
	if((Randnumber>(SmallPercent+NormalPercent)) && (Randnumber<=(SmallPercent+NormalPercent+LargePercent))){
		VasPickupMessage = VasPickupMessage$"Large " ;
		vasDrawscale = 1.25;
		vasmass =	(Vasmass*1.25);
		vasRating =	(VasRating*1.25);
		vasDamage = (Vasdamage*1.25);
	}

	randnumber = Rand(100);
	if(Randnumber<=MagicPercent){
		VasPickupMessage = VasPickupMessage$VasMagicTitle;
		vasRating =	(Rating*1.25);
		if(AutoMagic){SpawnPowerupEffect();
		SwipeClass = PoweredUpSwipeClass;
		bVASPoweredUp = True;
		vasbCanBePoweredUp=False;}
	}
	else{
		A = DetachActorFromJoint(0);
		A.Destroy();
		vasbCanBePoweredUp=False;
		Super.PowerupEnded();
		bVASPoweredUp = False;;
	}
	VasPickupMessage = VasPickupMessage$Default.PickupMessage;

	randnumber = Rand(100);
	if(Randnumber > MagicPercent){
		RandNumber=Rand(100);
		if(Randnumber<=NormalDamage){}
		if((Randnumber>NormalDamage) && (Randnumber<=(NormalDamage+RuinDamage))){VasPickupMessage = VasPickupMessage$" of Ruin";
			vasRating =	(vasRating*1.10);
			vasDamage = (vasdamage*1.10);}
		if((Randnumber>(NormalDamage+RuinDamage)) && (Randnumber<=(NormalDamage+RuinDamage+MightDamage))){VasPickupMessage = VasPickupMessage$" of Might";
		vasDamage = (vasdamage*1.20);
		vasRating =	(vasRating*1.20);}
		if((Randnumber>(NormalDamage+RuinDamage+MightDamage)) && (Randnumber<=(NormalDamage+RuinDamage+MightDamage+ForceDamage))){VasPickupMessage = VasPickupMessage$" of Force";
			vasRating =	(vasRating*1.50);
			vasDamage = (vasdamage*1.50);}
			if((Randnumber>(NormalDamage+RuinDamage+MightDamage+ForceDamage)) && (Randnumber<=(NormalDamage+RuinDamage+MightDamage+ForceDamage+PowerDamage))){VasPickupMessage = VasPickupMessage$" of Power";
				vasRating = (vasRating*1.75);
				vasDamage = (vasdamage*1.75);}
				if((Randnumber>(NormalDamage+RuinDamage+MightDamage+ForceDamage+PowerDamage)) && (Randnumber<=(NormalDamage+RuinDamage+MightDamage+ForceDamage+PowerDamage+Vaqdamage))){VasPickupMessage = VasPickupMessage$" of Vanquishing";
					vasRating =	(vasRating*2);
					vasDamage = (vasdamage*2);}
				}
				else{
					randnumber = Rand(13);
					switch(randnumber){
						case 0:
						case 1:
							VasPickupMessage=VasPickupMessage$" of Strength";
							WeaponSTRBonus = RandRange(20,60);
							WeaponINTBonus = 0;
							WeaponHealthBonus = 0;
							break;
						case 2:
						case 3:
							VasPickupMessage=VasPickupMessage$" of Life Steal";
							WeaponINTBonus = 0;
							WeaponSTRBonus = 0;
							WeaponHealthBonus = -99;
							break;
						case 4:
						case 5:
							VasPickupMessage=VasPickupMessage$" of RunePower";
							WeaponINTBonus = RandRange(20,60);
							WeaponSTRBonus = 0;
							WeaponHealthBonus = 0;
							break;
						case 6:
							VasPickupMessage=VasPickupMessage$" of Weakness";
							WeaponSTRBonus = RandRange(-20,-60);
							WeaponINTBonus = 0;
							WeaponHealthBonus = 0;
							break;
							case 7:
							VasPickupMessage=VasPickupMessage$" of RunePowerDrain";
							WeaponINTBonus = RandRange(-20,-60);
							WeaponSTRBonus = 0;
							WeaponHealthBonus = 0;
							break;
						case 8:
							VasPickupMessage=VasPickupMessage$" of the VasGods";
							randnumber = RandRange(20,100);
							WeaponINTBonus = randnumber;
							WeaponSTRBonus = randnumber;
							WeaponHealthBonus = randnumber;
							break;
						case 9:
						case 10:
						case 11:
							randnumber = RandRange(20,100);
							VasPickupMessage=VasPickupMessage$" of Life";
							WeaponINTBonus = 0;
							WeaponSTRBonus = 0;
							WeaponHealthBonus = randnumber;
							break;
						case 12:
							randnumber = RandRange(20,100);
							VasPickupMessage=VasPickupMessage$" of Stone";
							WeaponINTBonus = 0;
							WeaponSTRBonus = 0;
							WeaponHealthBonus = 0;
							bStone = True;
							break;
						case 13:
							randnumber = RandRange(20,100);
							VasPickupMessage=VasPickupMessage$" of ICE";
							WeaponINTBonus = 0;
							WeaponSTRBonus = 0;
							WeaponHealthBonus = 0;
							bice = True;
							break;
					}
				}

Self.Pickupmessage = VasPickupMessage;
Self.Mass = vasmass;
Self.Rating = vasRating;
Self.Damage = vasDamage;
Self.Drawscale = vasDrawscale;
self.bCanBePoweredUp = vasbCanBePoweredUp;
self.RunePowerRequired = VasRunePowerRequired;
self.bPoweredUp = bVASPoweredUp;
bVasNewItem = False;
Self.bStone = bStone;
Self.bice = bice;
}

State Sleeping{
ignores Touch;

	function BeginState(){
		RunePowerRequired = 1023;
		bSweepable=false;
		SetCollision(false, false, false);
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
	if(!bChangeonfirstspawn)
		Sleep(Default.ReSpawnTime);
	VasChangeItem();
	if(bChangeonfirstspawn)
		bChangeonfirstspawn = False;
	else{
		PlaySound(RespawnSound);
		Sleep(Level.Game.PlaySpawnEffect(self));
	}
	GoToState('Pickup');
}

auto state Pickup{
		function BeginState(){
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
			if(StabbedActor != None){
				StabbedActor.PlayStabRemove();
				StabbedActor = None;
			}
		}
		function Touch(Actor Other)
		{
			local Inventory Copy;
			if(Other.IsA('Pawn')){
				if(Pawn(Other).Health > 0 && Pawn(Other).CanPickUp(self)){
					if(Level.Game.LocalLog != None)
						Level.Game.LocalLog.LogPickup(Self, Pawn(Other));
					if(Level.Game.WorldLog != None)
						Level.Game.WorldLog.LogPickup(Self, Pawn(Other));
					Copy = SpawnCopy(Pawn(Other));

					if(bVasNewItem){VasPickupMessage=Self.Pickupmessage;}
					Pawn(Other).ClientMessage("You pick up a "$VasPickupMessage, 'Subtitle');
					Copy.PlaySound (PickupSound);
					if(bVasNewItem){
						VasPickupMessage=Self.Pickupmessage;
						weapon(Copy).Drawscale = Self.Drawscale;
						weapon(Copy).Rating = self.Rating;
						weapon(Copy).Damage = Self.Damage;
						weapon(Copy).mass = self.mass;
						weapon(Copy).RunePowerRequired = self.RunePowerRequired;
						weapon(Copy).bCanBePoweredUp = Self.bCanBePoweredUp;
						weapon(Copy).bPoweredUp = self.bPoweredUp;
						weapon(Copy).RespawnTime = self.RespawnTime;
						VW2Weapons(Copy).bice = Self.bice;
						VW2Weapons(Copy).bStone = Self.bStone;
						VW2Weapons(Copy).WeaponHealthBonus = Self.WeaponHealthBonus;
						VW2Weapons(Copy).WeaponSTRBonus = Self.WeaponSTRBonus;
						VW2Weapons(Copy).WeaponINTBonus = Self.WeaponINTBonus;
					}
					else{
						weapon(Copy).Drawscale = vasDrawscale;
						weapon(Copy).Rating = vasRating;
						weapon(Copy).Damage = vasDamage;
						weapon(Copy).mass = vasmass;
						weapon(Copy).RunePowerRequired = vasRunePowerRequired;
						weapon(Copy).bCanBePoweredUp = vasbCanBePoweredUp ;
						weapon(Copy).bPoweredUp = bVasPoweredUp;
						weapon(Copy).RespawnTime = RespawnTime;
						VW2Weapons(Copy).bice = bice;
						VW2Weapons(Copy).bStone = bStone;
						VW2Weapons(Copy).WeaponHealthBonus = WeaponHealthBonus;
						VW2Weapons(Copy).WeaponSTRBonus = WeaponSTRBonus;
						VW2Weapons(Copy).WeaponINTBonus = WeaponINTBonus;
					}

					weapon(Copy).Pickupmessage = VasPickupMessage;
					if(Level.Game.Difficulty > 1)
						Other.MakeNoise(0.1 * Level.Game.Difficulty);
					Pawn(Other).AcquireInventory(Copy);

					if(!Pawn(Other).IsInState('PlayerSwimming'))
						Copy.GotoState('VasActive');
				}
			}
		}

begin:
	if(AutoMagic && bVASPoweredUp){self.bPoweredUp = True;PowerupInit();Self.RunePowerDuration=9999;}
	AmbientGlow = 0;
	SkelMesh = Default.SkelMesh;

	if(Role==ROLE_Authority)
		bSimFall = false;
}

function inventory SpawnCopy(pawn Other){
	local inventory Copy;

	if(!self.bTossedOut){
		Copy = spawn(Class,Other,,,rot(0,0,0));
		if(Copy == None){
			log(name@"cannot be spawned in spawncopy");
			return(Copy);
		}
		Copy.Tag = Tag;
		Copy.Event = Event;
		GotoState('Sleeping');
	}
	else
		Copy = self;

	Copy.bTossedOut = true;
	Copy.RespawnTime = 0.0;
	Copy.GiveTo( Other );
	return Copy;
}

state Active{
	function BeginState(){SetPhysics(PHYS_None);
	Pawn(owner).ClientMessage("You ready your "$Self.PickupMessage, 'Subtitle');}
		function EndState(){}
		function StartAttack(){lastpos1 = GetJointPos(SweepJoint1);
			lastpos2 = GetJointPos(SweepJoint2);
			ClearSwipeArray();
			GotoState('Swinging');}
begin:
	if(AutoMagic && bVASPoweredUp){self.bPoweredUp = true;PowerupInit();Self.RunePowerDuration=9999;}
}

state VasActive{
	function BeginState(){SetPhysics(PHYS_None);}
	function EndState(){}
	function StartAttack(){lastpos1 = GetJointPos(SweepJoint1);
			lastpos2 = GetJointPos(SweepJoint2);
			ClearSwipeArray();
			GotoState('Swinging');}
begin:
	if(AutoMagic && Self.bPoweredUp){PowerupInit();
	bVASPoweredUp = self.bPoweredUp;
	Self.RunePowerDuration=9999;}
}

state Swinging{
	function BeginState(){
		WeaponFire(1);
		PlaySwipeSound();FrameOfAttackAnim=0;}
		function FrameNotify(int framepassed){
			local vector NewPos1, NewPos2, WeaponVector;
			NewPos1 = GetJointPos(SweepJoint1);
			NewPos2 = GetJointPos(SweepJoint2);
			WeaponVector = SweepVector * (VSize(NewPos2-NewPos1) + ExtendedLength);

			FrameSweep(framepassed, WeaponVector, lastpos1, lastpos2);
		}

		event FrameSwept(vector B1, vector E1, vector B2, vector E2){
			local int LowMask,HighMask;
			local vector HitLoc, HitNorm, NewPos1, NewPos2;
			local vector Momentum;
			local actor A;

			Momentum = (E2 - E1) * Mass;
			foreach SweepActors(class'actor', A, B1, E1, B2, E2, WeaponSweepExtent, HitLoc, HitNorm, LowMask, HighMask){
				if(SwipeArrayCheck(A, LowMask, HighMask)){
					if(!DoWeaponSwipe(A, LowMask, HighMask, HitLoc, HitNorm, Momentum)){}
					SpawnHitEffect(HitLoc, HitNorm, LowMask, HighMask, A);
				}
				gB1 = B1;
				gE1 = E1;
				gB2 = B2;
				gE2 = E2;
		}
	function StartAttack(){}
	function ClearSwipeArray(){global.ClearSwipeArray();}
	function FinishAttack(){Disable('Tick');GotoState('VasActive');}
begin:
	Enable('Tick');
}

function int CalculateDamage(actor Victim){
	local int newDamage;

	newDamage = Damage;
	if(Owner != None && Pawn(Owner) != None)
		newDamage *= Pawn(Owner).PawnDamageModifier(self);

	if((Owner.Region.Zone.bNeutralZone || Victim.Region.Zone.bNeutralZone) && (Victim.IsA('Pawn') || Victim.IsA('Shield')))
		newDamage = 0;
	else if(Victim.Owner != None && Victim.Owner.Region.Zone.bNeutralZone)
		newDamage = 0;

	if(Level.Game.bTeamGame && Pawn(Victim) != None && Pawn(Owner) != None && Pawn(Victim).PlayerReplicationInfo.Team != 255 && Pawn(Victim).PlayerReplicationInfo.Team == Pawn(Owner).PlayerReplicationInfo.Team)
		newDamage = 0;

	if(bStone){
		Victim.JointDamaged(newDamage, pawn(owner), Victim.Location, vect(0, 0, 0), 'stone', 0);
		pawn(Victim).PowerupStone(pawn(owner));
		DestroyCounter += 1;
	}
	if(bice){
		Victim.JointDamaged(newDamage, pawn(owner), Victim.Location, vect(0, 0, 0), 'ICE', 0);
		pawn(Victim).PowerupICE(pawn(owner));
		DestroyCounter += 1;
	}
	return newDamage;
}

simulated function Debug(Canvas canvas, int mode){
	local vector pos1, pos2;

	Super.Debug(canvas, mode);

	Canvas.DrawText("VasINFOWeapon:");
	Canvas.CurY -= 8;
	Canvas.DrawText("	WeaponHealthBonus: " $WeaponHealthBonus);
	Canvas.CurY -= 8;
	Canvas.DrawText("	WeaponINTBonus: " $WeaponINTBonus);
	Canvas.CurY -= 8;
	Canvas.DrawText("	WeaponSTRBonus: " $WeaponSTRBonus);
	Canvas.CurY -= 8;
	Canvas.DrawText("	bStone: " $WeaponSTRBonus);
	Canvas.CurY -= 8;
	Canvas.DrawText("	bice: " $BICE);
	Canvas.CurY -= 8;
	Canvas.DrawText("	VasPickupMessage: " $VasPickupMessage);
	Canvas.CurY -= 8;
	Canvas.DrawText("	bVASPoweredUp: " $bVASPoweredUp);
	Canvas.CurY -= 8;
	Canvas.DrawText("	Default Damage: " $default.Damage);
	Canvas.CurY -= 8;
	Canvas.DrawText("	vasDamage: " $vasDamage);
	Canvas.CurY -= 8;
	Canvas.DrawText("	DestroyCounter: " $DestroyCounter);
	Canvas.CurY -= 8;
}

defaultproperties{
	AutoMagic=True
	SmallPercent=25
	NormalPercent=70
	LargePercent=5
	MagicPercent=5
	NormalDamage=50
	RuinDamage=18
	MightDamage=14
	ForceDamage=10
	PowerDamage=6
	Vaqdamage=2
}
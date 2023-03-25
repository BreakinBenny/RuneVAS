// MarkLocation.
class MarkLocation expands GrainSack;

var() Pawn Owner;
var() bool Tele;

function Destroyed()
{
	local actor dropped, A;
	local class<actor> tempClass;

	if((Contents != None) && !Level.bStartup)
	{
		tempClass = Contents;
		if (Content2!=None && FRand()<0.3) tempClass = Content2;
		if (Content3!=None && FRand()<0.3) tempClass = Content3;
		dropped = Spawn(tempClass);
		dropped.RemoteRole = ROLE_DumbProxy;
		dropped.SetPhysics(PHYS_Falling);
		dropped.bCollideWorld = true;
		if(inventory(dropped) != None)
			inventory(dropped).GotoState('Pickup', 'Dropped');
	}	

	if(Event != ' )
		foreach AllActors( class 'Actor', A, Event )
			A.Trigger( Self, None );

	if (bPushSoundPlaying)
		PlaySound(EndPushSound, SLOT_Misc,0.0);
		
	if(Owner != None && !Tele)
		RunePlayer(Owner).ClientMessage("Your marked location was destroyed!", 'subtitle');
	Owner = None;

	Super.Destroyed();
}

function Timer()
{
	if(Owner == None)
		Destroy();
	setTimer(2.0,true);
}

defaultproperties
{
	DestroyedSound=Sound'MurmurSnd.Rocks.rock02'
	AmbientGlow=255
	ColorAdjust=(X=200.000000)
	DesiredColorAdjust=(X=200.000000)
	DesiredFatness=255
	CollisionRadius=10.000000
	CollisionHeight=3.000000
	LightType=LT_Steady
	LightBrightness=128
	LightSaturation=128
	LightRadius=16
	Skeletal=SkelModel'objects.Plate'
}
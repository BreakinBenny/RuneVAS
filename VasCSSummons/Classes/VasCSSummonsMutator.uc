//	VasCSSummon -  By Kal-Corp      Kal-Corp@cfl.rr.com
//		http://Vasserver.dyndns.org:88/KalsForums
//-----------------------------------------------------------
class VasCSSummonsMutator expands Mutator;

var() bool init;
Var() int Vastime;
var() color GreenColor,WhiteColor,BlueColor,RedColor;

simulated function PreBeginPlay(){
	pawn(owner).clientmessage("Powered by VasCSSummon -  Kal Corp");
	LOG("Powered by VasCS Summon -  Kal Corp");
}

simulated function Tick(float DeltaTime){
	Super.Tick(DeltaTime);
	if(!init)
		Vastime +=1;
	if(Vastime >= 10){
		Vastime =0;
		RegisterHUDMutator();
	}
}

simulated function RegisterHUDMutator(){
	local HUD MyHud;
	local Pawn P;
	local playerpawn playerpawn;

	if (!init){
		foreach AllActors(class'HUD', MyHud){
			init = true;
			if(MyHud.owner != none){
				if(MyHud.owner == owner){
					NextHUDMutator = MyHud.HUDMutator;
					MyHud.HUDMutator = Self;
					bHUDMutator = True;
				}
				else{
					init = true;
					return;
				}
			}
			else{
				init = true;
				return;
			}
		}
	}
}

simulated event PostRender(canvas Canvas){
	RenderNames(Canvas);

	if(nextHUDMutator != None)
		nextHUDMutator.PostRender(Canvas);
}

simulated function RenderNames(canvas Canvas){
	local scriptpawn P;
	local int SX,SY;
	local float scale, dist;
	local vector pos;
	local string Ally;
	local VasCSSummonRepl VasCSSummonRepl ;
	local bool attackothers;
	local string SummonState;

	foreach AllActors(class'scriptpawn', P){
		ally = "";
		SummonState = "";

		foreach AllActors(class'VasCSSummonRepl', VasCSSummonRepl){
			if(VasCSSummonRepl.NewMonster == p){
				ally  =  VasCSSummonRepl.ally.PlayerReplicationInfo.PlayerName;
				attackothers = VasCSSummonRepl.attackothers;
				SummonState = VasCSSummonRepl.SummonState;
				if(VasCSSummonRepl.ally == Owner)
					SummonState = SummonState$" Life="$VasCSSummonRepl.NewMonster.health$"/"$VasCSSummonRepl.NewMonster.Maxhealth;
			}
		}

		if(ally == "")
			continue;

		pos = P.Location+vect(0,0,1.2)*P.CollisionHeight;
		if (!FastTrace(pos, Canvas.ViewPort.Actor.ViewLocation) || P.IsA('CTTSpectator') || P.Health <= 0)
			continue;

		Canvas.TransformPoint(pos, SX, SY);
		if (SX > 0 && SX < Canvas.ClipX && SY > 0 && SY < Canvas.ClipY){
			dist = VSize(P.Location-Canvas.ViewPort.Actor.ViewLocation);
			dist = FClamp(dist, 1, 10000);
			scale = 500.0/dist;
			scale = FClamp(scale, 0.01, 2.0);

			Canvas.SetPos(SX-(32*scale)*0.5, SY-(32*scale));
			if(scale>0.3)
				Canvas.Font = Canvas.MedFont;
			else
				return;

			Canvas.DrawColor = GreenColor;
			if(attackothers)
				Canvas.DrawColor = RedColor;
			if(!attackothers)
				Canvas.DrawColor = BlueColor;
			Canvas.DrawText(ally$"'s Summon - "$SummonState);
		}
	}
}

defaultproperties{
	GreenColor=(R=0,G=255,B=0,A=0),
	WhiteColor=(R=255,G=255,B=255,A=0),
	BlueColor=(R=0,G=0,B=255,A=0),
	RedColor=(R=255,G=0,B=0,A=0),
	bAlwaysRelevant=True
	RemoteRole=2
}
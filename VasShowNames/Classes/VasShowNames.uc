//-----------------------------------------------------------
//	VasShowNames -  By Kal-Corp	Kal-Corp@cfl.rr.com
//		http://Vasserver.dyndns.org/KalsForums
//-----------------------------------------------------------
class VasShowNames expands Mutator;

var color GreenColor,WhiteColor;
var bool init;
var int Vastime;

simulated function Tick(float DeltaTime){
	Super.Tick(DeltaTime);
	If (!init)
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
				If (MyHud.owner == owner){
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
	local RunePlayer P;
	local int SX,SY;
	local float scale, dist;
	local vector pos;
	local string PName;

	foreach AllActors(class'RunePlayer', P){
		pos = P.Location+vect(0,0,1.2)*P.CollisionHeight;
		if (!FastTrace(pos, Canvas.ViewPort.Actor.ViewLocation) || P == Canvas.ViewPort.Actor || P.IsA('CTTSpectator') || P.Health <= 0)
			continue;
		if(P.style == STY_Translucent)
			Continue;
		Canvas.TransformPoint(pos, SX, SY);
		if(SX > 0 && SX < Canvas.ClipX && SY > 0 && SY < Canvas.ClipY){
			dist = VSize(P.Location-Canvas.ViewPort.Actor.ViewLocation);
			dist = FClamp(dist, 1, 10000);
			scale = 500.0/dist;
			scale = FClamp(scale, 0.01, 2.0);
			PName = P.PlayerReplicationInfo.PlayerName;
			Canvas.SetPos(SX-(32*scale)*0.5, SY-(32*scale));

			if(scale>0.3)
				Canvas.Font = Canvas.MedFont;
			else
				return;
			Canvas.DrawText(PName);
		}
	}
}

defaultproperties{
	GreenColor=(R=0,G=255,B=0,A=0),
	WhiteColor=(R=255,G=255,B=255,A=0),
	bAlwaysRelevant=True
	RemoteRole=2
}
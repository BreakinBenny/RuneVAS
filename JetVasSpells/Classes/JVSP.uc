//=============================================================================
// JVSP.
//=============================================================================
class JVSP expands Info;

var(Sounds) Sound Sound;

simulated function PreBeginPlay(){
setTimer(0.05,true);
}

function Timer(){
self.PlaySound(Sound, Slot_NONE);
Destroy();
}

defaultproperties{}
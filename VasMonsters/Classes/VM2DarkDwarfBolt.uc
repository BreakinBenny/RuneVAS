class VM2DarkDwarfBolt expands DarkDwarfBolt;
function SetPowerLevel(int powerlevel)
{BeamThickness = 2 + powerlevel;
Damage = 5 + powerlevel*6;
amplitude = 10 + 10*powerlevel;
BeamCloseTime = 3.0 - (powerlevel*0.5);}

defaultproperties{}
class VasEXPallyRepl expands ReplicationInfo;

Var ScriptPawn NewMonster;
Var pawn ally;

replication{
reliable if(Role == ROLE_Authority)
	NewMonster,ally;
}

defaultproperties{}
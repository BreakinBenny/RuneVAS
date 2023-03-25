class VasCSSummonRepl expands ReplicationInfo;

Var ScriptPawn NewMonster;
Var pawn ally;
Var bool Attackothers;
Var string SummonState;

replication
{
	reliable if(Role == ROLE_Authority)
		NewMonster,ally,Attackothers,SummonState;
}
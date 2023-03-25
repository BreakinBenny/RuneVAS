//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VasCPMagicProtectRepl expands ReplicationInfo;

var bool magicProtect;

replication
{
reliable if(Role == ROLE_Authority)
	magicProtect;
}

defaultproperties
{
}
//=============================================================================
// JetVasXBow.
//=============================================================================
class JetVasXBow expands Mutator;

function bool CheckReplacement(Actor Other, out byte bSuperRelevant){
	if(Other.IsA('VasGVEArrow'))
		Projectile(Other).Damage = Projectile(Other).Damage*30;

	return true;
}

defaultproperties{}
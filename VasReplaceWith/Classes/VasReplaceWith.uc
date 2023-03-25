class VasReplacewith expands Mutator Config(VasReplacewith);

Var() Config int VasReplaceWithItems;
Var() Config Name VasReplace[100];
Var() Config String VasWithString[100];
Var() Config Name VasWithName[100];

function bool CheckReplacement(Actor Other, out byte bSuperRelevant){
	local int i;

	for(i=0; i < VasReplaceWithItems; i++){
		if(Other.IsA(VasReplace[i]) && !Other.IsA(VasWithName[i])){
			ReplaceWith (Other, VasWithString[i]);
			return false;
		}
	}
	return true;
}

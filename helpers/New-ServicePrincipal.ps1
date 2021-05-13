#az login
$subId = "45a47ca2-196a-4d7d-a56e-cbe6b80e476d"
$rg = "contoso-imageworkspace-packer"
az ad sp create-for-rbac --name sp-imagebuilder-packer --role Contributor --scopes $("/subscriptions/{0}/resourceGroups/{1}" -f $subId, $rg)
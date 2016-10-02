function git-pull-and-rebase([Parameter(Mandatory=$true)]$branch, [switch]$i) {
	git branch | select-string -pattern "\* " | ForEach-Object { 
	    $_.ToString().TrimStart("* ") 
	} | ForEach-Object { 
	    git checkout $branch
		git pull origin $branch
		git checkout $_
		if ($i) {
			git rebase $branch -i
		}
		else {
			git rebase $branch
		}
	} 
}

function git-update-repos {
    $reposJson = '[
	{
		"name": "Repo1",
		"directory": "/repos/repo1",
		"branches": ["master"]
	},
	{
		"name": "Repo2",
		"directory": "/repos/repo2",
		"branches": ["master"]
	}
]'

	Push-Location
    $repos = ConvertFrom-Json $reposJson
    foreach ($repo in $repos)
    {
        $msg = "Updating " + $repo.name
		echo $msg
		cd $repo.directory
		
		$currentStatus = git status -s
		if ($currentStatus.length -gt 0)
		{
			echo "Can't update as there are pending changes in the current branch"
			continue;
		}

		$originalBranch = git branch | select-string -pattern "\* "
		$originalBranch = $originalBranch.ToString().TrimStart("* ")

		foreach ($branch in $repo.branches)
		{
			git checkout $branch
			git pull origin $branch
		}

		git checkout $originalBranch
        echo "----------"
    }
	Pop-Location
}

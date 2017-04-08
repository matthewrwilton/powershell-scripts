### git-pull-and-rebase

Rebase a feature branch onto the latest version of another branch. Switches to the given branch, pulls from origin, switches back to your current branch and rebases on the given branch. Can specify -i to perform an interactive rebase.

**Usage:** git-pull-and-rebase [branch] [-i (Optional)]

**Example:** git-pull-and-rebase dev -i

**Notes:** Relies on "git branch" prefixing the current branch with "* ". Additionally, because I am lazy, I use a customised version of this that has the branch parameter hardcoded.

### git-rm-origs

Removes all .orig files (merge originals) that show up in git status. Used when these files are not automatically cleaned up after a merge. Can prompt before removing files.

**Usage:** git-rm-origs [-Confirm (Optional)]

### git-update-repos

Loops through a configured list of repos and branches to pull the latest changes from origin. Will not update a repo if there pending changes.

**Usage:** git-update-repos

### kill-iis-express

Kills the IIS Express process.

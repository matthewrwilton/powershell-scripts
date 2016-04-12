### git-pull-and-rebase

Rebase a feature branch onto the latest version of another branch. Switches to the given branch, pulls from origin, switches back to your current branch and rebases on the given branch. Can specify -i to perform an interactive rebase.

**Usage:** git-pull-and-rebase [branch] [-i (Optional)]

**Example:** git-pull-and-rebase dev -i

**Notes:** Relies on "git branch" prefixing the current branch with "* ". Additionally, because I am lazy, I will use a version of this that has the branch parameter hardcoded as the main branch.
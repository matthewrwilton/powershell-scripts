function git-rm-origs([switch]$Confirm) { 
    git status -su | select-string -pattern "\.orig$" | ForEach-Object { 
	    $_.ToString().TrimStart("?? ") 
	} | ForEach-Object { 
		if ($i) {
	    	rm $_ -Confirm
		}
		else {
	    	rm $_ 
		}
	} 
}

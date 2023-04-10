
global rootdir : pwd
display in red "Rootdir has been set to: $rootdir"


/*================================================================================================================*/
/*                            You normally need to make no further changes below this                             */
/*                             unless you need to "net install" packages                                          */

set more off
cd "$rootdir"                            // Return to where we were before and never again use cd
global logdir "${rootdir}/logs"
cap mkdir "$logdir"

/* check if the author creates a log file. If not, adjust the following code fragment */

local c_date = c(current_date)
local cdate = subinstr("`c_date'", " ", "_", .)
local c_time = c(current_time)
local ctime = subinstr("`c_time'", ":", "_", .)

log using "$logdir/logfile_`cdate'-`ctime'-`c(username)'.log", name(ldi) replace text

/* It will provide some info about how and when the program was run */

/* install any packages locally */
di "=== Redirecting where Stata searches for ado files ==="
capture mkdir "$rootdir/ado"
sysdir set PERSONAL "$rootdir/ado/personal"
sysdir set PLUS     "$rootdir/ado/plus"
sysdir set SITE     "$rootdir/ado/site"

/* get estout */

// ssc install estout

net install estout, replace from(https://raw.githubusercontent.com/benjann/estout/master/)

which estout

/// now set up the problem 
/// for purpose of discussing this on Unix, use a sub-directory 

cap mkdir "$rootdir/tables"
cap mkdir "$rootdir/data"
cd data

sysuse auto

quietly regress price mpg weight
estadd scalar p_diff = r(p)
estout, stats(p_diff)
esttab using "$rootdir/tables/test.tex"

di "=== SYSTEM DIAGNOSTICS ==="
creturn list
query
di "=========================="





# MWE for Issue 58 at estout

Filed at [benjann/estout](https://github.com/benjann/estout/issues/58)

When using `esttab` with a Windows computer using a network path, it seems to sanitize the path in a way that makes it fail.

Example:

```
	*Output 
		esttab balance_* using "$tabs\Main_Tables\Tab1_BaselineBalance.csv", ///
		cells(b(star fmt(%9.6f)) se(fmt(%9.6f))) order(_cons treatment) ///
		stardetach stats(Mean Sd N, fmt(%9.3g)) style(tab) varwidth(8) ///
		modelwidth(8) plain replace
```
where
```
global root "\\rschfs1x\userrs\xxxxx\Desktop\workspace\yyyyy"
global tabs "$root\SUBMITTED_V3\Output\Tables"
```
(and  `SUBMITTED_V3\Output\Tables` exists)
Typical output is
```
. which estout
\\rschfs1x\userrs\xxxx\Desktop\workspace\yyyy/ado/plus\e\
> estout.ado
*! version 3.31  26apr2022  Ben Jann
```
but `esttab` fails with
```
file
    \rschfs1x\userrs\F-J\xxxxx\Desktop\workspace\yyyyy\SUBMIT
    > TED_V3\Output\Tables\Main_Tables\Tab1_BaselineBalance.csv not found)
file
    \rschfs1x\userrs\F-J\xxxxx\Desktop\workspace\yyyyy\SUBMIT
    > TED_V3\Output\Tables\Main_Tables\Tab1_BaselineBalance.csv could not be
    opened
```
(note the `\rschfs1x` instead of the `\\rschfs1x`). This only appears to happen with `esttab`, and can be avoided (on the same computer) by using `global root "U:/Desktop\workspace\yyyyy"` instead. However, this is not desirable, because the automatic detection of pathnames yields the network path, not the Drive-letter path (to avoid the problem means hard-coding paths all over the place).

My suspicion is that something related to the LaTeX processing of `esttab` is "sanitizing" the path before attempting to write it out.

## MWE

See [mwe-esttab-issue58.do](mwe-esttab-issue58.do). In order to run it:

- On Linux/Mac: cd into the working directory, run 

```
stata=stata-mp  # adjust for your system
$stata do mwe-esttab-issue58.do
``` 

- On Windows 10: use right-click, choose `Execute (do)` (see [pictures](https://labordynamicsinstitute.github.io/ldilab-manual/96-02-running-stata-code.html#step-6-run-the-code)). No need to edit anything. (On Windows 11, you need to select the 

## Logs

- Run using a Linux Docker: [logs/logfile_22_Mar_2023-13_43_26-statauser.log](logs/logfile_22_Mar_2023-13_43_26-statauser.log) [WORKS]
- Run on Windows with regular drive letters: [logs/logfile_22_Mar_2023-09_50_43-lars.log](logs/logfile_22_Mar_2023-09_50_43-lars) [WORKS]
- Run on Windows with network paths: [logs/logfile_22_Mar_2023-09_55_51-lv39_RS.log](logs/logfile_22_Mar_2023-09_55_51-lv39_RS.log) [BREAKS]



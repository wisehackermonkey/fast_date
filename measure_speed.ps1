echo "python"
# (Measure-Command { echo hi | Out-Default }).ToString()
(Measure-Command { .\click4date_python.exe  | Out-Default }).ToString()
pause
echo "rust"
(Measure-Command { .\click4date_rust.exe  | Out-Default }).ToString()
pause
echo "c"
(Measure-Command { .\click4date_c.exe  | Out-Default }).ToString()
pause
echo "assembly with print"
(Measure-Command { .\click4date_asm.exe  | Out-Default }).ToString()
pause
echo "assembly with out print"
(Measure-Command { .\click4date_asm2.exe  | Out-Default }).ToString()
pause
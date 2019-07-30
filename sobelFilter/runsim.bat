iverilog -o sobelRun sobelTB.v sobelFilter.v beatCounter.v SobelBufferBlock.v sobelHoldBlock.v sobelMultBlock.v sobelShifterBlock.v simple_ram_dual_clock.v sobelMag.v sobelDir.v
vvp -v sobelRun -fst
REM -fst to change from vsd to fst wave format -none no file output
REM cd C:\Users\RobertJolley\OneDrive - Innopharma Labs\Documents\pycode
REM deHex.py
REM start mspaint brace200HEX1A.jpg
REM cd C:\Users\RobertJolley\OneDrive - Innopharma Labs\Documents\Masters_Project\verilogProjects\gausBufferBlock
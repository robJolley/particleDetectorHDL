iverilog -o longRun gaussTB.v gaussianFilter.v beatCounter.v BufferBlock.v HoldBlock.v multiplierBlock.v normalisedOutDataBlock.v normalisingBlock.v ShifterBlock.v simple_ram_dual_clock.v
vvp -v longRun -fst
REM -fst to change from vsd to fst wave format -none no file output
cd C:\Users\RobertJolley\OneDrive - Innopharma Labs\Documents\pycode
deHex.py
start mspaint brace200HEX1A.jpg
cd C:\Users\RobertJolley\OneDrive - Innopharma Labs\Documents\Masters_Project\verilogProjects\gausBufferBlock
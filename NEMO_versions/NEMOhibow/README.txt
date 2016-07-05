MAKE SURE YOUR STAGE DATA IS SYNCED AND INTERPED NOW!

To start analyzing your video,

1. Type in your Command Window (box at the bottom of the Matlab console, look for ">>", type right after)

>> NEMO(start,finish,segnum,fps,pxpmm)

start-starting frame, usually 1 
finish-ending frame, usually # of frames
segnum-20 for all current experiments
fps-different across experiments
pxpmm-different across experiments

2. This will open a window where you will be asked to find your video in the directory, double click it.

3. Nemo will run on its own until it asks you to choose head and tail on the starting frame, (usually takes a few minutes), this will pop up a window with an image of the worm.
Click the head, then the tail, then press enter. You should then see many lines of "Orienting head and tail for frame_x"

4. Nemo will then prompt you for the stage coordinates, find the interped stage data in the directory in the pop up box, double click.

5. When it is done, you will be asked if you want to 'Nuke Everything,' it is usually a good idea to press "Hold On" and "Display Path Animation" to see if
the reconstructed movement of the worm looks realistic.
Look for the following signs of data analysis gone wrong, consult Suying and try to use a different run for that set of parameters:
-Head tail suddenly switch (blue dots start coming from wrong end in path animation)
-Worm going backwards after turn (see if the color indicating phase (forward, pause, omega or reverse) makes sense, if the worm turns once then goes backwards until the end of
the video, something went wrong with phase detection)
-If stuff looks generally weird, worm twitching/ gliding/ or whatever, check your stage coordinates!

6. Enjoy and remember the location of your excel file which is now ready to run through whatever plotting programs you need.


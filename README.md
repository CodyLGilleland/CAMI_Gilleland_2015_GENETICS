# CAMI_Gilleland_2015_GENETICS

CAMI software package

Cody Gilleland

email: codyg@alum.mit.edu

This is the software package as described in the supplementary information of the following paper: 
Gilleland et al. 2015 GENETICS, "Computer-assisted transgenesis in C. elegans for deep phenotyping"

Main file: CAMIvideoAVT.m 

GUI: CAMIvideoAVT.fig

Open 'CAMIvideoAVT.m' in MATLAB and click 'run'

This software package is designed to be run on the hardware equipment as described in the supplementary.
Please note that adapting this software to new hardware would require modifications.

--------------
Algorithm Demo:

For a stand alone demo of the gonad detection algorithm in MATLAB

1. Download the contents of the folder 'CAMI_Gilleland_2015_GENETICS/DemoGonadDetection/'
2. Run the file 'DEMO_Gonad_detection.m' 
3. The program will automatically load the example worm images and detect the gonad locations using the algorithm 'find_gonads.m' on six animals

Example worm image files:
worm_ex1.jpg
worm_ex2.jpg
worm_ex3.jpg
worm_ex4.jpg
worm_ex5.jpg
worm_ex6.jpg

Algorithm:
find_gonads.m

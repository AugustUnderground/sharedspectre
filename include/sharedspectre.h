#pragma once

// Opaque Haskell 'Object'
typedef void *HsStablePtr;

// Initialize Haskell and non-interactive spectre
void spectreInit(void);

// Quit Haskell
void spectreExit(void);

// Simulate given netlist, returns pointer to results
HsStablePtr spectreSimulate( char** // List of File paths to include
                           , int    // Number of files to include
                           , char*  // Path to netlist
                           ); 

// Initialize spectre interactive mode
HsStablePtr sclInit(char **, int, char *);

// Close spectre interactive mode session
void sclQuit(HsStablePtr);

int nutNumOfPlots(HsStablePtr);
char* nutNameOfPlot(HsStablePtr, int);
HsStablePtr nutPlotByName(HsStablePtr, char*);
HsStablePtr nutPlotByIndex(void*, int);
int nutNumOfVars(HsStablePtr);
char* nutNameOfVar(HsStablePtr, int);
int nutNumOfPoints(HsStablePtr);
HsStablePtr nutWaveByName(HsStablePtr, char*);
HsStablePtr nutWaveByIndex(HsStablePtr, int);
int nutIsComplex(HsStablePtr);
void nutRealData(HsStablePtr, double*);
void nutImagData(HsStablePtr, double*);

void test(void);

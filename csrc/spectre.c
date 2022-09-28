#include <stdio.h>
#include <stdlib.h>
#include "HsFFI.h"

#include "../include/sharedspectre.h"
#include "SharedSpectre_stub.h"

void spectreInit(void)
{
    char *rts = "+RTS";
    char *a32 = "-A32m";
    int argc     = 2;
    char *argv[] = { rts, a32, NULL };
    char **pargv = argv;

    hs_init(&argc, &pargv);
}

void spectreExit(void)
{
    hs_exit();
}

HsStablePtr spectreSimulate(char *includes[], int num_includes, char *netlist)
{
    int i;
    HsStablePtr res = simulate(includes, num_includes, netlist);
    return res;
}

HsStablePtr sclInit(char *includes[], int num_includes, char *netlist)
{
    spectreInit();
    HsStablePtr session = startSession(includes, num_includes, netlist);
    return session;
}

void sclQuit(HsStablePtr session)
{
    stopSession(session);
    spectreExit();
}

int nutNumOfPlots(void* nut)
{
    return numOfPlots(nut);
}

char* nutNameOfPlot(void* nut, int idx)
{
    return nameOfPlot(nut, idx);
}

HsStablePtr nutPlotByName(HsStablePtr nut, char* name)
{
    return plotByName(nut, name);
}

HsStablePtr nutPlotByIndex(HsStablePtr nut, int idx)
{
    return plotByIndex(nut, idx);
}

int nutNumOfVars(HsStablePtr plt)
{
    return numOfVars(plt);
}

char* nutNameOfVar(HsStablePtr plt, int idx)
{
    return nameOfVar(plt, idx);
}

int nutNumOfPoints(HsStablePtr plt)
{
    return numOfPoints(plt);
}

HsStablePtr nutWaveByName(HsStablePtr plt, char* name)
{
    waveByName(plt, name);
}

HsStablePtr nutWaveByIndex(HsStablePtr plt, int idx)
{
    waveByIndex(plt, idx);
}

int nutIsComplex(HsStablePtr plt)
{
    return isComplex(plt);
}

void nutRealData(HsStablePtr plt, double* rData)
{
    realData(plt, rData);
}

void nutImagData(HsStablePtr plt, double* iData)
{
    imagData(plt, iData);
}

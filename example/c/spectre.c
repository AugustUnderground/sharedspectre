#include <stdio.h>
#include <stdlib.h>

#include "sharedspectre.h"

int main(int argc, char *argv[])
{
    void* nut;
    int np;
    char* pn;
    void* plt;
    int nv;
    char* vn;
    int num;
    void* wv;
    int img;

    int pltIdx = 0;
    int varIdx = 0;

    char *netlist   = "../input.scs";
    char *include[] = {"/opt/pdk/gpdk090_v4.6/models/spectre/gpdk090.scs"};
    int length      = sizeof(include) / sizeof(include[0]);

    spectreInit();

    nut = spectreSimulate(include, length, netlist);

    np  = nutNumOfPlots(nut);
    pn  = nutNameOfPlot(nut, pltIdx);
    plt = nutPlotByIndex(nut, pltIdx);
    nv  = nutNumOfVars(plt);
    vn  = nutNameOfVar(plt, varIdx);
    num = nutNumOfPoints(plt);
    wv  = nutWaveByIndex(plt, varIdx);
    img = nutIsComplex(plt);

    double re[num];
    double im[num];
    nutRealData(wv, re);
    nutImagData(wv, im);

    printf("Number of Plots: %d\n", np);
    printf("Name of %dth Plot: %s\n", pltIdx, pn);
    printf("Number of Variables: %d\n", nv);
    printf("Name of %dth Variable: %s\n", varIdx, vn);
    printf("Number of Points: %d\n", num);
    printf("Is Complex: %d\n", img);

    printf("\nReal: [");
    for(int i = 0; i < num; i++) { printf("%f.2 ", re[i]); }
    printf("]\n");

    printf("Imag: [");
    for(int i = 0; i < num; i++) { printf("%f.2 ", im[i]); }
    printf("]\n");

    spectreExit();

    return 0;
}

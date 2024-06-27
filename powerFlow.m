basemva=100;
accel=1.6;
acc=0.00001; %accuracy
maxiter=80;

busdata=[1 1 1 0 0 0 0 0 0
        2 0 1 0 100 50 0 0 0];

linedata=[ 1 2 0.12 0.16 0 1];

lfybus;
lfnewton;
lfgauss;
busout
lineflow

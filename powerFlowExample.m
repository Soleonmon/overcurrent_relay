% Script to call the powerFlow function

% Parameters
busData = [
    1, 1.0, 0.0, 0.5, 0.2, 0.6, 0.3;
    2, 1.0, 0.0, 0.3, 0.1, 0.4, 0.2;
    3, 1.0, 0.0, 0.2, 0.1, 0.3, 0.1;
];

lineData = [
    1, 2, 0.1, 0.2, 0.05;
    2, 3, 0.2, 0.3, 0.07;
];

S = [
    0.6 + 0.3j;
    0.4 + 0.2j;
    0.3 + 0.1j;
];

tolerance = 1e-6;
maxIterations = 20;

% Call the powerFlow function
[busVoltage, lineCurrent] = powerFlow(busData, lineData, S, tolerance, maxIterations);

% Display results
disp('Bus Voltages:');
disp(busVoltage);
disp('Line Currents:');
disp(lineCurrent);

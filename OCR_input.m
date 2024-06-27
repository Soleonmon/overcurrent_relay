clc
clear

% Data for Source
source.voltage=33000;      % Source voltage, in V.
source.ratedPower=800e6;    % Source short circuit level, in VA.
source.ratedFrequency=50;   % Source rated frequency, in Hz.
source.xrRatio=5;           % Source x/r ratio.
source.resistance=source.voltage*source.voltage...
/(source.ratedPower*sqrt(1+source.xrRatio*source.xrRatio)); % Source resistance, in ohm.
source.reactance=source.resistance*source.xrRatio;          % Source reactance, in ohm.
source.impedance=(source.resistance+(source.reactance)*1i); % Source impedance, in ohm.

% Data for Transformer
transformer.ratedPower=60e6;           % Transformer rated apparent power, in VA.
transformer.priVoltage=source.voltage; % Transformer rated primary voltage, in V.
transformer.secVoltage=11000;          % Transformer rated secondary voltage, in V.
transformer.turnsRatio=transformer.priVoltage/transformer.secVoltage; % Transformer turns ratio.
transformer.magResistance=450;         % Transformer magnetizing resistance, in per-unit. 
transformer.magReactance=450;          % Transformer magnetizing reactance, in per-unit.
transformer.priResistance=0.0014;      % Transformer primary resistance, in per-unit. 
transformer.priReactance=0.06235;      % Transformer primary reactance, in per-unit. 
transformer.secResistance=0.0014;      % Transformer secondary resistance, in per-unit. 
transformer.secReactance=0.06235;      % Transformer secondary reactance, in per-unit. 
transformer.impedance=(transformer.priResistance+transformer.secResistance)...
          +(transformer.priReactance+transformer.secReactance)*1i;  % Transformer impedance, in per-unit. 

% Data for Distribution Line1
distributionLine1.length=10;                % Distribution Distribution line1 length, in km.
distributionLine1.resistance=0.0268;        % Distribution line1 resistance in, ohm/km.
distributionLine1.inductance=0.32;          % Distribution line1 inductance in, mH/km.
distributionLine1.capacitanceLL=0.37;       % Distribution line1 L-L capacitance in uF/km.
distributionLine1.capacitanceLG=0.1;        % Distribution line1 L-G capacitance in uF/km.
distributionLine1.reactance=distributionLine1.inductance...
        *2*pi*source.ratedFrequency*1e-3;   % Distribution line1 reactance in ohm/km.

% Data for Distribution Line2
distributionLine2.length=10;                % Distribution line2 length, in km.
distributionLine2.resistance=0.0268;        % Distribution line2 resistance, in ohm/km.
distributionLine2.inductance=0.32;           % Distribution line2 inductance, in mH/km.
distributionLine2.capacitanceLL=0.37;       % Distribution line2 L-L capacitance, in uF/km.
distributionLine2.capacitanceLG=0.1;        % Distribution line2 L-G capacitance, in uF/km.
distributionLine2.reactance=distributionLine2.inductance*...
         2*pi*source.ratedFrequency*1e-3;   % Distribution line2 reactance in ohm/km.

% Data for Load
load.P1=10e6;                   % Active load at bus1 in W.
load.Q1=4e6;                    % Reactive load at bus1 in var.
load.P2=10e6;                   % Active load at bus2 in W.
load.Q2=4e6;                    % Reactive load at bus2 in var.
load.P3=20e6;                   % Active load at bus 3 in W.
load.Q3=10e6;                   % Reactive load at bus 3 in var.


% Current Transformer Ratio Estimation
load.safetyFactor=1.25;         % Safety factor for Current transformer design.
load.ct2ActivePower=load.P3;    % Active power flow from bus2, in W. 
load.ct2ReactivePower=load.Q3;  % Reactive power power flow from bus2, in var.
load.ct1ActivePower=load.P2+load.P3;   % Active power power flow from bus1, in W.
load.ct1ReactivePower=load.Q2+load.Q3; % Reactive power power flow from bus1, in var.
load.ict2=(load.ct2ActivePower/(sqrt(3)*transformer.secVoltage*...
    cos(atan(load.ct2ReactivePower/load.ct2ActivePower)))*load.safetyFactor); % Current in current transformer2 primary winding with load safety factor included, in A.
load.ict1=(load.ct1ActivePower/(sqrt(3)*transformer.secVoltage*...
    cos(atan(load.ct1ReactivePower/load.ct1ActivePower)))*load.safetyFactor); % Current in current transformer2 primary winding with load safety factor included, in A.
sensor1.ctRatio=(ceil(load.ict1/100)*100); % Current transformer1 turns ratio.
sensor2.ctRatio=(ceil(load.ict2/100)*100); % Current transformer2 turns ratio.

% Fault Settings
fault.startTime=0.1;              % Fault start time, in sec.
protection.tEnable=1;             % Directly specify the operating time of relay2.
protection.tPhFault=0.2;          % Operating time of the relay2 for phase protection, in sec. 
protection.tErFault=0.2;          % Operating time of the relay2 for earth protection, in sec.
relay2.phFltTMS=0.1;              % Time multiplier setting of relay2 for phase protection, in sec.
relay2.erFltTMS=0.1;              % Time multiplier setting of relay2 for earth protection, in sec.
relay2.phFltPickUp=1;             % Pick up current for phase protection unit of relay2, in A.
relay1.phFltPickUp=1;             % Pick up current for phase protection unit of relay1, in A.
relay2.erFltPickUp=0.05;          % Pick up current for earth protection unit of relay2, in A.
relay1.erFltPickUp=0.05;          % Pick up current for earth protection unit of relay1, in A.
protection.tFactor=0.2;           % Time grading factor between relay1 and relay2, in sec. 
relay1.sampleTime=0.0001;         % Sample time for relay1 operation, in sec.
relay2.sampleTime=0.0001;         % Sample time for relay2 operation, in sec.

% Simulation Time
simulation.maxStepSize=relay1.sampleTime/2; % Maximum step size for simulation, in sec.

% Per-Unit Conversion
source.pSeqImpedance=(source.impedance)*source.ratedPower/(source.voltage*source.voltage); % Source positive sequence impedance, in per-unit.
source.nSeqImpedance=source.pSeqImpedance; % Source negative sequence impedance,in per-unit.
transformer.pSeqImpedance=transformer.impedance*(source.ratedPower/transformer.ratedPower); % Transformer positive sequence impedance, in per-unit.
transformer.zSeqImpedance=transformer.pSeqImpedance; % Transformer zero sequence impedance, in per-unit.
transformer.nSeqImpedance=transformer.pSeqImpedance; % Transformer negative sequence impedance, in per-unit.
distributionLine1.zSeqImpedance=(distributionLine1.resistance+distributionLine1.reactance*1i)*...
    distributionLine1.length*source.ratedPower/(transformer.secVoltage*transformer.secVoltage); % Distribution line1 zero sequence impedance, in per-unit. 
distributionLine1.pSeqImpedance=(distributionLine1.resistance+distributionLine1.reactance*1i)...
    *distributionLine1.length*source.ratedPower/(transformer.secVoltage*transformer.secVoltage); % Distribution line1 positive sequence impedance, in per-unit. 
distributionLine1.nSeqImpedance=distributionLine1.pSeqImpedance ; % Distribution line1 negative sequence impedance, in per-unit.

% Fault Current Determination
fault.pSeqImpedance=(distributionLine1.pSeqImpedance+transformer.pSeqImpedance+...
                    source.pSeqImpedance);    % Fault positive sequence impedance, in per-unit. 
fault.nSeqImpedance=(distributionLine1.nSeqImpedance+transformer.nSeqImpedance+...
                     source.nSeqImpedance);   % Fault negative sequence impedance, in per-unit. 
fault.zSeqImpedance=(transformer.zSeqImpedance+distributionLine1.zSeqImpedance); % Fault zero sequence impedance, in per-unit. 
fault.phCurrent=3/abs((fault.pSeqImpedance+fault.nSeqImpedance+fault.zSeqImpedance))...
                *(source.ratedPower/(sqrt(3)*transformer.secVoltage));  % Fault current for an L-G fault, in A.
relay2.phFltPSM=(fault.phCurrent/(sensor2.ctRatio*relay2.phFltPickUp)); % Plug setting multiplier of relay2 for phase protection.
fault.erCurrent=(1/(abs(fault.pSeqImpedance+2*fault.zSeqImpedance)))...
                *source.ratedPower/(sqrt(3)*transformer.secVoltage); % Zero sequence current for L-L-G fault, in A.
relay2.erFltPSM=fault.erCurrent/(sensor2.ctRatio*relay2.erFltPickUp); % Plug setting multiplier of relay2 for earth protection.

% Relay Settings Estimation
OCR_settings;
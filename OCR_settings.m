%% Relay Settings for ee_relay_overcurrentprotection
% This function estimates the time settings of relay1 if standard IEC or IEEE characteristics 
% are chosen. Fault currents calculated in ee_relay_overcurrent_protection.mlx are used as 
% operating currents for the relay.

% Copyright 2021 The MathWorks, Inc.

%% Relay Settings for Phase Protection Unit
mask=Simulink.Mask.get([bdroot '/Relay2']);% Get the mask parameters of relay2.
protection.index1=find(strcmp(mask.Parameters(1,1).Value,mask.Parameters(1,1).TypeOptions));  % Get the type of chosen relay characteristic for phase protection.
if protection.tEnable==1  % Trip time is enabled.
    relay2.phFltOpTime=protection.tPhFault; 
    relay2.phFltTMS=OCR_characteristics(protection.index1,relay2.phFltOpTime,...
        relay2.phFltPSM,relay2.phFltOpTime); % Time multiplier setting of relay2 for phase protection.
else
    relay2.phFltOpTime=OCR_characteristics(protection.index1,relay2.phFltTMS,...
        relay2.phFltPSM); % Operating time of relay2 for phase protection
end
relay1.phFltOpTime=relay2.phFltOpTime+protection.tFactor; % Operating time of relay1.
relay1.phFltPSM=(fault.phCurrent/(sensor1.ctRatio*relay1.phFltPickUp));  % Plug setting multiplier of relay1 for phase protection.
relay1.phFltTMS=OCR_characteristics(protection.index1,relay1.phFltOpTime,...
    relay1.phFltPSM,relay1.phFltOpTime); % Time multiplier setting of relay1 for phase protection.

%% Relay Settings for Earth Protection Unit
protection.index2=find(strcmp(mask.Parameters(1,2).Value,mask.Parameters(1,2).TypeOptions)); % Get the type of chosen relay characteristic for phase protection.
if protection.tEnable==1  % Trip time is enabled.
    relay2.erFltOpTime=protection.tErFault;    
    relay2.erFltTMS=OCR_characteristics(protection.index2,relay2.erFltOpTime,...
        relay2.erFltPSM,relay2.erFltOpTime); % Time multiplier setting of relay2 for earth protection.
else
    relay2.erFltOpTime=OCR_characteristics(protection.index2,relay2.erFltTMS,...
        relay2.erFltPSM); % Operating time of relay2 for the earth protection.
end   
relay1.erFltOpTime=relay2.erFltOpTime+protection.tFactor; % Operating time of relay1 for earth protection.
relay1.erFltPSM=(fault.erCurrent/sensor1.ctRatio)/...
    relay1.erFltPickUp;  % Plug setting multiplier of relay1 for earth protection.
relay1.erFltTMS=OCR_characteristics(protection.index2,relay1.erFltOpTime,...
    relay1.erFltPSM,relay2.erFltOpTime); % Time multiplier setting of relay1 for earth protection.


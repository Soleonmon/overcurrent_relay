function tOp = OCR_characteristics(varargin)
% Function to calculate relay operating time or Time multiplier setting of the relay
% This function gives the operating time or time multiplier setting of the relay based on the
% selected standard relay characteristic. If number of inputs is 3, then
% output of the function is the operating time and if the number of inputs
% is 4, output of the function is time multiplier setting

% Copyright 2021-2023 The MathWorks, Inc.

index=varargin{1};           % Type of chosen relay characteristic.
psm=varargin{3};             % Plug setting multiplier for relay operation.
tOp=ones(1,length(psm));
switch index                 % Selection of relay characteristic.
    case 1                   % IEC Normal Inverse
        a=0.14;
        b=0.02;
        c=0;
    case 2                   % IEC Very Inverse
        a=13.5;
        b=1;
        c=0;
    case 3                   % IEC Extremely Inverse
        a=80;
        b=2;
        c=0;
    case 4                   % IEEE Moderately Inverse
        a=0.0515;
        b=0.02;
        c=0.114;
    case 5                   % IEEE Very Inverse
        a=19.61;
        b=2;
        c=0.491;
    case 6                   % IEEE Exteremely Inverse
        a=28.2;
        b=2;
        c=0.1217;
    otherwise                % Definite Time
        a=1;
        b=1;
        c=0;
        psm=(psm./psm)*2;
end
if nargin==3
    for i=1:length(psm)
        tOp(i)=varargin{2}*((a/(power(psm(i),b)-1))+c);  % Operating time of the relay.
    end
else
    tOp=varargin{2}/((a/(power(psm,b)-1))+c); % Time multiplier setting of the relay.
end






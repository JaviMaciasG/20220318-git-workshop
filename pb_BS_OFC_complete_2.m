% RAYLEIGH BACKSCATTERING 
%
% Complete simulation including the backscattering and a perturbation
% =========================================================================

clc, clear all, close all, 
format longEng,

% Settings
% --------
DimEcran = get(0,'ScreenSize'); 
V = 0.15; H = 0.15;
PosFig  = [V*DimEcran(3),(H)*DimEcran(4),(1-V)*DimEcran(3),(0.9-H)*DimEcran(4)];
set(0,'DefaultFigurePosition',PosFig),
AFS = 24;   LFS = 30;   TFS = 30;       % Axis, label and title font size
set(0,'DefaultLineLineWidth',2)

% Global variables
c0 = 2.99792458e8; 
lambda0 = 1550e-9;
fc = c0/lambda0;  
n0 = 1.46;          


% Time and Frequency Vectors
% --------------------------
fSamp = 4e9;    
nSamp = fSamp/1e3;   
freq  = linspace(-fSamp/2, fSamp/2, nSamp+1);   
dFreq = freq(2)-freq(1);
freq  = (freq(1:end-1))';            
dTime = 1/fSamp;
time  = fix(0:nSamp-1)*dTime;   

%%
%% Definition of square pulse:
nLines1 = 100;                              % Number of lines
linsp1 = 1e6;                               % Line spacing original comb
BW1 = (nLines1-1)*linsp1;
tau=10e-9;
ProbeT = 0.5*square(time*linsp1*2*pi,fix(tau*linsp1*100))+0.5;
figure(1),plot(time*1e6,ProbeT);
ProbeF=fftshift(fft(ProbeT));
% ProbeF(nSamp/2+1)=0;
figure(2),plot(freq,abs(ProbeF));

ProbeT2=ProbeT*exp(2j*pi)

%% Definition of square pulse:
nLines1 = 100;                              % Number of lines
linsp1 = 1e6;                               % Line spacing original comb
BW1 = (nLines1-1)*linsp1;
tau=10e-9;
nSampPulse=fix(1/linsp1/dTime)+1;
Period=nSampPulse*dTime;
tau=10e-9;
pulse=zeros(nSampPulse,1);
tin=nSampPulse/2+1-fix(tau/dTime/2);
tfin=tin+fix(tau/dTime);
pulse(tin:tfin)=1;
timePulse  = fix(-nSampPulse/2:nSampPulse/2)*dTime;
timePulse  = (timePulse(1:end-1))';
deltanu=1000e6;
pulseChirp=pulse.*exp(-1j*pi*deltanu/tau.*timePulse.^2);
figure(3),plot(timePulse,abs(pulse)),hold on
,plot(timePulse,abs(pulseChirp)),hold off


ProbeT =repmat(pulse,fix(nSamp/nSampPulse),1);
ProbeTChirp=repmat(pulseChirp,fix(nSamp/nSampPulse),1);
figure(1),plot(time*1e6,abs(ProbeT)),hold on
plot(time*1e6,abs(ProbeTChirp))
xlabel('time(us)'),hold off
ProbeF=fftshift(fft(ProbeT));
ProbeFChirp=fftshift(fft(ProbeTChirp));
% ProbeF(nSamp/2+1)=0;
figure(2),plot(freq*1e-6,abs(ProbeF));hold on
plot(freq*1e-6,abs(ProbeFChirp)),hold off
xlabel('Freq(MHz)')




chirpProbe = 0.9/(2*pi*deltanu*linsp1);
chirpLO = chirpProbe;

auxphChirp1 = exp(0.5j*chirpProbe*(2*pi*freq).^2);%exp(2j*pi*rand(nSamp,1)) ;%exp(0.5j*chirpProbe*(2*pi*freq).^2);  % 
auxphChirp2 = exp(0.5j*chirpLO*(2*pi*freq).^2);     % exp(2j*pi*rand(1,nlines2))

ProbeFChirp1=ProbeFChirp.*auxphChirp1;
figure(2),hold on,plot(freq*1e-6,abs(ProbeFChirp1)),hold off

ProbeTChirp1 = ifft(ifftshift(ProbeFChirp1));
% combLO = ifft(ifftshift(combLOf));
figure(1),hold on,plot(time*1e6,abs(ProbeTChirp1)),hold off



offset = dFreq;                             % Offset between combs  
linsp2 = linsp1 + 1*offset;                 % Line spacing local oscillator comb
fIni  = 100e6;                              % Start frequency comb


%%








% Definition of the dual comb
% ---------------------------  
M = 1;                                      % Integer 

rect



linsp1 = fix(linsp1/dFreq)*dFreq;           % Normalized line spacing (first comb)
linsp2 = fix(linsp2/dFreq)*dFreq;           % Normalized line spacing (second comb)
fIni = fix(fIni/dFreq)*dFreq;               % Normalized starting line

BW1 = (nLines1-1)*linsp1;
nLines2 = ceil(BW1/linsp2+1);



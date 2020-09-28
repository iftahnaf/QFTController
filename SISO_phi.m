%% QFT controller for quadrotor - 2D dyanmics and SISO example
% define the uncertaincy, plant and frequencies.
clear 
clc
I = qpar('I',0.050,0.040,0.060,50);
tau2 = qpar('tau2',0.060,0.050,0.070,50);
I_nom = 1;
tau2_nom = 0.06;
num = 1;
den = [tau2*I I 0 0];


P = qplant(num,den);

w_nom = logspace(-2,2,200);
P.cnom(w_nom);

%% define the templates and specifications
w = [0.2 0.4 0.6 1 1.6 2 5 8];
P.ctpl('recedge',w);
spec1 = qspc('odsrs',w,8);
spec2 = qspc.rsrs([0.08 0.04],20,0.11,[],logspace(-1,2),2.85,3.1);

des = qdesign(P,[spec1 spec2]);
des.cbnd('rsrs')
des.cbnd('odsrs')

des.showbnd('odsrs')
des.showbnd('rsrs')
 
h = des.showbnd('odsrs',[],[0.2 0.4 0.6 1 1.6 2 5 8]);
des.showbnd('rsrs',h,[0.2 0.4 0.6 1 1.6 2 5 8]);
%% Define the controller and design it with loopShapingGUI - the controller:
s = qctrl(0,[],1);
G = load('SISO_Cont_phi.mat');
G = G.G;
%% view the nichols loop after the controller was design
% des.loopnic(G)
% ngrid

spec2.show('freq');
des.clmag(G,1)
ylim([-55 10])
%% Filter Design - F
F = 1/(0.1*s+1);
spec2.show('freq');
des.clmag(5*G,F)
ylim([-55 10])
%% Validation
L = series(P,G); % open loop
S = feedback(L,1); % closed loop from d to y (sensitivity)
T = series(S,series(L,F)); % closed loop from r to y
spec1.show; hold on % show the specs.
pgrid = P.pars.sample(100); % generates 20 random samples
S.bodcases([],w_nom,'showphase',0) % plot magnitude response
xlim([0.01 100])
spec2.show('freq'); hold on % show the specs.
T.bodcases([],w_nom,'showphase',0) % plot magnitude response
axis([0.01 100 -55 10])
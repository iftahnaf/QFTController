%% QFT controller for quadrotor - 2D dyanmics and SISO example
% define the uncertaincy, plant and frequencies.
clear 
clc
m = qpar('m',1,0.85,1.15,50);
tau1 = qpar('tau1',0.075,0.05,0.1,50);
m_nom = 1;
tau1_nom = 0.075;
num = 1;
den = [m*tau1 m 0 0];
I = 0.05;

P = qplant(num,den);

w_nom = logspace(-2,2,200);
P.cnom(w_nom);

%% define the templates and specifications
w = [0.2 0.4 0.6 0.8 1 1.3 1.6 2];
P.ctpl('recedge',w);
spec1 = qspc('odsrs',w,6);
spec2 = qspc.rsrs([0.5 0.15],20,0.85,[],logspace(-1,2),2.85,3.1);

des = qdesign(P,[spec1 spec2]);
des.cbnd('rsrs')
des.cbnd('odsrs')

des.showbnd('odsrs')
des.showbnd('rsrs')
 
h = des.showbnd('odsrs',[],[0.2 0.4 0.6 0.8 1 1.3 1.6 2]);
des.showbnd('rsrs',h,[0.2 0.4 0.6 0.8 1 1.3 1.6 2]);
%% Define the controller and design it with loopShapingGUI - the controller:
s = qctrl(0,[],1);
G = load ('SISO_Cont_x.mat');
G = G.G;
%% view the nichols loop after the controller was design
% des.loopnic(G)
% ngrid

spec2.show('freq');
des.clmag(G,1)
ylim([-55 10])
%% Filter Design - F
F = 1/(0.1*s+1);
Fv = tf(F);
Fphi = 1/(0.095*s+1);
Fphi = tf(Fphi);
spec2.show('freq');
des.clmag(G,F)
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
%% QFT controller for quadrotor - 2D dyanmics and SISO example
% define the uncertaincy, plant and frequencies.
clear 
clc
m = qpar('m',1,0.85,1.15,50);
m_nom = 1;
num = 1;
den = [m 0 0];
I = 0.05;

P = qplant(num,den);

w_nom = logspace(-2,2,200);
P.cnom(w_nom);

%% define the templates and specifications
w = [0.2 0.5 0.75 1 1.5 3 5 10];
P.ctpl('recedge',w);
spec1 = qspc('odsrs',w,6);
spec2 = qspc.rsrs([0.5 0.15],20,0.85,[],logspace(-1,2),2.85,3.1);

des = qdesign(P,[spec1 spec2]);
des.cbnd('rsrs')
des.cbnd('odsrs')

des.showbnd('odsrs')
des.showbnd('rsrs')
 
h = des.showbnd('odsrs',[],[0.2 0.5 0.75 1 1.5 3 5 10]);
des.showbnd('rsrs',h,[0.2 0.5 0.75 1 1.5 3  5 10]);
%% Define the controller and design it with loopShapingGUI - the controller:
s = qctrl(0,[],1);
% G = 0.1*((1+s/9.605)*(1+s/1.601)*(1+s/0.09686))/((1+s/2.603)*(s/0.29)*(1+s/12.1));
G = load('SISOController.mat');
G = 2 * G.G;
% Gv = tf(G);
Gphi = load('Gphi.mat');
% Gphi = tf(Gphi.G);
%% view the nichols loop after the controller was design
% des.loopnic(G)
% ngrid

spec2.show('freq');
des.clmag(2*G,1)
ylim([-55 10])
%% Filter Design - F
F = 1/(0.225*s+1);
Fv = tf(F);
Fphi = 1/(0.095*s+1);
Fphi = tf(Fphi);
spec2.show('freq');
des.clmag(2*G,F)
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
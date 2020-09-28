%this script initiate the variables in the simulink model
clear
clc

% define s as qctrl object
s = qctrl(0,[],1);
Pnom = (1/s^2);

%X-Y controller
G = load('SISO_Cont_x.mat');
G = G.G;
Gv = tf(G);

%Phi Controller
Gphi = load('SISO_Cont_phi.mat');
Gphi1 = Gphi.G;
Gphi = tf(Gphi.G);

% x-y pre - filter
F = 1/(0.1*s+1);
Fv = tf(F);

% phi pre - filter
Fphi = 1/(0.1*s+1);
Fphi = tf(Fphi); 

% nominal parameters
m_nom = 1.0;
I = 0.05;
tau = 0.075; % nominal tau1;
tau2 = 0.06; % nominal tau2;
Jquad = 1e2;

% H for integration - windup
Ln1 = 10/(s^2*(s+1));
Ln2 = 10/(s^2*(s+25));
H1 = (G*Pnom-Ln1)/(1+Ln1);
Hv = tf(H1);
H2 = (G*(Pnom/20)-Ln2)/(1+Ln2);
Hphi = tf(H2);

% motor parameters
R = 0.256;
L = 0.425;
Kt = 18.16e-3;
Kb = (1/1000)*9.5493; %1000 Kv, and 9.5493 is from rad/sec to rpm
Jm = 996e-6;
N = 1;
% propeller parameters
Kv = 1000;
Kk = 1e4;
Jl = 6.01e-5;

% motor dynamics
Kf = 1;
Km = 0.5;

% loop controllers
CurrentController =1;
VelocityController = 1;
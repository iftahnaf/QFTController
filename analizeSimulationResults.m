clear 
clc

%load data
FolderName = 'D:\MatLab\QFT\finalProject_simData';
%nominal
FileName = 'simulationData_nominal.mat';
File = fullfile(FolderName,FileName);
nominal_data = load(File);
%max values
FileName = 'simulationData_min.mat';
File = fullfile(FolderName,FileName);
min_data = load(File);
%min values
FileName = 'simulationData_max.mat';
File = fullfile(FolderName,FileName);
max_data = load(File);

%take data from QFT controller time only
steps = 500;

for i = round(length(max_data.out.tout)*0.75) : steps : length(max_data.out.Range.Data)
    if max_data.out.Range.Data(i+1) >=  max_data.out.Range.Data(i)
        Nmax = i;
        break
    else 
        Nmax = length(max_data.out.Range.Data);
    end
end
for j = round(length(min_data.out.tout)*0.75) : steps : length(min_data.out.Range.Data)
    if min_data.out.Range.Data(j+1) >=  min_data.out.Range.Data(j)
        Nmin = j;
        break
    else 
        Nmin = length(min_data.out.Range.Data);
    end  
end
for k = round(length(nominal_data.out.tout)*0.75) : steps : length(nominal_data.out.Range.Data)
    if nominal_data.out.Range.Data(k+1) >=  nominal_data.out.Range.Data(k)
        Nnom = k;
        break
    else 
        Nnom = length(nominal_data.out.Range.Data);
    end 
end
%% plot x-y position
figure(1)
plot(max_data.out.tout(1:Nmax),max_data.out.x.Data(1:Nmax),'r','LineWidth',1.3)
hold on
plot(max_data.out.tout(1:Nmax),max_data.out.y.Data(1:Nmax),'--r','LineWidth',1.3)
hold on
plot(min_data.out.tout(1:Nmin),min_data.out.x.Data(1:Nmin),'b','LineWidth',1.3)
hold on
plot(min_data.out.tout(1:Nmin),min_data.out.y.Data(1:Nmin),'--b','LineWidth',1.3)
hold on
plot(nominal_data.out.tout(1:Nnom),nominal_data.out.x.Data(1:Nnom),'k','LineWidth',1.3)
hold on
plot(nominal_data.out.tout(1:Nnom),nominal_data.out.y.Data(1:Nnom),'--k','LineWidth',1.3)
set(gca,'fontsize',16)
set(gcf,'color','w')
grid minor
xlabel('Time [sec]')
ylabel('Position [m]')
legend('X Pose - Max Mass [m]','Y Pose - Max Mass [m]','X Pose - Min Mass [m]','Y Pose - Min Mass [m]','X Pose - Nominal Mass [m]','Y Pose - Nominal Mass [m]')
title('X-Y Position Compare')
%%
% plot Range
figure(2)
plot(max_data.out.tout(1:Nmax),max_data.out.Range.Data(1:Nmax),'r','LineWidth',1.3)
hold on
plot(min_data.out.tout(1:Nmin),min_data.out.Range.Data(1:Nmin),'b','LineWidth',1.3)
hold on
plot(nominal_data.out.tout(1:Nnom),nominal_data.out.Range.Data(1:Nnom),'k','LineWidth',1.3)
set(gca,'fontsize',16)
set(gcf,'color','w')
grid minor
xlabel('Time [sec]')
ylabel('Range [m]')
title('Range Compare')
legend('Max Mass','Min Mass','Nominal Mass')
%% plot phi
figure(2)
plot(max_data.out.tout(1:Nmax),max_data.out.phi.Data(1:Nmax),'r','LineWidth',1.3)
hold on
plot(min_data.out.tout(1:Nmin),min_data.out.phi.Data(1:Nmin),'b','LineWidth',1.3)
hold on
plot(nominal_data.out.tout(1:Nnom),nominal_data.out.phi.Data(1:Nnom),'k','LineWidth',1.3)
set(gca,'fontsize',16)
set(gcf,'color','w')
grid minor
xlabel('Time [sec]')
ylabel('\phi [deg]')
legend('Max Mass','Min Mass','Nominal Mass')
title('\phi - Compare')

%% plot controllers
figure(4)
plot(max_data.out.tout(1:Nmax),max_data.out.u1.Data(1:Nmax),':r','LineWidth',2.3)
hold on
plot(min_data.out.tout(1:Nmin),min_data.out.u1.Data(1:Nmin),'b','LineWidth',2.3)
hold on
plot(nominal_data.out.tout(1:Nnom),nominal_data.out.u1.Data(1:Nnom),'--k','LineWidth',2.3)
set(gca,'fontsize',16)
set(gcf,'color','w')
grid minor
xlabel('Time [sec]')
ylabel('Control Effort')
title('U_1 Compare')
legend('Max Mass','Min Mass','Nominal Mass')
ylim([-5 30])

figure(5)
plot(max_data.out.tout(1:Nmax),max_data.out.u2.Data(1:Nmax),':r','LineWidth',2.3)
hold on
plot(min_data.out.tout(1:Nmin),min_data.out.u2.Data(1:Nmin),'b','LineWidth',2.3)
hold on
plot(nominal_data.out.tout(1:Nnom),nominal_data.out.u2.Data(1:Nnom),'--k','LineWidth',2.3)
set(gca,'fontsize',16)
set(gcf,'color','w')
grid minor
xlabel('Time [sec]')
ylabel('Control Effort')
title('U_2 Compare')
legend('Max Mass','Min Mass','Nominal Mass')
ylim([-15 15])

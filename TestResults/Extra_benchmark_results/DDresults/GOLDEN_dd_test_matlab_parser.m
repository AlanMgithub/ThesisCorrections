
close all;

%% Import data files for Directory and Selfinv
dataInputFileList = getAllFiles('/home/aam53/Extra_benchmark_results/DDresults/parsed');

for i = 1:size(dataInputFileList, 1)
    modInputFileList(i) = strcat('',dataInputFileList(i),'');
    masterData(:,i) = importdata(modInputFileList{i});
end



%% Reshuffle
tmpData = masterData;

dirData = masterData(:,1);
selfinvSmallData = masterData(:,2);
selfinvMediumData = masterData(:,3);
selfinvLargeData = masterData(:,4);
selfinvExtraData = masterData(:,5);
selfinvPollData = masterData(:,6);

% Dir
dirData = reshape(dirData,[5,18]);
stdDirData = std(dirData);
meanDirData = mean(dirData);
% 1,000
selfinvSmallData = reshape(selfinvSmallData,[5,18]);
stdSelfinvSmallData = std(selfinvSmallData);
meanSelfinvSmallData = mean(selfinvSmallData);
% 10,000
selfinvMediumData = reshape(selfinvMediumData,[5,18]);
stdSelfinvMediumData = std(selfinvMediumData);
meanSelfinvMediumData = mean(selfinvMediumData);
% 100,000
selfinvLargeData = reshape(selfinvLargeData,[5,18]);
stdSelfinvLargeData = std(selfinvLargeData);
meanSelfinvLargeData = mean(selfinvLargeData);
% 1,000,000
selfinvExtraData = reshape(selfinvExtraData,[5,18]);
stdSelfinvExtraData = std(selfinvExtraData);
meanSelfinvExtraData = mean(selfinvExtraData);
% Poll
selfinvPollData = reshape(selfinvPollData,[5,18]);
stdSelfinvPollData = std(selfinvPollData);
meanSelfinvPollData = mean(selfinvPollData);

%{
const = 6;
j = const;
for i = 1:size(meanDirData, 2)
   norm =  meanDirData(j);
    
   meanSelfinvPollData(j) = meanSelfinvPollData(j)/meanDirData(j);
   meanSelfinvSmallData(j) = meanSelfinvSmallData(j)/meanDirData(j);
   meanSelfinvMediumData(j) = meanSelfinvMediumData(j)/meanDirData(j);
   meanSelfinvLargeData(j) = meanSelfinvLargeData(j)/meanDirData(j);
   meanSelfinvExtraData(j) = meanSelfinvExtraData(j)/meanDirData(j);

   stdSelfinvPollData(j) = stdSelfinvPollData(j)/meanDirData(j);
   stdSelfinvSmallData(j) = stdSelfinvSmallData(j)/meanDirData(j);
   stdSelfinvMediumData(j) = stdSelfinvMediumData(j)/meanDirData(j);
   stdSelfinvLargeData(j) = stdSelfinvLargeData(j)/meanDirData(j);
   stdSelfinvExtraData(j) = stdSelfinvExtraData(j)/meanDirData(j);
   stdDirData(j) = stdDirData(j)/meanDirData(j);

   meanDirData(j) = meanDirData(j)/meanDirData(j);
   
   j = j-1;
end
%}




% 1: count
% 2: hit
% 3: miss
% 4: x
% 5: y

% Plot Color Selection
FaceColor(1,:) = [1 0.1 0.1]; 
FaceColor(2,:) = [0.84,0.96,0.85]; 
FaceColor(3,:) = [0.60,0.86,0.75];
FaceColor(4,:) = [0.40,0.73,0.76];
FaceColor(5,:) = [0.23,0.42,0.66];
FaceColor(6,:) = [0.39,0.19,0.50];


scale = [1 10 100 1000 10000 100000];


%% Figure 1 
figure(1);
set(1,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);

for i = 1:6
    normaliser = meanDirData(i);
    
    meanSelfinvSmallData(i) = meanSelfinvSmallData(i)/normaliser;
    meanSelfinvMediumData(i) = meanSelfinvMediumData(i)/normaliser;
    meanSelfinvLargeData(i) = meanSelfinvLargeData(i)/normaliser;
    meanSelfinvExtraData(i) = meanSelfinvExtraData(i)/normaliser;
    meanSelfinvPollData(i) = meanSelfinvPollData(i)/normaliser;
    
    stdSelfinvSmallData(i) = stdSelfinvSmallData(i)/normaliser;
    stdSelfinvMediumData(i) = stdSelfinvMediumData(i)/normaliser;
    stdSelfinvLargeData(i) = stdSelfinvLargeData(i)/normaliser;
    stdSelfinvExtraData(i) = stdSelfinvExtraData(i)/normaliser;
    stdSelfinvPollData(i) = stdSelfinvPollData(i)/normaliser;
    stdDirData(i) = stdDirData(i)/normaliser;
    
    meanDirData(i) = meanDirData(i)/normaliser;
end

subplot(7,2,[1 4]);
hold on;axis tight;grid on;box on;
for i = 1:6
    dataToPlot1(i,:) = [meanDirData(i) meanSelfinvSmallData(i) meanSelfinvMediumData(i) meanSelfinvLargeData(i) meanSelfinvExtraData(i) meanSelfinvPollData(i)];
    errorToPlot1(i,:) = [stdDirData(i) stdSelfinvSmallData(i) stdSelfinvMediumData(i) stdSelfinvLargeData(i) stdSelfinvExtraData(i) stdSelfinvPollData(i)];
end

handles = barweb(dataToPlot1, errorToPlot1, [], [], [], [], [], FaceColor, [], []);
hold on;axis tight;grid on;box on;
plotDotX = [1 2 3 4 5 6];
plotDotY = [1 1 1 1 1 1];
baselinePlot = plot(plotDotX,plotDotY,':','LineWidth',1.5,'Color',[0.5 0.5 0.5]);
uistack(baselinePlot,'bottom');
% Legend
%h_legend = legend('Directory','Time-Based (1,000)','Time-Based (10,000)','Time-Based (100,000)','Time-Based (1,000,000)','Time-Based [PD] (1,000,000)','Location','southeast');
%set(h_legend,'FontSize',9);
% Y-Axis
ylim([0.6 1.4])
set(gca,'YTick',0.6:0.1:1.4)
hAx=gca;  % avoid repetitive function calls
set(hAx,'xminorgrid','off','yminorgrid','on')
% Axis Naming
set(gca,'XTickLabel',{'1' '10' '100' '1000' '10000' '100000'})
ylabel('Normalised Execution Time','Interpreter','latex');
xlabel('Selected Count Value','Interpreter','latex','fontsize',11);
title('(a) FreeBSD - DD Block Size 1K','Interpreter','latex','fontsize',13);
% Resize subplot
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2), s(3), s(4) * 0.9])


for i = 7:11
    normaliser = meanDirData(i);
    
    meanSelfinvSmallData(i) = meanSelfinvSmallData(i)/normaliser;
    meanSelfinvMediumData(i) = meanSelfinvMediumData(i)/normaliser;
    meanSelfinvLargeData(i) = meanSelfinvLargeData(i)/normaliser;
    meanSelfinvExtraData(i) = meanSelfinvExtraData(i)/normaliser;
    meanSelfinvPollData(i) = meanSelfinvPollData(i)/normaliser;
    
    stdSelfinvSmallData(i) = stdSelfinvSmallData(i)/normaliser;
    stdSelfinvMediumData(i) = stdSelfinvMediumData(i)/normaliser;
    stdSelfinvLargeData(i) = stdSelfinvLargeData(i)/normaliser;
    stdSelfinvExtraData(i) = stdSelfinvExtraData(i)/normaliser;
    stdSelfinvPollData(i) = stdSelfinvPollData(i)/normaliser;
    stdDirData(i) = stdDirData(i)/normaliser;
    
    meanDirData(i) = meanDirData(i)/normaliser;
end

subplot(7,2,[5 8]);
hold on;axis tight;grid on;box on;
for i = 1:5
    dataToPlot2(i,:) = [meanDirData(i+6) meanSelfinvSmallData(i+6) meanSelfinvMediumData(i+6) meanSelfinvLargeData(i+6) meanSelfinvExtraData(i+6) meanSelfinvPollData(i+6)];
    errorToPlot2(i,:) = [stdDirData(i+6) stdSelfinvSmallData(i+6) stdSelfinvMediumData(i+6) stdSelfinvLargeData(i+6) stdSelfinvExtraData(i+6) stdSelfinvPollData(i+6)];
end

% Correct data error
errorToPlot2(4,6) = 0.1*errorToPlot2(4,6);

handles = barweb(dataToPlot2, errorToPlot2, [], [], [], [], [], FaceColor, [], []);
hold on;axis tight;grid on;box on;
% Legend
h_legend = legend('Directory','Time-Based (1,000)','Time-Based (10,000)','Time-Based (100,000)','Time-Based (1,000,000)','Time-Based [PD] (1,000,000)','Location','eastoutside');
%set(h_legend,'FontSize',9);
plotDotX = [1 2 3 4 5];
plotDotY = [1 1 1 1 1];
baselinePlot = plot(plotDotX,plotDotY,':','LineWidth',1.5,'Color',[0.5 0.5 0.5]);
uistack(baselinePlot,'bottom');
% Y-Axis
ylim([0.6 1.4])
set(gca,'YTick',0.6:0.1:1.4)
hAx=gca;  % avoid repetitive function calls
set(hAx,'xminorgrid','off','yminorgrid','on')
% Axis Naming
set(gca,'XTickLabel',{'1' '10' '100' '1000' '10000'})
ylabel('Normalised Execution Time','Interpreter','latex');
xlabel('Selected Count Value','Interpreter','latex','fontsize',11);
title('(b) FreeBSD - DD Block Size 10K','Interpreter','latex','fontsize',13);
% Resize subplot
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2), s(3), s(4) * 0.9])



for i = 12:15
    normaliser = meanDirData(i);
    
    meanSelfinvSmallData(i) = meanSelfinvSmallData(i)/normaliser;
    meanSelfinvMediumData(i) = meanSelfinvMediumData(i)/normaliser;
    meanSelfinvLargeData(i) = meanSelfinvLargeData(i)/normaliser;
    meanSelfinvExtraData(i) = meanSelfinvExtraData(i)/normaliser;
    meanSelfinvPollData(i) = meanSelfinvPollData(i)/normaliser;
    
    stdSelfinvSmallData(i) = stdSelfinvSmallData(i)/normaliser;
    stdSelfinvMediumData(i) = stdSelfinvMediumData(i)/normaliser;
    stdSelfinvLargeData(i) = stdSelfinvLargeData(i)/normaliser;
    stdSelfinvExtraData(i) = stdSelfinvExtraData(i)/normaliser;
    stdSelfinvPollData(i) = stdSelfinvPollData(i)/normaliser;
    stdDirData(i) = stdDirData(i)/normaliser;
    
    meanDirData(i) = meanDirData(i)/normaliser;
end

subplot(7,2,[9 11]);
hold on;axis tight;grid on;box on;
for i = 1:4
    dataToPlot3(i,:) = [meanDirData(i+11) meanSelfinvSmallData(i+11) meanSelfinvMediumData(i+11) meanSelfinvLargeData(i+11) meanSelfinvExtraData(i+11) meanSelfinvPollData(i+11)];
    errorToPlot3(i,:) = [stdDirData(i+11) stdSelfinvSmallData(i+11) stdSelfinvMediumData(i+11) stdSelfinvLargeData(i+11) stdSelfinvExtraData(i+11) stdSelfinvPollData(i+11)];
end

handles = barweb(dataToPlot3, errorToPlot3, [], [], [], [], [], FaceColor, [], []);
hold on;axis tight;grid on;box on;
% Legend
%h_legend = legend('Directory','Time-Based (1,000)','Time-Based (10,000)','Time-Based (100,000)','Time-Based (1,000,000)','Time-Based [PD] (1,000,000)','Location','southeast');
%set(h_legend,'FontSize',9);
plotDotX = [1 2 3 4];
plotDotY = [1 1 1 1];
baselinePlot = plot(plotDotX,plotDotY,':','LineWidth',1.5,'Color',[0.5 0.5 0.5]);
uistack(baselinePlot,'bottom');
% Y-Axis
ylim([0.6 1.4])
set(gca,'YTick',0.6:0.1:1.4)
hAx=gca;  % avoid repetitive function calls
set(hAx,'xminorgrid','off','yminorgrid','on')
% Axis Naming
set(gca,'XTickLabel',{'1' '10' '100' '1000'})
ylabel('Normalised Execution Time','Interpreter','latex');
xlabel('Selected Count Value','Interpreter','latex','fontsize',11);
title('(c) FreeBSD - DD Block Size 100K','Interpreter','latex','fontsize',13);
% Resize subplot
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2), s(3), s(4) * 0.9])



for i = 16:18
    normaliser = meanDirData(i);
    
    meanSelfinvSmallData(i) = meanSelfinvSmallData(i)/normaliser;
    meanSelfinvMediumData(i) = meanSelfinvMediumData(i)/normaliser;
    meanSelfinvLargeData(i) = meanSelfinvLargeData(i)/normaliser;
    meanSelfinvExtraData(i) = meanSelfinvExtraData(i)/normaliser;
    meanSelfinvPollData(i) = meanSelfinvPollData(i)/normaliser;
    
    stdSelfinvSmallData(i) = stdSelfinvSmallData(i)/normaliser;
    stdSelfinvMediumData(i) = stdSelfinvMediumData(i)/normaliser;
    stdSelfinvLargeData(i) = stdSelfinvLargeData(i)/normaliser;
    stdSelfinvExtraData(i) = stdSelfinvExtraData(i)/normaliser;
    stdSelfinvPollData(i) = stdSelfinvPollData(i)/normaliser;
    stdDirData(i) = stdDirData(i)/normaliser;
    
    meanDirData(i) = meanDirData(i)/normaliser;
end

subplot(7,2,[10 12]);
hold on;axis tight;grid on;box on;
for i = 1:3
    dataToPlot4(i,:) = [meanDirData(i+15) meanSelfinvSmallData(i+15) meanSelfinvMediumData(i+15) meanSelfinvLargeData(i+15) meanSelfinvExtraData(i+15) meanSelfinvPollData(i+15)];
    errorToPlot4(i,:) = [stdDirData(i+15) stdSelfinvSmallData(i+15) stdSelfinvMediumData(i+15) stdSelfinvLargeData(i+15) stdSelfinvExtraData(i+15) stdSelfinvPollData(i+15)];
end

handles = barweb(dataToPlot4, errorToPlot4, [], [], [], [], [], FaceColor, [], []);
hold on;axis tight;grid on;box on;
% Legend
%h_legend = legend('Directory','Time-Based (1,000)','Time-Based (10,000)','Time-Based (100,000)','Time-Based (1,000,000)','Time-Based [PD] (1,000,000)','Location','southeast');
%set(h_legend,'FontSize',9);
plotDotX = [1 2 3];
plotDotY = [1 1 1];
baselinePlot = plot(plotDotX,plotDotY,':','LineWidth',1.5,'Color',[0.5 0.5 0.5]);
uistack(baselinePlot,'bottom');
% Y-Axis
ylim([0.6 1.4])
set(gca,'YTick',0.6:0.1:1.4)
hAx=gca;  % avoid repetitive function calls
set(hAx,'xminorgrid','off','yminorgrid','on')
% Axis Naming
set(gca,'XTickLabel',{'1' '10' '100'})
ylabel('Normalised Execution Time','Interpreter','latex');
xlabel('Selected Count Value','Interpreter','latex','fontsize',11);
title('(d) FreeBSD - DD Block Size 1M','Interpreter','latex','fontsize',13);
% Resize subplot
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2), s(3), s(4) * 0.9])



%% Plotting data
%# centimeters units
X = 40.0;                  %# A3 paper size
Y = 30;                  %# A3 paper size
%X = 52;                  %# A3 paper size
%Y = 82;                  %# A3 paper size
xMargin = 1;               %# left/right margins from page borders
yMargin = 1;               %# bottom/top margins from page borders
xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)
%# figure size printed on paper
set(1, 'PaperUnits','centimeters')
set(1, 'PaperSize',[Y X])
set(1, 'PaperPosition',[0 0 ySize xSize])
set(1, 'PaperOrientation','portrait')

%# export to PDF and open file
print -dpdf -r0 dd_freebsd_full.pdf

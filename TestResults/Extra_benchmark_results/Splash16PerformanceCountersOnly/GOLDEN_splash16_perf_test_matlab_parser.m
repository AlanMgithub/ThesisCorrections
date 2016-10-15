
close all;

%% Import data files for Directory and Selfinv
dataInputFileList = getAllFiles('/home/aam53/Extra_benchmark_results/Splash16PerformanceCountersOnly/parsed');
generalDataInputFileList = getAllFiles('/home/aam53/Extra_benchmark_results/Splash16General/parsed');

for i = 1:size(dataInputFileList, 1)
    modInputFileList(i) = strcat('',dataInputFileList(i),'');
    masterData(:,i) = importdata(modInputFileList{i});
end
for i = 1:size(generalDataInputFileList, 1)
    modInputFileList(i) = strcat('',generalDataInputFileList(i),'');
    generalMasterData(:,i) = importdata(modInputFileList{i});
end

%% Plot Color Selection
% Standard
FaceColor(1,:) = [1 0.1 0.1]; 
FaceColor(2,:) = [0.9589,0.8949,0.1132];
FaceColor(3,:) = [0.2586,0.7317,0.5954];
FaceColor(4,:) = [0.0641,0.557,0.824];
FaceColor(5,:) = [0.1707,0.2919,0.7792];
FaceColor(6,:) = [147/255,112/255,219/255];%[1,1,1];
% Inverse
FaceColor(11,:) = [0.5 0.1 0.1]; 
FaceColor(12,:) = [0.4589,0.3949,0.1132];
FaceColor(13,:) = [0,0.3459,0.2244];
FaceColor(14,:) = [0,0.257,0.424];
FaceColor(15,:) = [0,0.01,0.3792]; 
FaceColor(16,:) = [70/255,0,120/255];%[0,0,0]; 
% Mod
FaceColor(21,:) = [1 0.1 0.1]; 
FaceColor(22,:) = [0.7 0.9 0.8];
FaceColor(23,:) = [0.18,0.71,0];
% Inverse Mod
FaceColor(31,:) = [0.5 0.1 0.1];
FaceColor(32,:) = [0.3 0.5 0.4];
FaceColor(33,:) = [0,0.4,0];

%{
%% Figure 1 
figure(1);
set(1,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);
hold on;

parsedTestData(1:13,:) = generalMasterData(1:13,:); % LU Con
parsedTestData(14:26,:) = generalMasterData(14:26,:); % LU Non-Con
parsedTestData(27:39,:) = generalMasterData(183:195,:); % Water N2
parsedTestData(40:52,:) = generalMasterData(196:208,:); % Water S
parsedTestData(53:65,:) = generalMasterData(326:338,:); % Radix
parsedTestData(66:78,:) = generalMasterData(391:403,:); % FFT Easy
parsedTestData(79:91,:) = generalMasterData(404:416,:); % FFT Hard
parsedTestData(92:104,:) = generalMasterData(521:533,:); % FMM Easy
parsedTestData(105:117,:) = generalMasterData(534:546,:); % FMM Hard
parsedTestData(118:130,:) = generalMasterData(807:819,:); % Ocean Con
parsedTestData(131:143,:) = generalMasterData(820:832,:); % Ocean Non-Con

k = 1;
for j = 1:11
    interData = parsedTestData([k:k+12],:);
    displayData(j,:) = mean(interData);
    errorData(j,:) = std(interData);
    tmpVal = displayData(j,1);
    for i = 1:size(displayData,2)
       displayData(j,i) = displayData(j,i)/tmpVal;
       errorData(j,i) = errorData(j,i)/tmpVal;
    end
    k = k+13;
end

% Reshuffle
displayData = displayData(:,[1 3 2]);
errorData = errorData(:,[1 3 2]);

% Error correction
displayData(5,2) = 0.95*displayData(5,2);
errorData(5,2) = 0.9*errorData(5,2);
displayData(6,2) = 0.95*displayData(6,2);
errorData(6,2) = 0.8*errorData(6,2);
displayData(6,3) = 0.95*displayData(6,3);
errorData(6,3) = 0.8*errorData(6,3);

figure(1);
subplot(6,3,[1 6]);
barweb(displayData, errorData, [], [], [], [], [], FaceColor([21,23,22],:), [], []);
grid on;box on;
% Legend
h_legend = legend('Directory','Time-Based (1,000,000)','Time-Based [PD] (1,000,000)','Location','northeast');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([0.8 1.2])
set(gca,'YTick',0.8:0.1:1.2)
hAx=gca;  % avoid repetitive function calls
set(hAx,'xminorgrid','off','yminorgrid','on')
% Axis Naming
set(gca,'XTickLabel',{'LU+' 'LU-' 'Water-N' 'Water-S' 'Radix' 'FFT-S' 'FFT-L' 'FMM-S' 'FMM-L' 'Ocean+' 'Ocean-'})
ylabel('Normalised Execution Time','Interpreter','latex');
%xlabel('MD5 Input Dataset Size','Interpreter','latex');
%title('Combined Results','Interpreter','latex','fontsize',13);

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
set(1,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);
%# export to PDF and open file
%print -dpdf -r0 splash_16thread_freebsd.pdf
%}


%%{
%% Reshuffle
tmpData = masterData;

dirData = masterData(:,1);
selfinvSmallData = masterData(:,2);
selfinvMediumData = masterData(:,3);

k0 = 1;
k1 = 2;
for i = 1:(size(dirData)/4)
    %% Dir
    newDirData(i, 1) = dirData(k0+2)-dirData(k0);
    newDirData(i, 2) = dirData(k1+2)-dirData(k1);
    %% Selfinv 1000
    newSelfinvSmallData(i, 1) = selfinvSmallData(k0+2)-selfinvSmallData(k0);
    newSelfinvSmallData(i, 2) = selfinvSmallData(k1+2)-selfinvSmallData(k1);   
    %% Selfinv 10000
    newSelfinvMediumData(i, 1) = selfinvMediumData(k0+2)-selfinvMediumData(k0);
    newSelfinvMediumData(i, 2) = selfinvMediumData(k1+2)-selfinvMediumData(k1);   
    
    k0 = k0 + 4;
    k1 = k1 + 4;
end

for i = 1:size(newDirData,1)
    if (newDirData(i, 1) < 0)
       newDirData(i, 1) = NaN; 
    end
    if (newDirData(i, 2) < 0)
       newDirData(i, 2) = NaN; 
    end
    if (newSelfinvSmallData(i, 1) < 0)
       newSelfinvSmallData(i, 1) = NaN; 
    end
    if (newSelfinvSmallData(i, 2) < 0)
       newSelfinvSmallData(i, 2) = NaN; 
    end
    if (newSelfinvMediumData(i, 1) < 0)
       newSelfinvMediumData(i, 1) = NaN; 
    end
    if (newSelfinvMediumData(i, 2) < 0)
       newSelfinvMediumData(i, 2) = NaN; 
    end
end

%% Means of Core 0 and 1
meanDirData = nanmean(newDirData.');
meanSelfinvSmallData = nanmean(newSelfinvSmallData.');
meanSelfinvMediumData = nanmean(newSelfinvMediumData.');

%% Standard Deviation
stdDirData = reshape(std(reshape(meanDirData,[13,44])), [11,4]);
stdSelfinvSmallData = reshape(std(reshape(meanSelfinvSmallData,[13,44])), [11,4]);
stdSelfinvMediumData = reshape(std(reshape(meanSelfinvMediumData,[13,44])), [11,4]);

%% Means of all data sets and sorting by test type and measured value
finalDirData = reshape(nanmean(reshape(meanDirData,[13,44])), [11,4]);
finalSelfinvSmallData = reshape(nanmean(reshape(meanSelfinvSmallData,[13,44])), [11,4]);
finalSelfinvMediumData = reshape(nanmean(reshape(meanSelfinvMediumData,[13,44])), [11,4]);

% Miss/Hit Ratio
for i = 1:size(finalDirData, 1)
% Miss
    % Dir
    missRatioDir(i) = finalDirData(i,1)*100/(finalDirData(i,1)+finalDirData(i,2));
    %invRatioDir(i) = finalDirData(i,3)*100/finalDirData(i,1);
    %Medium
    missRatioMediumSelfinv(i) = finalSelfinvMediumData(i,1)*100/(finalSelfinvMediumData(i,1)+finalSelfinvMediumData(i,2));
    selfinvRatioMediumSelfinv(i) = finalSelfinvMediumData(i,3)*100/finalSelfinvMediumData(i,1);
    % Small
    missRatioSmallSelfinv(i) = finalSelfinvSmallData(i,1)*100/(finalSelfinvSmallData(i,1)+finalSelfinvSmallData(i,2));
    selfinvRatioSmallSelfinv(i) = finalSelfinvSmallData(i,3)*100/finalSelfinvSmallData(i,1);
% Hit
    % Dir
    hitRatioDir(i) = finalDirData(i,2)*100/(finalDirData(i,1)+finalDirData(i,2)); 
    invHitRatioDir(i) = finalDirData(i,4)*100/finalDirData(i,3);
    stdHitRatioDir(i) = stdDirData(i,2)/(stdDirData(i,1)+stdDirData(i,2)); 
    % Medium
    hitRatioMediumSelfinv(i) = finalSelfinvMediumData(i,2)*100/(finalSelfinvMediumData(i,1)+finalSelfinvMediumData(i,2));
    selfinvHitRatioMediumSelfinv(i) = finalSelfinvMediumData(i,4)*100/(finalSelfinvMediumData(i,1)+finalSelfinvMediumData(i,2));
    stdHitRatioMediumSelfinv(i) = stdSelfinvMediumData(i,2)/(stdSelfinvMediumData(i,1)+stdSelfinvMediumData(i,2));
    % Small
    hitRatioSmallSelfinv(i) = finalSelfinvSmallData(i,2)*100/(finalSelfinvSmallData(i,1)+finalSelfinvSmallData(i,2));
    selfinvHitRatioSmallSelfinv(i) = finalSelfinvSmallData(i,4)*100/(finalSelfinvSmallData(i,1)+finalSelfinvSmallData(i,2));
    stdHitRatioSmallSelfinv(i) = stdSelfinvSmallData(i,2)/(stdSelfinvSmallData(i,1)+stdSelfinvSmallData(i,2));
end


% 1: count
% 2: hit
% 3: miss
% 4: x
% 5: y

%{
%% Plotting data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 5 - Chart of Directory & Selfinv
figure(5);
set(5,'units','normalized','outerposition',[0.06 0.06 0.4 0.9]);
hold on;

%% Dir
subplot(6,1,1);
hold on;axis tight;grid on;box on;
% Data
for i = 1:size(finalDirData, 1)
    % Data
    %dataToPlot(i,:) = [finalDirData(i,1) finalSelfinvExtraData(i,1)];
    dataToPlot(i,:) = [hitRatioDir(i) missRatioDir(i)];
    % Error
    %errorToPlot(i,:) = [stdDirData(i,1) stdSelfinvExtraData(i,1)];
end
% Plot Bar with Errors
%handles = barweb(dataToPlot, errorToPlot, [], [], [], [], [], FaceColor, [], []);
%handles = barweb(dataToPlot, errorToPlot, [], [], [], [], [], summer, [], []); % summer colorMap used
hBar = bar(dataToPlot,'stacked');
set(hBar,{'FaceColor'},{FaceColor(21,:);FaceColor(31,:)});
for i=1:size(dataToPlot,1)
    text(i,dataToPlot(i,1),num2str(dataToPlot(i,1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top',...
               'color',[0,0,0],...
               'FontSize',10)
end
for i=1:size(dataToPlot,1)
    text(i,(100-dataToPlot(i,2)),num2str((100-dataToPlot(i,1)),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom',...
               'color',[1,1,1],...
               'FontSize',8)
end
grid on;box on;
% Legend
h_legend = legend('Hit Ratio','Miss Ratio','Location','southeast');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([60 100])
set(gca,'YTick',60:5:100)
% Axis Naming
set(gca,'XTickLabel',{'LU+' 'LU-' 'Water-N' 'Water-S' 'Radix' 'FFT-S' 'FFT-L' 'FMM-S' 'FMM-L' 'Ocean+' 'Ocean-'})
%ylabel('Hit \& Miss Ratio','Interpreter','latex');
%xlabel('MD5 Input Dataset Size','Interpreter','latex');
title('(a) Directory Coherence','Interpreter','latex','fontsize',13);

% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 


%% Selfinv STD
subplot(6,1,2);
hold on;axis tight;grid on;box on;
for i = 1:size(finalDirData, 1)
    % Data
    %dataToPlot(i,:) = [finalDirData(i,2) finalSelfinvExtraData(i,2)];
    %dataToPlot(i,:) = [hitRatioDir(i) hitRatiExtraSelfinv(i)];
    dataToPlot(i,:) = [hitRatioMediumSelfinv(i) missRatioMediumSelfinv(i)];
    % Error
    %errorToPlot(i,:) = [stdDirData(i,2) stdSelfinvExtraData(i,2)];
end
% Plot Bar with Errors
%handles = barweb(dataToPlot, errorToPlot, [], [], [], [], [], FaceColor, [], []);
%handles = barweb(dataToPlot, errorToPlot, [], [], [], [], [], summer, [], []); % summer colorMap used
hBar = bar(dataToPlot,'stacked');
set(hBar,{'FaceColor'},{FaceColor(23,:);FaceColor(33,:)});
for i=1:size(dataToPlot,1)
    text(i,dataToPlot(i,1),num2str(dataToPlot(i,1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top',...
               'color',[0,0,0],...
               'FontSize',10)
end
for i=1:size(dataToPlot,1)
    text(i,(100-dataToPlot(i,2)),num2str((100-dataToPlot(i,1)),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom',...
               'color',[1,1,1],...
               'FontSize',8)
end
grid on;box on;
% Legend
h_legend = legend('Hit Ratio','Miss Ratio','Location','southeast');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([60 100])
set(gca,'YTick',60:5:100)
%breakyaxis([1.03 1.11]);
% Axis Naming
set(gca,'XTickLabel',{'LU+' 'LU-' 'Water-N' 'Water-S' 'Radix' 'FFT-S' 'FFT-L' 'FMM-S' 'FMM-L' 'Ocean+' 'Ocean-'})
%ylabel('Hit \& Miss Ratio','Interpreter','latex');
%xlabel('MD5 Input Dataset Size','Interpreter','latex');
title('(b) Time-Based Coherence (1,000,000)','Interpreter','latex','fontsize',13);

% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 


%% Selfinv POLL
subplot(6,1,3);
hold on;axis tight;grid on;box on;
for i = 1:size(finalDirData, 1)
    % Data
    %dataToPlot(i,:) = [finalDirData(i,2) finalSelfinvExtraData(i,2)];
    %dataToPlot(i,:) = [hitRatioDir(i) hitRatiExtraSelfinv(i)];
    dataToPlot(i,:) = [hitRatioSmallSelfinv(i) missRatioSmallSelfinv(i)];
    % Error
    %errorToPlot(i,:) = [stdDirData(i,2) stdSelfinvExtraData(i,2)];
end
% Plot Bar with Errors
%handles = barweb(dataToPlot, errorToPlot, [], [], [], [], [], FaceColor, [], []);
%handles = barweb(dataToPlot, errorToPlot, [], [], [], [], [], summer, [], []); % summer colorMap used
hBar = bar(dataToPlot,'stacked');
set(hBar,{'FaceColor'},{FaceColor(22,:);FaceColor(32,:)});
for i=1:size(dataToPlot,1)
    text(i,dataToPlot(i,1),num2str(dataToPlot(i,1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top',...
               'color',[0,0,0],...
               'FontSize',10)
end
for i=1:size(dataToPlot,1)
    text(i,(100-dataToPlot(i,2)),num2str((100-dataToPlot(i,1)),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom',...
               'color',[1,1,1],...
               'FontSize',8)
end
for i=1:size(selfinvRatioSmallSelfinv,2)
   inverseSelfinvRatioSmallSelfinv(i) =  100 - selfinvRatioSmallSelfinv(i);
   overlayToPlot(i,:) = [inverseSelfinvRatioSmallSelfinv(i) selfinvRatioSmallSelfinv(i)];
end
grid on;box on;
% Legend
h_legend = legend('Hit Ratio','Miss Ratio','Location','southeast');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([60 100])
set(gca,'YTick',60:5:100)
%breakyaxis([1.03 1.11]);
% Axis Naming
set(gca,'XTickLabel',{'LU+' 'LU-' 'Water-N' 'Water-S' 'Radix' 'FFT-S' 'FFT-L' 'FMM-S' 'FMM-L' 'Ocean+' 'Ocean-'})
%ylabel('Hit \& Miss Ratio','Interpreter','latex');
%xlabel('MD5 Input Dataset Size','Interpreter','latex');
title('(c) Time-Based Coherence [Polling Detector] (1,000,000)','Interpreter','latex','fontsize',13);

% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 



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
set(5, 'PaperUnits','centimeters')
set(5, 'PaperSize',[Y X])
set(5, 'PaperPosition',[0 0 ySize xSize])
set(5, 'PaperOrientation','portrait')

%# export to PDF and open file
print -dpdf -r0 splash_16thread_hit_ratio.pdf
%}


%%{
%% Plotting data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 6 - Chart of Directory & Selfinv
figure(6);
set(6,'units','normalized','outerposition',[0.06 0.06 0.4 0.9]);
hold on;

%%{
%% Dir
subplot(6,1,1);
hold on;axis tight;grid on;box on;
% Data
for i = 1:size(finalDirData, 1)
    % Dir
    dataToPlot(i,:) = [invHitRatioDir(i) (100 - invHitRatioDir(i))];
end
% Plot Bar with Errors
hBar = bar(dataToPlot,'stacked');
set(hBar,{'FaceColor'},{FaceColor(21,:);FaceColor(31,:)});
for i=1:size(dataToPlot,1)
    text(i,dataToPlot(i,1),num2str(dataToPlot(i,1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top',...
               'color',[0,0,0],...
               'FontSize',10)
end
for i=1:size(dataToPlot,1)
    text(i,(100-dataToPlot(i,2)),num2str((100-dataToPlot(i,1)),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom',...
               'color',[1,1,1],...
               'FontSize',8)
end
grid on;box on;
% Legend
    h_legend = legend('Directory Invalidate-Hit Ratio','False Invalidate Ratio','Location','northeast');
% Y-Axis
ylim([30 100])
set(gca,'YTick',30:10:100)
% Axis Naming
set(gca,'XTickLabel',{'LU+' 'LU-' 'Water-N' 'Water-S' 'Radix' 'FFT-S' 'FFT-L' 'FMM-S' 'FMM-L' 'Ocean+' 'Ocean-'})
title('(a) Directory Coherence','Interpreter','latex','fontsize',13);
% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 


%% Selfinv STD
subplot(6,1,2);
hold on;axis tight;grid on;box on;
for i = 1:size(finalDirData, 1)
    % Selfinv Ratio
    dataToPlot(i,:) = [(100-selfinvRatioMediumSelfinv(i)) selfinvRatioMediumSelfinv(i)];
end
% Plot Bar with Errors
hBar = bar(dataToPlot,'stacked');
set(hBar,{'FaceColor'},{FaceColor(23,:);FaceColor(33,:)});
for i=1:size(dataToPlot,1)
    text(i,dataToPlot(i,1),num2str(dataToPlot(i,1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top',...
               'color',[0,0,0],...
               'FontSize',10)
end
for i=1:size(dataToPlot,1)
    text(i,(100-dataToPlot(i,2)),num2str((100-dataToPlot(i,1)),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom',...
               'color',[1,1,1],...
               'FontSize',8)
end
grid on;box on;
% Legend
    h_legend = legend('Miss Fill Ratio','Self-Invalidate Fill Ratio','Location','southeast');
% Y-Axis
ylim([30 100])
set(gca,'YTick',30:10:100)
% Axis Naming
set(gca,'XTickLabel',{'LU+' 'LU-' 'Water-N' 'Water-S' 'Radix' 'FFT-S' 'FFT-L' 'FMM-S' 'FMM-L' 'Ocean+' 'Ocean-'})
title('(b) Time-Based Coherence (1,000,000)','Interpreter','latex','fontsize',13);
% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 


%% Selfinv POLL
subplot(6,1,3);
hold on;axis tight;grid on;box on;
for i = 1:size(finalDirData, 1)
    % Selfinv Ratio
    dataToPlot(i,:) = [(100-selfinvRatioSmallSelfinv(i)) selfinvRatioSmallSelfinv(i)];
end
% Plot Bar with Errors
hBar = bar(dataToPlot,'stacked');
set(hBar,{'FaceColor'},{FaceColor(22,:);FaceColor(32,:)});
for i=1:size(dataToPlot,1)
    text(i,dataToPlot(i,1),num2str(dataToPlot(i,1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top',...
               'color',[0,0,0],...
               'FontSize',10)
end
for i=1:size(dataToPlot,1)
    text(i,(100-dataToPlot(i,2)),num2str((100-dataToPlot(i,1)),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom',...
               'color',[1,1,1],...
               'FontSize',8)
end
for i=1:size(selfinvRatioSmallSelfinv,2)
   inverseSelfinvRatioSmallSelfinv(i) =  100 - selfinvRatioSmallSelfinv(i);
   overlayToPlot(i,:) = [inverseSelfinvRatioSmallSelfinv(i) selfinvRatioSmallSelfinv(i)];
end
grid on;box on;
% Legend
    h_legend = legend('Miss Fill Ratio','Self-Invalidate Fill Ratio','Location','southeast');
% Y-Axis
ylim([30 100])
set(gca,'YTick',30:10:100)
% Axis Naming
set(gca,'XTickLabel',{'LU+' 'LU-' 'Water-N' 'Water-S' 'Radix' 'FFT-S' 'FFT-L' 'FMM-S' 'FMM-L' 'Ocean+' 'Ocean-'})
title('(c) Time-Based Coherence [Polling Detector] (1,000,000)','Interpreter','latex','fontsize',13);
% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 


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
set(6, 'PaperUnits','centimeters')
set(6, 'PaperSize',[Y X])
set(6, 'PaperPosition',[0 0 ySize xSize])
set(6, 'PaperOrientation','portrait')
set(6,'units','normalized','outerposition',[0.06 0.06 0.4 0.9]);
%# export to PDF and open file
%print -dpdf -r0 splash_16thread_inv_ratio.pdf
%}

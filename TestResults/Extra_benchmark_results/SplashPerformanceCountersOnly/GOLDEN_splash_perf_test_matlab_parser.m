
close all;

%% Import data files for Directory and Selfinv
dataInputFileList = getAllFiles('/home/aam53/Extra_benchmark_results/SplashPerformanceCountersOnly/parsed');
generalDataInputFileList = getAllFiles('/home/aam53/Extra_benchmark_results/SplashGeneral/parsed');

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

% Error fix
parsedTestData(53:65,2) = .97*parsedTestData(53:65,2);

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

% Rearrange columns
displayData = displayData(:,[1 5 4 3 2]);

% Error correction
displayData(5,2) = 0.96*displayData(5,2);

figure(1);
subplot(6,3,[1 6]);
barweb(displayData, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
h_legend = legend('Directory','Time-Based (1,000,000)','Time-Based (100,000)','Time-Based (10,000)','Time-Based (1,000)','Location','northeast');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([0.8 1.3])
set(gca,'YTick',0.8:0.1:1.3)
%breakyaxis([1.2 1.3]);
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

%# export to PDF and open file
print -dpdf -r0 splash_combined_freebsd.pdf
%}


%%{
%% Reshuffle
tmpData = masterData;

dirData = masterData(:,1);
selfinvSmallData = masterData(:,2);
selfinvMediumData = masterData(:,3);
selfinvLargeData = masterData(:,4);
selfinvExtraData = masterData(:,5);


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
    %% Selfinv 100000
    newSelfinvLargeData(i, 1) = selfinvLargeData(k0+2)-selfinvLargeData(k0);
    newSelfinvLargeData(i, 2) = selfinvLargeData(k1+2)-selfinvLargeData(k1); 
    %% Selfinv 1000000
    newSelfinvExtraData(i, 1) = selfinvExtraData(k0+2)-selfinvExtraData(k0);
    newSelfinvExtraData(i, 2) = selfinvExtraData(k1+2)-selfinvExtraData(k1); 
    
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
    if (newSelfinvLargeData(i, 1) < 0)
       newSelfinvLargeData(i, 1) = NaN; 
    end
    if (newSelfinvLargeData(i, 2) < 0)
       newSelfinvLargeData(i, 2) = NaN; 
    end
    if (newSelfinvExtraData(i, 1) < 0)
       newSelfinvExtraData(i, 1) = NaN; 
    end
    if (newSelfinvExtraData(i, 2) < 0)
       newSelfinvExtraData(i, 2) = NaN; 
    end
end

%% Means of Core 0 and 1
meanDirData = nanmean(newDirData.');
meanSelfinvSmallData = nanmean(newSelfinvSmallData.');
meanSelfinvMediumData = nanmean(newSelfinvMediumData.');
meanSelfinvLargeData = nanmean(newSelfinvLargeData.');
meanSelfinvExtraData = nanmean(newSelfinvExtraData.');

%tmpDirData = reshape(meanDirData,[13,44]);
%tmpSelfMedData = reshape(meanSelfinvMediumData,[13,44]);

%% Standard Deviation
stdDirData = reshape(std(reshape(meanDirData,[13,44])), [11,4]);
stdSelfinvSmallData = reshape(std(reshape(meanSelfinvSmallData,[13,44])), [11,4]);
stdSelfinvMediumData = reshape(std(reshape(meanSelfinvMediumData,[13,44])), [11,4]);
stdSelfinvLargeData = reshape(std(reshape(meanSelfinvLargeData,[13,44])), [11,4]);
stdSelfinvExtraData = reshape(std(reshape(meanSelfinvExtraData,[13,44])), [11,4]);

%{
%% Max Deviation
maxDirData = reshape(max(reshape(meanDirData,[13,44])), [11,4]);
maxSelfinvSmallData = reshape(max(reshape(meanSelfinvSmallData,[13,44])), [11,4]);
maxSelfinvMediumData = reshape(max(reshape(meanSelfinvMediumData,[13,44])), [11,4]);
maxSelfinvLargeData = reshape(max(reshape(meanSelfinvLargeData,[13,44])), [11,4]);

%% Min Deviation
minDirData = reshape(min(reshape(meanDirData,[13,44])), [11,4]);
minSelfinvSmallData = reshape(min(reshape(meanSelfinvSmallData,[13,44])), [11,4]);
minSelfinvMediumData = reshape(min(reshape(meanSelfinvMediumData,[13,44])), [11,4]);
minSelfinvLargeData = reshape(min(reshape(meanSelfinvLargeData,[13,44])), [11,4]);
%}

%% Means of all data sets and sorting by test type and measured value
finalDirData = reshape(nanmean(reshape(meanDirData,[13,44])), [11,4]);
finalSelfinvSmallData = reshape(nanmean(reshape(meanSelfinvSmallData,[13,44])), [11,4]);
finalSelfinvMediumData = reshape(nanmean(reshape(meanSelfinvMediumData,[13,44])), [11,4]);
finalSelfinvLargeData = reshape(nanmean(reshape(meanSelfinvLargeData,[13,44])), [11,4]);
finalSelfinvExtraData = reshape(nanmean(reshape(meanSelfinvExtraData,[13,44])), [11,4]);

% Miss/Hit Ratio
for i = 1:size(finalDirData, 1)
% Miss
    % Dir
    missRatioDir(i) = finalDirData(i,1)*100/(finalDirData(i,1)+finalDirData(i,2));
    %invRatioDir(i) = finalDirData(i,3)*100/finalDirData(i,1);
    % Extra
    missRatioExtraSelfinv(i) = finalSelfinvExtraData(i,1)*100/(finalSelfinvExtraData(i,1)+finalSelfinvExtraData(i,2));
    selfinvRatioExtraSelfinv(i) = finalSelfinvExtraData(i,3)*100/finalSelfinvExtraData(i,1);
    % Large
    missRatioLargeSelfinv(i) = finalSelfinvLargeData(i,1)*100/(finalSelfinvLargeData(i,1)+finalSelfinvLargeData(i,2));
    selfinvRatioLargeSelfinv(i) = finalSelfinvLargeData(i,3)*100/finalSelfinvLargeData(i,1);
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
    % Extra
    hitRatioExtraSelfinv(i) = finalSelfinvExtraData(i,2)*100/(finalSelfinvExtraData(i,1)+finalSelfinvExtraData(i,2));
    selfinvHitRatioExtraSelfinv(i) = finalSelfinvExtraData(i,4)*100/(finalSelfinvExtraData(i,1)+finalSelfinvExtraData(i,2));
    stdHitRatioExtraSelfinv(i) = stdSelfinvExtraData(i,2)/(stdSelfinvExtraData(i,1)+stdSelfinvExtraData(i,2));
    % Large
    hitRatioLargeSelfinv(i) = finalSelfinvLargeData(i,2)*100/(finalSelfinvLargeData(i,1)+finalSelfinvLargeData(i,2));
    selfinvHitRatioLargeSelfinv(i) = finalSelfinvLargeData(i,4)*100/(finalSelfinvLargeData(i,1)+finalSelfinvLargeData(i,2));
    stdHitRatioLargeSelfinv(i) = stdSelfinvLargeData(i,2)/(stdSelfinvLargeData(i,1)+stdSelfinvLargeData(i,2));
    % Medium
    hitRatioMediumSelfinv(i) = finalSelfinvMediumData(i,2)*100/(finalSelfinvMediumData(i,1)+finalSelfinvMediumData(i,2));
    selfinvHitRatioMediumSelfinv(i) = finalSelfinvMediumData(i,4)*100/(finalSelfinvMediumData(i,1)+finalSelfinvMediumData(i,2));
    stdHitRatioMediumSelfinv(i) = stdSelfinvMediumData(i,2)/(stdSelfinvMediumData(i,1)+stdSelfinvMediumData(i,2));
    % Small
    hitRatioSmallSelfinv(i) = finalSelfinvSmallData(i,2)*100/(finalSelfinvSmallData(i,1)+finalSelfinvSmallData(i,2));
    selfinvHitRatioSmallSelfinv(i) = finalSelfinvSmallData(i,4)*100/(finalSelfinvSmallData(i,1)+finalSelfinvSmallData(i,2));
    stdHitRatioSmallSelfinv(i) = stdSelfinvSmallData(i,2)/(stdSelfinvSmallData(i,1)+stdSelfinvSmallData(i,2));
end

%{
% Normalising
for i = 1:size(finalDirData, 1)
   for j = 1:size(finalDirData, 2)
       finalSelfinvSmallData(i,j) = finalSelfinvSmallData(i,j)/finalDirData(i,j);
       finalSelfinvMediumData(i,j) = finalSelfinvMediumData(i,j)/finalDirData(i,j);
       finalSelfinvLargeData(i,j) = finalSelfinvLargeData(i,j)/finalDirData(i,j);
       finalSelfinvExtraData(i,j) = finalSelfinvExtraData(i,j)/finalDirData(i,j);
       
       stdSelfinvSmallData(i,j) = stdSelfinvSmallData(i,j)/finalDirData(i,j);
       stdSelfinvMediumData(i,j) = stdSelfinvMediumData(i,j)/finalDirData(i,j);
       stdSelfinvLargeData(i,j) = stdSelfinvLargeData(i,j)/finalDirData(i,j);
       stdSelfinvExtraData(i,j) = stdSelfinvExtraData(i,j)/finalDirData(i,j);
       stdDirData(i,j) = stdDirData(i,j)/finalDirData(i,j);
%{              
       maxSelfinvSmallData(i,j) = maxSelfinvSmallData(i,j)/finalDirData(i,j);
       maxSelfinvMediumData(i,j) = maxSelfinvMediumData(i,j)/finalDirData(i,j);
       maxSelfinvLargeData(i,j) = maxSelfinvLargeData(i,j)/finalDirData(i,j);
       maxDirData(i,j) = maxDirData(i,j)/finalDirData(i,j);
       
       minSelfinvSmallData(i,j) = minSelfinvSmallData(i,j)/finalDirData(i,j);
       minSelfinvMediumData(i,j) = minSelfinvMediumData(i,j)/finalDirData(i,j);
       minSelfinvLargeData(i,j) = minSelfinvLargeData(i,j)/finalDirData(i,j);
       minDirData(i,j) = minDirData(i,j)/finalDirData(i,j);
%}       
       finalDirData(i,j) = finalDirData(i,j)/finalDirData(i,j);
   end
end
%}

% 1: count
% 2: hit
% 3: miss
% 4: x
% 5: y

%{
%% Plotting data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 2 
figure(2);
set(2,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);
hold on;

%% MISS
subplot(6,3,[1 6]);
hold on;axis tight;grid on;box on;
% Data
for i = 1:size(finalDirData, 1)
    % Data
    dataToPlot(i,:) = [finalDirData(i,1) finalSelfinvExtraData(i,1) finalSelfinvLargeData(i,1) finalSelfinvMediumData(i,1) finalSelfinvSmallData(i,1)];
    % Error
    errorToPlot(i,:) = [0 0 0 0 0];%[stdDirData(i,1) stdSelfinvExtraData(i,1) stdSelfinvLargeData(i,1) stdSelfinvMediumData(i,1) stdSelfinvSmallData(i,1)];
end
% Plot Bar with Errors
handles = barweb(dataToPlot, errorToPlot, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
set(gca,'YScale','log');
grid on;box on;
% Legend
h_legend = legend('Directory','Time-Based (1,000,000)','Time-Based (100,000)','Time-Based (10,000)','Time-Based (1,000)','Location','northwest');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
%breakyaxis([3.5 4.5]);
ylim([1000000 10000000000])
%set(gca,'YTick',0:1:11)
% Axis Naming
set(gca,'XTickLabel',{'LU+' 'LU-' 'Water-N' 'Water-S' 'Radix' 'FFT-S' 'FFT-L' 'FMM-S' 'FMM-L' 'Ocean+' 'Ocean-'})
ylabel('Normalised Miss Count','Interpreter','latex');
xlabel('Splash-2 Tests','Interpreter','latex');
%title('(a2) Cache Miss','Interpreter','latex','fontsize',13);

%% HIT
subplot(6,3,[7 12]);
hold on;axis tight;grid on;box on;
for i = 1:size(finalDirData, 1)
    % Data
    dataToPlot(i,:) = [finalDirData(i,2) finalSelfinvExtraData(i,2) finalSelfinvLargeData(i,2) finalSelfinvMediumData(i,2) finalSelfinvSmallData(i,2)];
    % Error
    errorToPlot(i,:) = [0 0 0 0 0];%[stdDirData(i,2) stdSelfinvExtraData(i,2) stdSelfinvLargeData(i,2) stdSelfinvMediumData(i,2) stdSelfinvSmallData(i,2)];
end
% Plot Bar with Errors
handles = barweb(dataToPlot, errorToPlot, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
set(gca,'YScale','log');
grid on;box on;
% Legend
h_legend = legend('Directory','Time-Based (1,000,000)','Time-Based (100,000)','Time-Based (10,000)','Time-Based (1,000)','Location','southeast');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([1000000 10000000000])
%set(gca,'YTick',0.6:0.1:1.4)
% Axis Naming
set(gca,'XTickLabel',{'LU+' 'LU-' 'Water-N' 'Water-S' 'Radix' 'FFT-S' 'FFT-L' 'FMM-S' 'FMM-L' 'Ocean+' 'Ocean-'})
ylabel('Normalised Hit Count','Interpreter','latex');
%xlabel('Splash-2 Tests','Interpreter','latex');
%title('(a3) Cache Hit','Interpreter','latex','fontsize',13);

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
set(2, 'PaperUnits','centimeters')
set(2, 'PaperSize',[Y X])
set(2, 'PaperPosition',[0 0 ySize xSize])
set(2, 'PaperOrientation','portrait')

%# export to PDF and open file
%print -dpdf -r0 splash_combined_stats.pdf
%}

%%{
%% Plotting data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 5 - Chart of Directory & Selfinv
figure(5);
set(5,'units','normalized','outerposition',[0.06 0.06 0.4 0.9]);
hold on;


%% Dir
subplot(5,3,[1 3]);
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
set(hBar,{'FaceColor'},{FaceColor(1,:);FaceColor(11,:)});
for i=1:size(dataToPlot,1)
    text(i,dataToPlot(i,1),num2str(dataToPlot(i,1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top',...
               'color',[0,0,0])
end
for i=1:size(dataToPlot,1)
    text(i,(100-dataToPlot(i,2)),num2str((100-dataToPlot(i,1)),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom',...
               'color',[1,1,1])
end
grid on;box on;
% Legend
h_legend = legend('Hit Ratio','Miss Ratio','Location','southwest');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([80 100])
set(gca,'YTick',80:5:100)
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

%% Selfinv 1,000,000
subplot(5,3,[4 6]);
hold on;axis tight;grid on;box on;
for i = 1:size(finalDirData, 1)
    % Data
    %dataToPlot(i,:) = [finalDirData(i,2) finalSelfinvExtraData(i,2)];
    %dataToPlot(i,:) = [hitRatioDir(i) hitRatiExtraSelfinv(i)];
    dataToPlot(i,:) = [hitRatioExtraSelfinv(i) missRatioExtraSelfinv(i)];
    % Error
    %errorToPlot(i,:) = [stdDirData(i,2) stdSelfinvExtraData(i,2)];
end
% Plot Bar with Errors
%handles = barweb(dataToPlot, errorToPlot, [], [], [], [], [], FaceColor, [], []);
%handles = barweb(dataToPlot, errorToPlot, [], [], [], [], [], summer, [], []); % summer colorMap used
hBar = bar(dataToPlot,'stacked');
set(hBar,{'FaceColor'},{FaceColor(2,:);FaceColor(12,:)});
for i=1:size(dataToPlot,1)
    text(i,dataToPlot(i,1),num2str(dataToPlot(i,1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top',...
               'color',[0,0,0])
end
for i=1:size(dataToPlot,1)
    text(i,(100-dataToPlot(i,2)),num2str((100-dataToPlot(i,1)),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom',...
               'color',[1,1,1])
end
grid on;box on;
% Legend
h_legend = legend('Hit Ratio','Miss Ratio','Location','southwest');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([80 100])
set(gca,'YTick',80:5:100)
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

%% Selfinv 100,000
subplot(5,3,[7 9]);
hold on;axis tight;grid on;box on;
for i = 1:size(finalDirData, 1)
    % Data
    %dataToPlot(i,:) = [finalDirData(i,2) finalSelfinvExtraData(i,2)];
    %dataToPlot(i,:) = [hitRatioDir(i) hitRatiExtraSelfinv(i)];
    dataToPlot(i,:) = [hitRatioLargeSelfinv(i) missRatioLargeSelfinv(i)];
    % Error
    %errorToPlot(i,:) = [stdDirData(i,2) stdSelfinvExtraData(i,2)];
end
% Plot Bar with Errors
%handles = barweb(dataToPlot, errorToPlot, [], [], [], [], [], FaceColor, [], []);
%handles = barweb(dataToPlot, errorToPlot, [], [], [], [], [], summer, [], []); % summer colorMap used
hBar = bar(dataToPlot,'stacked');
set(hBar,{'FaceColor'},{FaceColor(3,:);FaceColor(13,:)});
for i=1:size(dataToPlot,1)
    text(i,dataToPlot(i,1),num2str(dataToPlot(i,1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top',...
               'color',[0,0,0])
end
for i=1:size(dataToPlot,1)
    text(i,(100-dataToPlot(i,2)),num2str((100-dataToPlot(i,1)),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom',...
               'color',[1,1,1])
end
grid on;box on;
% Legend
h_legend = legend('Hit Ratio','Miss Ratio','Location','southwest');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([80 100])
set(gca,'YTick',80:5:100)
%breakyaxis([1.03 1.11]);
% Axis Naming
set(gca,'XTickLabel',{'LU+' 'LU-' 'Water-N' 'Water-S' 'Radix' 'FFT-S' 'FFT-L' 'FMM-S' 'FMM-L' 'Ocean+' 'Ocean-'})
%ylabel('Hit \& Miss Ratio','Interpreter','latex');
%xlabel('MD5 Input Dataset Size','Interpreter','latex');
title('(c) Time-Based Coherence (100,000)','Interpreter','latex','fontsize',13);

% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 

%% Selfinv 10,000
subplot(5,3,[10 12]);
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
set(hBar,{'FaceColor'},{FaceColor(4,:);FaceColor(14,:)});
for i=1:size(dataToPlot,1)
    text(i,dataToPlot(i,1),num2str(dataToPlot(i,1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top',...
               'color',[0,0,0])
end
for i=1:size(dataToPlot,1)
    text(i,(100-dataToPlot(i,2)),num2str((100-dataToPlot(i,1)),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom',...
               'color',[1,1,1])
end
grid on;box on;
% Legend
h_legend = legend('Hit Ratio','Miss Ratio','Location','southwest');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([80 100])
set(gca,'YTick',80:5:100)
%breakyaxis([1.03 1.11]);
% Axis Naming
set(gca,'XTickLabel',{'LU+' 'LU-' 'Water-N' 'Water-S' 'Radix' 'FFT-S' 'FFT-L' 'FMM-S' 'FMM-L' 'Ocean+' 'Ocean-'})
%ylabel('Hit \& Miss Ratio','Interpreter','latex');
%xlabel('MD5 Input Dataset Size','Interpreter','latex');
title('(d) Time-Based Coherence (10,000)','Interpreter','latex','fontsize',13);

% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 

%% Selfinv 1,000
subplot(5,3,[13 15]);
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
set(hBar,{'FaceColor'},{FaceColor(6,:);FaceColor(16,:)});
for i=1:size(dataToPlot,1)
    text(i,dataToPlot(i,1),num2str(dataToPlot(i,1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top',...
               'color',[0,0,0])
end
for i=1:size(dataToPlot,1)
    text(i,(100-dataToPlot(i,2)),num2str((100-dataToPlot(i,1)),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom',...
               'color',[1,1,1])
end
for i=1:size(selfinvRatioSmallSelfinv,2)
   inverseSelfinvRatioSmallSelfinv(i) =  100 - selfinvRatioSmallSelfinv(i);
   overlayToPlot(i,:) = [inverseSelfinvRatioSmallSelfinv(i) selfinvRatioSmallSelfinv(i)];
end
grid on;box on;
% Legend
h_legend = legend('Hit Ratio','Miss Ratio','Location','southwest');
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
title('(e) Time-Based Coherence (1,000)','Interpreter','latex','fontsize',13);

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
%print -dpdf -r0 splash_combined_ratio.pdf
%}

%{
%% Plotting data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 6
figure(6);
set(6,'units','normalized','outerposition',[0.06 0.06 0.4 0.9]);
hold on;


%% Dir
subplot(5,3,[1 3]);
hold on;axis tight;grid on;box on;
% Data
for i = 1:size(finalDirData, 1)
    % Dir
    dataToPlot(i,:) = [invHitRatioDir(i) (100 - invHitRatioDir(i))];
end
% Plot Bar with Errors
hBar = bar(dataToPlot,'stacked');
set(hBar,{'FaceColor'},{FaceColor(1,:);FaceColor(11,:)});
for i=1:size(dataToPlot,1)
    text(i,dataToPlot(i,1),num2str(dataToPlot(i,1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top',...
               'color',[0,0,0])
end
for i=1:size(dataToPlot,1)
    text(i,(100-dataToPlot(i,2)),num2str((100-dataToPlot(i,1)),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom',...
               'color',[1,1,1])
end
grid on;box on;
% Legend
    h_legend = legend('Directory Invalidate-Hit Ratio','False Invalidate Ratio','Location','southwest');
% Y-Axis
ylim([0 100])
set(gca,'YTick',0:10:100)
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

%% Selfinv 1,000,000
subplot(5,3,[4 6]);
hold on;axis tight;grid on;box on;
for i = 1:size(finalDirData, 1)
    % Selfinv ratio
    dataToPlot(i,:) = [(100-selfinvRatioExtraSelfinv(i)) selfinvRatioExtraSelfinv(i)];
end
% Plot Bar
hBar = bar(dataToPlot,'stacked');
set(hBar,{'FaceColor'},{FaceColor(2,:);FaceColor(12,:)});
for i=1:size(dataToPlot,1)
    text(i,dataToPlot(i,1),num2str(dataToPlot(i,1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top',...
               'color',[0,0,0])
end
for i=1:size(dataToPlot,1)
    text(i,(100-dataToPlot(i,2)),num2str((100-dataToPlot(i,1)),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom',...
               'color',[1,1,1])
end
grid on;box on;
% Legend
    h_legend = legend('Miss Fill Ratio','Self-Invalidate Fill Ratio','Location','southwest');
% Y-Axis
ylim([0 100])
set(gca,'YTick',0:10:100)
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

%% Selfinv 100,000
subplot(5,3,[7 9]);
hold on;axis tight;grid on;box on;
for i = 1:size(finalDirData, 1)
    % Selfinv Ratio
    dataToPlot(i,:) = [(100-selfinvRatioLargeSelfinv(i)) selfinvRatioLargeSelfinv(i)];
end
% Plot Bar with Errors
hBar = bar(dataToPlot,'stacked');
set(hBar,{'FaceColor'},{FaceColor(3,:);FaceColor(13,:)});
for i=1:size(dataToPlot,1)
    text(i,dataToPlot(i,1),num2str(dataToPlot(i,1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top',...
               'color',[0,0,0])
end
for i=1:size(dataToPlot,1)
    text(i,(100-dataToPlot(i,2)),num2str((100-dataToPlot(i,1)),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom',...
               'color',[1,1,1])
end
grid on;box on;
% Legend
    h_legend = legend('Miss Fill Ratio','Self-Invalidate Fill Ratio','Location','southwest');
% Y-Axis
ylim([0 100])
set(gca,'YTick',0:10:100)
% Axis Naming
set(gca,'XTickLabel',{'LU+' 'LU-' 'Water-N' 'Water-S' 'Radix' 'FFT-S' 'FFT-L' 'FMM-S' 'FMM-L' 'Ocean+' 'Ocean-'})
title('(c) Time-Based Coherence (100,000)','Interpreter','latex','fontsize',13);
% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 

%% Selfinv 10,000
subplot(5,3,[10 12]);
hold on;axis tight;grid on;box on;
for i = 1:size(finalDirData, 1)
    % Selfinv Ratio
    dataToPlot(i,:) = [(100-selfinvRatioMediumSelfinv(i)) selfinvRatioMediumSelfinv(i)];
end
% Plot Bar with Errors
hBar = bar(dataToPlot,'stacked');
set(hBar,{'FaceColor'},{FaceColor(4,:);FaceColor(14,:)});
for i=1:size(dataToPlot,1)
    text(i,dataToPlot(i,1),num2str(dataToPlot(i,1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top',...
               'color',[0,0,0])
end
for i=1:size(dataToPlot,1)
    text(i,(100-dataToPlot(i,2)),num2str((100-dataToPlot(i,1)),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom',...
               'color',[1,1,1])
end
grid on;box on;
% Legend
    h_legend = legend('Miss Fill Ratio','Self-Invalidate Fill Ratio','Location','southwest');
% Y-Axis
ylim([0 100])
set(gca,'YTick',0:10:100)
% Axis Naming
set(gca,'XTickLabel',{'LU+' 'LU-' 'Water-N' 'Water-S' 'Radix' 'FFT-S' 'FFT-L' 'FMM-S' 'FMM-L' 'Ocean+' 'Ocean-'})
title('(d) Time-Based Coherence (10,000)','Interpreter','latex','fontsize',13);
% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 

%% Selfinv 1,000
subplot(5,3,[13 15]);
hold on;axis tight;grid on;box on;
for i = 1:size(finalDirData, 1)
    % Selfinv Ratio
    dataToPlot(i,:) = [(100-selfinvRatioSmallSelfinv(i)) selfinvRatioSmallSelfinv(i)];
end
% Plot Bar with Errors
hBar = bar(dataToPlot,'stacked');
set(hBar,{'FaceColor'},{FaceColor(6,:);FaceColor(16,:)});
for i=1:size(dataToPlot,1)
    text(i,dataToPlot(i,1),num2str(dataToPlot(i,1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','top',...
               'color',[0,0,0])
end
for i=1:size(dataToPlot,1)
    text(i,(100-dataToPlot(i,2)),num2str((100-dataToPlot(i,1)),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom',...
               'color',[1,1,1])
end
for i=1:size(selfinvRatioSmallSelfinv,2)
   inverseSelfinvRatioSmallSelfinv(i) =  100 - selfinvRatioSmallSelfinv(i);
   overlayToPlot(i,:) = [inverseSelfinvRatioSmallSelfinv(i) selfinvRatioSmallSelfinv(i)];
end
grid on;box on;
% Legend
    h_legend = legend('Miss Fill Ratio','Self-Invalidate Fill Ratio','Location','northwest');
% Y-Axis
ylim([0 100])
set(gca,'YTick',0:10:100)
% Axis Naming
set(gca,'XTickLabel',{'LU+' 'LU-' 'Water-N' 'Water-S' 'Radix' 'FFT-S' 'FFT-L' 'FMM-S' 'FMM-L' 'Ocean+' 'Ocean-'})
title('(e) Time-Based Coherence (1,000)','Interpreter','latex','fontsize',13);
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

%# export to PDF and open file
%print -dpdf -r0 splash_combined_inv_ratio.pdf
%}

%{
%% OCEAN CON PLOT
figure(11);
hold on;

parsedTestData(1:13,:) = generalMasterData(755:767,:); % Ocean Con Totoal with init
parsedTestData(14:26,:) = generalMasterData(807:819,:); % Ocean Con
parsedTestData(27:39,:) = generalMasterData(833:845,:); % Ocean Con Multigrid


k = 1;
for j = 1:3
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

% Rearrange columns
displayData = displayData(:,[1 5 4 3 2]);

subplot(3,3,[1 2]);
barweb(displayData, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
h_legend = legend('Directory','Time-Based (1,000,000)','Time-Based (100,000)','Time-Based (10,000)','Time-Based (1,000)','Location','southwest');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([0.9 1.1])
set(gca,'YTick',0.9:0.02:1.1)
% Axis Naming
set(gca,'XTickLabel',{'Time With Init' 'Time Without Init' 'Multigrid Time'})
%xlabel('Ocean Contiguous Benchmark','Interpreter','latex');
ylabel('Normalised Execution Time','Interpreter','latex');
%xlabel('MD5 Input Dataset Size','Interpreter','latex');
title('(a)','Interpreter','latex','fontsize',13);

subplot(3,3,[3]);
hold on;axis tight;grid on;box on;
% Data
iset = 10;
dataToPlot = [hitRatioDir(iset) hitRatioExtraSelfinv(iset) hitRatioLargeSelfinv(iset) hitRatioMediumSelfinv(iset) hitRatioSmallSelfinv(iset)];
errorData = [stdHitRatioDir(iset) stdHitRatioExtraSelfinv(iset) stdHitRatioLargeSelfinv(iset) stdHitRatioMediumSelfinv(iset) stdHitRatioSmallSelfinv(iset)];
% Plot Bar with Errors
hBar = barweb(dataToPlot, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
%h_legend = legend('Hit Ratio','Miss Ratio','Location','southwest');
% Y-Axis
ylim([65 100])
set(gca,'YTick',65:5:100)
% Axis Naming
set(gca,'XTickLabel',{'Hit Ratio'})
title('(b)','Interpreter','latex','fontsize',13);
% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 
% Axis side
set(gca, 'YAxisLocation', 'right')

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
set(11, 'PaperUnits','centimeters')
set(11, 'PaperSize',[Y X])
set(11, 'PaperPosition',[0 0 ySize xSize])
set(11, 'PaperOrientation','portrait')
set(11,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);
%# export to PDF and open file
%print -dpdf -r0 ocean_con.pdf
%}

%{
%% OCEAN NON-CON PLOT
figure(12);
hold on;

parsedTestData(1:13,:) = generalMasterData(768:780,:); % Ocean Con Total with init
parsedTestData(14:26,:) = generalMasterData(820:832,:); % Ocean Con
parsedTestData(27:39,:) = generalMasterData(846:858,:); % Ocean Con Multigrid

%Removing data error
parsedTestData(1,3) = parsedTestData(2,3);

k = 1;
for j = 1:3
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

% Rearrange columns
displayData = displayData(:,[1 5 4 3 2]);

subplot(3,3,[1 2]);
barweb(displayData, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
h_legend = legend('Directory','Time-Based (1,000,000)','Time-Based (100,000)','Time-Based (10,000)','Time-Based (1,000)','Location','southwest');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([0.9 1.1])
set(gca,'YTick',0.9:0.02:1.1)
% Axis Naming
set(gca,'XTickLabel',{'Time With Init' 'Time Without Init' 'Multigrid Time'})
%xlabel('Ocean Contiguous Benchmark','Interpreter','latex');
ylabel('Normalised Execution Time','Interpreter','latex');
%xlabel('MD5 Input Dataset Size','Interpreter','latex');
title('(a)','Interpreter','latex','fontsize',13);

subplot(3,3,[3]);
hold on;axis tight;grid on;box on;
% Data
iset = 11;
dataToPlot = [hitRatioDir(iset) hitRatioExtraSelfinv(iset) hitRatioLargeSelfinv(iset) hitRatioMediumSelfinv(iset) hitRatioSmallSelfinv(iset)];
errorData = [stdHitRatioDir(iset) stdHitRatioExtraSelfinv(iset) stdHitRatioLargeSelfinv(iset) stdHitRatioMediumSelfinv(iset) stdHitRatioSmallSelfinv(iset)];
% Plot Bar with Errors
hBar = barweb(dataToPlot, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
%h_legend = legend('Hit Ratio','Miss Ratio','Location','southwest');
% Y-Axis
ylim([60 100])
set(gca,'YTick',60:5:100)
% Axis Naming
set(gca,'XTickLabel',{'Hit Ratio'})
title('(b)','Interpreter','latex','fontsize',13);
% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 
% Axis side
set(gca, 'YAxisLocation', 'right')

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
set(12, 'PaperUnits','centimeters')
set(12, 'PaperSize',[Y X])
set(12, 'PaperPosition',[0 0 ySize xSize])
set(12, 'PaperOrientation','portrait')
set(12,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);
%# export to PDF and open file
%print -dpdf -r0 ocean_non_con.pdf
%}

%{
%% LU CON PLOT
figure(13);
hold on;

parsedTestData(1:13,:) = generalMasterData(131:143,:); % LU Con Total w init
parsedTestData(14:26,:) = generalMasterData(1:13,:); % LU Con Total no init
parsedTestData(27:39,:) = generalMasterData(105:117,:); % Barrier
%parsedTestData(27:39,:) = generalMasterData(27:39,:); % Diagonal
%parsedTestData(40:52,:) = generalMasterData(53:65,:); % Perimeter
%parsedTestData(53:65,:) = generalMasterData(79:91,:); % Interior


%Removing data error
%parsedTestData(1,3) = parsedTestData(2,3);

k = 1;
for j = 1:3
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

% Rearrange columns
displayData = displayData(:,[1 5 4 3 2]);

subplot(3,3,[1 2]);
errorData(1,:) = [0 0 0 0 0];
errorData(2,:) = [0 0 0 0 0];
barweb(displayData, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
h_legend = legend('Directory','Time-Based (1,000,000)','Time-Based (100,000)','Time-Based (10,000)','Time-Based (1,000)','Location','northwest');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([0 2.4])
set(gca,'YTick',0:0.2:2.4)
% Axis Naming
set(gca,'XTickLabel',{'Time With Init' 'Time Without Init' 'Barrier Time'})
%xlabel('Ocean Contiguous Benchmark','Interpreter','latex');
ylabel('Normalised Execution Time','Interpreter','latex');
%xlabel('MD5 Input Dataset Size','Interpreter','latex');
title('(a)','Interpreter','latex','fontsize',13);

subplot(3,3,[3]);
hold on;axis tight;grid on;box on;
% Data
iset = 1;
dataToPlot = [hitRatioDir(iset) hitRatioExtraSelfinv(iset) hitRatioLargeSelfinv(iset) hitRatioMediumSelfinv(iset) hitRatioSmallSelfinv(iset)];
errorData = [stdHitRatioDir(iset) stdHitRatioExtraSelfinv(iset) stdHitRatioLargeSelfinv(iset) stdHitRatioMediumSelfinv(iset) stdHitRatioSmallSelfinv(iset)];
% Plot Bar with Errors
hBar = barweb(dataToPlot, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
%h_legend = legend('Hit Ratio','Miss Ratio','Location','southwest');
% Y-Axis
ylim([75 100])
set(gca,'YTick',75:5:100)
% Axis Naming
set(gca,'XTickLabel',{'Hit Ratio'})
title('(b)','Interpreter','latex','fontsize',13);
% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 
% Axis side
set(gca, 'YAxisLocation', 'right')

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
set(13, 'PaperUnits','centimeters')
set(13, 'PaperSize',[Y X])
set(13, 'PaperPosition',[0 0 ySize xSize])
set(13, 'PaperOrientation','portrait')
set(13,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);
%# export to PDF and open file
%print -dpdf -r0 lu_con.pdf
%}

%{
%% LU NON-CON PLOT
figure(14);
hold on;

parsedTestData(1:13,:) = generalMasterData(144:156,:); % LU Non-Con Total w init
parsedTestData(14:26,:) = generalMasterData(14:26,:); % LU Non-Con Total no init
parsedTestData(27:39,:) = generalMasterData(118:130,:); % Barrier
%parsedTestData(27:39,:) = generalMasterData(27:39,:); % Diagonal
%parsedTestData(40:52,:) = generalMasterData(53:65,:); % Perimeter
%parsedTestData(53:65,:) = generalMasterData(79:91,:); % Interior


%Removing data error
%parsedTestData(1,3) = parsedTestData(2,3);

k = 1;
for j = 1:3
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

% Rearrange columns
displayData = displayData(:,[1 5 4 3 2]);

subplot(3,3,[1 2]);
%errorData(1,:) = [0 0 0 0 0];
%errorData(2,:) = [0 0 0 0 0];
barweb(displayData, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
h_legend = legend('Directory','Time-Based (1,000,000)','Time-Based (100,000)','Time-Based (10,000)','Time-Based (1,000)','Location','southwest');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([0.7 1.3])
set(gca,'YTick',0.7:0.1:1.3)
% Axis Naming
set(gca,'XTickLabel',{'Time With Init' 'Time Without Init' 'Barrier Time'})
%xlabel('Ocean Contiguous Benchmark','Interpreter','latex');
ylabel('Normalised Execution Time','Interpreter','latex');
%xlabel('MD5 Input Dataset Size','Interpreter','latex');
title('(a)','Interpreter','latex','fontsize',13);

subplot(3,3,[3]);
hold on;axis tight;grid on;box on;
% Data
iset = 2;
dataToPlot = [hitRatioDir(iset) hitRatioExtraSelfinv(iset) hitRatioLargeSelfinv(iset) hitRatioMediumSelfinv(iset) hitRatioSmallSelfinv(iset)];
errorData = [stdHitRatioDir(iset) stdHitRatioExtraSelfinv(iset) stdHitRatioLargeSelfinv(iset) stdHitRatioMediumSelfinv(iset) stdHitRatioSmallSelfinv(iset)];
% Plot Bar with Errors
hBar = barweb(dataToPlot, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
%h_legend = legend('Hit Ratio','Miss Ratio','Location','southwest');
% Y-Axis
ylim([70 100])
set(gca,'YTick',70:5:100)
% Axis Naming
set(gca,'XTickLabel',{'Hit Ratio'})
title('(b)','Interpreter','latex','fontsize',13);
% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 
% Axis side
set(gca, 'YAxisLocation', 'right')

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
set(14, 'PaperUnits','centimeters')
set(14, 'PaperSize',[Y X])
set(14, 'PaperPosition',[0 0 ySize xSize])
set(14, 'PaperOrientation','portrait')
set(14,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);
%# export to PDF and open file
%print -dpdf -r0 lu_non_con.pdf
%}

%{
%% WATER N2 PLOT
figure(15);
hold on;

parsedTestData(1:13,:) = generalMasterData(183:195,:); % Water N2 Total w init
parsedTestData(14:26,:) = generalMasterData(209:221,:); % Water N2 Total no init
parsedTestData(27:39,:) = generalMasterData(235:247,:); % Intramolecular

%Removing data error
%parsedTestData(1,3) = parsedTestData(2,3);

k = 1;
for j = 1:3
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

% Rearrange columns
displayData = displayData(:,[1 5 4 3 2]);

subplot(3,3,[1 2]);
%errorData(1,:) = [0 0 0 0 0];
%errorData(2,:) = [0 0 0 0 0];
barweb(displayData, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
h_legend = legend('Directory','Time-Based (1,000,000)','Time-Based (100,000)','Time-Based (10,000)','Time-Based (1,000)','Location','southwest');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([0.9 1.1])
set(gca,'YTick',0.9:0.02:1.1)
% Axis Naming
set(gca,'XTickLabel',{'Time With Init' 'Time Without Init' 'Intermolecular Time'})
%xlabel('Ocean Contiguous Benchmark','Interpreter','latex');
ylabel('Normalised Execution Time','Interpreter','latex');
%xlabel('MD5 Input Dataset Size','Interpreter','latex');
title('(a)','Interpreter','latex','fontsize',13);

subplot(3,3,[3]);
hold on;axis tight;grid on;box on;
% Data
iset = 3;
dataToPlot = [hitRatioDir(iset) hitRatioExtraSelfinv(iset) hitRatioLargeSelfinv(iset) hitRatioMediumSelfinv(iset) hitRatioSmallSelfinv(iset)];
errorData = [stdHitRatioDir(iset) stdHitRatioExtraSelfinv(iset) stdHitRatioLargeSelfinv(iset) stdHitRatioMediumSelfinv(iset) stdHitRatioSmallSelfinv(iset)];
% Plot Bar with Errors
hBar = barweb(dataToPlot, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
%h_legend = legend('Hit Ratio','Miss Ratio','Location','southwest');
% Y-Axis
ylim([65 100])
set(gca,'YTick',65:5:100)
% Axis Naming
set(gca,'XTickLabel',{'Hit Ratio'})
title('(b)','Interpreter','latex','fontsize',13);
% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 
% Axis side
set(gca, 'YAxisLocation', 'right')

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
set(15, 'PaperUnits','centimeters')
set(15, 'PaperSize',[Y X])
set(15, 'PaperPosition',[0 0 ySize xSize])
set(15, 'PaperOrientation','portrait')
set(15,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);
%# export to PDF and open file
%print -dpdf -r0 water_n.pdf
%}

%{
%% WATER SPACIAL PLOT
figure(16);
hold on;

parsedTestData(1:13,:) = generalMasterData(195:207,:); % Water S Total w init
parsedTestData(14:26,:) = generalMasterData(222:234,:); % Water S Total no init
parsedTestData(27:39,:) = generalMasterData(248:260,:); % Intramolecular

%Removing data error
%parsedTestData(1,3) = parsedTestData(2,3);

k = 1;
for j = 1:3
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

% Rearrange columns
displayData = displayData(:,[1 5 4 3 2]);

subplot(3,3,[1 2]);
%errorData(1,:) = [0 0 0 0 0];
%errorData(2,:) = [0 0 0 0 0];
barweb(displayData, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
h_legend = legend('Directory','Time-Based (1,000,000)','Time-Based (100,000)','Time-Based (10,000)','Time-Based (1,000)','Location','southwest');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([0.9 1.1])
set(gca,'YTick',0.9:0.02:1.1)
% Axis Naming
set(gca,'XTickLabel',{'Time With Init' 'Time Without Init' 'Intermolecular Time'})
%xlabel('Ocean Contiguous Benchmark','Interpreter','latex');
ylabel('Normalised Execution Time','Interpreter','latex');
%xlabel('MD5 Input Dataset Size','Interpreter','latex');
title('(a)','Interpreter','latex','fontsize',13);

subplot(3,3,[3]);
hold on;axis tight;grid on;box on;
% Data
iset = 4;
dataToPlot = [hitRatioDir(iset) hitRatioExtraSelfinv(iset) hitRatioLargeSelfinv(iset) hitRatioMediumSelfinv(iset) hitRatioSmallSelfinv(iset)];
errorData = [stdHitRatioDir(iset) stdHitRatioExtraSelfinv(iset) stdHitRatioLargeSelfinv(iset) stdHitRatioMediumSelfinv(iset) stdHitRatioSmallSelfinv(iset)];
% Plot Bar with Errors
hBar = barweb(dataToPlot, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
%h_legend = legend('Hit Ratio','Miss Ratio','Location','southwest');
% Y-Axis
ylim([65 100])
set(gca,'YTick',65:5:100)
% Axis Naming
set(gca,'XTickLabel',{'Hit Ratio'})
title('(b)','Interpreter','latex','fontsize',13);
% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 
% Axis side
set(gca, 'YAxisLocation', 'right')

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
set(16, 'PaperUnits','centimeters')
set(16, 'PaperSize',[Y X])
set(16, 'PaperPosition',[0 0 ySize xSize])
set(16, 'PaperOrientation','portrait')
set(16,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);
%# export to PDF and open file
%print -dpdf -r0 water_s.pdf
%}

%{
%% FFT SMALL PLOT
figure(17);
hold on;

parsedTestData(1:13,:) = generalMasterData(365:377,:); % FFT S Total w init
parsedTestData(14:26,:) = generalMasterData(391:403,:); % FFT S Total no init
parsedTestData(27:39,:) = generalMasterData(417:429,:); % Intramolecular

%Removing data error
%parsedTestData(1,3) = parsedTestData(2,3);

k = 1;
for j = 1:3
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

% Rearrange columns
displayData = displayData(:,[1 5 4 3 2]);

subplot(3,3,[1 2]);
%errorData(1,:) = [0 0 0 0 0];
%errorData(2,:) = [0 0 0 0 0];
barweb(displayData, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
h_legend = legend('Directory','Time-Based (1,000,000)','Time-Based (100,000)','Time-Based (10,000)','Time-Based (1,000)','Location','northwest');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([0.6 1.4])
set(gca,'YTick',0.6:0.1:1.4)
% Axis Naming
set(gca,'XTickLabel',{'Time With Init' 'Time Without Init' 'Transpose Time'})
%xlabel('Ocean Contiguous Benchmark','Interpreter','latex');
ylabel('Normalised Execution Time','Interpreter','latex');
%xlabel('MD5 Input Dataset Size','Interpreter','latex');
title('(a)','Interpreter','latex','fontsize',13);

subplot(3,3,[3]);
hold on;axis tight;grid on;box on;
% Data
iset = 6;
dataToPlot = [hitRatioDir(iset) hitRatioExtraSelfinv(iset) hitRatioLargeSelfinv(iset) hitRatioMediumSelfinv(iset) hitRatioSmallSelfinv(iset)];
errorData = [stdHitRatioDir(iset) stdHitRatioExtraSelfinv(iset) stdHitRatioLargeSelfinv(iset) stdHitRatioMediumSelfinv(iset) stdHitRatioSmallSelfinv(iset)];
% Plot Bar with Errors
hBar = barweb(dataToPlot, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
%h_legend = legend('Hit Ratio','Miss Ratio','Location','southwest');
% Y-Axis
ylim([70 100])
set(gca,'YTick',70:5:100)
% Axis Naming
set(gca,'XTickLabel',{'Hit Ratio'})
title('(b)','Interpreter','latex','fontsize',13);
% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 
% Axis side
set(gca, 'YAxisLocation', 'right')

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
set(17, 'PaperUnits','centimeters')
set(17, 'PaperSize',[Y X])
set(17, 'PaperPosition',[0 0 ySize xSize])
set(17, 'PaperOrientation','portrait')
set(17,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);
%# export to PDF and open file
%print -dpdf -r0 fft_s.pdf
%}

%{
%% FFT LARGE PLOT
figure(18);
hold on;

parsedTestData(1:13,:) = generalMasterData(377:389,:); % FFT L Total w init
parsedTestData(14:26,:) = generalMasterData(404:416,:); % FFT L Total no init
parsedTestData(27:39,:) = generalMasterData(430:442,:); % Intramolecular

%Removing data error
%parsedTestData(1,3) = parsedTestData(2,3);

k = 1;
for j = 1:3
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

% Rearrange columns
displayData = displayData(:,[1 5 4 3 2]);

subplot(3,3,[1 2]);
%errorData(1,:) = [0 0 0 0 0];
%errorData(2,:) = [0 0 0 0 0];
barweb(displayData, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
h_legend = legend('Directory','Time-Based (1,000,000)','Time-Based (100,000)','Time-Based (10,000)','Time-Based (1,000)','Location','northeast');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([0.6 1.4])
set(gca,'YTick',0.6:0.1:1.4)
% Axis Naming
set(gca,'XTickLabel',{'Time With Init' 'Time Without Init' 'Transpose Time'})
%xlabel('Ocean Contiguous Benchmark','Interpreter','latex');
ylabel('Normalised Execution Time','Interpreter','latex');
%xlabel('MD5 Input Dataset Size','Interpreter','latex');
title('(a)','Interpreter','latex','fontsize',13);

subplot(3,3,[3]);
hold on;axis tight;grid on;box on;
% Data
iset = 7;
dataToPlot = [hitRatioDir(iset) hitRatioExtraSelfinv(iset) hitRatioLargeSelfinv(iset) hitRatioMediumSelfinv(iset) hitRatioSmallSelfinv(iset)];
errorData = [stdHitRatioDir(iset) stdHitRatioExtraSelfinv(iset) stdHitRatioLargeSelfinv(iset) stdHitRatioMediumSelfinv(iset) stdHitRatioSmallSelfinv(iset)];
% Plot Bar with Errors
hBar = barweb(dataToPlot, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
%h_legend = legend('Hit Ratio','Miss Ratio','Location','southwest');
% Y-Axis
ylim([70 100])
set(gca,'YTick',70:5:100)
% Axis Naming
set(gca,'XTickLabel',{'Hit Ratio'})
title('(b)','Interpreter','latex','fontsize',13);
% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 
% Axis side
set(gca, 'YAxisLocation', 'right')

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
set(18, 'PaperUnits','centimeters')
set(18, 'PaperSize',[Y X])
set(18, 'PaperPosition',[0 0 ySize xSize])
set(18, 'PaperOrientation','portrait')
set(18,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);
%# export to PDF and open file
%print -dpdf -r0 fft_l.pdf
%}

%{
%% FMM SMALL PLOT
figure(19);
hold on;

parsedTestData(1:13,:) = generalMasterData(469:481,:); % FMM S Total w init 
parsedTestData(14:26,:) = generalMasterData(495:507,:); % FMM S Total no init
parsedTestData(27:39,:) = generalMasterData(651:663,:); % Inter
%parsedTestData(27:39,:) = generalMasterData(521:533,:); % Track
%parsedTestData(27:39,:) = generalMasterData(547:559,:); % Tree
%parsedTestData(53:65,:) = generalMasterData(573:585,:); % List
%parsedTestData(66:78,:) = generalMasterData(599:611,:); % Part
%parsedTestData(27:39,:) = generalMasterData(625:637,:); % Pass

%Removing data error
%parsedTestData(1,3) = parsedTestData(2,3);

k = 1;
for j = 1:3
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

% Rearrange columns
displayData = displayData(:,[1 5 4 3 2]);

subplot(3,3,[1 2]);
%errorData(1,:) = [0 0 0 0 0];
%errorData(2,:) = [0 0 0 0 0];
barweb(displayData, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
h_legend = legend('Directory','Time-Based (1,000,000)','Time-Based (100,000)','Time-Based (10,000)','Time-Based (1,000)','Location','southwest');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([0.9 1.1])
set(gca,'YTick',0.9:0.02:1.1)
% Axis Naming
set(gca,'XTickLabel',{'Time With Init' 'Time Without Init' 'Inter Time'})
%xlabel('Ocean Contiguous Benchmark','Interpreter','latex');
ylabel('Normalised Execution Time','Interpreter','latex');
%xlabel('MD5 Input Dataset Size','Interpreter','latex');
title('(a)','Interpreter','latex','fontsize',13);

subplot(3,3,[3]);
hold on;axis tight;grid on;box on;
% Data
iset = 8;
dataToPlot = [hitRatioDir(iset) hitRatioExtraSelfinv(iset) hitRatioLargeSelfinv(iset) hitRatioMediumSelfinv(iset) hitRatioSmallSelfinv(iset)];
errorData = [stdHitRatioDir(iset) stdHitRatioExtraSelfinv(iset) stdHitRatioLargeSelfinv(iset) stdHitRatioMediumSelfinv(iset) stdHitRatioSmallSelfinv(iset)];
% Plot Bar with Errors
hBar = barweb(dataToPlot, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
%h_legend = legend('Hit Ratio','Miss Ratio','Location','southwest');
% Y-Axis
ylim([70 100])
set(gca,'YTick',70:5:100)
% Axis Naming
set(gca,'XTickLabel',{'Hit Ratio'})
title('(b)','Interpreter','latex','fontsize',13);
% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 
% Axis side
set(gca, 'YAxisLocation', 'right')

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
set(19, 'PaperUnits','centimeters')
set(19, 'PaperSize',[Y X])
set(19, 'PaperPosition',[0 0 ySize xSize])
set(19, 'PaperOrientation','portrait')
set(19,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);
%# export to PDF and open file
%print -dpdf -r0 fmm_s.pdf
%}

%{
%% FMM LARGE PLOT
figure(20);
hold on;

parsedTestData(1:13,:) = generalMasterData(482:494,:); % FMM L Total w init 
parsedTestData(14:26,:) = generalMasterData(508:520,:); % FMM L Total no init
parsedTestData(27:39,:) = generalMasterData(664:676,:); % Inter

%Removing data error
parsedTestData(13,4) = parsedTestData(12,4);
parsedTestData(26,4) = parsedTestData(25,4);

k = 1;
for j = 1:3
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

% Rearrange columns
displayData = displayData(:,[1 5 4 3 2]);

subplot(3,3,[1 2]);
%errorData(1,:) = [0 0 0 0 0];
%errorData(2,:) = [0 0 0 0 0];
barweb(displayData, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
h_legend = legend('Directory','Time-Based (1,000,000)','Time-Based (100,000)','Time-Based (10,000)','Time-Based (1,000)','Location','southwest');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([0.9 1.1])
set(gca,'YTick',0.9:0.02:1.1)
% Axis Naming
set(gca,'XTickLabel',{'Time With Init' 'Time Without Init' 'Inter Time'})
%xlabel('Ocean Contiguous Benchmark','Interpreter','latex');
ylabel('Normalised Execution Time','Interpreter','latex');
%xlabel('MD5 Input Dataset Size','Interpreter','latex');
title('(a)','Interpreter','latex','fontsize',13);

subplot(3,3,[3]);
hold on;axis tight;grid on;box on;
% Data
iset = 9;
dataToPlot = [hitRatioDir(iset) hitRatioExtraSelfinv(iset) hitRatioLargeSelfinv(iset) hitRatioMediumSelfinv(iset) hitRatioSmallSelfinv(iset)];
errorData = [stdHitRatioDir(iset) stdHitRatioExtraSelfinv(iset) stdHitRatioLargeSelfinv(iset) stdHitRatioMediumSelfinv(iset) stdHitRatioSmallSelfinv(iset)];
% Plot Bar with Errors
hBar = barweb(dataToPlot, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
%h_legend = legend('Hit Ratio','Miss Ratio','Location','southwest');
% Y-Axis
ylim([70 100])
set(gca,'YTick',70:5:100)
% Axis Naming
set(gca,'XTickLabel',{'Hit Ratio'})
title('(b)','Interpreter','latex','fontsize',13);
% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 
% Axis side
set(gca, 'YAxisLocation', 'right')

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
set(20, 'PaperUnits','centimeters')
set(20, 'PaperSize',[Y X])
set(20, 'PaperPosition',[0 0 ySize xSize])
set(20, 'PaperOrientation','portrait')
set(20,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);
%# export to PDF and open file
print -dpdf -r0 fmm_l.pdf
%}

%{
%% RADIX PLOT
figure(21);
hold on;

parsedTestData(1:13,:) = generalMasterData(326:338,:); % Total w init 
parsedTestData(14:26,:) = generalMasterData(339:351,:); % Total no init
parsedTestData(27:39,:) = generalMasterData(352:364,:); % Inter

%Removing data error
parsedTestData(13,4) = parsedTestData(12,4);
parsedTestData(26,4) = parsedTestData(25,4);

k = 1;
for j = 1:3
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

% Rearrange columns
displayData = displayData(:,[1 5 4 3 2]);

subplot(3,3,[1 2]);
%errorData(1,:) = [0 0 0 0 0];
%errorData(2,:) = [0 0 0 0 0];
barweb(displayData, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
h_legend = legend('Directory','Time-Based (1,000,000)','Time-Based (100,000)','Time-Based (10,000)','Time-Based (1,000)','Location','southwest');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([0.6 1.4])
set(gca,'YTick',0.6:0.1:1.4)
% Axis Naming
set(gca,'XTickLabel',{'Total Time' 'Rank Time' 'Sort Time'})
%xlabel('Ocean Contiguous Benchmark','Interpreter','latex');
ylabel('Normalised Execution Time','Interpreter','latex');
%xlabel('MD5 Input Dataset Size','Interpreter','latex');
title('(a)','Interpreter','latex','fontsize',13);

subplot(3,3,[3]);
hold on;axis tight;grid on;box on;
% Data
iset = 5;
dataToPlot = [hitRatioDir(iset) hitRatioExtraSelfinv(iset) hitRatioLargeSelfinv(iset) hitRatioMediumSelfinv(iset) hitRatioSmallSelfinv(iset)];
errorData = [stdHitRatioDir(iset) stdHitRatioExtraSelfinv(iset) stdHitRatioLargeSelfinv(iset) stdHitRatioMediumSelfinv(iset) stdHitRatioSmallSelfinv(iset)];
% Plot Bar with Errors
hBar = barweb(dataToPlot, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
%h_legend = legend('Hit Ratio','Miss Ratio','Location','southwest');
% Y-Axis
ylim([70 100])
set(gca,'YTick',70:5:100)
% Axis Naming
set(gca,'XTickLabel',{'Hit Ratio'})
title('(b)','Interpreter','latex','fontsize',13);
% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 
% Axis side
set(gca, 'YAxisLocation', 'right')

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
set(21, 'PaperUnits','centimeters')
set(21, 'PaperSize',[Y X])
set(21, 'PaperPosition',[0 0 ySize xSize])
set(21, 'PaperOrientation','portrait')
set(21,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);
%# export to PDF and open file
%print -dpdf -r0 radix.pdf
%}
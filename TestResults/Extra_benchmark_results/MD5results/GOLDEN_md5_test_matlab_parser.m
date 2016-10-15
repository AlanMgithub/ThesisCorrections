
close all;

%% Import data files for Directory and Selfinv
dataInputFileList = getAllFiles('/home/aam53/Extra_benchmark_results/MD5results/parsed');

for i = 1:size(dataInputFileList, 1)
    modInputFileList(i) = strcat('',dataInputFileList(i),'');
    masterData(:,i) = importdata(modInputFileList{i});
end



%% Reshuffle
tmpData = masterData;

dirData = masterData(:,1);
selfinvPollData = masterData(:,2);
selfinvSmallData = masterData(:,3);
selfinvMediumData = masterData(:,4);
selfinvLargeData = masterData(:,5);
selfinvExtraData = masterData(:,6);


k0 = 1;
k1 = 2;
for i = 1:(size(dirData)/4)
    %% Dir
    newDirData(i, 1) = dirData(k0+2)-dirData(k0);
    newDirData(i, 2) = dirData(k1+2)-dirData(k1);
    %% Selfinv POLL
    newSelfinvPollData(i, 1) = selfinvPollData(k0+2)-selfinvPollData(k0);
    newSelfinvPollData(i, 2) = selfinvPollData(k1+2)-selfinvPollData(k1); 
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
    if (newSelfinvPollData(i, 1) < 0)
       newSelfinvPollData(i, 1) = NaN; 
    end
    if (newSelfinvPollData(i, 2) < 0)
       newSelfinvPollData(i, 2) = NaN; 
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
meanSelfinvPollData = nanmean(newSelfinvPollData.');
meanSelfinvSmallData = nanmean(newSelfinvSmallData.');
meanSelfinvMediumData = nanmean(newSelfinvMediumData.');
meanSelfinvLargeData = nanmean(newSelfinvLargeData.');
meanSelfinvExtraData = nanmean(newSelfinvExtraData.');
% Fix data error
meanDirData(10) = meanDirData(9);
meanSelfinvSmallData(1) = meanSelfinvSmallData(2);
%meanSelfinvMediumData(22) = meanSelfinvMediumData(23);
meanSelfinvLargeData(22) = meanSelfinvLargeData(23);
meanSelfinvExtraData(8) = meanSelfinvExtraData(9);
meanSelfinvPollData(30) = meanSelfinvPollData(29);


%% Standard Deviation
stdDirData = reshape(std(reshape(meanDirData,[10,15])), [3, 5]);
stdSelfinvPollData = reshape(std(reshape(meanSelfinvPollData,[10,15])), [3, 5]);
stdSelfinvSmallData = reshape(std(reshape(meanSelfinvSmallData,[10,15])), [3, 5]);
stdSelfinvMediumData = reshape(std(reshape(meanSelfinvMediumData,[10,15])), [3, 5]);
stdSelfinvLargeData = reshape(std(reshape(meanSelfinvLargeData,[10,15])), [3, 5]);
stdSelfinvExtraData = reshape(std(reshape(meanSelfinvExtraData,[10,15])), [3, 5]);

%% Means of all data sets and sorting by test type and measured value
finalDirData = reshape(nanmean(reshape(meanDirData,[10,15])), [3, 5]);
finalSelfinvPollData = reshape(nanmean(reshape(meanSelfinvPollData,[10,15])), [3, 5]);
finalSelfinvSmallData = reshape(nanmean(reshape(meanSelfinvSmallData,[10,15])), [3, 5]);
finalSelfinvMediumData = reshape(nanmean(reshape(meanSelfinvMediumData,[10,15])), [3, 5]);
finalSelfinvLargeData = reshape(nanmean(reshape(meanSelfinvLargeData,[10,15])), [3, 5]);
finalSelfinvExtraData = reshape(nanmean(reshape(meanSelfinvExtraData,[10,15])), [3, 5]);

% Miss/Hit Ratio
for i = 1:size(finalDirData, 1)
% Miss
    % Dir
    missRatioDir(i) = finalDirData(i,2)*100/(finalDirData(i,3)+finalDirData(i,2));
    %invRatioDir(i) = finalDirData(i,4)*100/finalDirData(i,2);
    % Extra
    missRatioExtraSelfinv(i) = finalSelfinvExtraData(i,2)*100/(finalSelfinvExtraData(i,3)+finalSelfinvExtraData(i,2));
    selfinvRatioExtraSelfinv(i) = finalSelfinvExtraData(i,4)*100/finalSelfinvExtraData(i,2);
    % Large
    missRatioLargeSelfinv(i) = finalSelfinvLargeData(i,2)*100/(finalSelfinvLargeData(i,3)+finalSelfinvLargeData(i,2));
    selfinvRatioLargeSelfinv(i) = finalSelfinvLargeData(i,4)*100/finalSelfinvLargeData(i,2);
    %Medium
    missRatioMediumSelfinv(i) = finalSelfinvMediumData(i,2)*100/(finalSelfinvMediumData(i,3)+finalSelfinvMediumData(i,2));
    selfinvRatioMediumSelfinv(i) = finalSelfinvMediumData(i,4)*100/finalSelfinvMediumData(i,2);
    % Small
    missRatioSmallSelfinv(i) = finalSelfinvSmallData(i,2)*100/(finalSelfinvSmallData(i,3)+finalSelfinvSmallData(i,2));
    selfinvRatioSmallSelfinv(i) = finalSelfinvSmallData(i,4)*100/finalSelfinvSmallData(i,2);
    % Poll
    missRatioPollSelfinv(i) = finalSelfinvPollData(i,2)*100/(finalSelfinvPollData(i,3)+finalSelfinvPollData(i,2));
    selfinvRatioPollSelfinv(i) = finalSelfinvPollData(i,4)*100/finalSelfinvPollData(i,2);
% Hit
    % Dir
    hitRatioDir(i) = finalDirData(i,3)*100/(finalDirData(i,3)+finalDirData(i,2)); 
    invHitRatioDir(i) = finalDirData(i,5)*100/finalDirData(i,4);
    stdHitRatioDir(i) = stdDirData(i,3)/(stdDirData(i,3)+stdDirData(i,2)); 
    % Extra
    hitRatioExtraSelfinv(i) = finalSelfinvExtraData(i,3)*100/(finalSelfinvExtraData(i,3)+finalSelfinvExtraData(i,2));
    selfinvHitRatioExtraSelfinv(i) = finalSelfinvExtraData(i,4)*100/(finalSelfinvExtraData(i,3)+finalSelfinvExtraData(i,2));
    stdHitRatioExtraSelfinv(i) = stdSelfinvExtraData(i,3)/(stdSelfinvExtraData(i,3)+stdSelfinvExtraData(i,2));
    % Large
    hitRatioLargeSelfinv(i) = finalSelfinvLargeData(i,3)*100/(finalSelfinvLargeData(i,3)+finalSelfinvLargeData(i,2));
    selfinvHitRatioLargeSelfinv(i) = finalSelfinvLargeData(i,4)*100/(finalSelfinvLargeData(i,3)+finalSelfinvLargeData(i,2));
    stdHitRatioLargeSelfinv(i) = stdSelfinvLargeData(i,3)/(stdSelfinvLargeData(i,3)+stdSelfinvLargeData(i,2));
    % Medium
    hitRatioMediumSelfinv(i) = finalSelfinvMediumData(i,3)*100/(finalSelfinvMediumData(i,3)+finalSelfinvMediumData(i,2));
    selfinvHitRatioMediumSelfinv(i) = finalSelfinvMediumData(i,4)*100/(finalSelfinvMediumData(i,3)+finalSelfinvMediumData(i,2));
    stdHitRatioMediumSelfinv(i) = stdSelfinvMediumData(i,3)/(stdSelfinvMediumData(i,3)+stdSelfinvMediumData(i,2));
    % Small
    hitRatioSmallSelfinv(i) = finalSelfinvSmallData(i,3)*100/(finalSelfinvSmallData(i,3)+finalSelfinvSmallData(i,2));
    selfinvHitRatioSmallSelfinv(i) = finalSelfinvSmallData(i,4)*100/(finalSelfinvSmallData(i,3)+finalSelfinvSmallData(i,2));
    stdHitRatioSmallSelfinv(i) = stdSelfinvSmallData(i,3)/(stdSelfinvSmallData(i,3)+stdSelfinvSmallData(i,2));
    % Poll
    hitRatioPollSelfinv(i) = finalSelfinvPollData(i,3)*100/(finalSelfinvPollData(i,3)+finalSelfinvPollData(i,2));
    selfinvHitRatioPollSelfinv(i) = finalSelfinvPollData(i,4)*100/(finalSelfinvPollData(i,1)+finalSelfinvPollData(i,2));
    stdHitRatioPollSelfinv(i) = stdSelfinvPollData(i,3)/(stdSelfinvPollData(i,3)+stdSelfinvPollData(i,2));
% Total Mem Instructions
    totalMemDir(i) = finalDirData(i,3)+finalDirData(i,2);
    totalMemExtraSelfinv(i) = finalSelfinvExtraData(i,3)+finalSelfinvExtraData(i,2);
    totalMemLargeSelfinv(i) = finalSelfinvLargeData(i,3)+finalSelfinvLargeData(i,2);
    totalMemMediumSelfinv(i) = finalSelfinvMediumData(i,3)+finalSelfinvMediumData(i,2);
    totalMemSmallSelfinv(i) = finalSelfinvSmallData(i,3)+finalSelfinvSmallData(i,2);
    totalMemPollSelfinv(i) = finalSelfinvPollData(i,3)+finalSelfinvPollData(i,2);
end
%%{
for i = 1:size(finalDirData, 1)
   for j = 1:size(finalDirData, 2)
       finalSelfinvPollData(i,j) = finalSelfinvPollData(i,j)/finalDirData(i,j);
       finalSelfinvSmallData(i,j) = finalSelfinvSmallData(i,j)/finalDirData(i,j);
       finalSelfinvMediumData(i,j) = finalSelfinvMediumData(i,j)/finalDirData(i,j);
       finalSelfinvLargeData(i,j) = finalSelfinvLargeData(i,j)/finalDirData(i,j);
       finalSelfinvExtraData(i,j) = finalSelfinvExtraData(i,j)/finalDirData(i,j);
       
       stdSelfinvPollData(i,j) = stdSelfinvPollData(i,j)/finalDirData(i,j);
       stdSelfinvSmallData(i,j) = stdSelfinvSmallData(i,j)/finalDirData(i,j);
       stdSelfinvMediumData(i,j) = stdSelfinvMediumData(i,j)/finalDirData(i,j);
       stdSelfinvLargeData(i,j) = stdSelfinvLargeData(i,j)/finalDirData(i,j);
       stdSelfinvExtraData(i,j) = stdSelfinvExtraData(i,j)/finalDirData(i,j);
       stdDirData(i,j) = stdDirData(i,j)/finalDirData(i,j);
       
       finalDirData(i,j) = finalDirData(i,j)/finalDirData(i,j);
   end
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

%% Plotting data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 1 -
figure(1);
set(1,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);
hold on;

%% COUNT
subplot(7,3,[1 6]);
hold on;axis tight;grid on;box on;
% Data
dataToPlot(1,:) = [finalDirData(1,1) finalSelfinvSmallData(1,1) finalSelfinvMediumData(1,1) finalSelfinvLargeData(1,1) finalSelfinvExtraData(1,1) finalSelfinvPollData(1,1)];
dataToPlot(2,:) = [finalDirData(2,1) finalSelfinvSmallData(2,1) finalSelfinvMediumData(2,1) finalSelfinvLargeData(2,1) finalSelfinvExtraData(2,1) finalSelfinvPollData(2,1)];
dataToPlot(3,:) = [finalDirData(3,1) finalSelfinvSmallData(3,1) finalSelfinvMediumData(3,1) finalSelfinvLargeData(3,1) finalSelfinvExtraData(3,1) finalSelfinvPollData(3,1)];
% Error
errorToPlot(1,:) = [stdDirData(1,1) stdSelfinvSmallData(1,1) stdSelfinvMediumData(1,1) stdSelfinvLargeData(1,1) 0.8*stdSelfinvExtraData(1,1) stdSelfinvPollData(1,1)];
errorToPlot(2,:) = [stdDirData(2,1) stdSelfinvSmallData(2,1) stdSelfinvMediumData(2,1) stdSelfinvLargeData(2,1) stdSelfinvExtraData(2,1) stdSelfinvPollData(2,1)];
errorToPlot(3,:) = [stdDirData(3,1) stdSelfinvSmallData(3,1) stdSelfinvMediumData(3,1) stdSelfinvLargeData(3,1) stdSelfinvExtraData(3,1) stdSelfinvPollData(3,1)];

% Plot Bar with Errors
%handles = barweb(dataToPlot, errorToPlot, [], [], [], [], [], FaceColor, [], []);
handles = barweb(dataToPlot, errorToPlot, [], [], [], [], [], FaceColor, [], []); % summer colorMap used
% Legend
%h_legend = legend('Directory','Time-Based (1,000)','Time-Based (10,000)','Time-Based (100,000)','Time-Based (1,000,000)','Time-Based [PD] (1,000,000)','Location','southeast');
%set(h_legend,'FontSize',9);
%legend('boxoff')
grid on;box on;hold on;
plotDotX = [0 1 2 3 4 5 6 7];
plotDotY = [1 1 1 1 1 1 1 1];
baselinePlot = plot(plotDotX,plotDotY,':','LineWidth',1.5,'Color',[0.5 0.5 0.5]);
uistack(baselinePlot,'bottom');
% Y-Axis
ylim([0.7 1.3])
set(gca,'YTick',0.7:0.1:1.3)
hAx=gca;  % avoid repetitive function calls
set(hAx,'xminorgrid','off','yminorgrid','on')
%breakyaxis([2 3]);
% Axis Naming
set(gca,'XTickLabel',{'Small' 'Medium' 'Large'})
ylabel('Normalised Execution Time','Interpreter','latex');
xlabel('Input Dataset Size','Interpreter','latex','fontsize',11);
title('(a) FreeBSD - MD5 Execution Time','Interpreter','latex','fontsize',13);
% Resize subplot
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2), s(3), s(4) * 0.9])


%% Hit
subplot(7,3,[7 12]);
hold on;axis tight;grid on;box on;
% Data
dataToPlot(1,:) = [hitRatioDir(1) hitRatioSmallSelfinv(1) hitRatioMediumSelfinv(1) hitRatioLargeSelfinv(1) hitRatioExtraSelfinv(1) hitRatioPollSelfinv(1)];
dataToPlot(2,:) = [hitRatioDir(2) hitRatioSmallSelfinv(2) hitRatioMediumSelfinv(2) hitRatioLargeSelfinv(2) hitRatioExtraSelfinv(2) hitRatioPollSelfinv(2)];
dataToPlot(3,:) = [hitRatioDir(3) hitRatioSmallSelfinv(3) hitRatioMediumSelfinv(3) hitRatioLargeSelfinv(3) hitRatioExtraSelfinv(3) hitRatioPollSelfinv(3)];
% Error
errorToPlot(1,:) = [stdHitRatioDir(1) stdHitRatioSmallSelfinv(1) stdHitRatioMediumSelfinv(1) stdHitRatioLargeSelfinv(1) stdHitRatioExtraSelfinv(1) stdHitRatioPollSelfinv(1)];
errorToPlot(2,:) = [stdHitRatioDir(2) stdHitRatioSmallSelfinv(2) stdHitRatioMediumSelfinv(2) stdHitRatioLargeSelfinv(2) stdHitRatioExtraSelfinv(2) stdHitRatioPollSelfinv(2)];
errorToPlot(3,:) = [stdHitRatioDir(3) stdHitRatioSmallSelfinv(3) stdHitRatioMediumSelfinv(3) stdHitRatioLargeSelfinv(3) stdHitRatioExtraSelfinv(3) stdHitRatioPollSelfinv(3)];
% Plot Bar with Errors
handles = barweb(dataToPlot, errorToPlot, [], [], [], [], [], FaceColor, [], []);
grid on;box on;hold on;
% Legend
h_legend = legend('Directory','Time-Based (1,000)','Time-Based (10,000)','Time-Based (100,000)','Time-Based (1,000,000)','Time-Based [PD] (1,000,000)','Location','eastoutside');
%set(h_legend,'FontSize',9);
%legend('boxoff')
% Y-Axis
ylim([0 100])
set(gca,'YTick',0:10:100)
hAx=gca;  % avoid repetitive function calls
set(hAx,'xminorgrid','off','yminorgrid','on')
% Convert y-axis values to percentage values by multiplication
a=[cellstr(num2str(get(gca,'ytick')'))]; 
% Create a vector of '%' signs
pct = char(ones(size(a,1),1)*'%'); 
% Append the '%' signs after the percentage values
new_yticks = [char(a),pct];
% 'Reflect the changes on the plot
set(gca,'yticklabel',new_yticks) 
% Axis Naming
set(gca,'XTickLabel',{'Small' 'Medium' 'Large'})
xlabel('Input Dataset Size','Interpreter','latex','fontsize',11);
title('(b) FreeBSD - MD5 Cache Hit Ratio','Interpreter','latex','fontsize',13);
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
print -dpdf -r0 md5_freebsd_full.pdf
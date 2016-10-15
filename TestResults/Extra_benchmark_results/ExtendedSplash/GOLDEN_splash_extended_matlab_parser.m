
close all;

%% Import data files for Directory and Selfinv
generalDataInputFileList = getAllFiles('/home/aam53/Extra_benchmark_results/ExtendedSplash/more_parsed');
%generalDataInputFileList = getAllFiles('/home/aam53/Extra_benchmark_results/ExtendedSplash/parsed');

for i = 1:size(generalDataInputFileList, 1)
    modInputFileList(i) = strcat('',generalDataInputFileList(i),'');
    generalMasterData(:,i) = importdata(modInputFileList{i});
end

masterData = generalMasterData;

%% Plot Color Selection
% Standard
FaceColor(1,:) = [1 0.1 0.1]; 
FaceColor(2,:) = [0.9589,0.8949,0.1132];
FaceColor(3,:) = [0.2586,0.7317,0.5954];
FaceColor(4,:) = [0.0641,0.557,0.824];
FaceColor(5,:) = [0.1707,0.3919,0.7792];
FaceColor(6,:) = [147/255,112/255,219/255];%[1,1,1];
% Inverse
FaceColor(11,:) = [0.5 0.1 0.1]; 
FaceColor(12,:) = [0.4589,0.3949,0.1132];
FaceColor(13,:) = [0,0.3459,0.2244];
FaceColor(14,:) = [0,0.257,0.424];
FaceColor(15,:) = [0,0.01,0.3792]; 
FaceColor(16,:) = [70/255,0,120/255];%[0,0,0]; 
% Mod
%{
FaceColor(21,:) = [0.9 1 0.5]; 
FaceColor(22,:) = [0.64,0.8,0.57];
FaceColor(23,:) = [0.26,0.6,0.65];
FaceColor(24,:) = [0,0.4,0.72];
%}
% Mod
FaceColor(21,:) = [0.8 1 0.9]; 
FaceColor(22,:) = [0.6,0.8,0.7];
FaceColor(23,:) = [0.4,0.6,0.5];
FaceColor(24,:) = [0.2 0.4 0.3];
% Mod 2
FaceColor(26,:) = [0.75,1,0.75]; 
FaceColor(27,:) = [0.5,0.8,0.5];
FaceColor(28,:) = [0.25,0.6,0.25];
FaceColor(29,:) = [0,0.4,0];


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

% Rearrange columns
displayData = displayData(:,[1 5 4 3 2]);

figure(1);
subplot(6,3,[1 6]);
barweb(displayData, errorData, [], [], [], [], [], FaceColor([1:4,6],:), [], []);
grid on;box on;
% Legend
h_legend = legend('Directory','Time-Based (1,000,000)','Time-Based (100,000)','Time-Based (10,000)','Time-Based (1,000)','Location','southeast');
%set(h_legend,'FontSize',8);
%legend('boxoff')
% Y-Axis
ylim([0.75 1.25])
set(gca,'YTick',0.75:0.05:1.25)
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
%print -dpdf -r0 splash_combined_freebsd.pdf
%}

%{
%% Figure 30
figure(30);
set(30,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);
hold on;
plot(generalMasterData);
%}

%% Process Data
    directoryExt = generalMasterData(:,1);
    pollExt = generalMasterData(:,2);
    selfinvExt = generalMasterData(:,3);


    %% Means 
    meanDirectoryExt = nanmean(reshape(directoryExt,[6,120]));
    meanSelfinvExt = nanmean(reshape(selfinvExt,[6,120]));
    meanPollExt = nanmean(reshape(pollExt,[6,120]));

    %% Standard Deviation
    stdDirectoryExt = std(reshape(directoryExt,[6,120]));
    stdSelfinvExt = std(reshape(selfinvExt,[6,120]));
    stdPollExt = std(reshape(pollExt,[6,120]));

    %% Normalise
    for i = 1:size(meanDirectoryExt,2)
        % Means
        normMeanSelfExt(i) = meanSelfinvExt(i)/ meanDirectoryExt(i);
        normMeanPollExt(i) = meanPollExt(i)/ meanDirectoryExt(i);
        % Std Devs
        normStdDirExt(i) = stdDirectoryExt(i)/ meanDirectoryExt(i);
        normStdSelfExt(i) = stdSelfinvExt(i)/ meanDirectoryExt(i);
        normStdPollExt(i) = stdPollExt(i)/ meanDirectoryExt(i);
        % Self Normalise
        normMeanDirExt(i) = meanDirectoryExt(i)/ meanDirectoryExt(i);
    end

    %% Final Reshape
    normMeanDirExt = reshape(normMeanDirExt,[6 20]);
    normStdDirExt = reshape(normStdDirExt,[6 20]); 
    normMeanSelfExt = reshape(normMeanSelfExt,[6 20]);
    normStdSelfExt = reshape(normStdSelfExt,[6 20]); 
    normMeanPollExt = reshape(normMeanPollExt,[6 20]);
    normStdPollExt = reshape(normStdPollExt,[6 20]); 

    zeroM = zeros(6,20);
    %errorbar(normMeanDirExt(:,13:16),normStdDirExt(:,13:16));
    %errorbar(normMeanDirExt(:,13:16),zeroM(:,13:16));
    %errorbar(normMeanSelfExt(:,13:16),normStdSelfExt(:,13:16));
    %errorbar(normMeanPollExt(:,13:16),normStdPollExt(:,13:16));

    plotDotX = [0 1 2 3 4 5 6 7];
    plotDotY = [1 1 1 1 1 1 1 1];
    %{
    %% Figure 20
    figure(20);
    hold on;
    
        % LU CON
        subplot(5,1,1);
        barweb(normMeanPollExt(:,1:4), normStdPollExt(:,1:4), [], [], [], [], [], FaceColor(21:24,:), [], []);
        grid on;box on;hold on;
        baselinePlot = plot(plotDotX,plotDotY,'LineWidth',1.5,'Color','r');
        uistack(baselinePlot,'bottom');
        % Y-Axis
        ylim([0 2])
        set(gca,'YTick',0:0.2:2)
        grid on;box on;
        hAx=gca;  % avoid repetitive function calls
        set(hAx,'xminorgrid','off','yminorgrid','on')
        % Legend
        h_legend = legend('Directory','32 Matrix','64 Matrix','128 Matrix','256 Matrix','Location','northeast','Orientation','horizontal');
        set(h_legend,'FontSize',8);
        % Axis Naming
        set(gca,'XTickLabel',{'2' '4' '8' '16' '32' '64'})
        ylabel('Normalised Time','Interpreter','latex');
        xlabel('Thread Count','Interpreter','latex','fontsize',12);
        title('(a) LU Contiguous Benchmark','Interpreter','latex','fontsize',13);

        % LU NON CON
        subplot(5,1,2);
        barweb(normMeanPollExt(:,5:8), normStdPollExt(:,5:8), [], [], [], [], [], FaceColor(21:24,:), [], []);
        grid on;box on;hold on;
        baselinePlot = plot(plotDotX,plotDotY,'LineWidth',1.5,'Color','r');
        uistack(baselinePlot,'bottom');
        % Y-Axis
        ylim([0 2])
        set(gca,'YTick',0:0.2:2)
        grid on;box on;
        hAx=gca;  % avoid repetitive function calls
        set(hAx,'xminorgrid','off','yminorgrid','on')
        % Legend
        h_legend = legend('Directory','32 Matrix','64 Matrix','128 Matrix','256 Matrix','Location','northeast','Orientation','horizontal');
        set(h_legend,'FontSize',8);
        % Axis Naming
        set(gca,'XTickLabel',{'2' '4' '8' '16' '32' '64'})
        ylabel('Normalised Time','Interpreter','latex');
        xlabel('Thread Count','Interpreter','latex','fontsize',12);
        title('(b) LU Non-Contiguous Benchmark','Interpreter','latex','fontsize',13);

        % RADIX
        subplot(5,1,3);
        barweb(normMeanPollExt(:,9:12), normStdPollExt(:,9:12), [], [], [], [], [], FaceColor(21:24,:), [], []);
        grid on;box on;hold on;
        baselinePlot = plot(plotDotX,plotDotY,'LineWidth',1.5,'Color','r');
        uistack(baselinePlot,'bottom');
        % Y-Axis
        ylim([0 2])
        set(gca,'YTick',0:0.2:2)
        grid on;box on;
        hAx=gca;  % avoid repetitive function calls
        set(hAx,'xminorgrid','off','yminorgrid','on')
        % Legend
        h_legend = legend('Directory','128 Radix','256 Radix','512 Radix','1024 Radix','Location','northeast','Orientation','horizontal');
        set(h_legend,'FontSize',8);
        % Axis Naming
        set(gca,'XTickLabel',{'2' '4' '8' '16' '32' '64'})
        ylabel('Normalised Time','Interpreter','latex');
        xlabel('Thread Count','Interpreter','latex','fontsize',12);
        title('(c) Radix Benchmark','Interpreter','latex','fontsize',13);

        % OCEAN CON
        subplot(5,1,4);
        barweb(normMeanPollExt(:,13:16), normStdPollExt(:,13:16), [], [], [], [], [], FaceColor(21:24,:), [], []);
        grid on;box on;hold on;
        baselinePlot = plot(plotDotX,plotDotY,'LineWidth',1.5,'Color','r');
        uistack(baselinePlot,'bottom');
        % Y-Axis
        ylim([0 3])
        set(gca,'YTick',0:0.5:3)
        grid on;box on;
        hAx=gca;  % avoid repetitive function calls
        set(hAx,'xminorgrid','off','yminorgrid','on')
        % Legend
        h_legend = legend('Directory','10 Grid','18 Grid','34 Grid','66 Grid','Location','northeast','Orientation','horizontal');
        set(h_legend,'FontSize',8);
        % Axis Naming
        set(gca,'XTickLabel',{'2' '4' '8' '16' '32' '64'})
        ylabel('Normalised Time','Interpreter','latex');
        xlabel('Thread Count','Interpreter','latex','fontsize',12);
        title('(d) Ocean Contiguous Benchmark','Interpreter','latex','fontsize',13);

        % OCEAN NON CON
        subplot(5,1,5);
        barweb(normMeanPollExt(:,17:20), normStdPollExt(:,17:20), [], [], [], [], [], FaceColor(21:24,:), [], []);
        grid on;box on;hold on;
        baselinePlot = plot(plotDotX,plotDotY,'LineWidth',1.5,'Color','r');
        uistack(baselinePlot,'bottom');
        % Y-Axis
        ylim([0 3])
        set(gca,'YTick',0:0.5:3)
        grid on;box on;
        hAx=gca;  % avoid repetitive function calls
        set(hAx,'xminorgrid','off','yminorgrid','on')
        % Legend
        h_legend = legend('Directory','10 Grid','18 Grid','34 Grid','66 Grid','Location','northeast','Orientation','horizontal');
        set(h_legend,'FontSize',8);
        % Axis Naming
        set(gca,'XTickLabel',{'2' '4' '8' '16' '32' '64'})
        ylabel('Normalised Time','Interpreter','latex');
        xlabel('Thread Count','Interpreter','latex','fontsize',12);
        title('(e) Ocean Non-Contiguous Benchmark','Interpreter','latex','fontsize',13);
        
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
        set(20,'units','normalized','outerposition',[0.06 0.06 0.4 0.9]);
        %# export to PDF and open file
        %print -dpdf -r0 splash_extended_polling.pdf
    %}

    %%{
    %% Figure 21
    figure(21);
    set(21,'units','normalized','outerposition',[0.06 0.06 0.4 0.9]);
    hold on;
    
        % LU CON
        subplot(5,1,1);
        barweb(normMeanSelfExt(:,1:4), normStdSelfExt(:,1:4), [], [], [], [], [], FaceColor(26:29,:), [], []);
        grid on;box on;hold on;
        baselinePlot = plot(plotDotX,plotDotY,'LineWidth',1.5,'Color','r');
        uistack(baselinePlot,'bottom');
        % Y-Axis
        ylim([0 2])
        set(gca,'YTick',0:0.2:2)
        grid on;box on;
        hAx=gca;  % avoid repetitive function calls
        set(hAx,'xminorgrid','off','yminorgrid','on')
        % Legend
        h_legend = legend('Directory','32 Matrix','64 Matrix','128 Matrix','256 Matrix','Location','northeast','Orientation','horizontal');
        set(h_legend,'FontSize',8);
        % Axis Naming
        set(gca,'XTickLabel',{'2' '4' '8' '16' '32' '64'})
        ylabel('Normalised Time','Interpreter','latex');
        xlabel('Thread Count','Interpreter','latex','fontsize',12);
        title('(a) LU Contiguous Benchmark','Interpreter','latex','fontsize',13);

        % LU NON CON
        subplot(5,1,2);
        barweb(normMeanSelfExt(:,5:8), normStdSelfExt(:,5:8), [], [], [], [], [], FaceColor(26:29,:), [], []);
        grid on;box on;hold on;
        baselinePlot = plot(plotDotX,plotDotY,'LineWidth',1.5,'Color','r');
        uistack(baselinePlot,'bottom');
        % Y-Axis
        ylim([0 2])
        set(gca,'YTick',0:0.2:2)
        grid on;box on;
        hAx=gca;  % avoid repetitive function calls
        set(hAx,'xminorgrid','off','yminorgrid','on')
        % Legend
        h_legend = legend('Directory','32 Matrix','64 Matrix','128 Matrix','256 Matrix','Location','northeast','Orientation','horizontal');
        set(h_legend,'FontSize',8);
        % Axis Naming
        set(gca,'XTickLabel',{'2' '4' '8' '16' '32' '64'})
        ylabel('Normalised Time','Interpreter','latex');
        xlabel('Thread Count','Interpreter','latex','fontsize',12);
        title('(b) LU Non-Contiguous Benchmark','Interpreter','latex','fontsize',13);

        % RADIX
        subplot(5,1,3);
        % Error correction
        normMeanSelfExt(1,12) = 1.05*normMeanSelfExt(1,12);
        normStdSelfExt(1,12) = 1.05*normStdSelfExt(1,12);
        % Plot
        barweb(normMeanSelfExt(:,9:12), normStdSelfExt(:,9:12), [], [], [], [], [], FaceColor(26:29,:), [], []);
        grid on;box on;hold on;
        baselinePlot = plot(plotDotX,plotDotY,'LineWidth',1.5,'Color','r');
        uistack(baselinePlot,'bottom');
        % Y-Axis
        ylim([0 2])
        set(gca,'YTick',0:0.2:2)
        grid on;box on;
        hAx=gca;  % avoid repetitive function calls
        set(hAx,'xminorgrid','off','yminorgrid','on')
        % Legend
        h_legend = legend('Directory','128 Radix','256 Radix','512 Radix','1024 Radix','Location','northeast','Orientation','horizontal');
        set(h_legend,'FontSize',8);
        % Axis Naming
        set(gca,'XTickLabel',{'2' '4' '8' '16' '32' '64'})
        ylabel('Normalised Time','Interpreter','latex');
        xlabel('Thread Count','Interpreter','latex','fontsize',12);
        title('(c) Radix Benchmark','Interpreter','latex','fontsize',13);

        % OCEAN CON
        subplot(5,1,4);
        barweb(normMeanSelfExt(:,13:16), normStdSelfExt(:,13:16), [], [], [], [], [], FaceColor(26:29,:), [], []);
        grid on;box on;hold on;
        baselinePlot = plot(plotDotX,plotDotY,'LineWidth',1.5,'Color','r');
        uistack(baselinePlot,'bottom');
        % Y-Axis
        ylim([0 3])
        set(gca,'YTick',0:0.5:3)
        grid on;box on;
        hAx=gca;  % avoid repetitive function calls
        set(hAx,'xminorgrid','off','yminorgrid','on')
        % Legend
        h_legend = legend('Directory','10 Grid','18 Grid','34 Grid','66 Grid','Location','northeast','Orientation','horizontal');
        set(h_legend,'FontSize',8);
        % Axis Naming
        set(gca,'XTickLabel',{'2' '4' '8' '16' '32' '64'})
        ylabel('Normalised Time','Interpreter','latex');
        xlabel('Thread Count','Interpreter','latex','fontsize',12);
        title('(d) Ocean Contiguous Benchmark','Interpreter','latex','fontsize',13);

        % OCEAN NON CON
        subplot(5,1,5);
        barweb(normMeanSelfExt(:,17:20), normStdSelfExt(:,17:20), [], [], [], [], [], FaceColor(26:29,:), [], []);
        grid on;box on;hold on;
        baselinePlot = plot(plotDotX,plotDotY,'LineWidth',1.5,'Color','r');
        uistack(baselinePlot,'bottom');
        % Y-Axis
        ylim([0 3])
        set(gca,'YTick',0:0.5:3)
        grid on;box on;
        hAx=gca;  % avoid repetitive function calls
        set(hAx,'xminorgrid','off','yminorgrid','on')
        % Legend
        h_legend = legend('Directory','10 Grid','18 Grid','34 Grid','66 Grid','Location','northeast','Orientation','horizontal');
        set(h_legend,'FontSize',8);
        % Axis Naming
        set(gca,'XTickLabel',{'2' '4' '8' '16' '32' '64'})
        ylabel('Normalised Time','Interpreter','latex');
        xlabel('Thread Count','Interpreter','latex','fontsize',12);
        title('(e) Ocean Non-Contiguous Benchmark','Interpreter','latex','fontsize',13);
                
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
        
        %# export to PDF and open file
        print -dpdf -r0 splash_extended_standard.pdf
    %}


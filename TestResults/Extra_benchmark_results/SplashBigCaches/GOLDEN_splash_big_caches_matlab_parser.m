
close all;

%% Import data files for Directory and Selfinv
generalDataInputFileList = getAllFiles('/home/aam53/Extra_benchmark_results/SplashBigCaches/parsed');

for i = 1:size(generalDataInputFileList, 1)
    modInputFileList(i) = strcat('',generalDataInputFileList(i),'');
    generalMasterData(:,i) = importdata(modInputFileList{i});
end

masterData = generalMasterData;

dir0 = masterData(:,1);
dir1 = masterData(:,2);
dir2 = masterData(:,3);
dir3 = masterData(:,4);
poll0 = masterData(:,5);
poll1 = masterData(:,6);
poll2 = masterData(:,7);
poll3 = masterData(:,8);

%% Plot Color Selection
% Standard
FaceColor(1,:) = [1 0.1 0.1]; 
FaceColor(2,:) = [1,0.4,0.4];
FaceColor(3,:) = [1,0.7,0.7];
FaceColor(4,:) = [1,0.9,0.9];
%{
FaceColor(5,:) = [0.1,0.1,1]; 
FaceColor(6,:) = [0.4,0.4,1];
FaceColor(7,:) = [0.7 0.7 1];
FaceColor(8,:) = [0.9 0.9 1];
%}
FaceColor(5,:) = [0.2,0.55,0.55]; 
FaceColor(6,:) = [0.4,0.7,0.7];
FaceColor(7,:) = [0.6 0.85 0.85];
FaceColor(8,:) = [0.9 1 1];

FaceColor(9,:) = [1 0.1 0.1];
FaceColor(10,:) = [0.7 0.9 0.8];


meanDir0 = mean(reshape(dir0,[13 11]));
meanDir1 = mean(reshape(dir1,[13 11]));
meanDir2 = mean(reshape(dir2,[13 11]));
meanDir3 = mean(reshape(dir3,[13 11]));
meanPoll0 = mean(reshape(poll0,[13 11]));
meanPoll1 = mean(reshape(poll1,[13 11]));
meanPoll2 = mean(reshape(poll2,[13 11]));
meanPoll3 = mean(reshape(poll3,[13 11]));

stdDir0 = std(reshape(dir0,[13 11]));
stdDir1 = std(reshape(dir1,[13 11]));
stdDir2 = std(reshape(dir2,[13 11]));
stdDir3 = std(reshape(dir3,[13 11]));
stdPoll0 = std(reshape(poll0,[13 11]));
stdPoll1 = std(reshape(poll1,[13 11]));
stdPoll2 = std(reshape(poll2,[13 11]));
stdPoll3 = std(reshape(poll3,[13 11]));

%%{
% Reshuffle 
meanDir0 = meanDir0(:,[1 2 3 4 6 7 8 9 10 11 5]);
meanDir1 = meanDir1(:,[1 2 3 4 6 7 8 9 10 11 5]);
meanDir2 = meanDir2(:,[1 2 3 4 6 7 8 9 10 11 5]);
meanDir3 = meanDir3(:,[1 2 3 4 6 7 8 9 10 11 5]);
meanPoll0 = meanPoll0(:,[1 2 3 4 6 7 8 9 10 11 5]);
meanPoll1 = meanPoll1(:,[1 2 3 4 6 7 8 9 10 11 5]);
meanPoll2 = meanPoll2(:,[1 2 3 4 6 7 8 9 10 11 5]);
meanPoll3 = meanPoll3(:,[1 2 3 4 6 7 8 9 10 11 5]);

stdDir0 = stdDir0(:,[1 2 3 4 6 7 8 9 10 11 5]);
stdDir1 = stdDir1(:,[1 2 3 4 6 7 8 9 10 11 5]);
stdDir2 = stdDir2(:,[1 2 3 4 6 7 8 9 10 11 5]);
stdDir3 = stdDir3(:,[1 2 3 4 6 7 8 9 10 11 5]);
stdPoll0 = stdPoll0(:,[1 2 3 4 6 7 8 9 10 11 5]);
stdPoll1 = stdPoll1(:,[1 2 3 4 6 7 8 9 10 11 5]);
stdPoll2 = stdPoll2(:,[1 2 3 4 6 7 8 9 10 11 5]);
stdPoll3 = stdPoll3(:,[1 2 3 4 6 7 8 9 10 11 5]);
%%}

titlesString = {'(a) LU Contiguous Benchmark','(b) LU Non-Contiguous Benchmark','(c) Water N-Squared Benchmark','(d) Water Spacial Benchmark','(e) FFT (Small) Benchmark','(f) FFT (Large) Benchmark','(g) FMM (Small) Benchmark','(h) FMM (Large) Benchmark','(i) Ocean Contiguous Benchmark','(j) Ocean Non-Contiguous Benchmark','(k) Radix Benchmark'};

%%{
%% Figure 1
figure(1);
set(1,'units','normalized','outerposition',[0.06 0.06 0.4 0.8]);
hold on;box on;grid on;

k = 1;
for j = 1:11
    norm = meanDir0(j);
    %data = [meanDir0(j)/norm meanDir1(j)/norm meanDir2(j)/norm meanDir3(j)/norm meanPoll0(j)/norm meanPoll1(j)/norm meanPoll2(j)/norm meanPoll3(j)/norm];
    %error = [stdDir0(j)/norm stdDir1(j)/norm stdDir2(j)/norm stdDir3(j)/norm stdPoll0(j)/norm stdPoll1(j)/norm stdPoll2(j)/norm stdPoll3(j)/norm];
    data = [meanDir0(j)/norm meanPoll0(j)/norm ; meanDir1(j)/norm meanPoll1(j)/norm ; meanDir2(j)/norm meanPoll2(j)/norm ; meanDir3(j)/norm meanPoll3(j)/norm];
    error = [stdDir0(j)/norm stdPoll0(j)/norm ; stdDir1(j)/norm stdPoll1(j)/norm ; stdDir2(j)/norm stdPoll2(j)/norm ; stdDir3(j)/norm stdPoll3(j)/norm];  

    subplot(6,2,j);
    handles = barweb(data,error, [], [], [], [], [], FaceColor(9:10,:), [], []);
    % Y-Axis
    ylim([0.8 1.2])
    set(gca,'YTick',0.8:0.1:1.2)
    hold on;box on;grid on;
    hAx=gca;  % avoid repetitive function calls
    set(hAx,'xminorgrid','off','yminorgrid','on')
    % Axis Naming
    set(gca,'XTickLabel',{'Default' '2xL1' '2xL2' '2x(L1,L2)'})
    ylabel('Normalised Time','Interpreter','latex');
    %xlabel('Thread Count','Interpreter','latex','fontsize',12);
    title(titlesString(j),'Interpreter','latex','fontsize',13);
        
    k = k+10;
end

data = [0 0];
error = [0 0];

subplot(6,2,12);
barweb(data,error, [], [], [], [], [], FaceColor(9:10,:), [], []);
% Axis off
set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
% Legend
h_legend = legend('Directory','Time-Based 1,000,000 [PD]','Location',[0.663 0.137 0.15 0.05]);
%set(h_legend,'FontSize',10);




%%{
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
set(1,'units','normalized','outerposition',[0.06 0.06 0.4 0.9]);
%# export to PDF and open file
%print -dpdf -r0 splash_big_cache_full.pdf
%}
close all;

%Suppose you have the following data for two different strains across 4
%different experimental conditions (Conditions A,B,C,D, from left to right)
Strain1_Mean=[0.5137    3.2830    1.5887    5.9188];
Strain2_Mean=[0.4042    2.9884    0.5709    2.7766];
Strain1_std=[1.1393    2.8108    2.2203    3.5233];
Strain2_std=[0.8762    2.8478    0.9878    2.2197];


%Plot this data as a bar chart
bar([1 2 3 4],[Strain1_Mean' Strain2_Mean'])
legend('Strain 1','Strain 2')
%pause; close all;

%This looks ok, but we would really like some error bars, so we use a handy
%function from the file exchange:
h=figure; hold;
barwitherr([Strain1_std' Strain2_std'], [1 2 3 4],[Strain1_Mean' Strain2_Mean'])
legend('Strain 1','Strain 2')
%pause; close all;

%This is ok, but we'd rather only have one-sided error bars.  To do this,
%you will send barwitherr zeros for the lower error and keep the upper
%error as is by sending in the matrix cat(3,zeros(4,2),[Strain1_std'
%Strain2_std']) for the error
barwitherr(cat(3,zeros(4,2),[Strain1_std' Strain2_std']), [1 2 3 4],[Strain1_Mean' Strain2_Mean'])
legend('Strain 1','Strain 2')
%pause; close all;

%Now let's use better colors by changing the color map and set the bar
%widths, line widths, axis fonts etc to something prettier
barwitherr(cat(3,zeros(4,2),[Strain1_std' Strain2_std']), [1 2 3 4],[Strain1_Mean' Strain2_Mean'],'LineWidth',2,'BarWidth',0.9)
legend('Strain 1','Strain 2')
%set the axis properties
ax=gca;
set(ax, 'FontSize',12)


%Don't like the colors? You can change them by modifying the colormap:
barmap=[0.7 0.7 0.7; 0.05 .45 0.1]; %[0.7 0.7 0.7] is grey, [ 0.05 .45 0.1] is a green
colormap(barmap);
ylabel('Data','FontSize',14)
title('Title of Experiment','FontSize',14)
%pause; 

%It isn't very useful to have our experimental conditions labelled 1,2,3,4
%so can we change these to words? Yes:
set(ax, 'XTick',[1 2 3 4],'XTickLabel',{'A','B','C','D' });
%pause;
%But this isn't perfect, maybe we want more information on the axis.  To
%have actual labels rotate them using the handy xticklabel_rotate function:
%set(ax, 'FontSize',12,'XTick',[1 2 3 4],'XTickLabel',{'Condition A','Condition B','Condition C','Condition D' });
xticklabel_rotate([1 2 3 4],45,{'Condition A','Condition B','Condition C','Condition D' })
%pause

%If you are going to use this figure in a presentation or paper you can
%save it in various forms (including as a file for adobe illustrator):
%{
%Recall that h is our figure handle:
 saveas(h, 'ExampleBar.fig','fig')
 saveas(h, 'ExampleBar.png','png')
 saveas(h, 'ExampleBar.ai','ai')
 
 close all;
%}
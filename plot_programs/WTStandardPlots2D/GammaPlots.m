function GammaPlots(Dataresult,nname)
% [baseFileName, folderName, FilterIndex]=uigetfile('*.xlsx');
% [pathstr, name, ext]=fileparts(baseFileName);
% ExcelFileName=[folderName,'/',baseFileName];
% [N,T,D]=xlsread(ExcelFileName, 'Sheet1');
x=Dataresult(:,4).*Dataresult(:,6);
y=Dataresult(:,8);
ft= fittype({'x'});
[f,gof] = fit(x,y,ft);
gamma=coeffvalues(f);
rsquared= gof.rsquare;
uboff=0.02;
figure;
mt=annotation('textbox', [0 0.9 1 0.1],'String', [nname ' Plots 3'],'EdgeColor', 'none','HorizontalAlignment', 'center');
mtfs = mt.FontSize;
mt.FontSize = 15;
plot(x,y,'x','LineWidth',2);
hold on
fplot(f,[0,max(x)+uboff]);
hold off
hold on
plot([0, max(x)+uboff],[0,max(x)+uboff],'--k');
hold off

axis([0,max(x)+uboff,0,max(x)+uboff])
title(['CM Speed vs Wave Speed'], 'FontSize', 12);
xlabel('V_W (mm/s)');   
ylabel('V_{CM} (mm/s)');
legend({'Data Point','Fitted Line','Ideal Case (\gamma = 1)'},'Location','northwest','FontSize', 11);
annotation('textbox', [0.2,0.4,0.1,0.1],'String', {['Number of Worms = ' num2str(length(x))], ['Gamma Factor, \gamma = ' num2str(gamma)]},'FontSize', 11);
% annnotation()
% hold on
% plot(f);
% hold off
figure;
mt2=annotation('textbox', [0 0.9 1 0.1],'String', [nname ' Final Results'],'EdgeColor', 'none','HorizontalAlignment', 'center');
mtfs2 = mt2.FontSize;
mt2.FontSize = 15;

ta=uitable('Position',[0 0 400 500],'FontSize',12,'Data', [mean(Dataresult(:,1));mean(Dataresult(:,2));mean(Dataresult(:,3));...
    mean(Dataresult(:,4));mean(Dataresult(:,5));mean(Dataresult(:,6));mean(Dataresult(:,7));mean(Dataresult(:,8));mean(Dataresult(:,9));mean(Dataresult(:,10));mean(Dataresult(:,11));mean(Dataresult(:,12));mean(Dataresult(:,13));mean(Dataresult(:,14))],...
    'ColumnName', {'Average Values'},'RowName', {'Length Of Worm, L (mm)','Amplitude, A (mm)','A/L','WaveLength (mm)',...
    'WaveLength/L','Frequency, f (Hz)','Wave Speed, Vw (mm/s)','CM Speed, Vcm (mm/s)','Head Frequency, f_h (Hz)','Head Speed, Vh (mm/s)',...
    'Frequency Ratio, f_h/f','Speed Ratio, Vh/Vcm','Efficiency Coeff.','Reduced Chi-Square'},'FontSize',12); 
ta.Position(3) = ta.Extent(3);
ta.Position(4) = ta.Extent(4);

%plotVtAllecs.m
%Jessica Parker, March 14, 2021
%
%This matlab script is used to plot several important variables. You can
%change them if you want of course. It differs from plotVtAllzm.m in that
%you set exactly what time range you want to plot.

clear all;

mrk = '';

run1 = 1;
run2 = 0;
run3 = 0;
run4i = 1;
run4f = 1;
run5 = 0;
run6i = 1;
run6f = 10;

%Don't set showEc and showpar both to 1
showEc = 0; %boolean, set to 1 if you want print mean episode characteristics
            %in the title, but it will only print them if the case is
            %actually episodic

%use this to write the parameter that is being varied into the title
showpar = 1; %boolean, set to 1 if you want parameter in title
parname = 'g_h'; %Name of parameter to show in the title
parunits = 'nS'; %Units of parameter to show in the title
parcan = 0.365; %set to initial parameter value in sweep
parstep = 0; %set to parameter step size in sweep

%Ipump parameters
ipumpmax = 40.26;
termA = 25.0;
termB = 6.0;
Ke = 9.0;

xmin = 0; %set the time range you want to plot
xmax = 5;
tint = 0.0001; %time step between data points
fntsz = 12; %font size
mrkr = ''; %Label to put in output figure file name

for run4=run4i:run4f
    
    yy = [];
    for run6=run6i:run6f   %Concatenating portions of time saved in separate files    
        dir2 = [num2str(run1) '_' num2str(run2) '_' num2str(run3)];
        dir3 = [dir2 '_' num2str(run4) '_' num2str(run5)];
        prfx = 'data/';
        
        VarN=[prfx 'Vall' dir3 '_' num2str(run6) '.dat'];
        f1=fopen(VarN);
        yy1=fread(f1,[22, 10000000],'double')';
        fclose(f1);
        
        yy = [yy; yy1(1:end-1,:)];  %Remove last point here, because otherwise 
    end                             %you will repeat the same time point
                                    %twice between consecutive run6 files    
    flg = 0;
    if exist([prfx 'ec1j' dir3 '_' num2str(run6f) mrk '.txt'])
        ec1 = load([prfx 'ec1j' dir3 '_' num2str(run6f) mrk '.txt']);
        ec2 = load([prfx 'ec2j' dir3 '_' num2str(run6f) mrk '.txt']);
        ep = mean([ec1(2,:) ec2(2,:)]);
        ed = mean([ec1(3,:) ec2(3,:)]);
        iei = mean([ec1(4,:) ec2(4,:)]);
        flg = 1; %if episode characteristics files exist then you automatically
    end          %have the option of printing these characteristics in the title
                 %You just have to make showEc = 1 at the top
    
    lnt = length(yy(:,1));
    tt = 0:tint:tint*(lnt-1);

    ipump = ipumpmax./(1.0+exp((termA-yy(:,7))/3.0)).*1.0./(1.0+exp(termB-Ke));
    
    f = figure();
    f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 7.5 9.5];
    
    maxV = max(yy(:,1));
    minV = min(yy(:,2));
    axes('position',[0.15 0.85 0.8 0.1]);
    plot(tt, yy(:,1),'k-','linewidth',1.5);
    hold on;
    xlim([xmin xmax]);
    ylim([-100 50]);
    ylabel('V_1 (mV)','fontname','arial','fontsize',fntsz,'fontweight','bold');
    if flg && showEc
        title(['mean EP = ' num2str(round(ep,2)) ' s, mean ED = ' num2str(round(ed,2)) ' s, IEI = ' ... 
            num2str(round(iei,2)) ' s'],'fontname','arial','fontsize',fntsz,'fontweight','bold');
    elseif showpar %change below to whatever parameter you are sweeping
        title([parname ' = ' num2str(parcan+parstep*(run4-1)) ' ' parunits],'fontname',...
           'arial','fontsize',fntsz,'fontweight','bold');
    end
    box off;
    ax = gca;
    ax.FontName = 'arial';
    ax.FontSize = fntsz;
    ax.FontWeight = 'bold';
    ax.LineWidth = 2.5;
    ax.XTick = [];
    
    axes('position',[0.15 0.72 0.8 0.1]);
    plot(tt, yy(:,11),'k-','linewidth',1.5);
    hold on;
    xlim([xmin xmax]);
    ylim([-100 50]);
    ylabel('V_2 (mV)','fontname','arial','fontsize',fntsz,'fontweight','bold');
    box off;
    ax = gca;
    ax.FontName = 'arial';
    ax.FontSize = fntsz;
    ax.FontWeight = 'bold';
    ax.LineWidth = 2.5;
    ax.XTick = [];
    
    axes('position',[0.15 0.59 0.8 0.1]);
    plot(tt, yy(:,8),'k-','linewidth',1.5);
    hold on;
    xlim([xmin xmax]);
    ylabel('[Na^+]_{i1} (mM)','fontname','arial','fontsize',fntsz,'fontweight','bold');    
    box off;
    ax = gca;
    ax.FontName = 'arial';
    ax.FontSize = fntsz;
    ax.FontWeight = 'bold';
    ax.LineWidth = 2.5;
    ax.XTick = [];
    
    axes('position',[0.15 0.46 0.8 0.1]);
    plot(tt, ipump,'k-','linewidth',1.5);
    hold on;
    xlim([xmin xmax]);
    ylabel('I_{Pump1} (pA)','fontname','arial','fontsize',fntsz,'fontweight','bold');    
    box off;
    ax = gca;
    ax.FontName = 'arial';
    ax.FontSize = fntsz;
    ax.FontWeight = 'bold';
    ax.LineWidth = 2.5;
    ax.XTick = [];
    
    axes('position',[0.15 0.33 0.8 0.1]);
    plot(tt, yy(:,3),'k-','linewidth',1.5);
    hold on;
    xlim([xmin xmax]);
    ylabel('h_{NaP1}','fontname','arial','fontsize',fntsz,'fontweight','bold');         
    box off;
    ax = gca;
    ax.FontName = 'arial';
    ax.FontSize = fntsz;
    ax.FontWeight = 'bold';
    ax.LineWidth = 2.5;
    ax.XTick = [];
    
    axes('position',[0.15 0.2 0.8 0.1]);
    plot(tt, yy(:,7),'k-','linewidth',1.5);
    hold on;
    xlim([xmin xmax]);
    ylabel('h_{CaS1}','fontname','arial','fontsize',fntsz,'fontweight','bold');   
    box off;
    ax = gca;
    ax.FontName = 'arial';
    ax.FontSize = fntsz;
    ax.FontWeight = 'bold';
    ax.LineWidth = 2.5;
    ax.XTick = [];
    
    axes('position',[0.15 0.07 0.8 0.1]);
    plot(tt, yy(:,9),'k-','linewidth',1.5);
    hold on;
    xlim([xmin xmax]);
    ylabel('m_{h1}','fontname','arial','fontsize',fntsz,'fontweight','bold'); 
    xlabel('Time (s)','fontname','arial','fontsize',fntsz,'fontweight','bold');
    box off;
    ax = gca;
    ax.FontName = 'arial';
    ax.FontSize = fntsz;
    ax.FontWeight = 'bold';
    ax.LineWidth = 2.5;
     
    print(f,['ManyVars' dir3 '_' num2str(run6) mrk mrkr '.eps'],'-depsc','-r0');
end
%plotJustV.m
%Jessica Parker, March 14, 2021
%
%This matlab script is used to produce a simple plot of the voltage of both 
%neurons for whatever time range you choose.

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
            %in the title

%use this to write the parameter that is being varied into the title
showpar = 1; %boolean, set to 1 if you want a parameter value in the title
parname = 'g_h'; %Name of parameter to show in the title
parunits = 'nS'; %Units of parameter to show in the title
parcan = 0.365; %set to initial parameter value in sweep
parstep = 0; %set to parameter step size in sweep

xmin = 0; %Set the time range that you want to plot
xmax = 5;
tint = 0.0001; %Time step between data points
fntsz = 12; %Font size
mrk2 = ''; %Use to give a unique label to output figure file name

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
        
        yy = [yy; yy1(1:end-1,:)];   %Remove last point here, because otherwise 
    end                              %you will repeat the same time point
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

    f = figure();
    f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 7 3];
    
    axes('position',[0.15 0.6 0.8 0.3]);
    plot(tt, yy(:,1),'k-','linewidth',1.5);
    hold on;
    xlim([xmin xmax]);
    ylim([-100 50]); 
    ylabel('V_1 (mV)','fontname','arial','fontsize',fntsz,'fontweight','bold');   
    if flg && showEc
        title(['mean EP = ' num2str(round(ep,2)) ' s, ED = ' num2str(round(ed,2)) ' s, IEI = ' ...
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
    
    axes('position',[0.15 0.2 0.8 0.3]);
    plot(tt, yy(:,11),'k-','linewidth',1.5);
    hold on;
    xlim([xmin xmax]);
    ylim([-100 50]);
    ylabel('V_2 (mV)','fontname','arial','fontsize',fntsz,'fontweight','bold');
    xlabel('Time (s)','fontname','arial','fontsize',fntsz,'fontweight','bold');
    box off;
    ax = gca;
    ax.FontName = 'arial';
    ax.FontSize = fntsz;
    ax.FontWeight = 'bold';
    ax.LineWidth = 2.5;
         
    print(f,['justV' dir3 '_' num2str(run6) mrk mrk2 '.eps'],'-depsc','-r0');
end
%runepisodeanalysisAslth.m
%Jessica Parker, March 14, 2021
%
%Matlab script for calculating and saving episode characteristics and burst
%characteristics. Calls to episodeanalysisHCO function for the actual
%measurements. Plots activity with characteristics marked if plt = 1.

clear all;

mrk = '';

run1 = 1;
run2 = 0;
run3 = 0;
run4i = 1; %Used as beginning of for loop to run through all run4 values
run4f = 1; %Used as end of for loop, set to last run4 value
run5 = 0;
run6i = 1; %Used as beggining of for loop
run6f = 10; %Used as end of for loop, set to last run6 value

ibith = 0.1; %Threshold for interburst interval
spth = -10.0; %Spike threshold

xmin = 0.0; %minimum time value plotted if plt = 1 on line 19
            %maximum time is set depending on the type of activity
            %presented
tint = 0.0001; %time step between data points
plt = 1;  %Set to 1 if you want to plot important aspects of episode analysis
          %in order to check that they were calculated correctly. Set to 0
          %if you don't want to make any figures.
bn = 3;  %Number of episodes or bursts that you want to plot if you choose to
         %set plt equal to 1

dir2 = [num2str(run1) '_' num2str(run2) '_' num2str(run3)];
prfx = 'data/';

for run4=run4i:run4f
    
    V1 = [];
    V2 = [];
    for run6 = run6i:run6f %Concatenate all time portions of a simulation
        dir3 = [dir2 '_' num2str(run4) '_' num2str(run5) '_' num2str(run6)];
        
        VarN=[prfx 'Vall' dir3 '.dat'];
        f1=fopen(VarN);
        yy1=fread(f1,[22,10000000],'double')';  %Use 
        %above array is [number of variables saved, any large number
        %greater than the number of data points]
        fclose(f1);
        
        V1 = [V1; yy1(1:end-1,1)];
        V2 = [V2; yy1(1:end-1,11)];
    end
    
    lnt = length(V1);
    tt = 0:tint:tint*(lnt-1);
    
    %measure episode characteristics and burst characteristics
    [ec1 bc1 tspks1] = episodeanalysisHCO(V1,V2,tint,spth,ibith); 
    [ec2 bc2 tspks2] = episodeanalysisHCO(V2,V1,tint,spth,ibith);
    
    %save spikes
    dlmwrite([prfx 'sps1j' dir3 '.txt'],tspks1);
    dlmwrite([prfx 'sps2j' dir3 '.txt'],tspks2);
    
    if length(ec1) > 1 && length(ec2) > 1  %this will be true if the case is episodic
        disp(['Episodic activity at run4 = ' num2str(run4)]);
        
        %save to file episode characteristics of each neuron in each
        %simulation
        dlmwrite([prfx 'ec1j' dir3 mrk '.txt'], ec1);
        dlmwrite([prfx 'ec2j' dir3 mrk '.txt'], ec2);
        
        %save to file burst characteristics of each neuron in each
        %simulation
        dlmwrite([prfx 'bc1j' dir3 mrk '.txt'], bc1);
        dlmwrite([prfx 'bc2j' dir3 mrk '.txt'], bc2);
               
        %collect means, medians, and standard deviations of episode characteristics
        ecmns(1,run4-run4i+1) = mean([ec1(2,:) ec2(2,:)]); %EP
        ecmns(2,run4-run4i+1) = mean([ec1(3,:) ec2(3,:)]); %ED
        ecmns(3,run4-run4i+1) = mean([ec1(4,:) ec2(4,:)]); %IEI
        ecmns(4,run4-run4i+1) = mean([ec1(5,:) ec2(5,:)]); %BpE
        ecmdns(1,run4-run4i+1) = median([ec1(2,:) ec2(2,:)]);
        ecmdns(2,run4-run4i+1) = median([ec1(3,:) ec2(3,:)]);
        ecmdns(3,run4-run4i+1) = median([ec1(4,:) ec2(4,:)]);
        ecmdns(4,run4-run4i+1) = median([ec1(5,:) ec2(5,:)]);
        ecstds(1,run4-run4i+1) = std([ec1(2,:) ec2(2,:)]);
        ecstds(2,run4-run4i+1) = std([ec1(3,:) ec2(3,:)]);
        ecstds(3,run4-run4i+1) = std([ec1(4,:) ec2(4,:)]);
        ecstds(4,run4-run4i+1) = std([ec1(5,:) ec2(5,:)]);
        
        %find the burst index of the interburst interval corresponding to 
        %the interepisode intervals
        iei1 = find(bc1(4,:)>0.5*mean([ec1(4,:) ec2(4,:)]));
        iei2 = find(bc2(4,:)>0.5*mean([ec1(4,:) ec2(4,:)]));
        
        %bcmns contains mean characteristics of the last burst in each
        %episode
        bcmns(1,run4-run4i+1) = mean([bc2(2,iei2(2:end-1)-1) bc1(2,iei1(2:end-1)-1)]); %BP
        bcmns(2,run4-run4i+1) = mean([bc2(3,iei2(2:end-1)-1) bc1(3,iei1(2:end-1)-1)]); %BD
        bcmns(3,run4-run4i+1) = mean([bc2(4,iei2(2:end-1)-1) bc1(4,iei1(2:end-1)-1)]); %IBI
        bcstds(1,run4-run4i+1) = std([bc2(2,iei2(2:end-1)-1) bc1(2,iei1(2:end-1)-1)]);
        bcstds(2,run4-run4i+1) = std([bc2(3,iei2(2:end-1)-1) bc1(3,iei1(2:end-1)-1)]);
        bcstds(3,run4-run4i+1) = std([bc2(4,iei2(2:end-1)-1) bc1(4,iei1(2:end-1)-1)]);
        
        bp1 = mean([bc2(2,iei2(2:end-1)+1) bc1(2,iei1(2:end-1)+1)]);
        bp2 = mean([bc2(2,iei2(2:end-1)+2) bc1(2,iei1(2:end-1)+2)]);
        bpl = mean([bc2(2,iei2(2:end-1)-1) bc1(2,iei1(2:end-1)-1)]);
        
        if plt
            if xmin+(bn+0.5)*ecmns(1,run4-run4i+1) < tt(end)
                xmax = xmin+(bn+0.5)*ecmns(1,run4-run4i+1);
            else
                xmax = tt(end);
            end
            
            f = figure();
            f.PaperPositionMode = 'auto';
            f.PaperUnits = 'inches';
            f.PaperPosition = [0 0 7 3];
            
            axes('position',[0.15 0.55 0.8 0.3]);
            plot(tt,V1,'k','linewidth',1.5);
            hold on;
            plot(tspks1,V1(round(tspks1./tint+1)),'r.','markersize',5);  %red dots mark spikes
            plot(ec1(1,:),spth*ones(1,length(ec1(1,:))),'gx','markersize',10); %green x's mark beginning
            plot(ec1(1,:)+ec1(3,:),spth*ones(1,length(ec1(1,:))),'gx','markersize',10); %and end of episodes
            plot(bc1(1,:),-20*ones(1,length(bc1(1,:))),'mx','markersize',10); %magenta x's mark beginning and
            plot(bc1(1,:)+bc1(3,:),-20*ones(1,length(bc1(1,:))),'mx','markersize',10); %end of burst durations
            title(['mean EP = ' num2str(ecmns(1,run4-run4i+1)) ' s, ED = ' num2str(ecmns(2,run4-run4i+1)) ...
                ' s, IEI = ' num2str(ecmns(3,run4-run4i+1)) ' s']);
            ylim([-100 50]);
            xlim([xmin xmax]);
            ylabel('V_1 (mV)');
            
            axes('position',[0.15 0.15 0.8 0.3]);
            plot(tt,V2,'k','linewidth',1.5);
            hold on;
            plot(tspks2,V2(round(tspks2./tint+1)),'r.','markersize',5);
            plot(ec2(1,:),spth*ones(1,length(ec2(1,:))),'gx','markersize',10);
            plot(ec2(1,:)+ec2(3,:),spth*ones(1,length(ec2(1,:))),'gx','markersize',10);
            plot(bc2(1,:),-20*ones(1,length(bc2(1,:))),'mx','markersize',10);
            plot(bc2(1,:)+bc2(3,:),-20*ones(1,length(bc2(1,:))),'mx','markersize',10);
            ylim([-100 50]);
            xlim([xmin xmax]);
            ylabel('V_2 (mV)');
            
            print(f,['chckEc' dir3 'brst' num2str(bn) mrk '.png'],'-dpng','-r0');
            %                 close(f);
        end
        
    elseif length(bc1) > 1 && length(bc2) > 1 %true if case is continuous bursting
        disp(['Bursting but no episodic activity at run4 = ' num2str(run4)]);        
        xmax = xmin+10*mean(bc1(2,:));
        
        dlmwrite([prfx 'bc1j' dir3 mrk '.txt'], bc1);
        dlmwrite([prfx 'bc2j' dir3 mrk '.txt'], bc2);
        
        %If there are no episodes, then bcmns contains average burst
        %characteristics.
        bcmns(1,run4-run4i+1) = mean([bc1(2,:) bc2(2,:)]); %BP
        bcmns(2,run4-run4i+1) = mean([bc1(3,:) bc2(3,:)]); %BD
        bcmns(3,run4-run4i+1) = mean([bc1(4,:) bc2(4,:)]); %IBI
        bcstds(1,run4-run4i+1) = std([bc1(2,:) bc2(2,:)]);
        bcstds(2,run4-run4i+1) = std([bc1(3,:) bc2(3,:)]);
        bcstds(3,run4-run4i+1) = std([bc1(4,:) bc2(4,:)]);
        
        if plt
            if xmin+(bn+0.5)*bcmns(1,run4-run4i+1) < tt(end)
                xmax = xmin+(bn+0.5)*bcmns(1,run4-run4i+1);
            else
                xmax = tt(end);
            end
                
            f = figure();
            f.PaperPositionMode = 'auto';
            f.PaperUnits = 'inches';
            f.PaperPosition = [0 0 7 3];
            
            %red dots mark spikes, and cyan x's mark beginnings and ends of
            %burst durations
            axes('position',[0.15 0.55 0.8 0.3]);
            plot(tt,V1,'k','linewidth',1.5);
            hold on;
            plot(tspks1,V1(round(tspks1./tint+1)),'r.','markersize',5);
            plot(bc1(1,:),-20*ones(1,length(bc1(1,:))),'cx','markersize',10);
            plot(bc1(1,:)+bc1(3,:),-20*ones(1,length(bc1(1,:))),'cx','markersize',10);
            title(['mean BP = ' num2str(bcmns(1,run4-run4i+1)) ' s, BD = ' num2str(bcmns(2,run4-run4i+1)) ...
                    ' s, IBI = ' num2str(bcmns(3,run4-run4i+1)) ' s']);
            ylim([-100 50]);
            xlim([xmin xmax]);
            ylabel('V_1 (mV)');
            
            axes('position',[0.15 0.15 0.8 0.3]);
            plot(tt,V2,'k','linewidth',1.5);
            hold on;
            plot(tspks2,V2(round(tspks2./tint+1)),'r.','markersize',5);
            plot(bc2(1,:),-20*ones(1,length(bc2(1,:))),'cx','markersize',10);
            plot(bc2(1,:)+bc2(3,:),-20*ones(1,length(bc2(1,:))),'cx','markersize',10);
            ylim([-100 50]);
            xlim([xmin xmax]);
            ylabel('V_2 (mV)');
            
            print(f,['chckEc' dir3 '.png'],'-dpng','-r0');
%             close(f);
        end
        
    elseif length(tspks1) > 1  %true if case is tonic spiking
        disp(['Spiking but no bursting at run4 = ' num2str(run4)]);
        
        if plt
            if xmin+tspks1(2*bn) < tt(end)
                xmax = xmin+tspks1(2*bn);
            else
                xmax = tt(end);
            end
            
            f = figure();
            f.PaperPositionMode = 'auto';
            f.PaperUnits = 'inches';
            f.PaperPosition = [0 0 7 3];
            
            axes('position',[0.15 0.15 0.8 0.8]);
            plot(tt,V1,'k','linewidth',1.5);
            hold on;
            plot(tspks1,V1(round(tspks1./tint+1)),'r.','markersize',5);
            ylim([-100 50]);
            xlim([xmin xmax]);
            ylabel('V_1 (mV)');
            
            axes('position',[0.15 0.15 0.8 0.8]);
            plot(tt,V2,'k','linewidth',1.5);
            hold on;
            plot(tspks2,V2(round(tspks2./tint+1)),'r.','markersize',5);
            ylim([-100 50]);
            xlim([xmin xmax]);
            ylabel('V_2 (mV)');
            
            print(f,['chckEc' dir3 '.png'],'-dpng','-r0');
%             close(f);
        end
        
    else %true if case is silent
        disp(['Silence at run4 = ' num2str(run4)]);
    end
end

if exist('ecmns')
    dlmwrite([prfx 'ecmn' dir2 mrk '.txt'], ecmns);
    dlmwrite([prfx 'ecmdn' dir2 mrk '.txt'], ecmdns);
    dlmwrite([prfx 'ecstd' dir2 mrk '.txt'], ecstds);
end

%note that bcmns mean different things depending on whether the case is 
%episodic or continuous. If it is episodic, then bcmns contains the mean
%characteristics of the last burst in each episode.
if exist('bcmns') 
    dlmwrite([prfx 'bcmn' dir2 mrk '.txt'], bcmns);
    dlmwrite([prfx 'bcstd' dir2 mrk '.txt'], bcstds);
end
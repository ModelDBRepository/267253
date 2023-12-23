%episodeanalysis.m
%Jessica Parker, March 14, 2021
%
%Function performs episode analysis and burst analysis, but this function
%is specifically for alternating bursting in HCOs. episodeanalysisSC.m is for
%bursting in a single cell. This is the analysis I am using for the Whelan paper.

function [ec bc tpks] = episodeanalysisAslth(V,V2,tint,spth,ibith)

lnt = length(V);
tt = 0:tint:tint*(lnt-1);

sps = find(V>spth); %find indexes of voltages greater than spike threshold

if length(sps)>1
    [Vpks pks] = findpeaks(V(sps)); %find indexes of sps corresponding to peaks of spikes
    tpks = [];
    tpks = tt(sps(pks)); %find times of the peaks of spikes
    ipks = sps(pks); %find indexes of times of the peaks of spikes
    isi = tpks(2:end)-tpks(1:end-1); %interspike intervals (ISI)
    
    if std(isi)/mean(isi) > 0.05   %if CoV of ISI is bigger than 0.05, look
        bb = 1;                    %for bursting
        for aa=1:length(ipks)-1 %running through all ISIs
            %if ISI is bigger than IBI threshold, and minV during ISI < -50
            %mV, and (during ISI spikes occur in other neuron or ISI is as big as IEI) 
            if tpks(aa+1)-tpks(aa) > ibith && min(V(ipks(aa):ipks(aa+1)))<-50.0 
                if max(V2(ipks(aa):ipks(aa+1)))>10.0 || tpks(aa+1)-tpks(aa) > 10*ibith
                    tbb(bb) = tpks(aa+1); %then time of burst beggining is the time  
                                          %of the spike at the end of ISI
                    if bb>1                   %end of previous burst duration is the
                        teb(bb-1) = tpks(aa); %the time of the spike at the                                           
                    end                       %beginning of the ISI   
                    bb = bb+1; %counts number of bursts
                end
            end
        end
        
        bp = tbb(2:end)-tbb(1:end-1); %burst period
        tbb(end) = []; %take out last time of burst beginning due to no IBI
        bd = teb-tbb; %burst duration
        ibi = bp-bd; %interburst interval
        
        bc = [tbb; bp; bd; ibi]; %will become bc1 or bc2
        
        nieis = find(ibi>1.2*mean(ibi)); %Find IBIs that may be IEIs
        if std(ibi)/mean(ibi) > 0.05 && length(nieis) > 2 %if CoV of IBI > 0.05
                                                          %and more than 2 possible IEIs
            cc = 1;                                       %then case may be episodic.
            for aa=1:length(tbb)-1 %run through every IBI
                if ibi(aa) > 1.2*mean(ibi) %if IBI is greater than 120% of mean IBI
                    tbe(cc) = tbb(aa+1); %time of episode beginning is end of IBI
                    if cc>1
                        tee(cc-1) = teb(aa); %end of previous burst duration 
                                             %is beginning of IBI
                        bpe(cc-1) = aa-nblast; %bursts per episode
                    end
                    nblast = aa; %used to measure bursts per episode
                    cc = cc+1; %counts number of episodes
                end
            end
            
            ep = tbe(2:end)-tbe(1:end-1); %episode period
            tbe(end) = []; %remove last time of episode beginning
            ed = tee-tbe; %episode duration
            iei = ep-ed; %interepisode interval
            
            ec = [tbe; ep; ed; iei; bpe]; %becomes ec1 or ec2
        else %if CoV of IBI <= 0.05 or not at least 2 possible episodes
            ec = [];
        end
    else %if CoV of ISI <= 0.05 but length of sps is at least 2, then spiking occurs
        bc = [];
        ec = [];
    end
else %silence
    bc = [];
    ec = [];
    tpks = [];
end

end
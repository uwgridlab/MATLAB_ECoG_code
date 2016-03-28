ddc={'outbound','inbound'};
sc=1;
for s=1:4
    for dc=1:2
        subj=sprintf('S%i',s+1);
        direction=ddc{dc};
        
        [data,clist,control,fs,tr]=get_subject_data(subj,5,.5,300,4);
        data=cheby_filter_notch(data,58,62,fs,4);
        data=cheby_filter_notch(data,118,122,fs,4);
        data=cheby_filter_notch(data,178,182,fs,4);
        
        elsewhere=1:size(data,2);
        elsewhere(clist)=[];
        
        fwa=3:30;
        fwb=40:170;
        if s==1 && dc==1
            map_out=zeros(length(fwb),length(fwa),size(data,2)*4);
            map_in=map_out;
        end
        
        
        data=resample(data,1,2);
        fs=fs/2;
        map=zeros(length(fwb),length(fwa),size(data,2));
        
        tic
        for i=1:size(data,2)
            switch dc
                case 1
                    pac=compute_pac_amp(data(:,control),data(:,i),fwa,fwb,fs,'norm');
                    map_out(:,:,i+sc-1)=pac;
                case 2
                    pac=compute_pac_amp(data(:,i),data(:,control),fwa,fwb,fs,'norm');
                    map_in(:,:,i+sc-1)=pac;
            end
            map(:,:,i)=pac;
        end
        save(fullfile(subj,sprintf('results_pac_norm%s.mat',direction)),'fs','map','fwa','fwb');
        t2=toc;
        fprintf('took %4.0f seconds\n',t2);
    end
    sc=sc+size(data,2);
end
save all_4subjects_pac_map_norm map_in map_out fwa fwb
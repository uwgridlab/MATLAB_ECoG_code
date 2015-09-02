clear ds;

%
% original targets used in first analyses done by tim
%   jc_mot
%   hh_mot
%   4568f4_mot
%   26cb98_im
%   30052b_im
%   mg_im
%   jt2_mot
%   04b3d5_im
%   fc9643_mot
%   38e116_mot ? not included in spreadsheet
% new
%  8381b8_mot

if (~exist('target', 'var'))
    target = '8381b8_mot';
end

switch (target)
    case '8381b8_mot'
        ds.subjId = '8381b8';
        ds.task = 'rjb';
        ds.code = 'ud';
        ds.controlType = 'mot';
        ds.motorTarget = 't';
        runs = { ...
                %'d5' '01'; ... excluded for different montage
                %'d5' '02'; ... excluded for different montage
                'd5' '03'; ...
                'd5' '04'; ...
                'd5' '05'; ...
                'd5' '06'; ...
                'd5' '07'; ...
                'd6' '01'; ...
                'd6' '02'; ...
                'd6' '03'; ...
                'd7' '01'; ...
                'd7' '02'; ...
                'd7' '03'; ...
                };
    case 'fc9643_mot'
        ds.subjId = 'fc9643';
        %ds.electrodes = 1:64;
        ds.task = 'rjb';
        ds.code = 'ud';
        ds.controlType = 'mot';
        ds.motorTarget = 't';
        runs = { 'd2' '01'; ... % removed for wrong control channel
                 'd2' '02'; ...
                 'd2' '03'; ...
                 'd3' '01'; ...
                 'd3' '02'; ...
                 'd4' '01'; ...
               };
    case 'fc9643_im'
        ds.subjId = 'fc9643';
        %ds.electrodes = 1:64;
        ds.task = 'rjb';
        ds.code = 'ud';
        ds.controlType = 'im';
        ds.motorTarget = 't';
        runs = { 'd2' '03'; ...
                 'd3' '02'; ...
                 'd3' '03'; ...
                 'd3' '04'; ...
                 'd3' '05'; ...
                 'd4' '01'; ...
               };
    case 'hh_mot'
        ds.subjId = 'hh';
        %ds.electrodes = 1:64;
        ds.task = 'ud';
        ds.code = 'ud';
        ds.controlType = 'mot';
        ds.motorTarget = 'tongue';
        files = {
            [myGetenv('subject_dir') 'hh\hh_d1_s3\hh_ud_mot_tongue001\'] 'hh_ud_mot_tongueS001R04.dat';...
            [myGetenv('subject_dir') 'hh\hh_d1_s3\hh_ud_mot_tongue001\'] 'hh_ud_mot_tongueS001R05.dat';...
            [myGetenv('subject_dir') 'hh\hh_d2_s1\hh_ud_mot_tongue001\'] 'hh_ud_mot_tongueS001R01.dat';...
            [myGetenv('subject_dir') 'hh\hh_d3_s3\hh_ud_mot_tongue001\'] 'hh_ud_mot_tongueS001R01.dat';...
            [myGetenv('subject_dir') 'hh\hh_d4_s1\hh_ud_mot_tongue001\'] 'hh_ud_mot_tongueS001R01.dat';...
            [myGetenv('subject_dir') 'hh\hh_d5_s1\hh_ud_mot_tongue001\'] 'hh_ud_mot_tongueS001R01.dat'
        };
        ds.controlChannel = 43;
        ds.controlRange = 80:98;            
    case 'hh_im'
        ds.subjId = 'hh';
        %ds.electrodes = 1:64;
        ds.task = 'ud';
        ds.code = 'ud';
        ds.controlType = 'im';
        ds.motorTarget = 'tongue';
        runs = { 'd1' '01'; ...
                 'd1' '02'; ...
                 'd1' '03'; ...
                 'd2' '01'; ...
                 'd2' '02'; ...
                 'd3' '01'; ...
                 'd3' '02'; ...
                 'd3' '03'; ...
                 'd4' '01'; ...
                 'd4' '02'; ...
                 'd4' '03'; ...
                 'd4' '04'; ...
                 'd4' '05'; ...
                 'd5' '01'; ...
                 'd5' '02'; ...
                 'd5' '03'; ...
                 'd5' '04'; ...
               };           
        ds.controlChannel = 43;
        ds.controlRange = 80:98;           
    case '4568f4_im'
        ds.subjId = '4568f4';
        %ds.electrodes = 1:64;
        ds.task = 'rjb';
        ds.code = 'ud';
        ds.controlType = 'im';
        ds.motorTarget = 't';
        runs = { 'd1' '02'; ...
                 'd1' '03'; ...
                 'd1' '06'; ...
                 'd1' '07'; ...
                 'd2' '01'; ...
                 'd2' '02'; ...
               };
    case '4568f4_mot'
        ds.subjId = '4568f4';
        %ds.electrodes = 1:64;
        ds.task = 'rjb';
        ds.code = 'ud';
        ds.controlType = 'mot';
        ds.motorTarget = 't';
        runs = { 'd1' '01'; ...
                 'd1' '04'; ...
                 'd1' '05'; ...
                 'd2' '01'; ...
                 'd2' '02'; ...
                 'd2' '03'; ...
               };
    case '4568f4_eyebrows'
        ds.subjId = '4568f4';
        %ds.electrodes = 1:64;
        ds.task = 'rjb';
        ds.code = 'ud';
        ds.controlType = 'mot';
        ds.motorTarget = 'eyebrows';
        runs = { 'd2' '01'; ...
                 'd2' '02'; ...
                 'd2' '03'; ...
                 'd2' '04'; ...
                 'd2' '05'; ...
                 'd2' '06'; ...
                 'd2' '07'; ...
               };
    case 'jc_mot'
        ds.subjId = 'jc';
        %ds.electrodes = 1:64;
        ds.task = 'ud';
        ds.code = 'ud';
        ds.controlType = 'mot';
        ds.motorTarget = 'tongue'; % need to rename recording files
        files = {
            [myGetenv('subject_dir') 'jc\D1_S2\UpDown_Tongue_2\'] 'jc_ud_tongue-bS001R01.dat';...
            [myGetenv('subject_dir') 'jc\D1_S2\UpDown_Tongue_2\'] 'jc_ud_tongue-bS001R02.dat';...
            [myGetenv('subject_dir') 'jc\D1_S2\UpDown_Tongue_2\'] 'jc_ud_tongue-bS001R03.dat';...
            [myGetenv('subject_dir') 'jc\D1_S2\UpDown_Tongue_3\'] 'jc_ud_tongue-cS001R01.dat';...
            [myGetenv('subject_dir') 'jc\D2\jc_ud_tongue-d001\'] 'jc_ud_tongue-dS001R01.dat';...
        };
        ds.controlChannel = 13;
        ds.controlRange = 80:98;
    case 'jt2_mot'
        ds.subjId = 'jt2';
        %ds.electrodes = 1:64;
        ds.task = 'ud';
        ds.code = 'ud';
        ds.controlType = 'mot';
        ds.motorTarget = 'tongue'; % need to rename recording files
            files = {
                [myGetenv('subject_dir') 'jt2\jt2_day3_s3\jt2_ud_tongue-a001'] 'jt2_ud_tongue-aS001R01.dat';...
                [myGetenv('subject_dir') 'jt2\jt2_day3_s3\jt2_ud_tongue-a001'] 'jt2_ud_tongue-aS001R02.dat';...
                [myGetenv('subject_dir') 'jt2\jt2_day3_s3\jt2_ud_tongue-a001'] 'jt2_ud_tongue-aS001R03.dat';...
                [myGetenv('subject_dir') 'jt2\jt2_day3_s3\jt2_ud_tongue-d001'] 'jt2_ud_tongue-dS001R01.dat';...
                };

        ds.controlChannel = 64;
        ds.controlRange = 80:86; 
    case '38e116_mot'
        ds.subjId = '38e116';
        %ds.electrodes = 1:64;
        ds.task = 'rjb';
        ds.code = 'ud';
        ds.controlType = 'mot';
        ds.motorTarget = 'h';
        runs = { 'd1' '01'; ...
                 'd1' '03'; ...
                 'd2' '02'; ...
               };
    case '38e116_im'
        ds.subjId = '38e116';
        %ds.electrodes = 1:64;
        ds.task = 'rjb';
        ds.code = 'ud';
        ds.controlType = 'im';
        ds.motorTarget = 'h';
        runs = { 'd1' '02'; ...
                 'd1' '03'; ...
                 'd1' '04'; ...
               };
    case '30052b_mot'
        ds.subjId = '30052b';
        %ds.electrodes = 1:64;
        ds.task = 'rjb';
        ds.code = 'ud';
        ds.controlType = 'mot';
        ds.motorTarget = 't';
        runs = { 'd1' '02'; ...
                 'd1' '03'; ...
                 'd1' '04'; ...
                 'd1' '05'; ...
                 'd2' '01'; ...
                 'd2' '02'; ...
               };
    case '30052b_im'
        ds.subjId = '30052b';
        %ds.electrodes = 1:64;
        ds.task = 'rjb';
        ds.code = 'ud';
        ds.controlType = 'im';
        ds.motorTarget = 't';
        runs = { 'd1' '02'; ...
                 'd1' '03'; ...
                 'd2' '01'; ...
                 'd2' '03'; ...
                 'd3' '01'; ... % had to remove first 4 recordings b/c of non constant control channels
                 'd3' '02'; ...
                 'd3' '04'; ...
                 'd3' '05'; ...
                 'd3' '06'; ...
                 'd3' '07'; ...
                 'd4' '01'; ...
               };
    case '26cb98_im'
        ds.subjId = '26cb98';
        %ds.electrodes = 1:64;
        ds.task = 'rjb';
        ds.code = 'ud';
        ds.controlType = 'im';
        ds.motorTarget = 't';
        runs = { 'd2' '01'; ...
                 'd2' '02'; ...
                 'd2' '03'; ...
                 'd2s2' '03'; ...
                 'd2s2' '04'; ...
               };
    case 'mg_im'
        ds.subjId = 'mg';
        %ds.electrodes = 1:64;
        ds.task = 'rjb';
        ds.code = 'ud';
        ds.controlType = 'im';
        ds.motorTarget = 't';
        runs = { 'day2' '01'; ...
                 'day2' '02'; ...
                 'day2' '03'; ...
                 'day2' '04'; ...
                 'day2' '05'; ...
                 'day2' '06'; ...
               };
    case '04b3d5_mot'
        ds.subjId = '04b3d5';
        %ds.electrodes = 1:64;
        ds.task = 'rjb';
        ds.code = 'ud';
        ds.controlType = 'mot';
        ds.motorTarget = 't';
        runs = { 'd5' '01'; ...
                 'd5' '02'; ...
                 'd6' '01'; ...
                 'd6' '02'; ...
               };
    case '04b3d5_im'
        ds.subjId = '04b3d5';
        %ds.electrodes = 1:64;
        ds.task = 'rjb';
        ds.code = 'ud';
        ds.controlType = 'im';
        ds.motorTarget = 't';
        runs = { 'd5' '01'; ...
                 'd5' '02'; ...
                 'd6' '01'; ...
                 'd6' '02'; ...
                 'd7' '01'; ...
               };
    otherwise
        clear ds;
        error ('unknown target %s', target);
end

ds.surf.dir = [myGetenv('subject_dir') '\' ds.subjId '\surf'];
ds.surf.file  = [ds.subjId '_cortex.mat'];

ds.trodes.dir = [myGetenv('subject_dir') '\' ds.subjId];
ds.trodes.file  = 'trodes.mat';

ds.exp = [ds.subjId '_' ds.code '_' ds.controlType '_' ds.motorTarget];

filename = [ds.exp '_ds'];
   
if (exist('runs','var'))
    for c = 1:size(runs, 1)
        ds.recs(c).dir = [myGetenv('subject_dir') '\' ds.subjId '\' runs{c, 1} '\' ds.exp '001'];
        ds.recs(c).file = [ds.exp 'S001R' runs{c, 2} '.dat'];
        ds.recs(c).montage = [ds.exp 'S001R' runs{c, 2} '_montage.mat'];
        %ds.recs(c).electrodes = ds.electrodes; % assume all recs per pt use
        %same montage
    end
else
    for c = 1:size(files, 1)
        ds.recs(c).dir = files{c, 1};
        ds.recs(c).file = files{c, 2};
        ds.recs(c).montage = strrep(files{c, 2}, '.dat', '_montage.mat');
    end
end

save(filename, 'ds');

clear subjId c filename;
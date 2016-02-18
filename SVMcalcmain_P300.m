function [ProbP300_2cls, ProbP300_4cls] = SVMcalcmain_P300(directory_Training, directory_Trial)

% === % === T r a i n i n g % === % ===
%Feature generation by signal file
[Signal_Target1, Sampling_Hz] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-SBE_Target1*.csv')]));
[Signal_Target2] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-SBE_Target2*.csv')]));
[Signal_Target3] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-SBE_Target3*.csv')]));
[Signal_Target4] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-SBE_Target4*.csv')]));
[Signal_NonTarget1] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-SBE_NonTarget1*.csv')]));
[Signal_NonTarget2] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-SBE_NonTarget2*.csv')]));
[Signal_NonTarget3] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-SBE_NonTarget3*.csv')]));
[Signal_NonTarget4] = fileProcessor_dir(directory_Training, dir(['./', directory_Training, horzcat('/[5] P300-SBE_NonTarget4*.csv')]));

%BandPass filtering
[Signal_Target1_Filtered, Signal_NonTarget1_Filtered] = BPFilter(Signal_Target1, Signal_NonTarget1, [1:8]);
[Signal_Target2_Filtered, Signal_NonTarget2_Filtered] = BPFilter(Signal_Target2, Signal_NonTarget2, [1:8]);
[Signal_Target3_Filtered, Signal_NonTarget3_Filtered] = BPFilter(Signal_Target3, Signal_NonTarget3, [1:8]);
[Signal_Target4_Filtered, Signal_NonTarget4_Filtered] = BPFilter(Signal_Target4, Signal_NonTarget4, [1:8]);

%Stimulation Based Epoching
[SBESignal_Target1_Filtered] = StimulationBasedEpoching(Signal_Target1_Filtered, 256, 0.4, 0.1, 0.2);
[SBESignal_Target2_Filtered] = StimulationBasedEpoching(Signal_Target2_Filtered, 256, 0.4, 0.1, 0.2);
[SBESignal_Target3_Filtered] = StimulationBasedEpoching(Signal_Target3_Filtered, 256, 0.4, 0.1, 0.2);
[SBESignal_Target4_Filtered] = StimulationBasedEpoching(Signal_Target4_Filtered, 256, 0.4, 0.1, 0.2);
[SBESignal_NonTarget1_Filtered] = StimulationBasedEpoching(Signal_NonTarget1_Filtered, 256, 0.4, 0.1, 0.2);
[SBESignal_NonTarget2_Filtered] = StimulationBasedEpoching(Signal_NonTarget2_Filtered, 256, 0.4, 0.1, 0.2);
[SBESignal_NonTarget3_Filtered] = StimulationBasedEpoching(Signal_NonTarget3_Filtered, 256, 0.4, 0.1, 0.2);
[SBESignal_NonTarget4_Filtered] = StimulationBasedEpoching(Signal_NonTarget4_Filtered, 256, 0.4, 0.1, 0.2);

%Downsampling
[SBESignal_Target1_Filtered_DS64Hz, SBESignal_NonTarget1_Filtered_DS64Hz, Duration_points_64Hz] = ...
    DownSampling(SBESignal_Target1_Filtered, SBESignal_NonTarget1_Filtered, [1:8], floor(Sampling_Hz * 0.2));
[SBESignal_Target2_Filtered_DS64Hz, SBESignal_NonTarget2_Filtered_DS64Hz, Duration_points_64Hz] = ...
    DownSampling(SBESignal_Target2_Filtered, SBESignal_NonTarget2_Filtered, [1:8], floor(Sampling_Hz * 0.2));
[SBESignal_Target3_Filtered_DS64Hz, SBESignal_NonTarget3_Filtered_DS64Hz, Duration_points_64Hz] = ...
    DownSampling(SBESignal_Target3_Filtered, SBESignal_NonTarget3_Filtered, [1:8], floor(Sampling_Hz * 0.2));
[SBESignal_Target4_Filtered_DS64Hz, SBESignal_NonTarget4_Filtered_DS64Hz, Duration_points_64Hz] = ...
    DownSampling(SBESignal_Target4_Filtered, SBESignal_NonTarget4_Filtered, [1:8], floor(Sampling_Hz * 0.2));

%Epoch Averaging
[SBESignal_Target1_Filtered_DS64Hz_Epoc10] = EpochAverage(SBESignal_Target1_Filtered_DS64Hz, Duration_points_64Hz, 5);
[SBESignal_Target2_Filtered_DS64Hz_Epoc10] = EpochAverage(SBESignal_Target2_Filtered_DS64Hz, Duration_points_64Hz, 5);
[SBESignal_Target3_Filtered_DS64Hz_Epoc10] = EpochAverage(SBESignal_Target3_Filtered_DS64Hz, Duration_points_64Hz, 5);
[SBESignal_Target4_Filtered_DS64Hz_Epoc10] = EpochAverage(SBESignal_Target4_Filtered_DS64Hz, Duration_points_64Hz, 5);
[SBESignal_NonTarget1_Filtered_DS64Hz_Epoc10] = EpochAverage(SBESignal_NonTarget1_Filtered_DS64Hz, Duration_points_64Hz, 5);
[SBESignal_NonTarget2_Filtered_DS64Hz_Epoc10] = EpochAverage(SBESignal_NonTarget2_Filtered_DS64Hz, Duration_points_64Hz, 5);
[SBESignal_NonTarget3_Filtered_DS64Hz_Epoc10] = EpochAverage(SBESignal_NonTarget3_Filtered_DS64Hz, Duration_points_64Hz, 5);
[SBESignal_NonTarget4_Filtered_DS64Hz_Epoc10] = EpochAverage(SBESignal_NonTarget4_Filtered_DS64Hz, Duration_points_64Hz, 5);

%Feature aggregate
[Target1] = FeatureAggregator(SBESignal_Target1_Filtered_DS64Hz_Epoc10, 64, [1 5 6], 0.2); %0.2=EPOClength
[Target2] = FeatureAggregator(SBESignal_Target2_Filtered_DS64Hz_Epoc10, 64, [1 5 6], 0.2); %0.2=EPOClength
[Target3] = FeatureAggregator(SBESignal_Target3_Filtered_DS64Hz_Epoc10, 64, [1 5 6], 0.2); %0.2=EPOClength
[Target4] = FeatureAggregator(SBESignal_Target4_Filtered_DS64Hz_Epoc10, 64, [1 5 6], 0.2); %0.2=EPOClength
[NonTarget1] = FeatureAggregator(SBESignal_NonTarget1_Filtered_DS64Hz_Epoc10, 64, [1 5 6], 0.2); %0.2=EPOClength
[NonTarget2] = FeatureAggregator(SBESignal_NonTarget2_Filtered_DS64Hz_Epoc10, 64, [1 5 6], 0.2); %0.2=EPOClength
[NonTarget3] = FeatureAggregator(SBESignal_NonTarget3_Filtered_DS64Hz_Epoc10, 64, [1 5 6], 0.2); %0.2=EPOClength
[NonTarget4] = FeatureAggregator(SBESignal_NonTarget4_Filtered_DS64Hz_Epoc10, 64, [1 5 6], 0.2); %0.2=EPOClength

% === % === T r i a l % === % ===

%Feature generation by signal file
[Signal_Label1] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-trialSignal_Label1(0.1-0.3)*.csv')]));
[Signal_Label2] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-trialSignal_Label2(0.1-0.3)*.csv')]));
[Signal_Label3] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-trialSignal_Label3(0.1-0.3)*.csv')]));
[Signal_Label4] = fileProcessor_dir(directory_Trial, dir(['./', directory_Trial, horzcat('/[6] P300-trialSignal_Label4(0.1-0.3)*.csv')]));

%BandPass filtering
[Signal_Label1_Filtered, Signal_Label2_Filtered] = BPFilter(Signal_Label1, Signal_Label2, [1:8]);
[Signal_Label3_Filtered, Signal_Label4_Filtered] = BPFilter(Signal_Label3, Signal_Label4, [1:8]);

%Downsampling
[Signal_Label1_Filtered_DS64Hz, Signal_Label2_Filtered_DS64Hz, Duration_points_64Hz] = ...
    DownSampling(Signal_Label1_Filtered, Signal_Label2_Filtered, [1:8], floor(Sampling_Hz * 0.2));
[Signal_Label3_Filtered_DS64Hz, Signal_Label4_Filtered_DS64Hz, Duration_points_64Hz] = ...
    DownSampling(Signal_Label3_Filtered, Signal_Label4_Filtered, [1:8], floor(Sampling_Hz * 0.2));

%Epoch Averaging
[Signal_Label1_Filtered_DS64Hz_Epoc5] = EpochAverage(Signal_Label1_Filtered_DS64Hz, Duration_points_64Hz, 5);
[Signal_Label2_Filtered_DS64Hz_Epoc5] = EpochAverage(Signal_Label2_Filtered_DS64Hz, Duration_points_64Hz, 5);
[Signal_Label3_Filtered_DS64Hz_Epoc5] = EpochAverage(Signal_Label3_Filtered_DS64Hz, Duration_points_64Hz, 5);
[Signal_Label4_Filtered_DS64Hz_Epoc5] = EpochAverage(Signal_Label4_Filtered_DS64Hz, Duration_points_64Hz, 5);

%Exploit feature
[Label1] = FeatureAggregator(Signal_Label1_Filtered_DS64Hz_Epoc5, 64, [1 5 6], 0.2); %EPOClength, Offset, Duration
[Label2] = FeatureAggregator(Signal_Label2_Filtered_DS64Hz_Epoc5, 64, [1 5 6], 0.2); %EPOClength, Offset, Duration
[Label3] = FeatureAggregator(Signal_Label3_Filtered_DS64Hz_Epoc5, 64, [1 5 6], 0.2); %EPOClength, Offset, Duration
[Label4] = FeatureAggregator(Signal_Label4_Filtered_DS64Hz_Epoc5, 64, [1 5 6], 0.2); %EPOClength, Offset, Duration

% === % === C a l c u l a t i o n % === % ===

% 4cls

%{
[z_4cls1, d_4cls1, p_4cls1, b_4cls1] = SVMmatlab_P300(NonTarget1, Target1, Label1);
[z_4cls2, d_4cls2, p_4cls2, b_4cls2] = SVMmatlab_P300(NonTarget2, Target2, Label2);
[z_4cls3, d_4cls3, p_4cls3, b_4cls3] = SVMmatlab_P300(NonTarget3, Target3, Label3);
[z_4cls4, d_4cls4, p_4cls4, b_4cls4] = SVMmatlab_P300(NonTarget4, Target4, Label4);
%}

% 2cls

%TargetA = vertcat(Target1, Target2);
%NonTargetA = vertcat(NonTarget1, NonTarget2);
[p_2cls1] = SVMmatlab_P300(vertcat(NonTarget1, NonTarget2), vertcat(Target1, Target2), Label1);

%{
[z_2cls1, d_2cls1, p_2cls1, b_2cls1] = SVMmatlab_P300(vertcat(NonTarget1, NonTarget2), vertcat(Target1, Target2), Label1);
[z_2cls2, d_2cls2, p_2cls2, b_2cls2] = SVMmatlab_P300(vertcat(NonTarget1, NonTarget2), vertcat(Target1, Target2), Label2);
[z_2cls3, d_2cls3, p_2cls3, b_2cls3] = SVMmatlab_P300(vertcat(NonTarget3, NonTarget4), vertcat(Target3, Target4), Label3);
[z_2cls4, d_2cls4, p_2cls4, b_2cls4] = SVMmatlab_P300(vertcat(NonTarget3, NonTarget4), vertcat(Target3, Target4), Label4);
%}

%Class A & B probability
%{
ProbP300_4cls = [p_4cls1(:, 2)  p_4cls2(:, 2) p_4cls3(:, 2) p_4cls4(:, 2)];
ProbP300_4cls
%}

% === ex.) TARGET == 1
%____________|_ Prob NonTARGET _|_ Prob TARGET _|
% Duration 1 | Wrong            | Correct       |
% Duration 2 | Correct          | Wrong         |
% Duration 3 | Correct          | Wrong         |
% Duration 4 | Correct          | Wrong         |

%{
ProbP300_2cls = [(p_2cls1(:, 2)+p_2cls2(:, 2))/2 (p_2cls1(:, 2)+p_2cls2(:, 2))/2  (p_2cls3(:, 2)+p_2cls4(:, 2))/2 (p_2cls3(:, 2)+p_2cls4(:, 2))/2 ];
ProbP300_2cls
%}

%____________|_ Prob NonTARGET _|_ Prob TARGET _|
% Duration 1 | Wrong            | Correct       |
% Duration 2 | Wrong            | Correct       |
% Duration 3 | Correct          | Wrong         |
% Duration 4 | Correct          | Wrong         |

%{
figure
for i = 1:4
    ProbAll = vertcat(ProbP300_4cls(i,:), ProbP300_2cls(i,:));
    
    graph(i) = subplot(2,2,i);
    DepictMatrix(ProbAll, {'Target1','Target2','Target3','Target4'}, ...
        {'P300Prob-4cls', 'P300Prob-2cls'})
end

title(graph(1), 'Discriminant Score Duration 1')
title(graph(2), 'Discriminant Score Duration 2')
title(graph(3), 'Discriminant Score Duration 3')
title(graph(4), 'Discriminant Score Duration 4')

filename_Prob = strcat(directory_Trial, '/_ResultP300Prob(SVM).png');
set(gcf,'Position', [0 0 1920 1080], 'PaperPositionMode', 'auto')
print(filename_Prob,'-dpng','-r0')
%}

end

function [AllData, Sampling_Hz] = fileProcessor_dir(directory, File_dir_struct)
   
    AllData = [];
    %File_dir_struct.name
    
    for i = 1:length(File_dir_struct)
        allData_struct = importdata(strcat('./', directory, '/', File_dir_struct(i).name));
        AllData = vertcat(AllData, allData_struct.data);
    end
    
    % === Exploit only signals % === 
    Sampling_Hz = AllData(1, end);
    AllData = AllData(:, 2:end-1);
end
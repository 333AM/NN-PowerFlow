clc;
clear all;
close all;

%% Change codes of names of csv files below
T1 = readtable('P10000.csv','ReadVariableNames',true,'ReadRowNames',false);
T1 = table2array(T1);
T1 = T1.';
T2 = readtable('Q10000.csv','ReadVariableNames',true,'ReadRowNames',false);
T2 = table2array(T2);
T2 = T2.';

inputs = [T1;T2];

%% Change codes of names of csv files below
T3 = readtable('V10000.csv','ReadVariableNames',false,'ReadRowNames',false);
T3 = table2array(T3);
T3 = T3.';
T4 = readtable('Delta10000.csv','ReadVariableNames',false,'ReadRowNames',false);
T4 = table2array(T4);
T4 = T4.';

targets = [T3;T4];

%% Change codes of parameters of hidden layers below
net = fitnet([10],'trainlm');
net = train(net,inputs,targets);

%% Get test data here (This test data are used for making PI boundary)

%% Change codes of names of csv files below
TestP = readtable('P_Test_For_10000.csv','ReadVariableNames',true,'ReadRowNames',false);
TestP = table2array(TestP);
TestP = TestP.';

TestQ = readtable('Q_Test_For_10000.csv','ReadVariableNames',true,'ReadRowNames',false);
TestQ = table2array(TestQ);
TestQ = TestQ.';

%% Change codes of names of csv files below
TestV = readtable('V_Test_For_10000.csv','ReadVariableNames',false,'ReadRowNames',false);
TestV = table2array(TestV);
TestV = TestV.';

TestDel = readtable('Delta_Test_For_10000.csv','ReadVariableNames',false,'ReadRowNames',false);
TestDel = table2array(TestDel);
TestDel = TestDel.';

%% Change codes of numbers of columns of matrix below
NetOutput = net([TestP;TestQ]);

%% Change codes of numbers of columns of matrix below
PowerFlowCalculation = [TestV;TestDel];

error = NetOutput - PowerFlowCalculation;

ErrorOfV = error(1:33,:);
ErrorOfDelta = error(34:end,:);

Graph(error,NetOutput,PowerFlowCalculation);
%% Change codes of numbers of columns of matrix below
for iteration_first = 1:1:33
    pd_V(iteration_first,1) = fitdist(transpose(ErrorOfV(iteration_first,:)),'Kernel');
end
for iteration_second = 1:1:33
    x_V(iteration_second,[1,2]) = icdf(pd_V(iteration_second,1),[0.1,0.9]);
end
for iteration_third = 1:1:33
    pd_Delta(iteration_third,1) = fitdist(transpose(ErrorOfDelta(iteration_third,:)),'Kernel');
end
for iteration_fourth = 1:1:33
    x_Delta(iteration_fourth,[1,2]) = icdf(pd_Delta(iteration_fourth,1),[0.1,0.9]);
end
%% Get ANOTHER test data here

%% Change codes of names of csv files below
TestP2 = readtable('P_2_For_10000.csv','ReadVariableNames',true,'ReadRowNames',false);
TestP2 = table2array(TestP2);
TestP2 = TestP2.';

TestQ2 = readtable('Q_2_For_10000.csv','ReadVariableNames',true,'ReadRowNames',false);
TestQ2 = table2array(TestQ2);
TestQ2 = TestQ2.';

%% Change codes of names of csv files below
TestV2 = readtable('V_2_For_10000.csv','ReadVariableNames',false,'ReadRowNames',false);
TestV2 = table2array(TestV2);
TestV2 = TestV2.';

TestDel2 = readtable('Delta_2_For_10000.csv','ReadVariableNames',false,'ReadRowNames',false);
TestDel2 = table2array(TestDel2);
TestDel2 = TestDel2.';

%% Change codes of numbers of columns of matrix below
NetOutput2 = net([TestP2;TestQ2]);

%% Change codes of numbers of columns of matrix below
PowerFlowCalculation2 = [TestV2;TestDel2];

error2 = NetOutput2 - PowerFlowCalculation2;

ErrorOfV2 = error2(1:33,:);
ErrorOfDelta2 = error2(34:end,:);

MAEofV2 = (sum(abs(ErrorOfV2),2) / 1500);
MAEofDelta2 = (sum(abs(ErrorOfDelta2),2) / 1500);

count = zeros(33,1);
count2 = zeros(33,1);

for iteration_sixth = 1:1:33
    for iteration_fifth = 1:1:1500
        if((PowerFlowCalculation2(iteration_sixth,iteration_fifth) < (NetOutput2(iteration_sixth,iteration_fifth) + x_V(iteration_sixth,1))) || ((NetOutput2(iteration_sixth,iteration_fifth) + x_V(iteration_sixth,2)) < PowerFlowCalculation2(iteration_sixth,iteration_fifth)))
            count(iteration_sixth,1) = count(iteration_sixth) + 1;
        end
    end
end

for iteration_eighth = 1:1:33
    for iteration_seventh = 1:1:1500
        if((PowerFlowCalculation2(33 + iteration_eighth,iteration_seventh) < (NetOutput2(33 + iteration_eighth,iteration_seventh) + x_Delta(iteration_eighth,1))) || ((NetOutput2(33 + iteration_eighth,iteration_seventh) + x_Delta(iteration_eighth,2)) < PowerFlowCalculation2(33 + iteration_eighth,iteration_seventh)))
            count2(iteration_eighth,1) = count2(iteration_eighth) + 1;
        end
    end
end

for iteration_ninth = 1:1:33
    figure;
    histfit(transpose(ErrorOfV(iteration_ninth,:)),100,'Kernel');
end

figure;
plot(x_V);
axis auto;

for iteration_tenth = 1:1:33
    figure;
    histfit(transpose(ErrorOfDelta(iteration_tenth,:)),100,'Kernel');
end

figure;
plot(x_Delta);
axis auto;

figure;
bar(MAEofV2);

figure;
bar(MAEofDelta2);

figure;
% plot(count);
bar(count);% こうした

figure;
% plot(count2);
bar(count2);% こうした
function Graph(error,NetOutput,PowerFlowCalculation)
%% 絶対値を取る場合
AbsErr = abs(error);
SumErr_V = sum(AbsErr(1:33,:));% SumErr_Vは1*1500の行ベクトル
%% 絶対値を取らない場合
% SumErr_V = sum(err(1:33,:));

[Maxi_V,IndMax_V] = max(SumErr_V,[],2);% これあってる？？？ 多分あってる
[Mini_V,IndMin_V] = min(SumErr_V,[],2);% これあってる？？？ 多分あってる

figure;
plot(1:1:33,12.66.*(NetOutput(1:33,IndMax_V)),1:1:33,12.66.*(PowerFlowCalculation(1:33,IndMax_V)));
legend('ニューラルネットワークが出力した各母線の電圧の値','電力潮流計算による各母線の電圧の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の値[kV]');
title('推定誤差が最大の時の各母線の電圧の値');

figure;
plot(1:1:33,12.66.*(NetOutput(1:33,IndMin_V)),1:1:33,12.66.*(PowerFlowCalculation(1:33,IndMin_V)));
legend('ニューラルネットワークが出力した各母線の電圧の値','電力潮流計算による各母線の電圧の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の値[kV]');
title('推定誤差が最小の時の各母線の電圧の値');

%% 絶対値を取る場合
SumErr_Delt = sum(AbsErr(34:66,:));
%% 絶対値を取らない場合
% SumErr_Delt = sum(err(34:66,:));

[Maxi_Delt,IndMax_Delt] = max(SumErr_Delt,[],2);% これあってる？？？？ 多分あってる
[Mini_Delt,IndMin_Delt] = min(SumErr_Delt,[],2);% これあってる？？？ 多分あってる

figure;
plot(1:1:33,(180/pi).*(NetOutput(34:66,IndMax_Delt)),1:1:33,(180/pi).*(PowerFlowCalculation(34:66,IndMax_Delt)));
legend('ニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[°]');
title('推定誤差が最大の時の各母線の電圧の位相角の値');

figure;
plot(1:1:33,(180/pi).*(NetOutput(34:66,IndMin_Delt)),1:1:33,(180/pi).*(PowerFlowCalculation(34:66,IndMin_Delt)));
legend('ニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[°]');
title('推定誤差が最小の時の各母線の電圧の位相角の値');

end
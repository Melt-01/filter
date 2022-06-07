function [ Y ] = fx_FIR( fs, fc1 ,fc2 , signal)
%===============IIR设计滤波器===============   
%一阶滤波器
% Wn=[fc1*2 fc2*2]/fs;                              
% [b,a]=butter(1,Wn);     
% Y=filtfilt(b,a,signal); 


% %高阶滤波器
% %理论分析
% fs2=1.2*fc2;
% fp2=fc2;
% fp1=fc1;
% fs1=fc1*(0.8);
% rp=1;
% rs=50;
% 
% %求对应角频率
% ws2=2*fs2/fs;
% wp2=2*fp2/fs;
% wp1=2*fp1/fs;
% ws1=2*fs1/fs;
% 
% %求滤波器的阶数
% [n2,wn2]=buttord([wp1,wp2],[ws1,ws2],rp,rs);
% if n2>2
%     n2=2;
% [b,a]=butter(n2,wn2);
% Y=filtfilt(b,a,signal);

%实际应用
%等效于上文中的高阶滤波器部分
% %二阶滤波器
% Wn=[fc1*2 fc2*2]/fs;                              
% [b,a]=butter(2,Wn);     
% Y=filtfilt(b,a,signal); 

%===============FIR设计滤波器===============   
% %理论分析
% fs2=fc2*(1.2);
% fp2=fc2;
% fp1=fc1;
% fs1=fc1*(0.8);
% 
% %求对应角频率
% ws2=fs2*2*pi/fs;
% wp2=fp2*2*pi/fs;
% wp1=fp1*2*pi/fs;
% ws1=fs1*2*pi/fs;
% %求滤波器的阶数
% B=min(ws2-wp2,wp1-ws1);   %求过渡带宽
% N1=ceil(12*pi/B);
% 
% 
% %计算滤波器系数
% wc2=(ws2+wp2)/2;
% wc1=(ws1+wp1)/2;
% wp=[wc1,wc2];
% 
% if N1>1000
%     N1=1000;
% b=fir1(N1-1,wp,'bandpass',blackman(N));
%实际应用
%由于上述计算的过程，耗时过长，难以实际应用（稳定性不足），经过一些测试，效果几近等同于下面的代码
 b = fir1(1000, [fc1*2/fs fc2*2/fs]);
 Y = filtfilt(b,1,signal);
end


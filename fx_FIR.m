function [ Y ] = fx_FIR( fs, fc1 ,fc2 , signal)
%===============IIR����˲���===============   
%һ���˲���
% Wn=[fc1*2 fc2*2]/fs;                              
% [b,a]=butter(1,Wn);     
% Y=filtfilt(b,a,signal); 


% %�߽��˲���
% %���۷���
% fs2=1.2*fc2;
% fp2=fc2;
% fp1=fc1;
% fs1=fc1*(0.8);
% rp=1;
% rs=50;
% 
% %���Ӧ��Ƶ��
% ws2=2*fs2/fs;
% wp2=2*fp2/fs;
% wp1=2*fp1/fs;
% ws1=2*fs1/fs;
% 
% %���˲����Ľ���
% [n2,wn2]=buttord([wp1,wp2],[ws1,ws2],rp,rs);
% if n2>2
%     n2=2;
% [b,a]=butter(n2,wn2);
% Y=filtfilt(b,a,signal);

%ʵ��Ӧ��
%��Ч�������еĸ߽��˲�������
% %�����˲���
% Wn=[fc1*2 fc2*2]/fs;                              
% [b,a]=butter(2,Wn);     
% Y=filtfilt(b,a,signal); 

%===============FIR����˲���===============   
% %���۷���
% fs2=fc2*(1.2);
% fp2=fc2;
% fp1=fc1;
% fs1=fc1*(0.8);
% 
% %���Ӧ��Ƶ��
% ws2=fs2*2*pi/fs;
% wp2=fp2*2*pi/fs;
% wp1=fp1*2*pi/fs;
% ws1=fs1*2*pi/fs;
% %���˲����Ľ���
% B=min(ws2-wp2,wp1-ws1);   %����ɴ���
% N1=ceil(12*pi/B);
% 
% 
% %�����˲���ϵ��
% wc2=(ws2+wp2)/2;
% wc1=(ws1+wp1)/2;
% wp=[wc1,wc2];
% 
% if N1>1000
%     N1=1000;
% b=fir1(N1-1,wp,'bandpass',blackman(N));
%ʵ��Ӧ��
%������������Ĺ��̣���ʱ����������ʵ��Ӧ�ã��ȶ��Բ��㣩������һЩ���ԣ�Ч��������ͬ������Ĵ���
 b = fir1(1000, [fc1*2/fs fc2*2/fs]);
 Y = filtfilt(b,1,signal);
end


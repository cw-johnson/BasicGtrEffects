
%Construct RC Lowpass Filter
f = 2*logspace(0,4,100)';
R = [0.1,1,10,100]*(10^3); %kOhms
C = 22E-9; %22 nFarad
fc = 1./(2*pi*R*C);
Tau = R*C;
w = 2*pi*f;
s = j*w;
H2 = 1./(1+s*R*C);
H2_M = abs(H2);
H2_P = rad2deg(angle(H2));

%Plot RC Lowpass Filter Response
figure(1)
subplot(2,2,1);
semilogx(f,H2_M(:,1),f,H2_M(:,2),f,H2_M(:,3),f,H2_M(:,4));
title('RC 1st-Order Lowpass Magnitude Response');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2,2,2);
semilogx(f,H2_P(:,1),f,H2_P(:,2),f,H2_P(:,3),f,H2_P(:,4));
title('RC 1st-Order Lowpass Phase Response');
xlabel('Frequency (Hz)');
ylabel('Phase (deg)');

fs = 96E3;
dt = 1/fs;

alpha = (2*pi*dt*fc)./(2*pi*dt*fc + 1)
%y[n] = a*x[n] + (1-a)*y[n-1]
%b0 = a
%a1 = (1-a)
%Y[z] = a*X[z] + z^-1*Y[z] - z^-1*a*Y[z]
%Y[z]/X[z]=a/(1 + z^-1*(a-1))
%Y[z]/X[z]=az/(z+(a-1))
a1 = [1, (alpha(1)-1)];
b1 = [alpha(1)];
[h1,w1] = freqz(b1,a1,f,fs);

a2 = [1, (alpha(2)-1)];
b2 = [alpha(2)];
[h2,w2] = freqz(b2,a2,f,fs);

a3 = [1, (alpha(3)-1)];
b3 = [alpha(3)];
[h3,w3] = freqz(b3,a3,f,fs);

a4 = [1, (alpha(4)-1)];
b4 = [alpha(4)];
[h4,w4] = freqz(b4,a4,f,fs);



subplot(2,2,3);
semilogx(f,abs(h1),f,abs(h2),f,abs(h3),f,abs(h4));
title('IIR 1st-Order Lowpass Magnitude Response');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
subplot(2,2,4);
semilogx(f,rad2deg(angle(h1)),f,rad2deg(angle(h2)),f,rad2deg(angle(h3)),f,rad2deg(angle(h4)));
title('IIR 1st-Order Lowpass Phase Response');
xlabel('Frequency (Hz)');
ylabel('Magnitude');


%Saturation Voltage Transfer Function->Run instances in succession
%Vin = [-200000000:100000:200000000];
t = [0:0.00001:0.5];
f = 1000;
Vin = 8000000*sin(2*pi*60.*t);
T = Vin.*0;
THRESH1 = 2000000;
THRESH2 = 4000000;
THRESH3 = 5000000;
ctr = 0;
for i = Vin
    ctr = ctr + 1;
    if (i > THRESH1)
        T(ctr) = THRESH1 + (i-THRESH1)/2;
    elseif (i < -THRESH1)
        T(ctr) = -THRESH1 + (i+THRESH1)/2;
    else
        T(ctr) = i;
    end
end
ctr = 0;
for i = T
    ctr = ctr + 1;
    if (i > THRESH2)
        T(ctr) = THRESH2 + (i-THRESH2)/2;
    elseif (i < -THRESH2)
        T(ctr) = -THRESH2 + (i+THRESH2)/2;
    else
        T(ctr) = i;
    end
end
ctr = 0;
for i = T
    ctr = ctr + 1;
    if (i > THRESH3)
        T(ctr) = THRESH3 + (i-THRESH3)/2;
    elseif (i < -THRESH3)
        T(ctr) = -THRESH3 + (i+THRESH3)/2;
    else
        T(ctr) = i;
    end
end
figure(4)
plot(t,Vin,t,T)
title('Simple Saturation Sinusoid Response');
xlabel('Voltage Input (Normalized)');
ylabel('Time (s)');

figure(5)
plot(Vin,T)
title('Simple Saturation Voltage Transfer Curve');
xlabel('Voltage Input (Normalized)');
ylabel('Voltage Output (Normalized)');

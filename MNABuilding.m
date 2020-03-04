% Rudi Hidvary

clear 
clc

G1 = 1;
G2 = 0.5;
G3 = 0.1;
G4 = 10;
G5 = 0.001

C = 0.25;

L = 0.2

alpha = 100;

Vin = -10:1:10;

GMatrix = [
    1 0 0 0 0 0 0;
    0 1 -1 0 0 0 0;
    G1 (-(G1+G2)) 0 0 0 -1 0;
    0 0 G3 0 0 -1 0;
    0 0 G3 0 0 0 -1;
    0 0 0 G4 (-(G4+G5)) 0 0;
    0 0 0 1 0 0 -alpha]

CMatrix = [
    0 0 0 0 0 0 0;
    0 0 0 0 0 -L 0;
    C -C 0 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;]

V3 = [];
V0 = [];
n = 1;
w = 0;
for Vin = -10:1:10
    A = ((CMatrix.*(1i.*0) + GMatrix));
    FVector = [Vin; 0; 0; 0; 0; 0; 0]
    V = A\FVector
    V3(n) = V(3);
    V0(n) = V(5);
    n = n+1;
end

n = linspace(-10,10,n-1);

% Plotting the outputs 
figure(1)
subplot(2,1,1)
plot(n,V3,'k')
xlabel('Voltage IN')
ylabel('V3')
title('V3 Output Voltage')
grid on 


subplot(2,1,2)
plot(n,V0,'b')
xlabel('Voltage IN')
ylabel('V0')
title('V0 Output Voltage')
grid on 


V0 = [];
n = 1;
Vin = 1; % DC bias of 1 Volt
freq = 5000; % maximum frequency
for w = 0:1:freq
    A = ((CMatrix.*(1i.*w) + GMatrix));
    FVector = [Vin; 0; 0; 0; 0; 0; 0];
    V = A\FVector;
    V3(n) = V(3);
    V0(n) = V(5);
    n = n+1;
end


% Plotting the outputs 
figure(2)
subplot(2,1,1)
plot(0:1:freq,abs(V0/Vin),'k')
xlabel('Frequency')
ylabel('V0')
title('V0 as Function of Frequency')
grid on 


subplot(2,1,2)
semilogx(0:1:freq,20*log(abs(V0/Vin)),'b')
xlabel('Frequency')
ylabel('V0 in dB')
title('V0 Output Voltage')
grid on

r = normrnd(C,0.05,20000,1);
figure(3)
hist(r,200)

V0 = [];
n = 1;
Vin = 1; % DC bias of 1 Volt
freq = pi; % maximum frequency
CVal = C;
for w = 1:1:20000
    
    C = r(w);
    
    CMatrix = [
    0 0 0 0 0 0 0;
    0 0 0 0 0 -L 0;
    C -C 0 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;];

    A = ((CMatrix.*(1i.*freq) + GMatrix));
    FVector = [Vin; 0; 0; 0; 0; 0; 0];
    V = A\FVector;
    V3(n) = V(3);
    V0(n) = V(5);
    n = n+1;
end

figure(4)
hist(20*log(abs(V0/Vin)),200)



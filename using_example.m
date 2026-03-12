%% test 
fs = 4e4;                              % Sampling frequency
T = 1;                                 % Time duration
delta_f = 1/T;                         % Frequency interval
f = (5:delta_f:fs/2);                  % Frequency axis
alpha = 3e-5;                          % modal loss factor


Lx = 5;                         % Length
Ly = 4;                         % Width
Lz = 3;                         % Height

s = [5 1.5 1];                  % Source Position
r1 = [0.5 1 1];                   % First reciever
r2 = [1 1.3 1];                % Second reciever

[h1,H1] = wfs(Lx,Ly,Lz,r1,s,alpha,f);   % The first room transfer function
[h2,H2] = wfs(Lx,Ly,Lz,r2,s,alpha,f);   % The second room transfer function

t = linspace(0,T,length(h1));

figure()
plot(t,h1,'DisplayName','1st RIR');
hold on
plot(t,h2,'DisplayName','2nd RIR');
xlabel('Time axis')
ylabel('RIR')
legend();


figure()
semilogx(f,20*log(abs(H1)),'DisplayName','1st RTF');
hold on
semilogx(f,20*log(abs(H2)),'DisplayName','2nd RTF');
xlabel('Frequency axis')
ylabel('RTF')
xlim([min(f),max(f)]);
legend();

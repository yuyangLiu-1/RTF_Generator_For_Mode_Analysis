%% test 
T = 1;                                 % Time duration
delta_f = 1/T;                         % Frequency interval
f = (5:delta_f:2000);                  % Frequency axis
alpha = 3e-5;                          % modal loss factor

Lx = 5;                         % Length
Ly = 4;                         % Width
Lz = 3;                         % Height

s = [2 1.5 1];                  % Source Position
r1 = [1 1 1];                   % First reciever
r2 = [1 1.3 1];                % Second reciever

H1 = wfs(Lx,Ly,Lz,r1,s,alpha,f);   % The first room transfer function
H2 = wfs(Lx,Ly,Lz,r2,s,alpha,f);   % The second room transfer function

figure()
semilogx(f,20*log10(abs(H1)),'DisplayName','1st RTF')
hold on
semilogx(f,20*log10(abs(H2)),'DisplayName','2nd RTF')
xlabel('Frequency')
ylabel('RTF (dB)')
legend();
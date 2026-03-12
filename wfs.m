%% This file is a simulator for generating a 3D non-rigid shoe-box wave field 
% Where the damping effects and the mode shifts are randomized.
% The file is mainly used for the acoustic modes estimation or sound field
% interpolation. Not sure if it's useful for early RIR estimation. But
% it's not supposed to be used for the diffused sound field estimation.


%---------------------------------------------------------
% Notes:
% 1. This file only focuses on the low frequency arange, i.e. f<f_s, where 
%    f_s is the Shroeder threshold. Larger than this threshold, the mode
%    density is too large and meaningless to estimate the modes.
% 2. This file using the direct-form Green's function. 
% 3. It can't customize the boundary condition, which means it can't be
%    used for the problems with priors of the boundary impedances.
% 4. For similar as the reality, a third-order high-pass ButterWorth filter
%    is used, the cut-off frequency is 15Hz.
%---------------------------------------------------------

% Input parameters:
% Lx, Ly, Lz are the shoebox parameters: length, width, height
% x: the observation point
% x0: the source position
% alpha: 1/(2*Q), where Q is the Q factor; The larger alpha, the stronger
% the damping effect.
% Suggested alpha range: <1e-4.
% Q factor: wn/(2*sigman), where the n-th resonant angle is w_n+jsigma_n. 

function G = wfs(Lx,Ly,Lz,x,x0,alpha,f)
seed = 3;
rng(seed);
c = 343;
omega = 2*pi*f;
k = omega/c;

Nx=10; Ny=10; Nz=10;

[nx,ny,nz] = ndgrid(0:Nx,0:Ny,0:Nz);

kx = nx*pi/Lx;
ky = ny*pi/Ly;
kz = nz*pi/Lz;

kn = sqrt(kx.^2 + ky.^2 + kz.^2);

kx=kx(:); ky=ky(:); kz=kz(:);
kn=kn(:);

% Assumtion of schoeder frequency
V = Lx*Ly*Lz;
T60_a = 1;
f_s = sqrt(c^3/(16*pi*T60_a*V)) + 500;
k_s = f_s*2*pi/c;
ind = find(kn < k_s);
kn = kn(ind);        
kx = kx(ind);
ky = ky(ind);
kz = kz(ind);

% Robin perturbation
shift = 2e-6*randn(size(kn));
damp = alpha*c*kn + alpha/4*c*randn(size(kn));

kappa = kn + shift + 1i*damp;

% random phase
bx = 2*pi*rand(size(kn));
by = 2*pi*rand(size(kn));
bz = 2*pi*rand(size(kn));

% eigenfunctions
phi_x = cos(kx*x(1)+bx).*cos(ky*x(2)+by).*cos(kz*x(3)+bz);
phi_x0= cos(kx*x0(1)+bx).*cos(ky*x0(2)+by).*cos(kz*x0(3)+bz);

% modal weights
a = phi_x .* phi_x0;

% vectorized Green function
denom = kappa.^2 - k.^2;     % modes × freq
G = sum(a ./ (4*pi^2*denom),1);
G = G(:);

% Third-order butterworth filter 
fc = 15;        % cutoff frequency
fs = 2*max(f); % sampling frequency for digital design

Wn = fc/(fs/2);
[b,a] = butter(3,Wn,'high');     % 3rd-order high-pass
H_mag = freqz(b,a,f,fs);         % evaluate at your frequency axis        

G = H_mag' .* G;

end


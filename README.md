# RTF_Generator_For_Mode_Analysis
This is the matlab file to generate the RTF specially for mode analysis

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

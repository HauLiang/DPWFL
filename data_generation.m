clear; clc; close all;

% Parameter Setting
delta = 1e-5;
p = 1; q = 1;
c = 2; D = 10000;
L = 1; sigma = 10;
n = 8; b = q*p*n; eta = 0.1;
L_delta = log10(1/delta);
T = 1000;

% Initalization
epsilon_T = zeros(1,T);
epsilon_baseline = zeros(1,T);
t_T = 0:T-1;


for t_temp = 1:T-1

    t = 0:t_temp;

    % Our result
    gamma = ones(1, t_temp);
    Phi = (gamma(end) + (1+eta*L)*sqrt(p*q)*D*n*gamma(end)/(2*eta*L) )^2;
    M = min(sum(gamma.^2),Phi);
    
    % K = (p*q*(c^2)/(sigma^2))*M;
    % epsilon_our = 2*K + sqrt(4*K.^2+8*K*L_delta);
    % epsilon_T(t_temp+1) = epsilon_our;

    A = 2*p*q*c^2/sigma^2*M; 
    epsilon_T(t_temp+1) = A+2*sqrt(A*L_delta);
    
    % DP-NOMA result
    epsilon_baseline(t_temp+1) = epsilon_from_sum(delta, c, sigma, gamma);
end


function eps_val = epsilon_from_sum(delta, c, sigma, gamma)
%EPSILON_FROM_SUM Closed-form epsilon for:
% sum_{t=0}^{T-1} (2 c^2 gamma(t)^2)/sigma^2 = (sqrt(eps + a^2) - a)^2
% with f(x) = sqrt(pi) * x * exp(x^2) and a = f^{-1}(1/delta).
%
% Inputs:
%   delta in (0,1)
%   c, sigma > 0
%   gamma: vector of gamma^(t)
%
% Output:
%   eps_val >= 0

    arguments
        delta (1,1) double {mustBeGreaterThan(delta,0), mustBeLessThan(delta,1)}
        c     (1,1) double {mustBePositive}
        sigma (1,1) double {mustBePositive}
        gamma (:,1) double
    end

    % S = (2 c^2 / sigma^2) * sum gamma^2
    S = (2 * c^2 / sigma^2) * sum(gamma.^2);

    if S == 0
        eps_val = 0;
        return;
    end

    % a = f^{-1}(1/delta) using Lambert W (principal branch)
    a = sqrt(0.5 * lambertw(0, 2/(pi*delta^2)));

    % epsilon = S + 2 a sqrt(S)
    eps_val = S + 2 * a * sqrt(S);
end


% Plot figure
figure;
plot(t_T, epsilon_T, 'b', 'linewidth',2); hold on;
plot(t_T, epsilon_baseline, 'k', 'linewidth',2)

set(gcf,'Position',[20 100 640 500]);	 
xlabel('Time (s)','FontSize',24,'FontName','Times New Roman');
ylabel('Frequency (Hz)','FontSize',24,'FontName','Times New Roman');
set(gca,'YDir','normal','FontName','Times New Roman')
set(gca,'FontSize',24);
set(gca,'linewidth',2);
set(gcf,'Color','w');	

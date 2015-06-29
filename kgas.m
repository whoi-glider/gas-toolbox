% =========================================================================
% KGAS - gas transfer coefficient for a range of windspeed based
% parameterizations
%
% [kv] = kgas(u10,Sc,param)
%
% -------------------------------------------------------------------------
% INPUTS:
% -------------------------------------------------------------------------
% u10       10-m windspeed (m/s)
% Sc        Schmidt number 
% param     abbreviation for parameterization:
%           W92a = Wanninkof 1992 - averaged winds
%           W92b = Wanninkof 1992 - instantaneous or steady winds
%           Sw07 = Sweeney et al. 2007
%           Ho06 = Ho et al. 2006
%           Ng00 = Nightingale 2000
%           LM86 = Liss and Merlivat 1986
%           W14 = Wanninkhof 2014
% 
% -------------------------------------------------------------------------
% REFERENCES:
% -------------------------------------------------------------------------
% Ho, D. T., C. S. Law, M. J. Smith, P. Schlosser, M. Harvey, and
%   P. Hill (2006), Measurements of air-sea gas exchange at high wind
%   speeds in the Southern Ocean: Implications for global parameterizations
%   , Geophys. Res. Lett., 33(16), L16611, doi:10.1029/2006GL026817.
%
% Liss, P. S., and L. Merlivat (1986), Air-sea gas exchange rates:
%   Introduction and synthesis, in The role of air-sea exchange in 
%   geochemical cycling, pp. 113?127, D. Reidel Publishing, Norwell, MA.
%
% Nightingale, P. D., G. Malin, C. S. Law, A. J. Watson, P. S. Liss, M. I. 
%   Liddicoat, J. Boutin, and R. C. Upstill-Goddard (2000), In situ 
%   evaluation of air-sea gas exchange parameterizations using novel 
%   conservative and volatile tracers, Global Biogeochemical Cycles, 14(1), 
%   373?387, doi:10.1029/1999GB900091.
%
% Wanninkhof, R. (1992), Relationship between gas exchange and wind speed 
%   over the ocean, J. Geophys. Res., 97(C5), 7373?7381, doi:10.1029/92JC00188.
%
% Wanninkhof, R. (2014), Relationship between wind speed and gas exchange 
%   over the ocean revisited, Limnol. Oceanogr. Methods, 12(6), 351?362, 
%   doi:10.4319/lom.2014.12.351.
%
%
% -------------------------------------------------------------------------
% OUTPUTS:
% -------------------------------------------------------------------------
% kv       Gas transfer velocity in m s-1
%
% -------------------------------------------------------------------------
% USGAGE:
% -------------------------------------------------------------------------
% k = kgas(10,1000,'W92b')
% k = 6.9957e-05
%
% Author: David Nicholson dnicholson@whoi.edu
%
%
% -------------------------------------------------------------------------
% Changes:
% -------------------------------------------------------------------------
% 6/23/15 - Ho06 case corrected from Sc600 --> Sc660
% 6/25/15 - W14 added Wanninkof 2014 Limnology and Oceanography Methods
% =========================================================================

function [kv] = kgas(u10,Sc,param)

quadratics = {'W92a','W92b','Sw07','Ho06','W14'};
% should be case insensitive
if ismember(upper(param),upper(quadratics))
    if strcmpi(param,'W92a')
        A = 0.39;
    elseif strcmpi(param,'W92b')
        A = 0.31;
    elseif strcmpi(param,'Sw07')
        A = 0.27;
    elseif strcmpi(param,'W14')
        A = 0.251;
    elseif strcmpi(param,'Ho06')
        A = 0.266.*(600/660).^0.5; % k_600 = 0.266 - adjusted to Sc =660
    else
        error('parameterization not found');
    end
    k_cm = A*u10.^2.*(Sc./660).^-0.5;
elseif strcmpi(param,'Ng00')
    k600 = 0.222.*u10.^2 + 0.333.*u10;
    k_cm = k600.*(Sc./600).^-0.5;
    % cm/h to m/s
elseif strcmpi(param,'LM86')
    k600 = zeros(1,length(u10));   
    k600(u10 <= 3.6) = 0.17.*u10(u10 <= 3.6);
    k600(u10 > 3.6 & u10 <= 13) = 2.85.*u10(u10 > 3.6 & u10 <= 13)-9.65;
    k600(u10 > 13) = 5.9.*u10(u10 > 13)-49.3;    
    k_cm = k600.*(Sc./600).^-0.5;
    k_cm(u10 <= 3.6) = k600(u10 <= 3.6).*(Sc./600).^(-2/3);    
end
    kv = k_cm./(100*60*60);
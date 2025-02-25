function ddeg=dms2deg(dms)
%
% Function dms2deg
% ================
%
%       Converts angles in the format gg.mmsssssssss to decimal degrees.
%
% Sintax
% ======
%
%       ddeg=dms2deg(dms)
%
% Input
% =====
%
%       dms -> angle in the format gg.mmsssssssss
%
% Output
% ======
%
%       ddeg -> angle in decimal degrees
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/06/28    Rodrigo Leandro         Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

%=======================
% 1. Get sign of angle
%-----------------------
sig=sign(dms);
dms=abs(dms);
%=======================

%====================================
% 2. Get degrees, minutes and seconds
%------------------------------------
deg=fix(dms);
% k is the largest value in seconds 
% that can be added to a valid value in 
% seconds ([0 60]) without making the sum 
% greater than 1 minute, all of it in the 
% dms representation:
k = 0.0100 - 0.0060 - sqrt(eps);
min1=(dms-deg)*100 + k;
min=fix(min1);
sec=mod(min1,min)*100;
sec=sec-100*k;
%====================================

%=============================
% 3. Compute angle in degrees:
%-----------------------------
ddeg=sig.*(deg+min/60+sec/3600);
%=============================

end

%!test
%! deg = [0; -90; 90.5; -(90+1/3600); -(1/60); 180; 1; 90+1/60];
%! dms = [0.0; -90.0; 90.300; -90.0001; -00.0100; 180.0; 1; 90.0060];
%! deg2 = dms2deg (dms);
%! %deg2 - deg  % DEBUG
%! assert (deg2, deg, -100*eps);

%!test
%! n = ceil(10*rand);
%! temp = rand(n,1);
%! sig = ones(n,1);  sig(temp>0.5) = -1;
%! deg = ceil(rand(n,1)*180);
%! min = ceil(rand(n,1)*60);
%! sec = rand(n,1)*60;
%! 
%! idx = sec == 60;  min(idx) = min(idx) + 1;  sec(idx) = 0; 
%! idx = min == 60;  deg(idx) = deg(idx) + 1;  min(idx) = 0; 
%! 
%! ddeg = sig .* (deg + (min + sec/60)/60);
%! dms = sig .* (deg + (min + sec/100)/100);
%! 
%! ddeg2 = dms2deg(dms);
%! err = ddeg2 - ddeg;
%! %idx = err > 0.1;
%! %err(idx), [ddeg(idx), ddeg2(idx)], [deg(idx), min(idx), sec(idx)]
%! assert (err, 0, -1000*eps)

%!test
%! n = ceil(100*rand);
%! temp = rand(n,1);
%! sig = ones(n,1);  sig(temp>0.5) = -1;
%! deg = ceil(rand(n,1)*180);
%! min = ceil(rand(n,1)*60);
%! sec = rand(n,1)*60;
%! 
%! idx = sec == 60;  min(idx) = min(idx) + 1;  sec(idx) = 0; 
%! idx = min == 60;  deg(idx) = deg(idx) + 1;  min(idx) = 0; 
%! 
%! dms = sig .* (deg + (min + sec/100)/100);
%! ddeg = sig .* (deg + (min + sec/60)/60);
%! 
%! dms2 = deg2dms(dms2deg(dms));
%! ddeg2 = dms2deg(deg2dms(ddeg));
%! 
%! err_dms  = dms2 - dms;
%! err_ddeg = ddeg2 - ddeg;
%! %idx = err_ddeg > 0.1;
%! %err_ddeg(idx), [ddeg(idx), ddeg2(idx)], [deg(idx), min(idx), sec(idx)]
%! assert(dms2, dms, -1000*eps);
%! assert(ddeg2, ddeg, -1000*eps);


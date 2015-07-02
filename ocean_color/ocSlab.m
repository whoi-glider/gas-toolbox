function [slab, lonout,latout] = ocSlab( latRng,lonRng,t,varName,varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
nt = length(t);
% convert lons to -180 to 180 range
lonRng = mod(lonRng,360);
lonRng(lonRng > 180) = lonRng(lonRng > 180) - 360;
if lonRng(1) > lonRng(2)
    isSplit = 1;
    lonRng1 = [lonRng(1) 180];
    lonRng2 = [-180 lonRng(2)];
else
    isSplit = 0;
end

[url] = ocFileString(t(1),varName,varargin{:});
% these 
lat = ncread(url,'lat');
lon = ncread(url,'lon');

ilat = find(lat > latRng(1) & lat <= latRng(2));
latout = lat(ilat);
nlat = length(ilat);
if isSplit
    ilon1 = find(lon > lonRng1(1) & lon <= lonRng1(2));
    nlon1 = length(ilon1);
    ilon2 = find(lon > lonRng2(1) & lon <= lonRng2(2));
    nlon2 = length(ilon2);
    lonout = lon([ilon1;ilon2]);   
else
    ilon = find(lon > lonRng(1) & lon <= lonRng(2));
    lonout = lon(ilon);
end
nlon = length(lonout);

slab = nan(nlon,nlat,nt);

for ii = 1:length(t)
    [url] = ocFileString(t(1),varName,varargin{:});
    if isSplit
        slab(1:nlon1,:,ii) = ncread(url,varName,[ilon1(1),ilat(1)],...
            [nlon1,nlat]);
        slab(nlon1+1:end,:,ii) = ncread(url,varName,[1,ilat(1)],...
            [nlon2,nlat]);
    else
        slab(:,:,ii) = ncread(url,varName,[ilon(1),ilat(1)],...
            [nlon,nlat]);
    end
end
        
   
    
    
end


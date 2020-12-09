clear all;
clc

addpath('./m_map1.4/m_map/')

% US_Gravity_Data
load('./US_Gravity_Data/USgrav.mat')

long1 = gravitydata{:,7};
lat1 = gravitydata{:,6};
g1 = gravitydata{:,5};

% Satellite
load('./US_EGM2008_0.1.txt')

long2 = US_EGM2008_0_1(:,1);
lat2 = US_EGM2008_0_1(:,2);
g2 = US_EGM2008_0_1(:,3);

m_proj('Mercator', 'lon', [min(long1) max(long1)], 'lat', [min(lat1) max(lat1)])
m_scatter(long1, lat1, 1, g1, 'filled', 's')
axis equal
axis off

m_proj('Mercator', 'lon', [min(long2) max(long2)], 'lat', [min(lat2) max(lat2)])
m_scatter(long2, lat2, 5, g2, 'filled','s')
caxis([min(g1) max(g1)]) % re-scale the range of color bar
axis equal
axis off




clear all;
clc

addpath('./m_map1.4/m_map/')

data = xlsread('./CA_Gravity_Data/Bouguer_gravity_canada.xlsx');


long1 = data(:,5);
lat1 = data(:,4);
g1 = data(:,3);

m_proj('Mercator', 'lon', [min(long1) max(long1)], 'lat', [min(lat1) max(lat1)])
m_scatter(long1, lat1, 1, g1, 'filled', 's')
axis equal
axis off

load('./CA_EGM2008_0.1.txt')

long2 = CA_EGM2008_0_1(:,1);
lat2 = CA_EGM2008_0_1(:,2);
g2 = CA_EGM2008_0_1(:,3);

m_proj('Mercator', 'lon', [min(long2) max(long2)], 'lat', [min(lat2) max(lat2)])
m_scatter(long2, lat2, 10, g2, 'filled','s')
caxis([min(g1) max(g1)]) % re-scale the range of color bar
axis equal
axis off
clc
clear all

%%
n2yoAPI = N2YOWebAPI

%%
%Объекты над точкой наблюдения
n2yoAPI.GetCategoryList;
data = n2yoAPI.GetAboveObjects(55.75222,37.61556,100,45,0)

%%
%TLE МКС
tle_25544 = n2yoAPI.GetTLE(25544)

%%
%положение МКС
satPos = n2yoAPI.GetSatellitePositions(25544,55.75222,37.61556,100,300)

%%
%пролет МКС
pass = n2yoAPI.GetVisualPasses(25544,55.75222,37.61556,100,10,60)
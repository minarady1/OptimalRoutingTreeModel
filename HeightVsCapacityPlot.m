% Gateway Capacity Estimator model as a function of height and PHY Maximum Coupling Loss
% Mina Rady, Orange Labs, 2019

clear
mesh_resolution = 32;
max_capacity1= 5000;
max_capacity2= 10000;
% -------------------------------------------------------
% first figure: high GW height and high GW density
% Input Parameters: Define GW height range and ED Density Range
min_height = 1;
max_height = 1200; %m

min_density = 0;
max_density = 0.6e3;

freq = 868e6 %Hz
ple = 5 %friis path loss exponent n


%------ End input

lamda = 3e8/freq;
min_los = 3.57*(min_height.^0.5);
max_los = 3.57*(max_height.^0.5);
los_step = (max_los-min_los)/mesh_resolution;


min_pl = 20*log10(4*pi/lamda)+10*ple*log10(min_los);
max_pl = 20*log10(4*pi/lamda)+10*ple*log10(max_los);
pl_step = (max_pl-min_pl)/mesh_resolution;

density_step = (max_density-min_density)/mesh_resolution;

[linkbudget,density] = meshgrid(min_pl:pl_step:max_pl,min_density:density_step:max_density);
[GW_los,density] = meshgrid(min_los:los_step:max_los,min_density:density_step:max_density);

height= (GW_los/3.57).^2;
GW_radius = ((GW_los.^2)-((0.001*height).^2)).^0.5;
GW_Load = (pi*(GW_radius).^2).*density;

f=figure (1)
clf;
colormap default;
surf(linkbudget,density,GW_Load,'DisplayName','EDs in GW range');
set(gca, 'ZScale', 'log');
mkdir('Figures/CapacityCurves/');
hold on
%practical gw capacity benchmark
    mesh(linkbudget,density,ones ([size(density,1) size(density,2)])*max_capacity1,'EdgeColor',[0.3010, 0.7450, 0.9330],'DisplayName',...
        'Zero-repetition band capacity (EMeters)','FaceColor', 'none');
%theoretical gw capacity benchmark with tdma
    mesh(linkbudget,density,ones ([size(density,1) size(density,2)])*max_capacity2, 'EdgeColor',[0.8500, 0.3250, 0.0980], 'DisplayName',...
        'One-repetition band capacity (EMeters)','FaceColor', 'none');

view([-125 13]);
hold off
xlabel('Maximum Coupling Loss (dB)');
ylabel('ED Spatial Density (EDs/km²)')
zlabel('Number of EDs in GW range')
zz = zlim;
z_upper=zz(1,2);
zlim([700 z_upper]);
% Create legend
legend1 = legend;
set(legend1,...
    'Position',[0.194465586723629 0.925744539700681 0.616306941322 0.0338283820514238],...
    'Orientation','horizontal',...
    'FontSize',12);

saveas(f,'Figures/CapacityCurves/high_load_curve.png') % save image as a .tiff file
saveas(f,'Figures/CapacityCurves/high_load_curve.fig') % save image as a .tiff file

return;
% -------------------------------------------------------
% first figure: low GW height and low GW density
% Input Parameters: Define GW height range and ED Density Range
min_height = 1;
max_height = 20; %m

min_density = 0;
max_density = 300;

freq = 868e6 %Hz
%------ End input

lamda = 3e8/freq;
min_los = 3.57*(min_height.^0.5);
max_los = 3.57*(max_height.^0.5);
los_step = (max_los-min_los)/mesh_resolution;


min_pl = 20*log10(4*pi/lamda)+10*ple*log10(min_los);
max_pl = 20*log10(4*pi/lamda)+10*ple*log10(max_los);
pl_step = (max_pl-min_pl)/mesh_resolution;

density_step = (max_density-min_density)/mesh_resolution;

[linkbudget,density] = meshgrid(min_pl:pl_step:max_pl,min_density:density_step:max_density);
[GW_los,density] = meshgrid(min_los:los_step:max_los,min_density:density_step:max_density);

height= (GW_los/3.57).^2;
GW_radius = ((GW_los.^2)-((0.001*height).^2)).^0.5;
GW_Load = (pi*(GW_radius).^2).*density;

f=figure (2)
clf;
colormap default;
surf(linkbudget,density,GW_Load,'DisplayName','EDs in GW range');

set(gca, 'ZScale', 'log');
mkdir('Figures/CapacityCurves/');
hold on
%practical gw capacity benchmark
    mesh(linkbudget,density,ones ([size(density,1) size(density,2)])*max_capacity1,'EdgeColor',[0.3010, 0.7450, 0.9330],'DisplayName','Zero-repetition ISM Band capacity (EMeters)','FaceColor', 'none');
%theoretical gw capacity benchmark with tdma
    mesh(linkbudget,density,ones ([size(density,1) size(density,2)])*max_capacity2, 'EdgeColor',[0.8500, 0.3250, 0.0980], 'DisplayName','One-repetition ISM Band capacity (EMeters)','FaceColor', 'none');

view([-125 13]);
hold off
xlabel('GW Maximum Coupling Loss (dB)');
ylabel('ED Spatial Density (EDs/km²)')
zlabel('Number of EDs in GW range')
zlim([1e3 z_upper]);
% Create legend
legend1 = legend;
set(legend1,...
    'Position',[0.194465586723629 0.925744539700681 0.616306941322 0.0338283820514238],...
    'Orientation','horizontal',...
    'FontSize',12);

saveas(f,'Figures/CapacityCurves/low_load_curve.png') % save image as a .tiff file
saveas(f,'Figures/CapacityCurves/low_load_curve.fig') % save image as a .tiff file


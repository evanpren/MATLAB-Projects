%Script simulates 3D random walk and then generates pdf based on each particle’s final distance from the origin
clc;
clearvars;
close all;

num_part = 1*10^6;  %number of particles used
t = 500;            %number of steps each particle will take
x = zeros(1,num_part);
y = zeros(1,num_part);
z = zeros(1,num_part);
prevX = 0;
prevY = 0;
prevZ = 0;


probADJ = zeros(6,1);
adjINC = 0.015;	%affects amount of skew

%handles each particle’s random 3D movement
for i = 1:num_part
    for j = 1:t
        randT = rand();
        if randT < 1/6 + probADJ(1)     %moves x --> x+1
            x(1,i) = prevX + 1;
            prevX = x(1,i);
            y(1,i) = prevY;
            z(1,i) = prevZ;
            probADJ(1) = probADJ(1) + adjINC;
            probADJ(2:end) = probADJ(2:end) + adjINC/5;
            %countXP = countXP + 1;
        elseif  randT < (2/6 + probADJ(2))      %moves x --> x-1
            x(1,i) = prevX - 1;
            prevX = x(1,i);
            y(1,i) = prevY;
            z(1,i) = prevZ;
            probADJ(2) = probADJ(2) + 4*adjINC/5;
            probADJ(1) = probADJ(1) - adjINC/5;
            probADJ(3:end) = probADJ(3:end) + adjINC/5;
            %countXN = countXN + 1;
        elseif randT < (3/6 + probADJ(3))    %moves y --> y+1
            y(1,i) = prevY + 1;
            prevY = y(1,i);
            x(1,i) = prevX;
            z(1,i) = prevZ;
            probADJ(3) = probADJ(3) + 3*adjINC/5;
            probADJ(2) = probADJ(2) - 2*adjINC/5;
            probADJ(1) = probADJ(1) - adjINC/5;
            probADJ(4:end) = probADJ(4:end) + adjINC/5;
            %countYP = countYP + 1;
        elseif randT < 4/6 + probADJ(4)    %moves y --> y-1
            y(1,i) = prevY - 1;
            prevY = y(1,i);
            x(1,i) = prevX;
            z(1,i) = prevZ;
            probADJ(4) = probADJ(4) + 2*adjINC/5;
            probADJ(3) = probADJ(3) - 3*adjINC/5;
            probADJ(1:2) = probADJ(1:2) - adjINC/5;
            probADJ(5:end) = probADJ(5:end) + adjINC/5;
            %countYN = countYN + 1;
        elseif randT < 5/6 + probADJ(5)    %moves z --> z+1
            z(1,i) = prevZ + 1;
            prevZ = z(1,i);
            x(1,i) = prevX;
            y(1,i) = prevY;
            probADJ(5) = probADJ(5) + adjINC/5;
            probADJ(4) = probADJ(4) - 4*adjINC/5;
            probADJ(1:3) = probADJ(1:3) - adjINC/5;
            %countZP = countZP + 1;
        else                               %moves z --> z-1
            z(1,i) = prevZ - 1;
            prevZ = z(1,i);
            x(1,i) = prevX;
            y(1,i) = prevY;
            probADJ(5) = probADJ(5) - adjINC;
            probADJ(1:4) = probADJ(1:4) - adjINC/5;
            %countZN = countZN + 1;
        end
    end
    %reset dynamic probability and position for next particle
    probADJ(:) = 0;
    prevX = 0;
    prevY = 0;
    prevZ = 0;
    if mod(i,100000) == 0
        disp(['at particle ', num2str(i)]);
    end
end

%3D scatter plot in cartesian graph
figure(1);
scatter3(x(end,:),y(end,:),z(end,:), 'b.')
title(['$3D \hspace{1 mm} Random \hspace{1 mm} Walk \hspace{1 mm} Using \hspace{1.5 mm} $', num2str(num_part), '$ \hspace{1.5 mm} Particles \hspace{1 mm} (Cartesian)$'], 'interpreter','latex', 'FontSize', 13);
xlabel('$x$', 'interpreter', 'latex', 'FontSize', 15)
ylabel('$y$','interpreter', 'latex', 'FontSize', 15)
zlabel('$z$','interpreter', 'latex', 'FontSize', 15)


%3D scatter plot in spherical graph
[theta, phi, r] = cart2sph(x(end,:), y(end,:), z(end,:));
figure(2);
scatter3(r, theta, phi, 'r.')
title(['$3D \hspace{1 mm} Random \hspace{1 mm} Walk \hspace{1 mm} Using \hspace{1.5 mm} $', num2str(num_part), '$ \hspace{1.5 mm} Particles \hspace{1 mm} (Spherical)$'], 'interpreter','latex', 'FontSize', 13);
xlabel('$r$', 'interpreter', 'latex', 'FontSize', 15)
ylabel('$\theta$','interpreter', 'latex', 'FontSize', 15)
zlabel('$\phi$','interpreter', 'latex', 'FontSize', 15)


%normalized gaussian pdf graph
nbins = 125;
figure(4);
h = histogram(r-mean(r),nbins);
v1 = vline(mean(r-mean(r)), 'k-');
v2 = vline(var(r-mean(r))^0.5, 'g');
v3 = vline(-var(r-mean(r))^0.5, 'g');
modeLoc = find(h.BinCounts == max(h.BinCounts));
v4 = vline(h.BinEdges(modeLoc)+h.BinWidth/2, 'r');
v5 = vline(median(r-mean(r)), 'y');
L = legend([v1,v3,v4,v5], ['$\mu = $', num2str(mean(r-mean(r)))], ['$\pm \sigma = \pm$', num2str(var(r-mean(r))^0.5)], ['$mode = $', num2str(h.BinEdges(modeLoc))], ['$median = $', num2str(median(r-mean(r)))], 'Location', 'Best');
set(L, 'interpreter', 'latex');
title(['$Skewed \hspace{1 mm} 3D \hspace{1 mm} Random \hspace{1 mm} Walk \hspace{1 mm} Histogram \hspace{1 mm} with \hspace{1 mm}$', num2str(num_part), '$\hspace{1 mm} Particles$'],'interpreter','latex')
xlabel('$r$','interpreter','latex')
ylabel('$frequency \hspace{1 mm} of \hspace{1 mm} occurance$','interpreter','latex')


%gaussian pdf graph
nbins = 125;
figure(5);
h = histogram(r,nbins);
v1 = vline(mean(r), 'k-');
v2 = vline(mean(r)+var(r)^0.5, 'g');
v3 = vline(mean(r)-var(r)^0.5, 'g');
modeLoc = find(h.BinCounts == max(h.BinCounts));
v4 = vline(h.BinEdges(modeLoc)+h.BinWidth/2, 'r');
v5 = vline(median(r), 'y');
L = legend([v1,v3,v4,v5], ['$\mu = $', num2str(mean(r))], ['$\pm \sigma = \pm$', num2str(var(r)^0.5)], ['$mode = $', num2str(h.BinEdges(modeLoc))], ['$median = $', num2str(median(r))], 'Location', 'Best');
set(L, 'interpreter', 'latex');
title(['$Skewed \hspace{1 mm} 3D \hspace{1 mm} Random \hspace{1 mm} Walk \hspace{1 mm} Histogram \hspace{1 mm} with \hspace{1 mm}$', num2str(num_part), '$\hspace{1 mm} Particles$'],'interpreter','latex')
xlabel('$r$','interpreter','latex')
ylabel('$frequency \hspace{1 mm} of \hspace{1 mm} occurance$','interpreter','latex')


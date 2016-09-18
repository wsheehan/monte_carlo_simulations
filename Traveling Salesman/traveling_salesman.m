% Simulated annealing for the traveling salesman problem
% 29 Bavarian cities

clear all;
% load in the coordinates of the Bavarian cities
coord=load('Capitals.txt');

cities = importdata('City_names.txt');

n=length(coord); % number of data points
x=zeros(n+1,1); y=zeros(n+1,1);

% City 1 is starting city
x(1)=coord(1,2); y(1)=coord(1,3);
% City 1 is also ending city
x(n+1)=x(1); y(n+1)=y(1);

% Find initial permutation (2,n)
perm = randperm(n-1)+1;
x(2:n)=coord(perm,2); y(2:n)=coord(perm,3); 

% minimum path
path=[1 perm n+1];

% initial minimum path
minpath=path
% Distance (energy) function
%dist = @(x1,y1) sqrt(x1^2+y1^2);

% define distribution
f = @ (E,Ts) exp(-E/Ts);

nsteps=10^5;
tdist=zeros(nsteps,1);
cdist=zeros(nsteps,1);
% Compute initial total distance
tempd=0;
for k=1:n
    k1=k+1;
    tempd=tempd + haversine(x(k),x(k1),y(k),y(k1));
end
tdist(1)=tempd;
%using geometric cooling (T=ab^t);
a=3; b=0.999999; T=a;

% Store initial distance for bookkeeping 
Bb=tdist(1);
naccept=0;
%Start loop
tic
for t=1:nsteps-1
    t1=t+1;
    % Generate a partial path reversal
    ppr=sort(randperm(n-1,2))+1;
    i=ppr(1); j=ppr(2);
    
    % path
    xnew=x; ynew=y; newpath=path; jlim=j;
    % new path
    for m=i:j
        xnew(m)=x(jlim);
        ynew(m)=y(jlim);
        newpath(m)=path(jlim);
        jlim=jlim-1;
    end
    
    % Compute new total distance
    tempd=0;
    for k=1:n
        k1=k+1;
        tempd=tempd+haversine(xnew(k),xnew(k1),ynew(k),ynew(k1));
    end
    if(tempd < tdist(t))
        x=xnew;
        y=ynew;
        path=newpath;
        tdist(t1)=tempd;
        naccept=naccept+1;
    elseif(rand < f(tempd-tdist(t),T))
        x=xnew;
        y=ynew;
        path=newpath;
        tdist(t1)=tempd;
        naccept=naccept+1;
    else
        tdist(t1)=tdist(t);
    end
    if(tdist(t1) < Bb)
        Bb=tdist(t1);
        minpath=path;
    end
    % Update temperature
    T=T*b;
end
toc
figure(1)
subplot(2,1,1),loglog(1:t+1,tdist,'k-.')
subplot(2,1,2),plot(minpath)
minpath
finalpath = cell(1,50);
for i=1:49
    k = minpath(i);
    finalpath(i) = cities(k);
end
finalpath(50) = cities(1);
disp('Initial Distance')
tdist(1)
disp('Final Distance')
tdist(nsteps)
disp('Final City Path')
finalpath
    
    
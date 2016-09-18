% Simulation of cells with an average life span and time before split
% Goal is to evaluate behavior of system

clear all

u = 1;
lambda_a = 1.1;                   % Change this to try different Labda values
nruns = 100;                      % Number of simulations
A = zeros(nruns,1);
dt = 0.001;

for j = 1:nruns
    count = [0, round(exprnd(1/u),3), round(exprnd(1/lambda_a), 3)]; % Initialize first cell
    t = 0;
    add = zeros(1,3);
    for t = 0:dt:4
        n = size(count,1);
        for i = 1:n
            if t == count(i,2) || t == count(i,3) % If a cell is set to die or split at t
                if count(i,2) > count(i,3)  % If the cell is going to split or not                    
                    t_split = round((t+exprnd(1/u,1,2)),3);
                    t_death = round((t+exprnd(1/u,1,2)),3);
                    count(i,:) = [t, t_death(1,1), t_split(1,1)]; % Repopulating old cell with new one                    
                    add = [t, t_death(1,2), t_split(1,2)]; % New cell to add 
                    count = [count; add]; % New Count
                else
                    count(i,:) = [0,0,0]; % Setting cell to zero because it has died
                end
            end
        end
        count( ~any(count,2), : ) = []; % Erasing rows that are all zeros
    end
    A(j) = size(count,1); % Tracking counts
end
histogram(A)
var(A)
mean(A)

% for lambda = 1, mean = 0.86, var = 3.37 for  one trial
% for lambda = 1.05, mean = 0.76, var = 3.13
% for lambda = 1.10, mean = 1.16, var = 13.57

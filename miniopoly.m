% Miniopoly
% Jan 18, 2016

clear;
% nruns is the number of simulations of 20 turn games
% y tracks the final money amount of each game

nruns = 10000;
y = zeros(1,nruns);

%======================================================
% money is the current funds of the player
% pos is the position of the player on the 40 block board
% instructions are the square #'s where the player draws a card
% card is a vector with the possible card values
% free are the square #'s where nothing happens
% die1 & die2 are the two dice rolled
% roll is the sum of the dice unless pos == 30 ...
% bonus is a random selection from the card vector
%======================================================

for j=1:nruns
    money = 200;
    pos = 0;
    instructions = [2,7,17,22,33,36];
    card = [50,100,200,-100,-150];
    free = [0,10,20];
    for i=1:20
        if money < 0
            disp('You Lost!')
            break
        end
        die1 = randi(6);
        die2 = randi(6);
        if pos == 30 && die1 ~= die2
            roll = 0;
        else
            roll = die1 + die2;
        end
        pos = mod((pos + roll),40);
        if roll > pos
            money = money + 200;
        end
        if any(pos==instructions)
            bonus = datasample(card,1);
            money = money + bonus;
        elseif pos == 30
            money = money - 10;
        elseif any(pos==free)
            money = money;
        else
            money = money - pos;
        end
    end
    y(j) = money;
end

hist(y) % A histogram of all the final money amounts

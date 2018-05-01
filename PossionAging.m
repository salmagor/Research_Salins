clear all
T = 400; % length of test
L = 10; % number of repetitions
P1 = 0.7; % prob. of birth
P0 = 1-P1; % prob. of death
dead = 0; % will log every trial that ends with death
deadvec = ones(1,L); % used to graph the avg number of pop that didnt die off
Lam = 0.01; % Lamda
Lamdis = 0.00005; % Lamda for disaster
total = zeros(L,20,2); % will be use for all the results
oops = 0; % used to find errors 
ds = 0 ; %DISASTER - used to see how many times disaster struck - no importance to the code

subplot(3,1,1);

hold
for g = 1:L % total number of iterations
    g   % marks where we are, just as the code can take some time
t = 0; % computation is fairly quick, dont really need to ini. vector
pop = 0; % restart the pop vector
age = 0; % restart the age vector
i = 1; % initialzing time and iteration variables.  the first generation is actuall i = 2, for convenience purposes


while t(i)<=T % each trial continues until the t value reaches or passes T
if find(age<=45) == 0
    oops = oops +1;
end

    if i == 1 % the first gen. is 1 (recall, first gen that is calculated is i = 2)
        pop(i) = 1;
        pop(i+1) = pop(i); % recording twice for a step graph
        total(g,i,1) = pop(i);
        total(g,i+1,1) = pop(i);
        else % the size of the the second generation is determind by P1.  the pop size can either increase or derease by 1.  note that both age and pop need to change.
            adults = find(age<=45 & age>=18);        
            k = rand;    
                if k <= Lamdis/((sum(adults)*Lam+Lamdis)) % based off of poisson variables and general probability
                k = -500;
                ds = ds +1 ;
                if length(age)<500
                    age = [];
                else
                age(1:500) = []; % this "kills" 500 in the population.  currently kills the oldest ones, may be replaced with a random function
                end
                elseif k <= (Lamdis/(sum(adults)*Lam+Lamdis)+(sum(adults)*Lam)/(sum(adults)*Lam+Lamdis)*P1)
                k = 1;
                age(end+1) = 0;
                else
                k = -1;
                age(1) = [];
                end
                
                
    pop(i) = pop(i-1)+k;
    pop(i+1) = pop(i);
    end    
    
    
    
total(g,i,1) = pop(i); % logs the size of the pop throughout the different trials
total(g,i+1,1) = pop(i);
    if pop(i) <= 0 % end the trial if the pop is 0 or below
        dead = dead + 1;
        deadvec(g) = 0;
        pop(i) = 0;
        pop(i+1) = 0; % step graphs 
        t(i+1) = 100;
        break
    end
   
nexttime = findtime(age,t,i,Lam); 
t(i+1) = t(i) + nexttime;
t(i+2) = t(i+1);
total(g,i+1,2) = t(i+1); % logs the time of the event, again double logging is used to create a step graph
total(g,i+2,2) = t(i+1);
i = i+2;
age = age+nexttime;
end
if t(end) > T % we want the last time to be T, but the actual last time can be bigger, smaller or equal to T.  This solves it
    t(end) = [];
    t(end) = T;
else
    t(end) = T;
end
total(g,1,2) = 1;
plot(t,pop); %limiting the length of t is needed becuase t 
%might be longer then pop if the trial ends with death
end
hold

% formats the plots

title(sprintf('Pop. Dist. for N trials = %d', L)); % formats the first graph - just putting all the graphs together
xtext = sprintf('time passed', T);
xlabel(xtext);
ylabel('Pop. size');
X = (1/5)*T;
Y = max(max(total(:,:,1)))*2/3;

text(X, Y,sprintf('u = %.2f', dead/g));

subplot(3,1,2); % the second plot is the avg of all the tests
endt = 50;
X = linspace(0,T,endt);
avgpop = zeros(1,endt);
for m = 1:endt
        if m == 1
        avg = (X(m))/2;
        else
        avg = (X(m-1)+X(m))/2;
        end
    for k = 1:L
        botlim = find(total(k,:,2)>=avg,1, 'first' );
            if isempty(botlim)
            M = 0;
            else
            M = total(k,botlim+1,1);
            end
        avgpop(m) = avgpop(m) + M;
    end
avgpop(m) = avgpop(m)/L;
end
plot(X(1:endt),avgpop)

title(sprintf('Avg. Pop. Dist. for N trials = %d, including dead pop', L));



subplot(3,1,3); % used to see the average when excluding the dead population vectors.  in reality not a big difference save for specific large disasters
index = find(deadvec == 1);
avgpopliv = zeros(1,endt);
X = linspace(0,T,endt);
for m = 1:endt
        if m == 1
        avg = (X(m))/2;
        else
        avg = (X(m-1)+X(m))/2;
        end
    for k = 1:length(index)
        botlim = find(total(index(k),:,2)>=avg,1, 'first' );
            if isempty(botlim)
            M = 0;
            else
            M = total(index(k),botlim+1,1);
            end
        avgpopliv(m) = avgpopliv(m) + M;
    end
avgpopliv(m) = avgpopliv(m)/length(index);
end
plot(X(1:endt),avgpopliv)

title(sprintf('Avg. Pop. Dist. for N trials = %d, excluding dead pop', L));


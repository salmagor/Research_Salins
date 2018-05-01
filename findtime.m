function nexttime = findtime(age,t,i,Lam)
% used to calculate when the next event will take place.  very generaly
% speaking this is a function of fertile adults and Lambda.

empty = [];
adults = find(age<=45 & age>=18);
if isempty(adults)
    randomtime = inf;
else
randomtime = -(log(1-rand))/(Lam*sum(adults)); % the time until the next event (birth or death) is calcuated by this formula, which depends on Lamda and the current pop size
end

if min(age)+randomtime > 18 || randomtime == inf
    timetoadult = 18-min(age);
    if timetoadult < 0
        timetoadult = [];
    end
else
    timetoadult = [];
end


if min(age(adults))+randomtime > 45
    timetoelder = 45-min(age(adults));
    if timetoelder == 0
        timetoelder = empty;
    end
else
    timetoelder = empty;
end

if isempty(timetoadult) && isempty(timetoelder)
    nexttime = randomtime;
elseif isempty(timetoadult) && ~isempty(timetoelder)
    nexttime = timetoelder;
elseif ~isempty(timetoadult) && isempty(timetoelder)
    nexttime = timetoadult;
elseif timetoadult < timetoelder
    nexttime = timetoadult;
else
    nexttime = timetoelder;   
end

end

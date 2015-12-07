%InFlow
fileID= fopen('InFlow.txt','w');

hours=96; %set number of hours
days=3; %set number of days
plants=1;
seasons=4;

% Set inflow in for each season


%Fill matrix
InflowSeason=[3 10 7 5]; %row=plant, column=season
hoursInSeason=hours/seasons;
teller=0;
Inflow=zeros(plants,hours);
for i=1:plants
    for k=1:seasons
        for j=1:hoursInSeason
            teller=teller+1;
            Inflow(i,teller)=InflowSeason(i,k);
        end
    end
end


fprintf(fileID,' %d',Inflow);


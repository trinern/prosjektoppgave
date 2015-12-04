%importer hours_years_vinddata.csv, matrise heter hoursyearsvinddata

%user input
Seasons=1;
S1=3; %number of scenarios generated first stage in season
MaxChange=0.4;

%Parameters
filename='FirstLevScenarios.xlsx';
ProdData=hoursyearsvinddata;
ConDays=4;
ConHours=24;
%Periods=365*24/Seasons/ConDays; %number of 3-day-periods in a year
HoursInSeason=24*356/Seasons;
Hours3Days=ConDays*ConHours;


S2=(S1^2); %number of scenarios generated second stage in season
S3=(S1^3); %number of scenarios generated third stage in season
U=1; %number of scenario trees for each season
Y=61;
MinHour=[1 (HoursInSeason+1) (2*HoursInSeason+1) (3*HoursInSeason+1)];
MaxHour=[(HoursInSeason-ConDays*ConHours) (2*HoursInSeason-ConDays*ConHours) (3*HoursInSeason-ConDays*ConHours) (4*HoursInSeason-ConDays*ConHours)];


TreeDim2=ConDays*ConHours;
scenarios0=zeros(Seasons,ConHours);%first level first stage forecast
scenarios1=zeros(Seasons,S1,ConHours);%first level second stage scenarios for season
scenarios2=zeros(Seasons,S2,ConHours);%first level third stage scenarios for season
scenarios3=zeros(Seasons,S3,ConHours);%first level fourth stage scenarios for season
Hours0=zeros(1,Seasons);
Tree=zeros(Seasons,S3,TreeDim2);

for k=1:Seasons
    H0=randi([MinHour(k),MaxHour(k)]);%first hour in scenario tree
    Hours0(k)=H0;
    y=randi(Y);
    for i=0:(ConHours-1)
        %Forecast first day, fills the node with 24 h of values from the same year
        scenarios0(k,(i+1))=ProdData(H0+i,y);
        lastValue=scenarios0(k,(i+1));
    end
    
    for j=1:S1%every scenario is a 24-h time series from a random year
        y=randi(Y);
        nextValue=ProdData(H0,y);
        while abs(lastValue-nextValue)/lastValue > MaxChange
            y=randi(Y);
            nextValue=ProdData(H0,y);
        end
        for i=0:(ConHours-1)
            %fills the scenario with 24 h of values from the same year
            scenarios1(k,j,(i+1))=ProdData(H0+i,y);
            lastValue=scenarios1(k,j,(i+1));
        end
    end
    
    H0=H0+24;
    for j=1:(S2)
        y=randi(Y);
        nextValue=ProdData(H0,y);
        while abs(lastValue-nextValue)/lastValue > MaxChange
            y=randi(Y);
            nextValue=ProdData(H0,y);
        end
        for i=0:(ConHours-1)
            %fills the scenario with 24 h of values from the same year
            scenarios2(k,j,(i+1))=ProdData(H0+i,y);
            lastValue=scenarios2(k,j,(i+1));
        end
    end
    H0=H0+24;
    for j=1:(S3)
        y=randi(Y);
        nextValue=ProdData(H0,y);
        while abs(lastValue-nextValue)/lastValue > MaxChange
            y=randi(Y);
            nextValue=ProdData(H0,y);
        end
        for i=0:(ConHours-1)
            %fills the scenario with 24 h of values from the same year
            scenarios3(k,j,(i+1))=ProdData(H0+i,y);
        end
    end
end
%Fills a matrix, Tree with all scenarios
m=1;
l=1;
for i=1:Seasons    
    for k=1:S3
        for j=1:ConHours 
            Tree(i,k,j)=scenarios0(i,j);
            Tree(i,k,j+ConHours)=scenarios1(i,m,j);
            Tree(i,k,j+2*ConHours)=scenarios2(i,l,j);
            Tree(i,k,j+3*ConHours)=scenarios3(i,k,j);
        end
            if mod(k,S2)==0
                m=m+1;
            end
            if mod(k,S1)==0
                l=l+1;
            end
    end
end


% %Beregner momentene i hvert tre
mom=zeros(4,Seasons*U,Hours3Days);
%mom(1,,)=mean, mom(2,,,)=st.dev, mom(3,,)=Skewness, mom(4,,)=kurt
tempV=zeros(S3,1);

for k=1:Seasons
    for h=1:Hours3Days
        for s=1:S3
           tempV(s,1)=Tree(k,s,h);
        end
       Mean=mean(tempV);
       Std=std(tempV);
       Skew=sum((tempV-Mean).^3)./S3./Std.^3;
       Kurt= sum((tempV-Mean).^4)./S3./Std.^4;
        mom(1,k,h)=Mean;
        mom(2,k,h)=Std;
        mom(3,k,h)=Skew;
        mom(4,k,h)=Kurt;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Beregner momenter i historiske data
histMom=zeros(4,Seasons*U,Hours3Days);
tempHistV=zeros(Y,1);
j=0;
for h=Hours0
    j=j+1;
    for i=0:(Hours3Days-1)
        for t=1:Y
            tempHistV(t)=ProdData(h+i,t);
        end
        Mean=mean(tempHistV);
        Std=std(tempHistV);
        Skew=sum((tempHistV-Mean).^3)./S3./Std.^3;
        Kurt= sum((tempHistV-Mean).^4)./S3./Std.^4;
        histMom(1,j,i+1)=Mean;
        histMom(2,j,i+1)=Std;
        histMom(3,j,i+1)=Skew;
        histMom(4,j,i+1)=Kurt;
    end
end

%¨Beregner Deviation av momenter og sum av dev av momenter
dev=zeros(4,Seasons*U,Hours3Days);
sumDev=0;
for i=1:4
    for j=1:Seasons*U
        for k=1:Hours3Days
            dev(i,j,k)=abs((mom(i,j,k)-histMom(i,j,k))/(histMom(i,j,k)*288));
            sumDev=sumDev+dev(i,j,k);
        end
    end
end

        
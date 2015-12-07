%importer hours_years_vinddata.csv, matrise heter hoursyearsvinddata

fileID= fopen('ScenariosLevel1.txt','w');

%user input
Seasons=4;
S1=10; %number of scenarios generated first stage in season
MaxChange=1;

%Parameters
filename='FirstLevScenarios.xlsx';
ProdData=hoursyearsvinddata;
ConDays=3;
ConHours=24;
%Periods=365*24/Seasons/ConDays; %number of 3-day-periods in a year
HoursInSeason=24*356/Seasons;
Hours3Days=ConDays*ConHours;
%HoursY=8760;


S2=(S1^2); %number of scenarios generated second stage in season
S3=(S1^3); %number of scenarios generated third stage in season
U=1; %number of scenario trees for each season
Y=61;
MinHour=zeros(1,Seasons);
MaxHour=zeros(1,Seasons);
TreeDim=ConDays*ConHours;
%scenarios0=zeros(Seasons,ConHours);%first level first stage forecast
scenarios1=zeros(Seasons,S1,ConHours);%first level second stage scenarios for season
scenarios2=zeros(Seasons,S2,ConHours);%first level third stage scenarios for season
scenarios3=zeros(Seasons,S3,ConHours);%first level fourth stage scenarios for season
Hours0=zeros(ConDays,Seasons);
Tree=zeros(Seasons,S3,TreeDim);

for i=1:Seasons
    MinHour(i)=(i-1)*HoursInSeason+1;
    MaxHour(i)=i*HoursInSeason-ConDays*ConHours;
end

for k=1:Seasons
    H0=randi([MinHour(k),MaxHour(k)]);%first hour in scenario tree
    Hours0(1,k)=H0;
    for j=1:S1%every scenario is a random 24-h time series within season from a random year
        y=randi(Y);
        for i=0:(ConHours-1)
            %fills the scenario with 24 h of values from the same year
            scenarios1(k,j,(i+1))=ProdData(H0+i,y);
            lastValue=scenarios1(k,j,(i+1));
        end
    end
    H0=randi([MinHour(k),MaxHour(k)]);
    Hours0(2,k)=H0;
    %H0=H0+24;
    for j=1:S2
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
    H0=randi([MinHour(k),MaxHour(k)]);
    Hours0(3,k)=H0;
    for j=1:S3
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

for i=1:Seasons    
    m=1;
    l=1;
    for k=1:S3
        
        for j=1:ConHours 
            Tree(i,k,j)=scenarios1(i,m,j);
            Tree(i,k,j+ConHours)=scenarios2(i,l,j);
            Tree(i,k,j+2*ConHours)=scenarios3(i,k,j);
        end
            if mod(k,S2)==0 && m<S1
                m=m+1;
            end
            if mod(k,S1)==0 && l<S2
                l=l+1;
            end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ny momentberegning basert på %-vis endring

% %Beregner momentene overgangen mellom dag 1 og 2, og dag 2 og 3 for alle
% sesonger
mom=zeros(Seasons,2,4);% 4 moments for 2 hours and every Season
%mom(,,1)=mean, mom(,,,2)=st.dev, mom(,,3)=Skewness, mom(,,4)=kurt
tempV=zeros(S3,1);

for k=1:Seasons
    for h=1:2
        t=h*24+1;
        for s=1:S3
           tempV(s)=(Tree(k,s,t)-Tree(k,s,t-1))/Tree(k,s,t-1);
        end
        Mean=mean(tempV);
        Std=std(tempV);
        Skew=sum((tempV-Mean).^3)./(S3-1)./Std.^3;
       	Kurt= sum((tempV-Mean).^4)./(S3-1)./Std.^4;
        mom(k,h,1)=Mean;
        mom(k,h,2)=Std;
        mom(k,h,3)=Skew;
        mom(k,h,4)=Kurt;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Beregner momenter i historiske data
histMom=zeros(Seasons,2,4);
tempHistV=zeros(Y,1);

for i=1:Seasons
    for j=1:2 
        t=Hours0(j+1,i);
        for k=1:Y
            tempHistV(k)=(ProdData(t,k)-ProdData(t-1,k))/ProdData(t-1,k);
        end
        Mean=mean(tempHistV);
        Std=std(tempHistV);
        Skew=sum((tempHistV-Mean).^3)./(Y-1)./Std.^3;
        Kurt= sum((tempHistV-Mean).^4)./(Y-1)./Std.^4;
        histMom(i,j,1)=Mean;
        histMom(i,j,2)=Std;
        histMom(i,j,3)=Skew;
        histMom(i,j,4)=Kurt;
    end
    
end

%Beregner Deviation av momenter og sum av dev av momenter
dev=zeros(Seasons,2,4);
sumDev=0;
for i=1:Seasons
    for j=1:2
        for k=1:4
            dev(i,j,k)=abs(histMom(i,j,k)-mom(i,j,k))/histMom(i,j,k);
            sumDev=sumDev+dev(i,j,k);
        end
    end
end

fprintf(fileID,' %f',Tree);

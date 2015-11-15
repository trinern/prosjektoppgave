%importer hours_years_vinddata.csv, matrise heter hoursyearsvinddata

filename='FirstLevScenarios.xlsx';
ProdData=hoursyearsvinddata;

ConDays=3;
ConHours=24;
Seasons=4;
Periods=365*24/Seasons/ConDays; %number of 3-day-periods in a year
HoursInSeason=24*356/Seasons;
Hours3Days=ConDays*ConHours;

S1=4; %number of scenarios generated first stage in season
S2=(S1^2); %number of scenarios generated second stage in season
S3=(S1^3); %number of scenarios generated third stage in season
U=1; %number of scenario trees for each season
Y=61;

TreeDim2=ConDays*ConHours;
scenarios1=zeros(S1,ConHours);%first level second stage scenarios for season
scenarios2=zeros((S2),ConHours);%first level third stage scenarios for season
scenarios3=zeros((S3),ConHours);%first level fourth stage scenarios for season
Hours0=zeros(1,Seasons);
Tree1=zeros(S3,TreeDim2);
Tree2=zeros(S3,TreeDim2);
Tree3=zeros(S3,TreeDim2);
Tree4=zeros(S3,TreeDim2);

%Season 1
H0=randi(HoursInSeason-ConDays*ConHours);%first hour in scenario tree
    for j=1:S1
        y=randi(Y);
        for i=0:(ConHours-1)
            scenarios1(j,(i+1))=ProdData(H0+i,y);
        end
    end
    Hours0(1)=H0;
    H0=H0+24;
    for j=1:(S2)
        y=randi(Y);
        for i=0:(ConHours-1)
            scenarios2(j,(i+1))=ProdData(H0+i,y);
        end
    end
H0=H0+24;
    for j=1:(S3)
        y=randi(Y);
        for i=0:(ConHours-1)
            scenarios3(j,(i+1))=ProdData(H0+i,y);
        end
    end

m=1;
l=1;
for k=1:S3
    for j=1:ConHours 
        Tree1(k,j)=scenarios1(m,j);
        Tree1(k,(j+ConHours))=scenarios2(l,j);
        Tree1(k,(j+2*ConHours))=scenarios3(k,j);
    end
        if mod(k,S2)==0
        m=m+1;
        end
        if mod(k,S1)==0
            l=l+1;
        end
end

%Season 2
H0=randi([(HoursInSeason+1),(2*HoursInSeason-ConDays*ConHours)]);%first hour in scenario tree
    for j=1:S1
        y=randi(Y);
        for i=0:(ConHours-1)
            scenarios1(j,(i+1))=ProdData(H0+i,y);
        end
    end
Hours0(2)=H0;
H0=H0+24;
    for j=1:(S2)
        y=randi(Y);
        for i=0:(ConHours-1)
            scenarios2(j,(i+1))=ProdData(H0+i,y);
        end
    end
H0=H0+24;
    for j=1:(S3)
        y=randi(Y);
        for i=0:(ConHours-1)
            scenarios3(j,(i+1))=ProdData(H0+i,y);
        end
    end

m=1;
l=1;
for k=1:S3
    for j=1:ConHours 
        Tree2(k,j)=scenarios1(m,j);
        Tree2(k,(j+ConHours))=scenarios2(l,j);
        Tree2(k,(j+2*ConHours))=scenarios3(k,j);
    end
        if mod(k,S2)==0
        m=m+1;
        end
        if mod(k,S1)==0
            l=l+1;
        end
end
 
 
%Season 3
H0=randi([(2*HoursInSeason+1),(3*HoursInSeason-ConDays*ConHours)]);%first hour in scenario tree
    for j=1:S1
        y=randi(Y);
        for i=0:(ConHours-1)
            scenarios1(j,(i+1))=ProdData(H0+i,y);
        end
    end
Hours0(3)=H0;
H0=H0+24;
    for j=1:(S2)
        y=randi(Y);
        for i=0:(ConHours-1)
            scenarios2(j,(i+1))=ProdData(H0+i,y);
        end
    end
H0=H0+24;
    for j=1:(S3)
        y=randi(Y);
        for i=0:(ConHours-1)
            scenarios3(j,(i+1))=ProdData(H0+i,y);
        end
    end

m=1;
l=1;
for k=1:S3
    for j=1:ConHours 
        Tree3(k,j)=scenarios1(m,j);
        Tree3(k,(j+ConHours))=scenarios2(l,j);
        Tree3(k,(j+2*ConHours))=scenarios3(k,j);
    end
        if mod(k,S2)==0
        m=m+1;
        end
        if mod(k,S1)==0
            l=l+1;
        end
end
 
%Season 4
H0=randi([(3*HoursInSeason+1),(4*HoursInSeason-ConDays*ConHours)]);%first hour in scenario tree
    for j=1:S1
        y=randi(Y);
        for i=0:(ConHours-1)
            scenarios1(j,(i+1))=ProdData(H0+i,y);
        end
    end
Hours0(4)=H0;
H0=H0+24;
    for j=1:(S2)
        y=randi(Y);
        for i=0:(ConHours-1)
            scenarios2(j,(i+1))=ProdData(H0+i,y);
        end
    end
H0=H0+24;
    for j=1:(S3)
        y=randi(Y);
        for i=0:(ConHours-1)
            scenarios3(j,(i+1))=ProdData(H0+i,y);
        end
    end

m=1;
l=1;
for k=1:S3
    for j=1:ConHours 
        Tree4(k,j)=scenarios1(m,j);
        Tree4(k,(j+ConHours))=scenarios2(l,j);
        Tree4(k,(j+2*ConHours))=scenarios3(k,j);
    end
        if mod(k,S2)==0
        m=m+1;
        end
        if mod(k,S1)==0
            l=l+1;
        end
end

%Beregner momentene i hvert tre

mom=zeros(4,Seasons*U,Hours3Days);
%mom(1,,)=mean, mom(2,,,)=st.dev, mom(3,,)=Skewness, mom(4,,)=kurt
tempV=zeros(S3,1);

%Season 1
for h=1:Hours3Days
    for s=1:S3
       tempV(s,1)=Tree1(s,h);
    end
   Mean=mean(tempV);
   Std=std(tempV);
   Skew=sum((tempV-Mean).^3)./S3./Std.^3;
   Kurt= sum((tempV-Mean).^4)./S3./Std.^4;
    mom(1,1,h)=Mean;
    mom(2,1,h)=Std;
    mom(3,1,h)=Skew;
    mom(4,1,h)=Kurt;
end
%Season 2
for h=1:Hours3Days
    for s=1:S3
       tempV(s)=Tree2(s,h);
    end
   Mean=mean(tempV);
   Std=std(tempV);
   Skew=sum((tempV-Mean).^3)./S3./Std.^3;
   Kurt= sum((tempV-Mean).^4)./S3./Std.^4;
    mom(1,2,h)=Mean;
    mom(2,2,h)=Std;
    mom(3,2,h)=Skew;
    mom(4,2,h)=Kurt;
end
%Season 3
for h=1:Hours3Days
    for s=1:S3
       tempV(s)=Tree3(s,h);
    end
   Mean=mean(tempV);
   Std=std(tempV);
   Skew=sum((tempV-Mean).^3)./S3./Std.^3;
   Kurt= sum((tempV-Mean).^4)./S3./Std.^4;
    mom(1,3,h)=Mean;
    mom(2,3,h)=Std;
    mom(3,3,h)=Skew;
    mom(4,3,h)=Kurt;
end
%Season 4
for h=1:Hours3Days
    for s=1:S3
       tempV(s)=Tree4(s,h);
    end
    Mean=mean(tempV);
    Std=std(tempV);
    Skew=sum((tempV-Mean).^3)./S3./Std.^3;
    Kurt= sum((tempV-Mean).^4)./S3./Std.^4;
    mom(1,4,h)=Mean;
    mom(2,4,h)=Std;
    mom(3,4,h)=Skew;
    mom(4,4,h)=Kurt;
end

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
            dev(i,j,k)=(mom(i,j,k)-histMom(i,j,k))/histMom(i,j,k);
            sumDev=sumDev+dev(i,j,k);
        end
    end
end

        
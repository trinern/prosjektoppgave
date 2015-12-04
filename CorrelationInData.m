%importer hours_years_vinddata.csv, matrise heter hoursyearsvinddata
ProdData=hoursyearsvinddata;
H=8760;
Y=61;
I=10;
%Beregn endring i abs i prosent fra time til time
change=zeros(I*(H-1),1);

for i=1:I
    y=randi(Y);
    for h=2:H
        a=ProdData(h-1,y);
        b=ProdData(h,y);
        change(i*h)=abs(b-a)/a;
%         if abs(b-a)/a > Max
%             Max=abs(b-a)/a;
%         elseif abs(b-a)/a < Min
%             Min=abs(b-a)/a;
%         end
    end
end
mean(change)
max(change)

%beregn korrelasjon mellom hver time

% V1=zeros(Y,1);
% V2=zeros(Y,1);
% 
% corr=zeros(H-1,1);
% 
% for i=1:(H-1)
%     V1=ProdData(i,1:Y);
%     V2=ProdData(i+1,1:Y);
%     SD1=std(V1);
%     SD2=std(V2);
%     mu1=mean(V1);
%     mu2=mean(V2);
%     tempSum=0;
%     for j=1:Y
%         tempSum=tempSum+(V1(j)-mu1)*(V2(j)-mu2);
%     end
%     corr(i)=tempSum/(SD1*SD2*(Y-1));
% end


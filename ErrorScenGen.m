


fileID1= fopen('ErrorScenarios.txt','w');
fileID2= fopen('ErrorScenariosProb.txt','w');

mean=-0.0005;
sigma=0.0534;

moments = {mean,sigma,0.1378,2.3859};
rng default  % For reproducibility
[r,type] = pearsrnd(moments{:},10,1);
pd2 = makedist('Normal',mean, sigma);
y = cdf(pd2,r);
z=[r,y];
c = sort(z, 1);

ProbMargin=1/(size(c,1)-1);
Size=size(c,1)-1;
tellerError=0;
tellerMod=2;
cMod(1,1)=c(1,1);
cMod(1,2)=c(1,2);
cMod(2,1)=c(2,1);
cMod(2,2)=c(2,2);
i=0;
while (i<=(Size-1))
    i=i+1;
    Tempy=cMod((i+1),2)-cMod(i,2);
    if (Tempy<ProbMargin*0.5)
        tempSize=size(cMod);
        if(i+1 < tempSize(1))
            cMod((i+1),1)=cMod(i,1);
            cMod((i+1),2)=cMod(i,2);
        elseif(i+1 >= tempSize(1) && tellerMod<size(c,1))
        tellerMod=tellerMod+1;
        cMod(tempSize(1),1)=cMod(i,1);
        cMod((tempSize(1)),2)= cMod(i,2);
        cMod((tempSize(1)+1),1)=c(tellerMod,1);
        cMod((tempSize(1)+1),2)=c(tellerMod,2);
        else
         tellerError=tellerError+1;
         Error(tellerError,1)=(cMod((i+1),1)+cMod(i,1))/2;
         Error(tellerError,2)=  (1-cMod(i,2));
        end
    elseif (Tempy>ProbMargin*1.5)
        Size=Size+2;
        tempSize=size(cMod);
        a=3;
        for j=tempSize:-1:(i+1)
            a=a-1;
            cMod((tempSize(1)+a),1)=cMod(j,1);
            cMod((tempSize(1)+a),2)=cMod(j,2);   
        end
        cMod(i+2,1)= (cMod((i+1),1)+cMod(i,1))/2;
        cMod((i+2),2)= cdf(pd2,cMod((i+2),1));
        cMod((i+1),1)=cMod(i,1);
        cMod((i+1),2)=cMod(i,2); 
    elseif (Tempy>=ProbMargin*0.5 && Tempy<=ProbMargin*1.5 && tellerMod<size(c,1))
      tellerError=tellerError+1;
      Error(tellerError,1)=(cMod((i+1),1)+cMod(i,1))/2;
      Error(tellerError,2)=  Tempy;
      tellerMod=tellerMod+1;
      tempSize=size(cMod);
      cMod((tempSize(1)+1),1)=c(tellerMod,1);
      cMod((tempSize(1)+1),2)=c(tellerMod,2);
    else
      tellerError=tellerError+1;
      Error(tellerError,1)=(cMod((i+1),1)+cMod(i,1))/2;
      Error(tellerError,2)=  Tempy;
    end          
end

Error(1,2)=Error(1,2)+ cMod(1,2);
length= size(Error);


Test=sum(Error);
Test(2)


fprintf(fileID1,' %f',Error(:,1));
fprintf(fileID2,' %f',Error(:,2));

clc;
clear;
A = 'C:\Users\Junyu\Desktop\WET\WETindex-21-N\A1.csv';%%sheet1 WET index A1 trend，A2 measure
B = 'C:\Users\Junyu\Desktop\WET\WETindex-21-N\B.csv';%%sheet2 wetland area 
C = 'C:\Users\Junyu\Desktop\WET\WETindex-21-N\C.csv';%%sheet3 DP
D = 'C:\Users\Junyu\Desktop\WET\WETindex-21-N\D.csv';%%sheet4 GHG and CI
E = 'C:\Users\Junyu\Desktop\WET\WETindex-21-N\E.csv';%%sheet5 countries
A=csvread(A);
B=csvread(B);
C=csvread(C);
D=csvread(D);
E=csvread(E);
S1 = nan(130,21,152);
S2 = nan(130,21,152);
S2SE = nan(130,21,152);
for i = 1:130 
    for j = 1:21
        for h = 1:152
            a = E(i,1);
            if C(i,j)>= h-1  %%h-1 
                S1(i,j,h)=A(h,a)-A(1,a);
            else b = h - C(i,j);
                S1(i,j,h)=A(h,a)-A(b,a);
            end
            if S1(i,j,h)>0
                S1(i,j,h)=0;
            end
            S2(i,j,h)= S1(i,j,h)*D(2,j)*B(i,j)/10000; %%D[1,j] type of GHGs，1-4 mean GHGs, NEE, CH4, N2O, 5-8 mean their CI
            S2CI(i,j,h)= S1(i,j,h)*D(6,j)*B(i,j)/10000; %%D[1,j] type of GHGs，1-4 mean GHGs, NEE, CH4, N2O, 5-8 mean their CI
        end
    end
end
%By countries
T1 = nan(130,152);
T2 = nan(130,152);
T3 = nan(130,152);

T1 = sum(S2,2); %%yearly-countries
T2 = sum(S2CI,2); %%yealy-countries 95%CI
T3 = cumsum(T1);  %%accumulation-countries
%%trend 
csvwrite('C:\Users\Junyu\Desktop\WET\WETindex-21-N\Output-netflux\NEP-reduce0.csv',T1);%A为A1,D[1,j]=GHG,D[2,j]=NEP
csvwrite('C:\Users\Junyu\Desktop\WET\WETindex-21-N\Output-netflux\NEP-reduce0-95CI.csv',T2);%A为A1,D[5,j]=GHG,D[6,j]=NEP


%By wetland categories

 T11 = nan(21,152);
 T22 = nan(21,152);
 for i=1:21;
     for j=1:152;
         T11(i,j)=sum(S2(:,i,j));%%year-category
         T22(i,j)=sum(S2CI(:,i,j));%%year-category 95%CI
     end
 end
 csvwrite('C:\Users\Junyu\Desktop\WET\WETindex-21-N\Output-netflux\type\NEP-type0.csv',T11);%A为A2,D[9,j]=GHG
 csvwrite('C:\Users\Junyu\Desktop\WET\WETindex-21-N\Output-netflux\type\NEP-type0-95CI.csv',T22);%A为A2,D[13,j]=GHG



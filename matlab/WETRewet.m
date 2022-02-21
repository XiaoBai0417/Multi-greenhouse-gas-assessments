clc;
clear;
A1 = 'C:\Users\Junyu\Desktop\WET\WETindex-21-N\A1.csv';%%sheet1 WET index  trend
A2 = 'C:\Users\Junyu\Desktop\WET\WETindex-21-N\A2.csv';%%sheet1 WET index measure
B = 'C:\Users\Junyu\Desktop\WET\WETindex-21-N\B.csv';%%sheet2 wetland area 
C = 'C:\Users\Junyu\Desktop\WET\WETindex-21-N\C.csv';%%sheet3 DP
D = 'C:\Users\Junyu\Desktop\WET\WETindex-21-N\D.csv';%%sheet4 GHG and CI
E = 'C:\Users\Junyu\Desktop\WET\WETindex-21-N\E.csv';%%sheet5 countries
A1=csvread(A1);
A2=csvread(A2);
B=csvread(B);
C=csvread(C);
D=csvread(D);
E=csvread(E);
S1 = nan(130,21,152);
S2 = nan(130,21,152);
for i = 1:130
    for j = 1:21
        for h = 1:152
            a = E(i,1);
            if C(i,j)>= 80
                if C(i,j)>= h-1  %%h-1 
                S1(i,j,h)=A2(h,a)-A2(1,a);
                else b = h - C(i,j);
                S1(i,j,h)=A2(h,a)-A2(b,a);
                end
            else     
                if C(i,j)>= h-1  %%h-1 
                S1(i,j,h)=A1(h,a)-A1(1,a);
                else b = h - C(i,j);
                S1(i,j,h)=A1(h,a)-A1(b,a);
                end
            end
            if S1(i,j,h)>0
                S1(i,j,h)=0;
            end
            S2(i,j,h)= S1(i,j,h)*D(1,j)*B(i,j)/10000; %%´Ë´¦D[1,j]type of GHGs£¬1-4 mean GHGs, NEE, CH4, N2O, 5-8 mean their CI
            S2CI(i,j,h)= S1(i,j,h)*D(5,j)*B(i,j)/10000; %%D[1,j]type of GHGs£¬1-4 mean GHGs, NEE, CH4, N2O, 5-8 mean their CI
        end
    end
end
T1 = nan(130,152);
T2 = nan(130,152);
T3 = nan(130,152);
T1 = sum(S2,2); %%yearly-countries
T2 = sum(S2CI,2); %%yealy-countries 95%CI
T3 = cumsum(T1);  %%accumulation-countries
%%Rewet highOCS
csvwrite('C:\Users\Junyu\Desktop\WET\WETindex-21-N\Output-netflux\GHG-reduce2.csv',T1);
csvwrite('C:\Users\Junyu\Desktop\WET\WETindex-21-N\Output-netflux\GHG-reduce2-95CI.csv',T2);


%By wetland categories

 T11 = nan(21,152);
 T22 = nan(21,152);
 for i=1:21;
     for j=1:152;
         T11(i,j)=sum(S2(:,i,j));%%year-category
         T22(i,j)=sum(S2CI(:,i,j));%%year-category 95%CI
     end
 end
 csvwrite('C:\Users\Junyu\Desktop\WET\WETindex-21-N\Output-netflux\type\GHG.csv',T11);%A==A2,D[1,j]=GHG
 csvwrite('C:\Users\Junyu\Desktop\WET\WETindex-21-N\Output-netflux\type\GHG-95CI.csv',T22);%A==A2,D[5,j]=GHG-CI

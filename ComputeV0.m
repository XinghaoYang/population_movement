K = 5; %K-means clustering parameter
[num,txt] = xlsread('2015-House data-EconomyIndustry-Crime-two parts.xlsx');
Num = num';
Norm_Num = zeros(64,111);
for i = 1 : 64
    [ma,I] = max(Num(i,:));
    for j = 1 : 111
        Norm_Num(i,j) = Num(i,j)/ma;
    end
end
combination = Norm_Num;
[W,H] = nnmf(combination,K);
V_0 = H';
S = xlswrite('V_0.xls',V_0);
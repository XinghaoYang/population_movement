[num,txt] = xlsread('Regional internal migration estimates (RIME) - Three domain Common.xls');
A = num(:,1);
D = num(:,2);
Sum_A = sum(A);
Sum_D = sum(D);
A_nsw = 90860*(1-0.2193); %The proportion is computed and saved in "Regional internal 
D_nsw = 99760*(1-0.229);  %migration estimates (RIME) - Uncommon.xls"

A_net = zeros(111,1);
D_net = zeros(111,1);

for i = 1 : 111
    A_net(i) = A(i) - (A(i)/Sum_A) * A_nsw;
    D_net(i) = D(i) - (D(i)/Sum_D) * D_nsw;
end

V_0 = csvread('V_0.csv');
%Rescale the sum probability of each row of V_0 to 1
for i = 1 : 111
    V_0_Sum_i = sum(V_0(i,:));
    if V_0_Sum_i ~= 0
        V_0(i,:) = V_0(i,:) / V_0_Sum_i;
    else
        disp('hello world');
    end
end
V_01 = V_0(1:9,:);
V_02 = V_0(10:end,:);

A_net1 = A_net(1:9,1);
A_net2 = A_net(10:end,1);
D_net1 = D_net(1:9,1);
D_net2 = D_net(10:end,1);

K =5;
VA1 = zeros(9,K);
VA2 = zeros(102,K);
VD1 = zeros(9,K);
VD2 = zeros(102,K);
for i = 1 : K
    VA1(:,i) = V_01(:,i) .* A_net1;
    VA2(:,i) = V_02(:,i) .* A_net2;
    VD1(:,i) = V_01(:,i) .* D_net1;
    VD2(:,i) = V_02(:,i) .* D_net2;
end

%SOURCE = VA1 * VD2';
%DESTINATION = VD1 * VA2';
SOURCE = V_01 * VD2';
DESTINATION = VD1 * V_02';
%Rescale the total number of arrival/departure of each LGA into the RIME Net
for i = 1 : 9
    Sum_Source_i = sum(SOURCE(i,:));
    Sum_Destination_i = sum(DESTINATION(i,:));
    Scale_Source = A_net(i) / Sum_Source_i;
    Scale_Destination = D_net(i) / Sum_Destination_i;
    SOURCE(i,:) = SOURCE(i,:) * Scale_Source;
    DESTINATION(i,:) = DESTINATION(i,:) * Scale_Destination;
end
SOURCE = round(SOURCE);
DESTINATION = round(DESTINATION);
xlswrite('SOURCE.xls',SOURCE);
xlswrite('DESTINATION.xls',DESTINATION);

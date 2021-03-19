close all

alpha0 = 0.1; %0.261799; %rad
V0 = 0.5; % chords/s
k = alpha0*V0^2;

alpha_qs = k./(vel(:,1).^2);


figure(1)
plot(t_array,alpha*180/pi)
hold on
plot(t_array,alpha_qs*180/pi)
xlabel("t")
ylabel("alpha [deg]")
legend("PM","QS")

figure(2)
plot(-pos(:,1),alpha*180/pi)
hold on
plot(-pos(:,1),alpha_qs*180/pi)
xlabel("s")
ylabel("alpha [deg]")
legend("PM","QS","Location","southeast")
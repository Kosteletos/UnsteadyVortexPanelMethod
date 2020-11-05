load("PIVData/PIV-Vel_322_Angle_45_Acc_50")

lift = PIV.Lift;
t = PIV.Time;

plot(t,lift)
legend("Experimental Lift",'northwest');
xlabel("Time (s)")
ylabel("Lift (N)")
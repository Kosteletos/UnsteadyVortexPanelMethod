load("PIVData/PIV-Vel_322_Angle_45_Acc_50")

PIVlift = PIV.Lift;
PIVt = PIV.Time - PIV.Time(1);

plot(PIVt,PIVlift)
legend("Experimental Lift",'northwest');
xlabel("Time (s)")
ylabel("Lift (N)")
function  plotLiftAlpha(alpha_dLift_vec, tc)
% Plot of lift vs alpha while minimising delta_lift

alpha = nonzeros(alpha_dLift_vec(tc,:,1));
deltaLift = nonzeros(alpha_dLift_vec(tc,:,2));
figure(2)
plot(alpha(2:end)*180/pi,deltaLift(2:end));
xlabel('alpha [deg]');
ylabel('Lift Delta');
end


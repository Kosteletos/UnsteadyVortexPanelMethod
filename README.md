# UnsteadyVortexPanelMethod
* 2-D unsteady point vortex panel method 
* Based on a method outlined in Low-Speed Aerodynamics - J. Katz, A. Plotkin
* Considers a translating and rotating flat plate shedding leading edge and trailing edge vorticity
* Forces are solved for via the impulse method, and are split into circulatory and added-mass components
* An iterative solver is used to mitigate the effect of streamwise gusts (i.e. solving for the angle of attack that produces a given lift)

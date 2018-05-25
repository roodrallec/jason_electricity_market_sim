// Agent buyer in project electricity_market.mas2j

/* Initial beliefs and rules */
sensitivity(0.5).

/* Initial goals */
!initialize.
/* Plans */

+newDecision(Price) 
    : consumption(C) & profitPerUnit(UnitProfit)
	& sensitivity(S) & potential(Potential) & trader(Trader)
	<- if (Price > UnitProfit) {
	       NewProduction = C * S;
	   } else {
	       NewProduction = C + S *(Potential- C);
	   }
	   .send(logger, tell, need(NewProduction));
	   .send(Trader, tell, energyNeeds(NewProduction)).
	   -newDecision(Price)[source(Trader)].
	

+!findTrader
	<- .my_name(Me);
	   .send(tradersProvider, tell, prosumer(Me)).

+!initialize
    <- !initializePotential;
	   !initializeProfits;
	   !initializeConsumption;
	   !findTrader.
	   
	   
+!initializePotential // 10 - 200
	<- .random(R);
	   Potential = 190 * R + 10;
	   +potential(Potential).
	   
+!initializeProfits // 5-15 Willingness to pay
	<- .random(R);
	   Cost = 10 * R + 5;
	   +profitPerUnit(Cost).
	   
+!initializeConsumption : potential(P) // 0-potential
	<- .random(R);
	   InitialConsumption = P * R;
	   +consumption(0, InitialConsumption).

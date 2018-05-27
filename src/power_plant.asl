// Agent buyer in project electricity_market.mas2j

/* Initial beliefs and rules */
sensitivity(0.5).

/* Initial goals */
!initialize.

/* Plans */
+!initialize
    <- 	!initializePotential;
	   	!initializeCosts;
		!initializeProduction;
		!findTrader.
	   
+!initializePotential // 100 - 1000
	<-	.random(R);
	   	Potential = 900 * R + 100;
		+potential(Potential).
	   
+!initializeCosts // 5-15
	<- 	.random(R);
	   	Cost = 10 * R + 5;
		+costPerUnit(Cost).
	   
+!initializeProduction : potential(P) // 0-potential
	<- 	.random(R);
	   	InitialProduction = P * R;
		+production(InitialProduction).
	  
+!newDecision(Price) 
    : 	production(P) & costPerUnit(UnitCost)
	& 	sensitivity(S) & potential(Potential) & trader(Trader)
	<- 	if (Price < UnitCost) {
			NewProduction = P * S;
		} else {
			NewProduction = P + S * (Potential- P);
		}
		-+production(NewProduction)
		.print("newProduction", NewProduction);
		.send(logger, achieve, logProduction(NewProduction, Potential));
		.send(Trader, tell, energyNeeds(-NewProduction)).
	

+!findTrader
	<- 	.my_name(Me);
	   	.send(trader_profiler, achieve, prosumer(Me)).


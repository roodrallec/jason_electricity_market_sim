// Agent buyer in project electricity_market.mas2j

/* Initial beliefs and rules */
sensitivity(0.5).

/* Initial goals */
!initialize.

/* Plans */
+!initialize
    <- 	!initializePotential;
	   	!initializeProfits;
		!initializeConsumption;
		!findTrader.

+!initializePotential // 10 - 200
	// <- 	.random(R);
	//    	Potential = math.round((190 * R) + 10);
  <-   Potential = 170;
		+potential(Potential).

+!initializeProfits // 5-15 Willingness to pay
	<- 	.random(R);
	   	Cost = math.round(10 * R + 5);
		+profitPerUnit(Cost).

+!initializeConsumption : potential(P) // 0-potential
	<- 	.random(R);
	   	InitialConsumption = math.round(P * R);
		+consumption(InitialConsumption).

+!findTrader
	<- 	.my_name(Me);
	   	.send(trader_profiler, achieve, prosumer(Me)).

+!newDecision(Price)
	: 	consumption(C) & profitPerUnit(UnitProfit)	& sensitivity(S) & potential(Potential) & trader(Trader)
	<-	if (Price > UnitProfit) {
	       	NewProduction = C * S;
		} else {
			NewProduction = C + S *(Potential- C);
		}
		.print("factory");
		.send(simulator, achieve, logNeed(NewProduction));
		.send(Trader, tell, energyNeeds(NewProduction)).






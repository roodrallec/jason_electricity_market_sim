// Agent buyer in project electricity_market.mas2j

/* Initial beliefs and rules */
sensitivity(0.5).

/* Initial goals */
!initialize.

/* Plans */
+!initialize
    <- !initializeNeeds;
	   !findTrader.
	   
+!initializeNeeds // -5 - 5
	<- 	.random(R);
	   	Need = 10 * R - 5;
		+needs(Need).

+!findTrader
	<- 	.my_name(Me);
	   	.send(trader_profiler, achieve, prosumer(Me)).
	   
+!newDecision(Price) 
    :  	needs(Need) & trader(Trader)
	<- 	if (Need > 0) {
			.send(logger, achieve, logNeed(Need));
		} else {
			.send(logger, achieve, logProduction(-Need));
			.send(logger, achieve, logPotential(-Need));
		}
		.send(Trader, tell, energyNeeds(Need)).
	   

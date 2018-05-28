// Agent buyer in project electricity_market.mas2j

/* Initial goals */
!initialize.

/* Plans */
+!initialize
    <- !initializeNeeds;
	   !findTrader.

+!initializeNeeds // -5 - 5
//randomness here
	// <- 	.random(R);
  <-   Need = 3;
		+needs(Need).

+!findTrader
	<- 	.my_name(Me);
	   	.send(trader_profiler, achieve, prosumer(Me)).

+!newDecision(Price)
    :  	needs(Need) & trader(Trader)
	<- 	if (Need > 0) {
			.send(simulator, achieve, logNeed(Need));
		} else {
			.send(simulator, achieve, logProduction(-Need));
			.send(simulator, achieve, logPotential(-Need));
		}
		.send(Trader, tell, energyNeeds(Need)).


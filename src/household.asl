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
<<<<<<< HEAD

+!newDecision(Price)
    :  	needs(Need) & trader(Trader)
	<- 	if (Need > 0) {
=======
	   
+!newDecision(Price) 
    :  	needs(N) & trader(Trader)
	<- 	.random(R);
		Need = N + 4 * (R - 0.5);
		if (Need > 0) {
>>>>>>> market_regulation
			.send(simulator, achieve, logNeed(Need));
		} else {
			.send(simulator, achieve, logProduction(-Need));
			.send(simulator, achieve, logPotential(-Need));
		}
		.send(Trader, tell, energyNeeds(Need)).


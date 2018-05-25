// Agent buyer in project electricity_market.mas2j

/* Initial beliefs and rules */
sensitivity(0.5).

/* Initial goals */
!initialize.
/* Plans */

+newDecision(Turn, Price) 
    :  needs(Need) & trader(Trader)
	<- 
	   if (Need > 0) {
	       .send(logger, tell, need(Need));
	   } else {
	       .send(logger, tell, produced(-Need, -Need));
	   }
	   .send(Trader, tell, energyNeeds(Need));
	   -newDecision(Price)[source(Trader)].

+!findTrader
	<- .my_name(Me);
	   .send(tradersProvider, tell, prosumer(Me)).
	   
+!initialize
    <- !initializeNeeds;
	   !findTrader.
	   
	   
+!initializeNeeds // -5 - 5
	<- .random(R);
	   Need = 10 * R - 5;
	   +needs(Need).
	   

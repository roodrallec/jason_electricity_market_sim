// Agent buyer in project electricity_market.mas2j

/* Initial beliefs and rules */
energyNeeded(0).
currentBalance(0).
head([H|T],Head) :- Head = H.

/* Initial goals */
!findProsumer.

/* Plans */	
+!findProsumer
	<- 	.my_name(Me);
	   	.send(trader_profiler, achieve, trader(Me)).
	                          
+!trade
	: 	energyNeeded(E) & currentBalance(B) & prosumer(P, X)
	<- 	.my_name(Me);	    
        .print("Requesting trade from regulator for prosumer ", P, " at pos ", X);
		if(E > 0 & E - B > 0) {      
			.print("Buying ", E-B, " units")
		    .send(network_regulator, achieve, buyer(Me, E - B, X));
		}
		if(E < 0 & B - E > 0) {      
			.print("Selling ", B-E, " units")
		    .send(network_regulator, achieve, seller(Me, B - E, X));
		}.

+!acceptTrade(E_traded) 
	: 	currentBalance(B) & energyNeeded(E) 
	<- 	.print("I traded ", E_traded," amount of energy");
		-+currentBalance(B + E_traded); // -+ necessary
		.my_name(Me); 
		if(E == B ) {      
			.print("I ", Me," am happy now, I have enough energy");
		} else {
		  	!trade;
		}.

+!priceUpdate(Price)
    : 	prosumer(P, X) 
	<-  .send(P, achieve, newDecision(Price)).
	
+energyNeeds(E) 
	: prosumer(P, X)  
	<-	-+energyNeeded(E);
      	-+currentBalance(0);
		-energyNeeds(E)[source(P)];
		!trade.
	

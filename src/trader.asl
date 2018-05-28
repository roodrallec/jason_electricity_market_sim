// Agent buyer in project electricity_market.mas2j

/* Initial beliefs and rules */
needsEnergy(0).
hasEnergy(0).

/* Initial goals */
!findProsumer.

/* Plans */	
+!findProsumer
	<- 	.my_name(Me);
	   	.send(trader_profiler, achieve, trader(Me)).
	                          
+!trade
	: 	needsEnergy(N) & hasEnergy(H) & prosumer(P, X)
	<- 	.my_name(Me);	    		
		if (N > 0) {
			.print("Trying to buy ", N, " units");
			.send(network_regulator, achieve, buyer(Me, N, X));
		}
		if (H > 0) {
			.print("Trying to sell ", H, " units");
			.send(network_regulator, achieve, seller(Me, H, X));
		}
		if (N == 0 & H == 0) {
			.print("I traded all my energy");
		}.

+!sold(E_traded)
	:	hasEnergy(H)
	<- 	.my_name(Me);
		.print("I sold ", E_traded," amount of energy");
		-+hasEnergy(H - E_traded);
		!trade.

+!bought(E_traded)
	:	needsEnergy(N)
	<- 	.my_name(Me);
		.print("I sold ", E_traded," amount of energy");
		-+needsEnergy(N - E_traded);
		!trade.

+!priceUpdate(Price)
    : 	prosumer(P, X) 
	<-  .send(P, achieve, newDecision(Price)).
	
+energyNeeds(E) 
	: 	prosumer(P, X)  
	<-	if(E > 0) {
			-+needsEnergy(E);
			-+hasEnergy(0);
		}
		if (E < 0) {
			-+hasEnergy(math.round(math.sqrt(E*E)));
			-+needsEnergy(0);
		}		
		!trade.
	

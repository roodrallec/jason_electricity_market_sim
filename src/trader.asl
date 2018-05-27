// Agent buyer in project electricity_market.mas2j

/* Initial beliefs and rules */
managers([]).
energyNeeded(0).
currentBalance(0).
head([H|T],Head) :- Head = H.


/* Initial goals */
!findProsumer.	

/* Plans */
+manager(M) 
	: 	managers(Managers) 
	<- 	-+managers([M|Managers]).
	
+!findProsumer
	<- 	.my_name(Me);
	   	.send(trader_profiler, achieve, trader(Me)).
	                          
+!trade
	: 	energyNeeded(E) & currentBalance(B) & managers(Managers) 
	<- 	.my_name(Me);
	    .shuffle(Managers, Shuffled);
		?head(Shuffled, H);
	    .print("I need ", E," amount of energy balance:", B);
        .print("Requesting trade from manager ", H);
		if(E > 0 & E - B > 0) {      
		    .send(H, achieve, buyer(Me, E - B));
		}
		if(E < 0 & B - E > 0) {      
		    .send(H, achieve, seller(Me, B - E));
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

+!newTurn(Price)
    : 	prosumer(Who) 
	<-  .send(Who, achieve, newDecision(Price)).
	
+energyNeeds(E) : prosumer(Who)  
	<-	-+energyNeeded(E);
      	-+currentBalance(0);
		-energyNeeds(E)[source(Who)];
		!trade.
	

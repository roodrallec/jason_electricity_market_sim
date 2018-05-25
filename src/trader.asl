// Agent buyer in project electricity_market.mas2j

/* Initial beliefs and rules */
managers([]).
head([H|T],Head) :- Head = H.
/* Initial goals */
!findProsumer.	
/* Plans */

+manager(M) : managers(Managers) <- 
    -+managers([M|Managers]).
	
+!findProsumer
	<- .my_name(Me);
	   .send(tradersProvider, tell, trader(Me)).
	                          
+!trade
	: energy_needed(E) & currentBalance(B) &  B > E  & managers(Managers)
	<- 	.my_name(Me);
	    .shuffle(Managers, Shuffled);
		?head(Shuffled, H);
	    .print("I need ", E - B," amount of energy");
        .print("Requesting trade from manager ", H);
		if(E > 0) {      
		    .send(H, tell, buyer(Me, E - B));
		}
		if(E < 0) {      
		    .send(H, tell, seller(Me, B - E));
		}.

+traded(E_traded) 
	: currentBalance(B) & energy_needed(E) 
	<- .print("I traded ", E_bought," amount of energy");
	    newBalance = B + E_traded;
		-+currentBalance(newBalance); // -+ necessary
		.my_name(Me); 
		if(E > 0 & B >= E) {      
		    .print("I ", Me," am happy now, I have enough energy");
		} else {
		    if(E < 0 & B <= E) {      
		        .print("I ", Me," am happy now, I sold enough energy");
		    } else {
			   !trade;
			}
		}.

+newTurn(Price)
    : prosumer(Who) 
	<-  .send(Who, tell, newDecision(Price));
		-newTurn(Price)[source(logger)].
	
+energyNeeds(E) 
   <- -+energy_needed(C);
      -+currentBalance(0);
	  !trade.
	

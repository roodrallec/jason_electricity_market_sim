// Agent network_manager in project electricity_market.mas2j

/* Initial beliefs and rules */

/* Initial goals */
!greet.
/* Plans */

+!buyer(Agent, E) <- 
    +buyer(Agent, E);
	//.print("finding energy ", E, " for agent ", Agent);
	!pair.
	
+!seller(Agent, E) <- 
    +seller(Agent, E);
	//.print("finding energy ", E, " for agent ", Agent);
	!pair.

+!greet : true <-
    .my_name(Me);
    .broadcast(tell, manager(Me)).
	
+newTurn(Price)
    : prosumer(Who) 
	<-  .abolish(buyer(_, _));
	    .abolish(seller(_, _));
		-newTurn(Price)[source(logger)].
	
+!pair : buyer(B_agent, E_buying) & seller(S_agent, E_selling)  <-
	//.print("pairing buyer agent ", B_agent, " with seller agent ", S_agent);
	//.print("pairing buyer agent ", E_buying, " with seller agent ", E_selling);
	.min([E_selling, E_buying], AgreedAmount);
	//.print("They agree on amount ", AgreedAmount);
	-buyer(B_agent, E_buying);
	-seller(S_agent, E_selling);
	.send(B_agent, achieve, acceptTrade(AgreedAmount));
	.send(S_agent, achieve, acceptTrade(-AgreedAmount));
	.send(logger, achieve, logTrade(S_agent, B_agent, AgreedAmount)).
	


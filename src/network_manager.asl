// Agent network_manager in project electricity_market.mas2j

/* Initial beliefs and rules */
transaction_cap(50).
/* Initial goals */
!greet.
/* Plans */

+buyer(Agent, E) : true <- 
	.print("finding energy ", E, " for agent ", Agent);
	!pair.
	
+seller(Agent, E) : true <- 
	.print("finding energy ", E, " for agent ", Agent);
	!pair.

+!greet : true <-
    .my_name(Me);
    .broadcast(tell, manager(Me)).
	
+!pair : buyer(B_agent, E_buying) & seller(S_agent, E_selling) & transaction_cap(T_cap)  <-
	.print("pairing buyer agent ", B_agent, " with seller agent ", S_agent);
	.min([E_selling, E_buying, T_cap], AgreedAmount);
	.print("They agree on amount ", AgreedAmount);
	-buyer(B_agent, E_buying)[source(B_agent)];
	-seller(S_agent, E_selling)[source(S_agent)];
	.send(B_agent, tell, traded(AgreedAmount));
	.send(S_agent, tell, traded(-AgreedAmount));
	.send(logger, tell, trade(S_agent, B_agent, AgreedAmount)).
	


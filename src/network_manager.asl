// Agent netwwork_manager in project electricity_market.mas2j

/* Initial beliefs and rules */

/* Initial goals */


/* Plans */

+buying(E) : true <- 
	.print("finding energy ", E, " for agent ", buyer);
	+needs(buyer, E);
	!!pair.
	
+selling(E) : true <- 
	.print("finding energy ", E, " for agent ", seller);
	+has(seller, E);
	!!pair.
	
+!pair : needs(B_agent, E_buying) & has(S_agent, E_selling) <-
	.print("pairing buyer agent ", B_agent, " with seller agent ", S_agent);
	.send(buyer, tell, bought(E_selling));
	.send(seller, tell, sold(E_buying)).
	

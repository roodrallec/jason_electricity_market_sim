// Agent network_manager in project electricity_market.mas2j

/* Initial beliefs and rules */
transaction_cap(50).
snum(0).
sact(0).
bnum(0).
bact(0).

/* Initial goals */
!greet.

/* Plans */
+!buyer(Agent, E)
	: 	seller(Seller,Sell,S) & sact(S)  
	<-	-seller(Seller,Sell,S);
    	-+sact(S+1);
		//.print("finding energy ", E, " for agent ", Agent);
		!pair(Agent, Seller, E, Sell).

+!buyer(Agent, E) 
	: 	bnum(B)  
	<- 	-+bnum(B+1);
    	+buyer(Agent, E, B).
	
+!seller(Agent, E) 
	: 	buyer(Buyer, Buy, B) & bact(B) 
	<- 	-buyer(Buyer, Buy,B);
    	-+bact(B+1);
		//.print("finding energy ", E, " for agent ", Agent);
		!pair(Buyer, Agent, Buy, E).

+!seller(Agent, E) 
	: 	snum(S)  
	<- 	-+snum(S+1);
    	+seller(Agent, E, S).
	
+!greet 
	: 	true 
	<-	.my_name(Me);
    	.broadcast(tell, manager(Me)).
	
+newTurn(Price)
    : 	prosumer(Who) 
	<-  .abolish(buyer(_, _, _));
	    .abolish(seller(_, _, _));
		-+snum(0);
        -+sact(0);
        -+bnum(0);
        -+bact(0);
		-newTurn(Price)[source(logger)].
	
+!pair(B_agent, S_agent, E_buying, E_selling) 
	<-	//.print("pairing buyer agent ", B_agent, " with seller agent ", S_agent);
		//.print("pairing buyer agent ",B_agent,"  ", E_buying, " with seller agent ",S_agent,"  ", E_selling);
		.min([E_selling, E_buying], AgreedAmount);
		//.print("They agree on amount ", AgreedAmount);
		.send(B_agent, achieve, acceptTrade(AgreedAmount));
		.send(S_agent, achieve, acceptTrade(-AgreedAmount));
		.send(logger, achieve, logTrade(S_agent, B_agent, AgreedAmount)).
	
+!pairBuyer(S_agent, N)
	:	true 
	<- 	true.
	
+!pairSeller(S_agent, N) 
	: 	buyer(B_agent, E_buying, N) & seller(S_agent, E_selling, A) & bact(B)  
	<-	-+bact(B+1);
		//.print("pairing buyer agent ", B_agent, " with seller agent ", S_agent);
		.print("pairing buyer agent ",B_agent,"  ", E_buying, " with seller agent ",S_agent,"  ", E_selling);
		.min([E_selling, E_buying], AgreedAmount);
		.print("They agree on amount ", AgreedAmount);
		-buyer(B_agent, E_buying, N);
		-seller(S_agent, E_selling, A);
		.send(B_agent, achieve, acceptTrade(AgreedAmount));
		.send(A, achieve, acceptTrade(-AgreedAmount));
		.send(logger, achieve, logTrade(S_agent, B_agent, AgreedAmount)).
	
+!pairSeller(S_agent, N)
	:	true 
	<- 	true.

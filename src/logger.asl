// Agent buyer in project electricity_market.mas2j

/* Initial beliefs and rules */
turn(0).
price(0, 10).
production(0, 0, 0).
consumption(0, 0).
needs(0, 0).
trades(0,[]).
adjustPrice(OldPrice, Production, Consumption, NewPrice) :- NewPrice = OldPrice.	
/* Initial goals */
!makeNewTurn.
/* Plans */

+!logProduction(Amount, Potential) 
    : turn(T) & production(T, A, P) 
	  <- //.print("adding: ", A, " potential ", Potential);
     	-+production(T, A + Amount, P + Potential).	
	
+!logNeed(Need) 
    : turn(T) & needs(T, N)
	<- //.print("need ", Need);
	   -+needs(T, N + Need).
	   
+!logTrade(Seller, Buyer, Amount) 
    : turn(T) & trades(T, List) & consumption(T, C)
	<- -+trades(T, [[Seller, Buyer, Amount]|List]);
	   //.print("logTrade", Amount , C);
	   -+consumption(T, C + Amount).

+!makeNewTurn
	: turn(T) & price(T, OldPrice) & production(T, A, P) & consumption(T, C) & needs(T, N)        
	<- 	.wait(10000);
	    .print("produced: ", A, " potential ", P);
		.print("consumed: ", C, " need ", N);
	    .print("new turn begins ", T + 1);
	    +trades(T+1, []);
	    +production(T+1, 0, 0);
	    +consumption(T+1, 0);
		+needs(T+1, 0);
	    -+turn(T+1);
		?adjustPrice(OldPrice, P, C, Price);
		+price(T+1, Price);
		.broadcast(tell, newTurn(Price));
		.wait(10000);
		!makeNewTurn.


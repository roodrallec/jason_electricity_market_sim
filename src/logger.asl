// Agent buyer in project electricity_market.mas2j

/* Initial beliefs and rules */
turn(0).
price(0, 10).
production(0, 0, 0).
adjustPrice(OldPrice, Production, Consumption, NewPrice) :- NewPrice = OldPrice.	
/* Initial goals */
!makeNewTurn.
/* Plans */

+produced(Amount, Potential) 
    : turn(T) & production(T, A, P) 
	  <- .print("adding: ", A, " potential ", Potential);
     	-+production(T, A + Amount, P + Potential).	
	
+need(Need) 
    : turn(T) & consumption(T, C, N)
	<- -+consumption(T, C, N + Need).
	   
+trade(Seller, Buyer, Amount) 
    : turn(T) & trades(T, List) & consumption(T, C, N)
	<- -+trades(T, [[Seller, Buyer, Amount]|List]);
	   -+consumption(T, C + Cons, N).

+!makeNewTurn
	: turn(T) & price(T, OldPrice) & production(T, A, P)
	<- 	.wait(2000);
	    .print("produced: ", A, " potential ", P);
	    .print("new turn begins ", T + 1);
	    +trades(T+1, []);
	    +production(T+1, 0, 0);
	    +consumption(T+1, 0);
	    -+turn(T+1);
		?adjustPrice(OldPrice, P, C, Price);
		+price(T+1, Price);
		.broadcast(tell, newTurn(Price));
		.wait(2000);
		!makeNewTurn.


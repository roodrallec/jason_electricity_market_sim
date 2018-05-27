// Agent buyer in project electricity_market.mas2j

/* Initial beliefs and rules */
turn(0).
price(10).
production(0).
potential(0).
consumption(0).
needs(0).
trades([]).

/* Plans */
+!simulate
	: 	turn(T) & price(OldPrice) & production(A) & potential(P) & consumption(C) & needs(N)        
	<-	.print("######## Begin Simulation Step ########");
		.print("production: ", A, " potential: ", P, " consumption: ", C, " needs: ", N, " OldPrice: ", OldPrice);
		my.plot("Potential", T, P);
		my.plot("Production", T, A);
		my.plot("Consumption", T, C);
		my.plot("Needs", T, N);
		my.plot("OldPrice", T, OldPrice); 
		-+turn(T + 1);
	    -+production(0);
		-+potential(0);	    
		-+consumption(0);
		-+needs(0);
		-+trades([]);
		-+price(10);
		.send(network_regulator, achieve, setPrice(OldPrice, A, P));		
		.wait(2000);
		!simulate.		
		
+!priceUpdate(Price)
	<- 	-+price(T, Price).		
		
+!logProduction(Amount) 
	: 	production(A)
	<- 	-+production(A + Amount).	

+!logPotential(Amount) 
	: 	potential(P)
	<- 	-+potential(P + Amount).
		
+!logNeed(Need) 
    : 	needs(N)
	<- 	-+needs(N + Need).
	   
+!logTrade(Seller, Buyer, Amount) 
    : 	trades(List) & consumption(C)
	<- 	-+consumption(C + Amount);		
		-+trades([[Seller, Buyer, Amount]|List]).


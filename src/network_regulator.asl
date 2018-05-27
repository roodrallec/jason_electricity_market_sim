// Agent network_regulator in project electricity_market.mas2j

/* Initial beliefs and rules */
transaction_cap(50).
loss_per_distance(0.01).
price(10).
buyer_id(0).
adjustPrice(OldPrice, Production, Consumption, NewPrice) :- NewPrice = OldPrice.

/* Initial goals */
+!setPrice(OldPrice, Production, Consumption)
	<- 	?adjustPrice(OldPrice, Production, Consumption, NewPrice);
		-+buyer_id(0);
		.abolish(buyer(_, _, _));
	    .abolish(seller(_, _, _));
		.broadcast(achieve, priceUpdate(NewPrice)).

+!seller(Seller, E_selling, X_seller)
	: 	buyer(Buyer, Id, E_buying, X_buyer) & transaction_cap(Cap) 
	<-	-seller(Seller, E_selling, X_seller);
		.min([E_selling, E_buying, Cap], AgreedAmount);
		.print("Allowing ", Seller, " to sell to ", Buyer);
		.send(Buyer, achieve, acceptTrade(AgreedAmount));
		.send(Seller, achieve, acceptTrade(-AgreedAmount));
		.send(simulator, achieve, logTrade(S_agent, B_agent, AgreedAmount)).		
		
+!seller(S, E_selling, X_seller) 
	<- 	.print("No buyers for seller ", S);    
		.send(S, achieve, trade).
		
+!buyer(B, E_buying, X)
	: 	buyer_id(Id) 
	<-	-+buyer_id(Id+1);
		+buyer(B, Id+1, E_buying, X).


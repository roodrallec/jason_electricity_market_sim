// Agent network_regulator in project electricity_market.mas2j

/* Initial beliefs and rules */
transaction_cap(500).
loss_constant(0.1).
price(10).
buyer_id(0).
adjustPrice(OldPrice, Production, Consumption, NewPrice) :- NewPrice = OldPrice.
applyLoss(Amount, Distance, Loss, ReducedAmount) :- ReducedAmount = Loss * Amount / ((Distance*Distance)/Distance).

/* Initial goals */
+!setPrice(OldPrice, Production, Consumption)
	<- 	?adjustPrice(OldPrice, Production, Consumption, NewPrice);
		-+buyer_id(0);
		.abolish(buyer(_, _, _));
	    .abolish(seller(_, _, _));
		.broadcast(achieve, priceUpdate(NewPrice)).
		
+!seller(Seller, E_selling, X_seller)
	: 	buyer(Buyer, Id, E_buying, X_buyer) & transaction_cap(Cap) & loss_constant(L) 
	<-	-seller(Seller, E_selling, X_seller);
		.min([E_selling, E_buying, Cap], AgreedAmount);
		?applyLoss(AgreedAmount, X_seller - X_buyer, L, ReducedAmount);
		.print("Allowing ", Seller, " to sell to ", Buyer, " amount ", ReducedAmount);
		.send(Buyer, achieve, acceptTrade(ReducedAmount));
		.send(Seller, achieve, acceptTrade(-ReducedAmount));
		.send(simulator, achieve, logTrade(S_agent, B_agent, ReducedAmount)).		
		
+!seller(S, E_selling, X_seller) 
	<- 	.print("No buyers for seller ", S);    
		.send(S, achieve, trade).
		
+!buyer(B, E_buying, X)
	: 	buyer_id(Id) 
	<-	-+buyer_id(Id+1);
		+buyer(B, Id+1, E_buying, X).


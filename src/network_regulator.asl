// Agent network_regulator in project electricity_market.mas2j

/* Initial beliefs and rules */

//regulation
transaction_cap(200).

//0 => perfect energy consumption
loss_constant(0).

//general price per energy unit
price(10).
buyer_id(0).
<<<<<<< HEAD
adjustPrice(OldPrice, Production, Consumption, NewPrice) :- NewPrice = OldPrice.
//linear loss
applyLoss(Amount, Distance, LossConstant, Loss) :- Loss = math.round(LossConstant * Amount / Distance).
absoluteDistance(X_1, X_2, Distance) :- Distance = math.round(math.sqrt((X_1 - X_2) * (X_1 - X_2))).
=======

adjustPrice(OldPrice, Supply, Demand, NewPrice) 
	:- NewPrice = OldPrice * (10 + (Demand+1)/(Supply+1))/11.

calculateLoss(Amount, Distance, LossConstant, Loss) 
	:- Loss = math.round(LossConstant * Amount / Distance).

absoluteDistance(X_1, X_2, Distance) 
	:- Distance = math.round(math.sqrt((X_1 - X_2) * (X_1 - X_2))). 
>>>>>>> market_regulation

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
		?absoluteDistance(X_seller, X_buyer, Distance);
		?calculateLoss(AgreedAmount, Distance, L, AmountLost);
		.print("Allowing ", Seller, " to sell to ", Buyer, " amount ", AgreedAmount);
		.print("Loss Amount ", AmountLost);
		.send(Buyer, achieve, bought(AgreedAmount - AmountLost));
		.send(Seller, achieve, sold(AgreedAmount));
		.send(simulator, achieve, logTrade(S_agent, B_agent, AgreedAmount)).

+!seller(S, E_selling, X_seller)
	<- 	.print("No buyers for seller ", S);
		.send(S, achieve, trade).

+!buyer(B, E_buying, X)
	: 	buyer_id(Id)
	<-	-+buyer_id(Id+1);
		+buyer(B, Id+1, E_buying, X).


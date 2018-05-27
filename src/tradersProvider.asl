// Agent buyer in project electricity_market.mas2j

/* Initial beliefs and rules */
	
/* Initial goals */
/* Plans */

	
+prosumer(Who) 
	: 	trader(_) 
	<- 	!pair(Who).
	
+trader(Who)
	: 	prosumer(_) 
	<- 	!pair(Who).

+!pair(T)
	: 	trader(T) & prosumer(P)  
	<- 	-prosumer(P)[source(P)];
	   	-trader(T)[source(T)];
		.print("pairing ", P , " and ", T);
		.send(T, tell, prosumer(P));
		.send(P, tell, trader(T)).
	
	   


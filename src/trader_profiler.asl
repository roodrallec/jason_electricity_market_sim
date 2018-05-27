// Agent buyer in project electricity_market.mas2j

/* Initial beliefs and rules */
	
/* Initial goals */
prosumer_id(0).

/* Plans */
!pairing_countdown.

+!pairing_countdown 
	<-	.wait(1500);
		.send(logger, achieve, simulate).

+!trader(T) 
	: 	prosumer(P, Id) & .random(D)
	<- 	-prosumer(P, Id);		
		.print("Pairing trader ", T, " with prosumer ", P);
		.send(T, tell, prosumer(P, D));	
		.send(P, tell, trader(T)).		

+!trader(T) 
	<- 	.print("No prosumers for trader ", T);   
		.send(T, achieve, findProsumer).		
		
+!prosumer(P)
	: 	prosumer_id(Id) 
	<-	-+prosumer_id(Id+1);
		+prosumer(P, Id+1).
		

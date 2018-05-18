// Agent buyer in project electricity_market.mas2j

/* Initial beliefs and rules */
energy_stored(15).

/* Initial goals */
!sells.

/* Plans */
+!sells	: energy_stored(E) & E > 0 
	<- 	.print("I have ",E," amount of energy");
        .print("Offering energy to manager ", network_manager);
		.send(network_manager,tell,selling(E)).

+sold(E_sold) 
	: energy_stored(E) 
	<- .print("I sold ", E_sold, " amount of energy");
		+energy_needed(E - E_sold).

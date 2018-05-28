# jason_electricity_market_sim

# install mac
download a java jdk 1.7/1.8
download jason: https://sourceforge.net/projects/jason/?source=typ_redirect
unzip it

run jason-2.2a/libs/jason-2.2.jar
replace there
/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/
by i.e.
/Library/Java/JavaVirtualMachines/jdk1.8.0.jdk/Contents/Home

run jason-2.2a/jedit/jedit.jar


potential - maximal possible production of the system
needs - demand
consumption - needs which are met
oldPrice:
- prices never change
- random energy requirements household(either consumer or producer)
- power-plant: random cost per unit
- factory: random profit per unit

rename:
-trader?
-begin Begin Simulation Step
-buy/sell -> trade

-make household consumption change?
-bug? plot is not remembering
-make randomness explicit



READEME FILE

To Build you must first run the script called:
	
	rubyInstaller.sh

Don't forget to do "chmod 700 rubyInstaller.sh" to make the script executable.

To run all tests you can simply type the command:

	rspec


To start the server you can either type the command:

	ruby lib/delectable/delectableserver.rb 


LICENSING INFORMATION:

GNU General Public License Version 3


Known Bugs/Issues:


1. Orders are created even when given menu Item ids that do not exist within the menu. This was done on purpose however because I have code that will allow you to modify the order overtime. And I thought of the possibility of someone entering multiple orders with only one not existing and still wanted the other items to be accepted. A delivery method can be written to modify orders over time, the use cases are already done.

2. The reports function work but the way I approached it feels more hacked than thorough, I made the asusmption that those 4 reports that are delivered are the only ones ever delivered all the time. Therefore each time you call reports, it generates new reports with the latest set of orders. 

3. If I were to refactor this code even more, I would probably change the way admin deals with most items instead of menu, customers and orders all being underneath a single admin.

4. I should have written a yaml file which stores json objects instead of just copying everything over from test to test. It looks messy and disgusting. That definitely needs to be refactored. 





CREDITS & ACKNOWLEDGEMENTS

I would like to thank the makers of the sinatra gem: 
	
	Blake Mizerany, Ryan Tomayko, Simon Rozet, Konstantin Haase

Without them, I would not have been able to implement the rest api.


The makers of the rspec gem:

	Steven Baker, David Chelimsky, Myron Marston

Without them, I would not have been able to accomplish 100% test coverage on this project


The makers of the simplecov gem:

	Christoph Olszowka

Without him, I would not have been able to see which code was not being tested to ensure 100% test coverage. 







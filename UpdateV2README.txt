UPDATE FOR VERSION 2

Updates:
	Code Organization: The admin class is no longer a god object and now only does what it is able to do as listed in the api. In replacement the server object is now a god object. I thought that this was okay since in reality, the server is supposed to have access to everything.
	 
	Reports: The way reports are being handeld has been slightly refined. A new set of reports are not being made everytime 'GET /report' is called. It now gets orders that are due the same date as the specified start date and end date other than strictly inbetween. This can still use a little bit more refinement.


Hours taken for fixes: 3

Lines of Code: 840

Lines of Code (Unit Tests): 1092

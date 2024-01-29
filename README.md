# README

* This is a demo application showing a basic weather forecast UI. 

* To run all tests:
 - rails spec

* To run application locally:
  - Note: there is no DB requirements (the default SQLite DB is left enabled, but no migrations/schema exist.)
  - bin/dev

* Docker instructions:
** image construction
   - From within the project directory:
   - docker build -t forecast .

** container launch
   - docker run --rm -it -p 3000:3000 --env RAILS_MASTER_KEY=<master key content here> forecast
   - application is server at http://localhost:3000


* Design Notes

For the most part the application does not employ objects. The functonality is encapsulated in extensions of existing Rails classes as methods implmented in controllers or helpers.

There are 2 controllers for the foreacast UI - "Addresses" and "Forecasts". 

The Addresses controller provides search suggestions to the UI's input form. As values are entered, there is a slight delay before the query is sent to the controller. The responses are returned via a Turbo stream handler, so updates are dynamically populated on the form. This functionality provies a convenient way for the user to enter an address, see completions, then select one of those.

Once the text field is populated, there are also inputs that contain the geolocation data points for that address. The form submission sends this to the Forecasts controller, which in turn queries an open weather API endpoint for releveant weather conditions and a 7 day forecast. Again, the response is a Turbo stream. The forecast is then updated on the page withou a full reload.

In both controllers the handling is kept to a minimum - we defer the API interactions to the helper methods. This allows for separation of logic which in turn made is easier to test and refactor.

The UI CSS is entirely Tailwind CSS. Each element uses the Tailwind convention of "inline" CSS classes.



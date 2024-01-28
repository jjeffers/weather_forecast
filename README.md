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



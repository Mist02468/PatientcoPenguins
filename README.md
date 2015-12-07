# Release Notes

The goal of this first release of this project is to create a website that enables effective communication between many professionals of a single industry through a social networking medium.

## Site Features

* Users can log in through an existing LinkedIn account

* A profile is generated from information pulled from a connected LinkedIn account

* Users can create a text post that will be linked to the creator’s account and timestamped

* Users can comment on existing posts and having those comments tied to the commenter and timestamped

* Users can create and attend a "Round-Table Discussion" which includes

    * Screen scraping to create a Google Hangout on Air tied to the site’s Google account

    * Creating a Google Doc to facilitate live, collaborative note taking

    * Allowing users to invite other users to join or watch the conversation

    * Offering users a chance to share this on their LinkedIn

* Users have access to a homefeed that can display posts and round-table discussions chronologically.

* Users can report other users that aren’t beneficial to the community

* The site will lock out any user with 3+ reports logged in the system.

* Filtering by tags

## Known Issues

* The creation of a Round-Table Discussion takes a long time. It should probably be moved into the background in the future

* The homefeed is not sorted by relevance only recency

* The tag filter does not include similar tags or tags that are synonyms

* There is currently no way to unblock a user since there is no moderator to determine whether the reports are reasonable or not.

# Installation Information

As a user interactions with our product would happen by visiting the website. Those interactions are detailed in the User’s Manual. However, there is some set up for the development of this project.

## Setting up the Development Environment

To make the development environment consistent we used ruby stack and  github repository

1. Go to [https://bitnami.com/stack/ruby/installer](https://bitnami.com/stack/ruby/installer) and download Ruby Stack 2.0.0

2. In a console/terminal open the application folder and run **./rubyconsole **(or **use_ruby** on Windows)

3. Navigate into projects

4. Run **git clone https://github.com/Mist02468/PatientcoPenguins.git**

5. Check that it worked by navigating into the PatientcoPenguins directory

6. Go back out 2 folders and run **./rubyconsole**** **(or **use_ruby** on Windows)

7. Run **./ctlscript.sh start** (or **Bitnami Ruby Stack Manager Tool **on Windows)

8. Navigate into projects/PatientcoPenguins again

9. Run **bundle**** install**

    1. If you get a json error try the steps andres offers here: [https://community.bitnami.com/t/ruby-stack2-0-0-24-bundle-install-failed/30727/9](https://community.bitnami.com/t/ruby-stack2-0-0-24-bundle-install-failed/30727/9) to move dependencies. Then try sudo **gem install json -v '1.8.2'** and run **bundle install**

10. Fill the config folder with the given files (email Sierra at [sierra.brader@gatech.edu](mailto:sierra.brader@gatech.edu) to get them)

    2. accountSecrets.yml

    3. database.yml

    4. secrets.yml

    5. key file

11. Install phantomJS. [http://phantomjs.org/download.html](http://phantomjs.org/download.html)

12. Install firefox

    6. With Google Talk plugins

    7. run **gem install headless**

13. Run **bin/rake db:migrate**

14. Run **rails server** to launch a local server

15. Open a browser and navigate to [http://localhost:3000/access/startLinkedInAuth](http://localhost:3000/access/startLinkedInAuth)

## Each time you want to develop on this project there is some set up

1. Go to rubystack folder

2. Run **./rubyconsole** or **use_ruby** on Windows

3. Run **./ctlscript.sh start **or **Bitnami Ruby Stack Manager Tool **on Windows

4. Go into projects/PatientcoPenguins

5. Might need to run **rake db:migrate** (if you are manually testing on the local server it will tell you to run this if needed)

## To Manually Test

1. Run **rails server**

2. Open a browser and navigate to [http://localhost:3000/profile/show](http://localhost:3000/profile/show)

3. To Manually Edit the database (standard SQLite3 database)

    1. Go to db/

    2. **sqlite3 development.sqlite3**

    3. **.help** for commands

    4. **.tables** to list tables

    5. **.quit **to exit

4. To use demo data

    6. Get developmentDemo.sqlite3 file from Sierra

    7. Rename to development.sqlite3

    8. Replace existing db file in PatientcoPenguins/db

    9. If you want to save the old db, just rename it to something else first

## Automated Testing

### Creating Tests

1. Install the Selenium IDE Firefox plugin [http://docs.seleniumhq.org/download/](http://docs.seleniumhq.org/download/) (you must have Firefox for this to work)

2. Click the Selenium IDE icon on the toolbar

    1. There will be a popup window and it will start recording

3. Click around as if you were manually testing the software (be aware any login information will be recorded in plain text in the test so it is suggested that you use the test account - see existing tests)

4. Right click on elements to add testing commands like "verify text"

5. Click File -> Export Test Case As -> Ruby/RSpec/WebDriver

6. Save into spec/features with a descriptive test name

7. Open this file

    2. Remove the line: require "rspec"

    3. Add the line: require_relative "../testCommonFunctions.rb"

    4. Change each ${receiver} to @driver

    5. Start your test with @driver = TestCommonFunctions.login(@base_url, @driver) put this under ‘it "FILENAME_spec" do’

### Running Tests

1. Start rails server in one terminal

2. In another terminal, run **rake spec **(this will run all the tests)

3. To run a single test: **rake spec SPEC=spec/features/test_name.rb** (runs only test_name.rb)

## Server

# User’s Manual / Help

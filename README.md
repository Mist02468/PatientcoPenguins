# Release Notes

The goal of this first project release is to create an industry-specific social network that enables effective communication between professionals of a single industry.

## Site Features

* Users can log in with their LinkedIn account

* Their profile is generated from their LinkedIn account information

* Users can create a post which is free-form text, optionally includes tags, and will be linked to their user account and timestamped

* Users can comment on existing posts and their comments will be tied to their user account and timestamped

* Users can create and attend events which are round table discussions including

    * A Google Hangout on Air to facilitate live, video discussion, which requires PhantomJS for screen scrape creation on our site’s Google Service Account

    * A Google Doc to facilitate live, collaborative note taking, which is created on our site’s Google Service Account using Google’s Drive API

    * A LinkedIn button to offer users the chance to share a link to an event with their LinkedIn connections

* Users have access to a home feed that displays posts and events chronologically, and optionally filters them by tag

* Users can report users who are not being beneficial to the community

* Users with 3+ reports logged in our database will be locked out

## Known Issues

* The creation of an event takes an extended time due to all of the screen scraping required, processing which could be moved to the background in the future

* The home feed is not sorted by relevance, only recency

* Filtering by tag does not include similar tags or tags that are synonyms

* Users cannot currently be unblocked, except by editing the database, since we do not have a moderator page in place where an admin could determine whether the reports are reasonable or not

# Installation Information

A casual Pronnect user would only need to install a web browser and navigate to the url where this code is deployed. They can find instructions on how to use our site in the User Manual section below. Therefore, the information in this section is only pertinent to our client or a GitHub user if they were to deploy this code on another server or wished to run it locally in order to continue development and contribute to this project.

## First Time Setting up the Environment

To keep the environment consistent we used Bitnami and GitHub.

1. Go to [https://bitnami.com/stack/ruby/installer](https://bitnami.com/stack/ruby/installer) and download RubyStack

2. In a terminal navigate to the rubystack folder and run **./rubyconsole **(or **use_ruby** on Windows)

3. Navigate into the projects folder

4. Run **git clone https://github.com/Mist02468/PatientcoPenguins.git**

5. Check that it worked by navigating into the PatientcoPenguins directory

6. Go back out to the rubystack folder and run **./ctlscript.sh start** (or **Bitnami Ruby Stack Manager Tool **on Windows)

7. Navigate into the projects/PatientcoPenguins folder again

8. Run **bundle**** install**

    1. If you get a json error try the steps which Andres offers here: [https://community.bitnami.com/t/ruby-stack2-0-0-24-bundle-install-failed/30727/9](https://community.bitnami.com/t/ruby-stack2-0-0-24-bundle-install-failed/30727/9) to move dependencies and then try sudo **gem install json -v '1.8.2'** and run **bundle install**

9. Fill the config folder with the following secret files (email Sierra at [sierra.brader@gatech.edu](mailto:sierra.brader@gatech.edu) for copies)

    2. accountSecrets.yml

    3. database.yml

    4. secrets.yml

    5. key file

10. Go to [http://phantomjs.org/download.html](http://phantomjs.org/download.html) and install phantomJS

11. Install Firefox

    6. With Google Talk plugins

    7. Run **gem install headless**

12. Run **bin/rake db:migrate**

13. Run **rails server** to launch a local server

14. Try opening a browser and navigate to [http://localhost:3000/access/login](http://localhost:3000/access/login)

## Each Time Setting up to Run Locally

1. In a terminal navigate to the rubystack folder

2. Run **./rubyconsole** (or **use_ruby** on Windows)

3. Run **./ctlscript.sh start **(or **Bitnami Ruby Stack Manager Tool **on Windows)

4. Navigate into the projects/PatientcoPenguins folder

5. Might need to run **rake db:migrate** (if new commits added a migration)

6. Run **rails server** to launch a local server

## Each Time Manually Testing With Demo Data

1. To use the demo data

    1. Put the developmentDemo.sqlite3 file in the db folder  (email Sierra at [sierra.brader@gatech.edu](mailto:sierra.brader@gatech.edu) for a copy)

    2. If you want to save your current database, rename development.sqlite3 to something else

    3. Rename developmentDemo.sqlite3 to development.sqlite3

2. To edit the demo data

    4. Navigate to the db folder

    5. Run **sqlite3 development.sqlite3**

        1. Run** .help** for commands (it is a standard SQLite3 database)

        2. Run **.tables** to list tables

        3. Run **.quit **to exit

## Each Time Creating or Running Automated Tests

### Creating Tests

1. If this is your fist time, go to [http://docs.seleniumhq.org/download/](http://docs.seleniumhq.org/download/) and install the Selenium IDE plugin (you must do this in Firefox)

2. Click the Selenium IDE icon on the Firefox toolbar (a popup window will appear and it will start recording)

3. Click around as if you were manually testing the software (be aware that any login information or other text entered while recording will be stored in the plain text test, so it is suggested that you use the test account credentials instead of your own)

4. If you wish, right click on page elements to add testing commands like "verify text"

5. When finished recording, click File -> Export Test Case As -> Ruby/RSpec/WebDriver

6. Save that file into spec/features with a descriptive test name

7. Open that file

    1. Remove the line: require "rspec"

    2. Add the line: require_relative "../testCommonFunctions.rb"

    3. Change each "${receiver}" to “@driver”

    4. Start your test with "@driver = TestCommonFunctions.login(@base_url, @driver)" (put this under ‘it "FILENAME_spec" do’)

### Running Tests

1. Launch a local server in one terminal by running **rails server**

2. In another terminal, run **rake spec**** **if you want to run all the tests or run a single test using a command like: **rake spec SPEC=spec/features/test_name.rb** (that would only run test_name.rb)

## First Time Setting up a Server

I would suggest using the Bitnami Launchpad for the Google Cloud Platform ([https://google.bitnami.com/](https://google.bitnami.com/)).

1. Follow all the "**First Time Setting up the Environment**" instructions

2. Install Xvfb

3. Go to [https://wiki.bitnami.com/Infrastructure_Stacks/Bitnami_RubyStack#How_can_I_deploy_my_Rails_application.3f](https://wiki.bitnami.com/Infrastructure_Stacks/Bitnami_RubyStack#How_can_I_deploy_my_Rails_application.3f) and follow the **Using Apache With Passenger** instructions

# User’s Manual

## Getting Started

1. Log in with your LinkedIn account. If you do not yet have a LinkedIn account, click the Join LinkedIn link after clicking the Sign in with LinkedIn button.

2. Upon signing in you will be taken directly to the home feed, there are no time consuming registration forms to submit or settings to configure.

3. Check out your profile by clicking View Profile on the menu bar. This page is not meant to be your full resume, think of it more like your business card. The information is drawn directly from your LinkedIn. Your user activity will also be listed on this page.

4. Click home feed links and use the menu bar to navigate through and familiarize yourself with the rest of our site, the features of which are explained in the next sections of this user manual.

5. The menu bar follows as you scroll down the home feed or any other page of our site.

## Home Feed

* The home feed has two columns: one for recent posts, the other for recent events.

* Each post or event is clickable. See how the cursor changes to a hand and the text changes to the color green as you mouse over it.

    * Clicking a post will take you to a page where you can view and add comments.

    * Clicking an event will take you to a page where you can see information about the event and join if it is live or watch the recording if it has already ended.

* Each post or event shows the time and day it was created, and this is how they are ordered in the lists on the page.

* Each post or event has a link to the profile of the user which created it.

## Posts

### Creating a Post

1. Click Create Post on the menu bar.

2. Optionally add tag(s). For each tag:

    1. Type a word, or multiple words without spaces (as one tag), into the text box

    2. Click Add Tag to Post.

    3. If you change your mind, click the green X on the right side of a tag to remove it.

3. Type the content of your post in the larger text box.

4. Click the Post button.

### Commenting on a Post

1. Click on a post which you find on the home feed or a user’s profile.

2. Type the content of your comment in the text box.

3. Click the Comment button.

## Events

### Creating an Event

1. Click Create Event on the menu bar.

2. Optionally add tag(s) for each tag:

    1. Type a word, or multiple words without spaces (this will all be one tag), into the text box.

    2. Click Add Tag to Event.

    3. If you change your mind, click the green X on the right side of a tag to remove it.

3. Use the select boxes to choose the date and time at which you want to host your event.

4. Type a topic for your event in the text box.

5. Click the Create Event button.

6. Do not click back or close your browser, the next page will take some time to load.

### Hosting an Event

1. Click on your event.

2. Optionally click on the LinkedIn button and write a message in order to share a link to your event with your LinkedIn connections.

3. Click the Start this Event button.

4. As the host, you will be shown two links, both of which will open in a new tab.

    1. The Open the Discussion link will take you to the Google Hangout on Air where you will be the first user to join and start the live video discussion.

    2. The Open the Notes link will take you to the Google Doc where you and the viewers of your event can collaboratively take notes.

5. When you are finished, click the End this Event button.

### Attending an Event

1. Click on the event.

2. Optionally click on the LinkedIn button and write a message in order to share a link to this event with your LinkedIn connections.

3. Press play on the embedded Google Hangout on Air to start watching the event.

4. Type in the embedded Google Doc if you wish to contribute to the collaborative notes.

5. If the event is live, you can also click the Join the Discussion? link if you wish join the Google Hangout on Air. The hangout will open in a new tab. Up to 10 people can join.

# Frequently Asked Questions

* **Why am I locked out? What should I do?**

You have been locked out because three or more of your peers on Pronnect: Revenue Cycle have reported you as not being beneficial to this community. You should contact the moderator of this community.

* **How do I report someone?**

To report someone you will need to go to their profile page. Below their profile information you will see a text box where you can enter a reason for reporting them and click the Report User button. Note that you can only report a user once.

* **How do I update my profile?**

Your Pronnect profile information is pulled directly from your LinkedIn profile. If you log into LinkedIn and change your profile information there, the next time you log into our site your Pronnect profile information will be updated as well.

* **Are my posts and comments public?**

Your posts and comments are visible to all other Pronnect: Revenue Cycle users but they are not visible to the general public.

* **Can I edit or remove my post/comment?**

No, our site does not currently support editing or deleting. We would suggest that you add a comment to the post or comment in question which clarifies your statement or fixes your error.

* **How do I connect with another user privately?**

Our site does not currently support private messaging, but you can find a user’s email address on their profile and connect with them in that way.

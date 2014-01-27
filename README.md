DartWebSim
==========

A web app to make acceptance test for web applications (it is in pre-alpha tough)

The objective is to use an easy to understand language to executes task
with an editor that automatically finds errors in the gramar in real time.

It is designed to run in a web browser by connecting to a selenium server, why?
because as for now there is no way to automate with a browser alone, whats more,
it can be used to simulate with multiple browsers.

Selenium is an aplication that automates browsers, it can automate all "evergreen"
browsers.

here is an exmaple of a test code

    I go to page http://google.com
    I get element of name q
    It is visible
    I write hello world\n
    I wait 1 seconds
    I get link with text Hello world program
    I click it
    I wait 3 seconds
    
It basically goes to the Wikipedia page by using google 


As for now, it simply pauses when the test fails.

Contributions are welcome

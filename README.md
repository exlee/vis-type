Type Timer
==========

## About

This little piece of software is for visualisation of type pattern for word or phrase.  You can see the demo [here][demourl].

Libraries used:

- [Brunch][brunch]
- [Angular.JS][angular]
- [Brunch on Asteroids][angular]
- [CoffeeScript][coffee]/[Livescript][live]
- [Stylus][stylus]
- [Twitter Bootstrap][twitterb]

Code quality
:Proof of Concept - experimental coding (i.e. no insight before hacking in), lack of comments, duplicated code etc. :-)

## Assumptions

Simple security concept based on the idea that every person is a little bit different. I assumed that every person has their own typing pattern, and so, using [3 Sigma Rule][3sig] I wanted to monitor such entries and timed key presses and pauses between them and match them against average pattern.

## Result

Solution is a bit unstable. I got into event hell and decided to stop after doing the visual part, unfortunately it tends to break when incomplete data is posted.


[demourl]: http://http://exlee.github.com/vis-type/
[brunch]: http://brunch.io
[angular]: http://angularjs.org
[3sig]: http://en.wikipedia.org/wiki/68-95-99.7_rule
[twitterb]: http://twitter.github.com/bootstrap
[live]: http://livescript.net
[stylus]: http://learnboost.github.com/stylus/
[coffee]: http://coffeescript.org


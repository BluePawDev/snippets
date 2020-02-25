/* DATA */

// assignments with dots
var person = {};
person.name = "Mrs. White";

// object litteral notation
var person = {
    "name": "Mrs. White"
};

var who = person.name;

who; // ??

person.name = "Mr. White";

who; // ??

/*
Primitive and non-primitive values do not have the same behave.
As such, it's recommended that you don't mutate data structures.
Rather it is better to copy a data structure and return a new copy.
*/
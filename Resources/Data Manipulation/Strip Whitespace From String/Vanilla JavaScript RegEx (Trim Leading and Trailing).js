var str = "   a b    c d e f g ";
var newStr = str.replace(/(^\s+|\s+$)/g, '');
// "a b    c d e f g"
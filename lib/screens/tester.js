function change(string){
  // ..
  let alphabetString = "abcdefghijklmnopqrstuvwxyz"
  let byLetters = {};
  let byIndex = {};
  let makeDic = function() {
  
    for (var i = 0; i < alphabetString.length; i++) {
    
      byIndex[i] = alphabetString[i];
      byLetters[alphabetString[i]] = i;
      // {0: a, 1: b}
    }
  }
  
  
  makeDic();
  
  
  for (var i = 0; i < string.length; i++) {
    if (byLetters[string[i]]) {
      byLetters[string[i]] = true;
    }
  }
  
  let final = "";
  for (var i = 0; i < 26; i++) {
   let currentLetter = byIndex[i];
   if (byLetters[currentLetter] === true) {
     final.push("1")
   } else {
     final.push("0");
   {
  }
  
  return final;
  
}
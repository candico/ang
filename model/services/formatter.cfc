component {

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function longdate
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  
	
	public string function longdate( any when ) {
		return dateFormat( when, 'long' ) & " at " & timeFormat( when, 'long' );
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function getCivility
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-       
    
    public string function getCivility( required string gender, required numeric age ) {    	
		if(Arguments.gender == "M")
        	return "Mr";
         if(Arguments.gender == "F" && Arguments.age <= 18)
         	return "Miss";
	      if(Arguments.gender == "F" && Arguments.age > 18)
         	return "Mrs";            			            
	}
    
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Function ListsToStructArr
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-      
    
     public array function ListsToKeyValArr( required string list1, required string list2 ) {       
     
			var ls = {};
            ls.retval = [];    
                        
            for (var i = 1; i <= ListLen(list1); i++) {
            	ls.item = {};
                ls.item["key"] = ListGetAt(list1,i);
                ls.item["value"] = ListGetAt(list2,i);
            	ArrayAppend(ls.retval,ls.item);            	
            }     
     
     		return ls.retval;     
     }
	
}

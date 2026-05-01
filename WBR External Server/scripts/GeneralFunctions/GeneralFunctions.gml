function generateLobbyCode() {
	var code = "";
	var code_length = 8;
	for (var i = 0; i < code_length; i++) {
		var letter_type = choose(1, 2, 3);
		
		switch (letter_type) {
			case 1 : // number
				code += chr(irandom_range(48, 57));
				break;
			
			case 2 : // upper case letter
				code += chr(irandom_range(65, 90));
				break;
			
			case 3 :
			default :
				code += chr(irandom_range(97, 122));
				break;	  
		}
	}
	
	return code;
}
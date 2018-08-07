module menu_text_setter(clk, inmenu, x_pointer, y_pointer, menu_text);
   input inmenu;
   input clk;
   input [7:0]x_pointer;
	input [6:0]y_pointer;
	output reg menu_text; // check if the pixel is the menu's text.
	
	reg [31:0] flash_counter;
	
   always@(posedge clk)
	begin 
		if (flash_counter == 0)
			flash_counter <= 31'd49999999;
	   else
			 flash_counter <= flash_counter - 1'b1;
	end
	
	wire enable_flash_text = (flash_counter < 25000000) ? 1 : 0;

	//menu's normal text
	always@(posedge clk)
	begin
		if (inmenu)
			 begin
			 if (
			 // Letter "S"
				  (x_pointer >= 10 && x_pointer <= 36 && y_pointer >= 11  && y_pointer <= 16)
				||(x_pointer >= 10 && x_pointer <= 15 && y_pointer >= 11  && y_pointer <= 33)
				||(x_pointer >= 31 && x_pointer <= 36 && y_pointer >= 11  && y_pointer <= 20)
				||(x_pointer >= 10 && x_pointer <= 36 && y_pointer >= 29  && y_pointer <= 33)
				||(x_pointer >= 31 && x_pointer <= 36 && y_pointer >= 29  && y_pointer <= 54)
				||(x_pointer >= 10 && x_pointer <= 36 && y_pointer >= 49  && y_pointer <= 54)
				||(x_pointer >= 10 && x_pointer <= 15 && y_pointer >= 44  && y_pointer <= 54)
				
			 // Letter "N"
				||(x_pointer >= 41 && x_pointer <= 46 && y_pointer >= 11  && y_pointer <= 54)
				||(x_pointer >= 46 && x_pointer <= 50 && y_pointer >= 13  && y_pointer <= 20)
				||(x_pointer >= 50 && x_pointer <= 54 && y_pointer >= 20  && y_pointer <= 29)
				||(x_pointer >= 53 && x_pointer <= 57 && y_pointer >= 28  && y_pointer <= 38)
				||(x_pointer >= 56 && x_pointer <= 60 && y_pointer >= 37  && y_pointer <= 45)
				||(x_pointer >= 59 && x_pointer <= 62 && y_pointer >= 44  && y_pointer <= 51)
				||(x_pointer >= 62 && x_pointer <= 67 && y_pointer >= 11  && y_pointer <= 54)
			 // Letter "A"
			 	||(x_pointer >= 71 && x_pointer <= 76 && y_pointer >= 29  && y_pointer <= 54)
				||(x_pointer >= 73 && x_pointer <= 79 && y_pointer >= 19  && y_pointer <= 29)
				||(x_pointer >= 76 && x_pointer <= 81 && y_pointer >= 14  && y_pointer <= 19)
				||(x_pointer >= 80 && x_pointer <= 88 && y_pointer >= 11  && y_pointer <= 14)
				||(x_pointer >= 87 && x_pointer <= 92 && y_pointer >= 14  && y_pointer <= 19)
				||(x_pointer >= 91 && x_pointer <= 96 && y_pointer >= 19  && y_pointer <= 29)
				||(x_pointer >= 76 && x_pointer <= 93 && y_pointer >= 35  && y_pointer <= 39)
				||(x_pointer >= 93 && x_pointer <= 98 && y_pointer >= 29  && y_pointer <= 54)
			 // Letter "K"
			   ||(x_pointer >= 101 && x_pointer <= 107 && y_pointer >= 10  && y_pointer <= 54)
				||(x_pointer >= 107 && x_pointer <= 111 && y_pointer >= 24  && y_pointer <= 32)
				||(x_pointer >= 111 && x_pointer <= 116 && y_pointer >= 16  && y_pointer <= 25)
				||(x_pointer >= 111 && x_pointer <= 116 && y_pointer >= 32  && y_pointer <= 40)
				||(x_pointer >= 115 && x_pointer <= 120 && y_pointer >= 40  && y_pointer <= 48)
				||(x_pointer >= 119 && x_pointer <= 127 && y_pointer >= 47  && y_pointer <= 54)
				||(x_pointer >= 116 && x_pointer <= 127 && y_pointer >= 10  && y_pointer <= 16)
			 // Letter "E"
			 	||(x_pointer >= 129 && x_pointer <= 150 && y_pointer >= 10  && y_pointer <= 14)
				||(x_pointer >= 129 && x_pointer <= 149 && y_pointer >= 24  && y_pointer <= 32)
				||(x_pointer >= 129 && x_pointer <= 150 && y_pointer >= 49  && y_pointer <= 54)
				||(x_pointer >= 129 && x_pointer <= 135 && y_pointer >= 10  && y_pointer <= 54)
				
			 // Square for "1"
			   ||(x_pointer >= 28 && x_pointer <= 43 && y_pointer == 64)
				||(x_pointer == 28 && y_pointer >= 64 && y_pointer <= 78)
			   ||(x_pointer >= 28 && x_pointer <= 43 && y_pointer == 78)
			   ||(x_pointer == 43 && y_pointer >= 64 && y_pointer <= 78)
				
			 // Square for "2"
			   ||(x_pointer >= 28 + 44 && x_pointer <= 43 + 44 && y_pointer == 64)
				||(x_pointer == 28 + 44 && y_pointer >= 64 && y_pointer <= 78)
			   ||(x_pointer >= 28 + 44 && x_pointer <= 43 + 44 && y_pointer == 78)
			   ||(x_pointer == 43 + 44 && y_pointer >= 64 && y_pointer <= 78)		
			   // Square for "3"
			   ||(x_pointer >= 28 + 90 && x_pointer <= 43 + 90 && y_pointer == 64)
				||(x_pointer == 28 + 90 && y_pointer >= 64 && y_pointer <= 78)
			   ||(x_pointer >= 28 + 90 && x_pointer <= 43 + 90 && y_pointer == 78)
			   ||(x_pointer == 43 + 90 && y_pointer >= 64 && y_pointer <= 78)
			   // character "1"
			 	||(x_pointer >= 34 && x_pointer <= 36 && y_pointer == 67)
			   ||(x_pointer == 36 && y_pointer >= 67 && y_pointer <= 75)
			   ||(x_pointer >= 34 && x_pointer <= 38 && y_pointer == 75)
				// character "2"
			 	||(x_pointer >= 77 && x_pointer <= 82 && y_pointer == 67)
			   ||(x_pointer == 82 && y_pointer >= 67 && y_pointer <= 71)
			   ||(x_pointer >= 77 && x_pointer <= 82 && y_pointer == 71)
				||(x_pointer == 77 && y_pointer >= 71 && y_pointer <= 75)
				||(x_pointer >= 77 && x_pointer <= 82 && y_pointer == 75)
				// character "3"
			 	||(x_pointer >= 123 && x_pointer <= 128 && y_pointer == 67)
			   ||(x_pointer >= 124 && x_pointer <= 128 && y_pointer == 71)
			   ||(x_pointer >= 123 && x_pointer <= 128 && y_pointer == 75)
				||(x_pointer == 128 && y_pointer >= 67 && y_pointer <= 75)
				// character "Easy"
			 	||(x_pointer == 25 && y_pointer >= 83 && y_pointer <= 91)
			   ||(y_pointer == 83 && x_pointer >= 25 && x_pointer <= 30)
			   ||(y_pointer == 87 && x_pointer >= 25 && x_pointer <= 29)
				||(y_pointer == 91 && x_pointer >= 25 && x_pointer <= 30)
				
				||(x_pointer >= 32 && x_pointer <= 35 && y_pointer == 87)
			   ||(x_pointer == 35 && y_pointer >= 87 && y_pointer <= 91)
			   ||(x_pointer >= 32 && x_pointer <= 35 && y_pointer == 89)
				||(x_pointer == 32 && y_pointer >= 89 && y_pointer <= 91)
				||(x_pointer >= 32 && x_pointer <= 35 && y_pointer == 91)
				
				||(x_pointer >= 37 && x_pointer <= 40 && y_pointer == 87)
			   ||(x_pointer == 37 && y_pointer >= 87 && y_pointer <= 89)
			   ||(x_pointer >= 37 && x_pointer <= 40 && y_pointer == 89)
				||(x_pointer == 40 && y_pointer >= 89 && y_pointer <= 91)
				||(x_pointer >= 37 && x_pointer <= 40 && y_pointer == 91)
				
				||(x_pointer == 42 && y_pointer >= 87 && y_pointer <= 91)
			   ||(x_pointer == 46 && y_pointer >= 87 && y_pointer <= 96)
			   ||(x_pointer >= 42 && x_pointer <= 46 && y_pointer == 91)
				||(x_pointer >= 42 && x_pointer <= 46 && y_pointer == 96)
				// character "Normal"
				
				// n
			 	||((x_pointer == 67 && y_pointer == 84) || (x_pointer == 68 && y_pointer == 85)
				    || (x_pointer == 68 && y_pointer == 86) || (x_pointer == 69 && y_pointer == 87)
					 || (x_pointer == 70 && y_pointer == 88) || (x_pointer == 71 && y_pointer == 89)
					 || (x_pointer == 71 && y_pointer == 90))
			   ||(x_pointer == 66 && y_pointer >= 83 && y_pointer <= 91)
				||(x_pointer == 72 && y_pointer >= 83 && y_pointer <= 91)
				// o
				||(x_pointer == 74 && y_pointer >= 87 && y_pointer <= 91)
			   ||(x_pointer == 77 && y_pointer >= 87 && y_pointer <= 91)
			   ||(x_pointer >= 74 && x_pointer <= 77 && y_pointer == 87)
				||(x_pointer >= 74 && x_pointer <= 77 && y_pointer == 91)
				// r
				||(x_pointer == 79 && y_pointer >= 87 && y_pointer <= 91)
			   ||(x_pointer >= 79 && x_pointer <= 81 && y_pointer == 87)
				// m
				||(x_pointer == 83 && y_pointer >= 87 && y_pointer <= 91)
				||(x_pointer == 85 && y_pointer >= 87 && y_pointer <= 91)
				||(x_pointer == 87 && y_pointer >= 87 && y_pointer <= 91)
				||(y_pointer == 87 && x_pointer >= 83 && x_pointer <= 87)
				// a
				||(x_pointer >= 32 + 57 && x_pointer <= 35 + 57 && y_pointer == 87)
			   ||(x_pointer == 35 + 57 && y_pointer >= 87 && y_pointer <= 91)
			   ||(x_pointer >= 32 + 57 && x_pointer <= 35 + 57 && y_pointer == 89)
				||(x_pointer == 32 + 57 && y_pointer >= 89 && y_pointer <= 91)
				||(x_pointer >= 32 + 57 && x_pointer <= 35 + 57 && y_pointer == 91)
				// l
				||(x_pointer == 94 && y_pointer >= 83 && y_pointer <= 91)
				// character "Hard"
				// H
				||(x_pointer == 115 && y_pointer >= 83 && y_pointer <= 91)
				||(x_pointer == 121 && y_pointer >= 83 && y_pointer <= 91)
				||(y_pointer == 87 && x_pointer >= 115 && x_pointer <= 121)
				
				// a
				||(x_pointer >= 32 + 91 && x_pointer <= 35 + 91 && y_pointer == 87)
			   ||(x_pointer == 35 + 91 && y_pointer >= 87 && y_pointer <= 91)
			   ||(x_pointer >= 32 + 91 && x_pointer <= 35 + 91 && y_pointer == 89)
				||(x_pointer == 32 + 91 && y_pointer >= 89 && y_pointer <= 91)
				||(x_pointer >= 32 + 91 && x_pointer <= 35 + 91 && y_pointer == 91)
			   
				// r
				||(x_pointer == 128 && y_pointer >= 87 && y_pointer <= 91)
			   ||(x_pointer >= 128 && x_pointer <= 130 && y_pointer == 87)
				// d
				||(x_pointer == 132 && y_pointer >= 87 && y_pointer <= 91)
			   ||(x_pointer == 135 && y_pointer >= 82 && y_pointer <= 91)
			   ||(x_pointer >= 132 && x_pointer <= 135 && y_pointer == 87)
				||(x_pointer >= 132 && x_pointer <= 135 && y_pointer == 91)
				)
				 menu_text <= 1'b1;
			 else if (
			 // text "Press"
				(y_pointer == 104 && x_pointer >= 36 + 9 && x_pointer <= 41 + 9)
			 ||(y_pointer == 108 && x_pointer >= 36 + 9 && x_pointer <= 41 + 9)
			 ||(x_pointer == 36 + 9 && y_pointer >= 104 && y_pointer <= 111)
			 ||(x_pointer == 41 + 9 && y_pointer >= 104 && y_pointer <= 108)
			 
			 ||(y_pointer == 107 && x_pointer >= 43 + 9 && x_pointer <= 45 + 9)
			 ||(x_pointer == 43 + 9 && y_pointer >= 107 && y_pointer <= 111)
			 
			 ||(y_pointer == 107 && x_pointer >= 47 + 9 && x_pointer <= 50 + 9)
			 ||(y_pointer == 109 && x_pointer >= 47 + 9 && x_pointer <= 50 + 9)
			 ||(y_pointer == 111 && x_pointer >= 47 + 9 && x_pointer <= 50 + 9)
			 ||(x_pointer == 47 + 9 && y_pointer >= 107 && y_pointer <= 111)
			 ||(x_pointer == 50 + 9 && y_pointer >= 107 && y_pointer <= 109)
			 
			 ||(y_pointer == 107 && x_pointer >= 52 + 9 && x_pointer <= 55 + 9)
			 ||(y_pointer == 109 && x_pointer >= 52 + 9 && x_pointer <= 55 + 9)
			 ||(y_pointer == 111 && x_pointer >= 52 + 9 && x_pointer <= 55 + 9)
			 ||(x_pointer == 52 + 9 && y_pointer >= 107 && y_pointer <= 109)
			 ||(x_pointer == 55 + 9 && y_pointer >= 109 && y_pointer <= 111)
			 
			 ||(y_pointer == 107 && x_pointer >= 57 + 9 && x_pointer <= 60 + 9)
			 ||(y_pointer == 109 && x_pointer >= 57 + 9 && x_pointer <= 60 + 9)
			 ||(y_pointer == 111 && x_pointer >= 57 + 9 && x_pointer <= 60 + 9)
			 ||(x_pointer == 57 + 9 && y_pointer >= 107 && y_pointer <= 109)
			 ||(x_pointer == 60 + 9 && y_pointer >= 109 && y_pointer <= 111)
			 // text "to"
			 ||(y_pointer == 107 && x_pointer >= 74 && x_pointer <= 78 )
			 ||(y_pointer == 111 && x_pointer >= 76  && x_pointer <= 78)
			 ||(x_pointer == 76 && y_pointer >= 104 && y_pointer <= 111)
			 
			 ||(x_pointer == 80 && y_pointer >= 107 && y_pointer <= 111)
			 ||(x_pointer == 83 && y_pointer >= 107 && y_pointer <= 111)
			 ||(x_pointer >= 80 && x_pointer <= 83 && y_pointer == 107)
			 ||(x_pointer >= 80 && x_pointer <= 83 && y_pointer == 111)
			 
			 // text "start"
			 ||(y_pointer == 107 && x_pointer >= 57 + 31 && x_pointer <= 60 + 31)
			 ||(y_pointer == 109 && x_pointer >= 57 + 31 && x_pointer <= 60 + 31)
			 ||(y_pointer == 111 && x_pointer >= 57 + 31 && x_pointer <= 60 + 31)
			 ||(x_pointer == 57 + 31 && y_pointer >= 107 && y_pointer <= 109)
			 ||(x_pointer == 60 + 31 && y_pointer >= 109 && y_pointer <= 111)
			 
			 ||(y_pointer == 107 && x_pointer >= 93 && x_pointer <= 97)
			 ||(y_pointer == 111 && x_pointer >= 95 && x_pointer <= 97)
			 ||(x_pointer == 95 && y_pointer >= 104 && y_pointer <= 111)
			 
			 
			 ||(x_pointer >= 99 && x_pointer <= 102 && y_pointer == 107)
			 ||(x_pointer == 99 && y_pointer >= 109 && y_pointer <= 111)
			 ||(x_pointer >= 99 && x_pointer <= 102 && y_pointer == 109)
			 ||(x_pointer == 102 && y_pointer >= 107 && y_pointer <= 111)
			 ||(x_pointer >= 99 && x_pointer <= 102 && y_pointer == 111)
			 
			 ||(y_pointer == 107 && x_pointer >= 104 && x_pointer <= 106)
			 ||(x_pointer == 104 && y_pointer >= 107 && y_pointer <= 111)
			 
			 ||(y_pointer == 107 && x_pointer >= 74 + 34 && x_pointer <= 78 + 34)
			 ||(y_pointer == 111 && x_pointer >= 76 + 34 && x_pointer <= 78 + 34)
			 ||(x_pointer == 76 + 34 && y_pointer >= 104 && y_pointer <= 111)
			 )
			    menu_text <= (enable_flash_text) ? 1 : 0;
			 else
				 menu_text <= 1'b0;
			 end
	end
	//menu's flashing text
endmodule
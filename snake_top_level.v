module snake_top_level
	(
		CLOCK_50,						//	On Board 50 MHz
		
		// Your inputs and outputs here
      KEY,
      SW,
		LEDR,
		  
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,					//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,							//	VGA Blue[9:0]
		PS2_DAT, 						// KEYboard input
		PS2_CLK							// KEYboard clock
		);

	input	  CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;
	
	input   PS2_DAT;
	input   PS2_CLK;
	// Declare your inputs and outputs here
	// Do not change the follo wing outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	output   [9:0] LEDR;
	
	wire resetn;
	assign resetn = SW[4];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(1),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
	 //direction wire
	 wire [4:0] direction;
	 wire [4:0] number;
//	 kbInput kbIn(CLOCK_50, KEY, SW, direction, reset);
	 kbInput kbIn(PS2_CLK,direction,PS2_DAT,reset_n, number);
	 
	 wire inmenu;
	 wire ingame;
	 wire inresult, game_over;
	 wire initial_head, allow_moving;
	 wire [3:0]main_difficulty;
	 
	 datapath d0(
	         .clk(CLOCK_50),
	         .direction(direction),
				.inmenu(inmenu),
				.ingame(ingame),
				.inresult(inresult),
				.game_over(game_over),
		      .RGB(colour),
				.x_pointer(x),
				.y_pointer(y),
				.main_difficulty(main_difficulty),
				//delete later
				.initial_head(initial_head),
				.allow_moving(allow_moving)
	 );
	 

	 
	 Controller c0(
				.clk(CLOCK_50),
				.number_input(number),
				.direction(direction),
				.game_over(game_over),
				.inmenu(inmenu),
				.ingame(ingame),
				.inresult(inresult),
				.main_difficulty(main_difficulty),
				.initial_head(initial_head),
				.allow_moving(allow_moving),
				.LEDdebug(LEDR[0])
	 );
	 
	 
endmodule


module datapath(
   input clk,
	input [3:0] main_difficulty,
	output [7:0] x_pointer,
	output [6:0] y_pointer,
	output reg game_over,
	input [4:0] direction,
	
	input initial_head, allow_moving,
	
	//status of game
   input inmenu,
	input ingame,
	input inresult,

	output [2:0] RGB // the colour used for output);
   );
	
	wire R, G, B; // Will be used for concatenation for output "RGB".
	wire frame_update; // signal for frame update
	wire delayed_clk;
	
	
	wire menu_text; // check if the pixel is the menu's text.
	wire game_text, result_text;
	
	//register for score
	reg [12:0] score;
	
	//register for hiscore
	//*******************DO NOT RESET*******************
	reg [12:0] hiscore;
	
	//register for border
	reg border;
	
	//registers for snake
	reg [6:0] size;
	reg [7:0] snake_X[0:511];
	reg [6:0] snake_Y[0:511];
	reg found;
	reg snakeHead;
	reg snakeBody;
	reg snakeBody_collision;  //special detector for the detection of snake colliding with itself
	reg [1:0]currentDirect;
	integer bodycounter, bodycounter2, bodycounter3;
	reg up,down,left,right;
	
	//registers for apple
	reg apple;
	reg [7:0] appleX;
	reg [6:0] appleY;
	reg apple_inX, apple_inY;
	wire [7:0]rand_X;
	wire [6:0]rand_Y;
	
	//registers for game status
	reg lethal, nonLethal;
	reg bad_collision, good_collision;
	
	
	
	//down level modules
	refresher ref0(clk, x_pointer, y_pointer);
	frame_updater upd0(clk, 1'b1, frame_update);
	delay_counter dc0(clk, 1'b1, frame_update,delayed_clk,main_difficulty);
	random rand1(clk, rand_X, rand_Y);
	menu_text_setter menu0(clk, inmenu, x_pointer, y_pointer, menu_text);
	game_text_setter gametxt0(clk, score, hiscore, ingame, main_difficulty, x_pointer, y_pointer, game_text);
	result_text_setter restxt0(clk, score, inresult, main_difficulty, x_pointer, y_pointer, result_text);
	// check if the pixel is the menu's text.
	
	

	
	always@(posedge clk)
	begin
		if (inmenu)begin
			 //initialize snake's position
			 for(bodycounter3 = 1; bodycounter3 <=127; bodycounter3 = bodycounter3+1)begin
					snake_X[bodycounter3] = 0;
					snake_Y[bodycounter3] = 0;
			 end

			 //initialze snake's size
			 size = 1;
			 
			 //start game
			 game_over=0;
		
			 //initialize apple's position
			 appleX = 15;
			 appleY = 15;
		end
		else if(ingame)begin
				//################################################################################################
				//Add border
				border <= (((x_pointer >= 2) && (x_pointer <= 4)&&(y_pointer >= 2) && (y_pointer <=112))
								||((x_pointer >= 156)&& (x_pointer <= 158)&&(y_pointer >= 2) && (y_pointer <=112))
								||((x_pointer >= 2) && (x_pointer <= 158)&&(y_pointer >= 2) && (y_pointer <= 4))
								||((x_pointer >= 2) && (x_pointer <= 158)&&(y_pointer >= 110) && (y_pointer <= 112)));
				
				
				//################################################################################################
				//SNAKE PART STARTS FROM HERE!
				//Add Snake body
				found = 0;
				for(bodycounter = 1; bodycounter <= size; bodycounter = bodycounter + 1)begin
					if(~found)begin				
						snakeBody = ( (x_pointer >= snake_X[bodycounter] && x_pointer <= snake_X[bodycounter]+2) 
								  && (y_pointer >= snake_Y[bodycounter] && y_pointer <= snake_Y[bodycounter]+2));
						snakeBody_collision = (bodycounter >= 5) && ( (x_pointer >= snake_X[bodycounter] && x_pointer <= snake_X[bodycounter]+2) 
								  && (y_pointer >= snake_Y[bodycounter] && y_pointer <= snake_Y[bodycounter]+2));
						found = snakeBody;
					end
				end

				//Add Snake head
				snakeHead = (x_pointer >= snake_X[0] && x_pointer <= (snake_X[0]+2))
								&& (y_pointer >= snake_Y[0] && y_pointer <= (snake_Y[0]+2));
			
				//Initial Snake's head
				if(initial_head) begin
					snake_Y[0] = 60;
					snake_X[0] = 80;
				end
				
				
				//update snake's position
				if(delayed_clk)begin
					for(bodycounter2 = 127; bodycounter2 > 0; bodycounter2 = bodycounter2 - 1)begin
							if(bodycounter2 <= size - 1)begin
								snake_X[bodycounter2] = snake_X[bodycounter2 - 1];
								snake_Y[bodycounter2] = snake_Y[bodycounter2 - 1];
							end	
					end	
						
					//update snake's direction
					case(direction)
						//UP
						5'b00010: if(!down)begin
											up = 1;
											down = 0;
											left = 0;
											right = 0;
									 end 
						//LEFT
						5'b00100: if(!right)begin
											up = 0;
											down = 0;
											left = 1;
											right = 0;
									 end 
						//DOWN
						5'b01000: if(!up)begin
											up = 0;
											down = 1;
											left = 0;
											right = 0;
									end 
						//RIGHT
						5'b10000: if(!left)begin
											up = 0;
											down = 0;
											left = 0;
											right = 1;
									end
						default: begin //maintain
										up = up;
										down = down;
										left = left;
										right = right;
									end
					endcase	
					if (allow_moving) begin
						if(up)
							 snake_Y[0] <= (snake_Y[0] - 2);
						else if(left)
							 snake_X[0] <= (snake_X[0] - 2);
						else if(down)
							 snake_Y[0] <= (snake_Y[0] + 2);
						else if(right)
							 snake_X[0] <= (snake_X[0] + 2);
					end
				end


				//################################################################################################
				//APPLE PART STARTS FROM HERE! 
				//Draw an apple
				apple_inX <= (x_pointer >= appleX && x_pointer <= (appleX + 2));
				apple_inY <= (y_pointer >= appleY && y_pointer <= (appleY + 2));
				apple = apple_inX && apple_inY;
				
				//Set apple's position
				if(good_collision)begin
						appleX <= rand_X;
						appleY <= rand_Y;
				end
				
				
				
				
				
				
				
				
				
				
				//###############################################################################################
				//CHECK COLLISION
				//if is in lethal position
				lethal = border || snakeBody_collision;
	
				//if is in nonLethal position
				nonLethal = apple;
	
				//check good collision
				if(nonLethal && snakeHead) begin 
					good_collision <= 1;
					size = size + 1;
					//update score
					score = score + 1;
					//update hiscore
					if (score > hiscore)
						hiscore = score;
				end
				else 
					good_collision <= 0;
			
				//check bad collision
				if(lethal && snakeHead) begin
					bad_collision<=1;
				end
				else begin 
					bad_collision<=0;
				end
	
				//check game over
				if(bad_collision) begin
					game_over<=1;
				end	
				
				
		end
	end
	
	// Display white: menu_text
	// Display green: the snake's head and the snake's body
	// Display red: the apple, or game over
	// Display blue: the border
		assign R = ((ingame && apple) || (inmenu && menu_text)) || (inresult && result_text);
		assign G = ((ingame && snakeHead) || (ingame && snakeBody)) || (inmenu && menu_text) || (ingame && game_text) || (inresult && result_text);
		assign B = (ingame && border) || (inmenu && menu_text) || (inresult && result_text);
		assign RGB = {R, G, B};
endmodule

module random(clk, rand_X, rand_Y);
	input clk;
	output reg [7:0] rand_X =6;
	output reg [6:0] rand_Y =6;
	
	// set the maximum height and width of the game interface.
	// x and y will scan over every pixel.
	integer max_height = 108;
	integer max_width = 154;
	
	always@(posedge clk)
	begin
		if(rand_X === max_width)
			rand_X <= 6;
		else
			rand_X <= rand_X + 1;
	end

	always@(posedge clk)
	begin
		if(rand_X === max_width)
		begin
			if(rand_Y === max_height)
				rand_Y <= 6;
			else
				rand_Y <= rand_Y + 1;
		end
	end
endmodule



module kbInput(PS2_CLK,direction,data,reset_n, number);
	input PS2_CLK, data;
	output reg [4:0] direction;
	output reg [4:0] number;
	output reg reset_n = 0; 
	reg [7:0] code;
	reg [7:0] release_code;
	reg [10:0]keyCode, previousCode;
	reg recordNext = 0;
	integer count = 0;

	always@(posedge PS2_CLK)
	begin
		keyCode[count] = data;
		count = count + 1;			
		if(count == 11)
		begin
			if(previousCode != 8'hF0)begin
				code = keyCode[8:1];
			end
			
			if(previousCode == 8'hF0)begin
			   release_code = keyCode[8:1];
			end

			previousCode = keyCode[8:1];
			count = 0;
		end
	end
	
	always@(code)
	begin
		if(code == 8'h75)
			direction = 5'b00010;
		else if(code == 8'h6B)
			direction = 5'b00100;
		else if(code == 8'h72)
			direction = 5'b01000;
		else if(code == 8'h74)
			direction = 5'b10000;
//		else if(code == 8'h5A)
//			reset <= ~reset;
		else direction = 5'b00000;
	end
	
	always@(release_code)
	begin
		if(release_code == 8'h16)
			number = 5'b00010;
		else if(release_code == 8'h1E)
			number = 5'b00100;
		else if(release_code == 8'h26)
			number = 5'b01000;
		else number = 5'b00000;
	end
	
	
endmodule


module refresher(clk, x_counter, y_counter);
// refreshes the coordinate of x and y to the next check point.
	input clk;
	output reg [7:0] x_counter;
	output reg [6:0] y_counter;
	
	// set the maximum height and width of the game interface.
	// x and y will scan over every pixel.
	integer max_height = 120;
	integer max_width = 160;
	
	always@(posedge clk)
	begin
		if(x_counter === max_width)
			x_counter <= 0;
		else
			x_counter <= x_counter + 1;
	end

	always@(posedge clk)
	begin
		if(x_counter === max_width)
		begin
			if(y_counter === max_height)
				y_counter <= 0;
			else
			y_counter <= y_counter + 1;
		end
	end
endmodule

module frame_updater(clk, reset_n, frame_update);
	input clk;
	input reset_n;
	output frame_update;
	reg[19:0] delay;
	// Register for the delay counter
	
	always @(posedge clk)
	begin: delay_counter
//		if (!reset_n)
//			delay <= 20'd840000;
		if (delay == 0)
			delay <= 20'd840000;
	   else
		begin
			    delay <= delay - 1'b1;
		end
	end
	
	assign frame_update = (delay == 20'd0)? 1: 0;
endmodule



module delay_counter(clk, reset_n, en_delay,delayed_clk,main_difficulty);
	input clk;
	input reset_n;
	input en_delay;
	input [3:0]main_difficulty;
	output delayed_clk;
	
	reg[3:0] delay;
	
	// Register for the delay counter
	always @(posedge clk)begin
//		if (!reset_n)
//			delay <= 20'd840000;
		if(delay == main_difficulty)
				delay <= 0;
		else if (en_delay)begin
			   delay <= delay + 1'b1;
		end	
	end
	
	assign delayed_clk = (delay == main_difficulty)? 1: 0;
endmodule

	
module Controller(
//	input reset_n,
	input clk,
	output LEDdebug,
//	input esc,
//	input key_up, key_down, key_left, key_right,
	input [4:0] direction,
	input [4:0] number_input,
//	input finished_showing_stage,
	input game_over,
	output reg inmenu,
	output reg ingame,
	output reg inresult,
	output reg initial_head,
	output reg allow_moving,
//	output enable_moving, //for the snake
//	output game_over,
	output reg [3:0] main_difficulty
//	output [3:0] stage
);
   assign LEDdebug = allow_moving;
   wire number_touched = (number_input == 5'b00010
									||number_input == 5'b00100
								   ||number_input == 5'b01000);
   wire direction_touched = (direction == 5'b00010
									||direction == 5'b00100
								   ||direction == 5'b01000
								   ||direction == 5'b10000) ; // detection of starting the snake.
	
	reg [3:0] current_state, next_state;
	
   localparam INIT = 4'd0,
	           MENU = 4'd1,
				  GAME_WAIT = 4'd2,
				  INGAME = 4'd3,
				  GAME_OVER = 4'd4;

	always@(*)
      begin: state_table 
            case (current_state)
					INIT: next_state = MENU;
					MENU: next_state = (number_touched) ? GAME_WAIT : MENU;
					GAME_WAIT: next_state = (direction_touched) ? INGAME : GAME_WAIT;
					INGAME: next_state = (game_over) ? GAME_OVER : INGAME; // 20180723: TO BE CHANGED
					GAME_OVER: next_state = GAME_OVER;
            default: next_state = INIT;
        endcase
      end 
	
	always@(posedge clk)begin
//					case(selected_difficulty)
//						3'b001: main_difficulty <= 2'd10;
//						3'b010: main_difficulty <= 2'd3;
//						3'b100: main_difficulty <= 2'd1;
//						default: main_difficulty <= 2'd1;
//					endcase
		if (current_state == MENU) begin
				if (number_input == 5'b00010)
					main_difficulty <= 4'd4;
				else if (number_input == 5'b00100)
					main_difficulty <= 4'd2;
				else
					main_difficulty <= 4'd1;
		end
	end
		
	always@(*) begin //enable_signals
        // By default make all our signals 0
	       inmenu = 1'b0;
	       ingame = 1'b0;
			 inresult = 1'b0;
			 allow_moving = 1'b0;
			 initial_head = 1'b0;
		  case(current_state)
		      MENU:begin
				      inmenu = 1'b1;
					end
				GAME_WAIT:begin
				      ingame = 1'b1;
					   initial_head = 1'b1;
				end
				INGAME:begin
				      ingame = 1'b1;
						allow_moving = 1'b1;
					end
				GAME_OVER: begin
						inresult = 1'b1;
					end
		  endcase
     end
	
	always@(posedge clk)
      begin
//        if(!reset_n)
//            current_state <= MENU;
//        else
            current_state <= next_state;
      end 
endmodule
module snake_top_level
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input	  CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
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
		
	datapath d0(
	         .clk(CLOCK_50),
	         .direction(5'd0),
				.inmenu(1'd1),
				.ingame(1'd0),
		      .RGB(colour),
				.x_pointer(x),
				.y_pointer(y)
	            );
endmodule


module datapath(clk, direction, inmenu, ingame, RGB, x_pointer, y_pointer);
   input clk;
	output [7:0] x_pointer;
	output [6:0] y_pointer;
	input [4:0] direction;
	//coordinates of snake
	reg [7:0] snake_x [0:127];
	reg [6:0] snake_y [0:127];
	//status of game
   input inmenu;
	input ingame;
	
	wire R, G, B; // Will be used for concatenation for output "RGB".
	wire frame_update; // signal for frame update
	output [2:0] RGB; // the colour used for output
	
	refresher ref0(clk, x_pointer, y_pointer);
	frame_updater upd0(clk, 1'b1, frame_update);
	menu_text_setter menu0(clk, inmenu, x_pointer, y_pointer, menu_text);// check if the pixel is the menu's text.
	
	// Display white: menu_text
	// Display green: the snake's head and the snake's body
	// Display red: the apple, or game over
	// Display blue: the border
	
	assign R = menu_text;  // add more stuff use || and && here!
	assign G = menu_text;  // same as above
	assign B = menu_text;  
   assign RGB = {R, G, B};
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
	
module fsm(
	input reset_n,
	input clk,
	input esc,
	input key_up, key_down, key_left, key_right,
	input num_1, num_2, num_3,
	input finished_showing_stage,
	input bad_collision,
	output inmenu,
	output ingame,
	output enable_moving, //for the snake
	output game_over,
	output reg [1:0] main_difficulty;
//	output [3:0] stage
);

   wire number_touched = num_1 || num_2 || num_3;
	wire key_touched = key_up || key_down || key_left || key_right; // detection of starting the snake.
	
	
	reg [3:0] current_state, next_state;
	
	 
//	localparam  MENU      	  = 4'd0,
//	            STAGE_DISPLAY = 4'd1,
//               GAME_WAIT     = 4'd2,
//					INGAME        = 4'd3,
//					GAME_OVER     = 4'd4;
   localparam MENU = 4'd0,
	           INGAME = 4'd1;

	always@(*)
      begin: state_table 
            case (current_state)
//              MENU: next_state = number_touched ? STAGE_DISPLAY : MENU;
//					 STAGE_DISPLAY: next_state = finished_showing_stage ? GAME_WAIT : STAGE_DISPLAY;
//					 GAME_WAIT: next_state = key_touched ? INGAME : GAME_WAIT;
//					 INGAME: next_state = bad_collision ? GAME_OVER : INGAME;
//					 GAME_OVER: next_state = esc ? MENU : GAME_OVER;
					MENU: next_state = number_touched ? INGAME : MENU;
					INGAME: next_state = INGAME // 20180723: TO BE CHANGED
            default: next_state = MENU;
        endcase
      end 
	
	always@(posedge clk)
		begin: difficulty register
			if (current_state = MENU && number_touched)
				begin
					if (num1)
						main_difficulty <= 2'd1;
					else if (num2)
					   main_difficulty <= 2'd2;
					else if (num3)
					   main_difficulty <= 2'd3;
				end
		end
	
	
	always@(posedge clk)
	if (
		
	always@(*)
      begin: enable_signals
        // By default make all our signals 0
	       inmenu = 1'b0;
	       ingame = 1'b0;
	       game_over = 1'b0;
//	       stage = 4'd0;
			 enable_moving = 1'b0;
		    
		  case(current_state)
		      MENU:begin
				      inmenu = 1'b1;
					end
				INGAME:begin
				      ingame = 1'b1;
						game_over = 1'b0;
						enable_moving = 1'b1;
					end
		  endcase
    end
	
	always@(posedge clock)
      begin: state_FFs
        if(!reset_n)
            current_state <= MENU;
        else
            current_state <= next_state;
      end 

endmodule
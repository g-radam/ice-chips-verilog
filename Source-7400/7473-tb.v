// Test: Dual J-K flip-flop with clear; negative-edge-triggered

module test;

`TBASSERT_METHOD(tbassert)

localparam BLOCKS = 3;

// DUT inputs
reg [BLOCKS-1:0] Clear_bar;
reg [BLOCKS-1:0] J;
reg [BLOCKS-1:0] K;
reg [BLOCKS-1:0] Clk;

// DUT outputs
wire [BLOCKS-1:0] Q;
wire [BLOCKS-1:0] Q_bar;

// DUT
ttl_7473 #(.BLOCKS(BLOCKS), .DELAY_RISE(5), .DELAY_FALL(3)) dut(
  .Clear_bar(Clear_bar),
  .J(J),
  .K(K),
  .Clk(Clk),
  .Q(Q),
  .Q_bar(Q_bar)
);

initial
begin
  $dumpfile("7473-tb.vcd");
  $dumpvars;

  // the following set of tests are for: load

#65
  // initial state
  tbassert(Q === 3'bxxx, "Test 1");
  tbassert(Q_bar === 3'bxxx, "Test 1");
#0
  // load all zeroes, the clock input takes on a value
  Clk = 3'b000;
#7
  tbassert(Q === 3'bxxx, "Test 1");
  tbassert(Q_bar === 3'bxxx, "Test 1");
#0
  // load all zeroes, set up the data
  J = 3'b000;
  K = 3'b111;
#25
  tbassert(Q === 3'bxxx, "Test 1");
  tbassert(Q_bar === 3'bxxx, "Test 1");
#0
  // load all zeroes, wait for clock edge
  Clk = 3'b111;
#2
  tbassert(Q === 3'bxxx, "Test 1");
  tbassert(Q_bar === 3'bxxx, "Test 1");
#0
  // load all zeroes, not enough time for output to fall/rise
  Clk = 3'b000;
#2
  tbassert(Q === 3'bxxx, "Test 1");
  tbassert(Q_bar === 3'bxxx, "Test 1");
#5
  // load all zeroes -> output 0s
  tbassert(Q == 3'b000, "Test 1");
  tbassert(Q_bar == 3'b111, "Test 1");
#140
  // hold state
  Clk = 3'b111;
#175
  tbassert(Q == 3'b000, "Test 2");
  tbassert(Q_bar == 3'b111, "Test 2");
#0
  // load all ones, set up the data
  J = 3'b111;
  K = 3'b000;
#125
  tbassert(Q == 3'b000, "Test 3");
  tbassert(Q_bar == 3'b111, "Test 3");
#0
  // load all ones, not enough time for output to rise/fall
  Clk = 3'b000;
#2
  tbassert(Q == 3'b000, "Test 3");
  tbassert(Q_bar == 3'b111, "Test 3");
#5
  // load all ones -> output 1s
  tbassert(Q == 3'b111, "Test 3");
  tbassert(Q_bar == 3'b000, "Test 3");
#50
  // hold state
  Clk = 3'b111;
#125
  tbassert(Q == 3'b111, "Test 4");
  tbassert(Q_bar == 3'b000, "Test 4");
#0
  // hold state, the clear input takes on a value
  Clear_bar = 3'b111;
#50
  tbassert(Q == 3'b111, "Test 4");
  tbassert(Q_bar == 3'b000, "Test 4");
#0
  // load 010, set up the data
  J = 3'b010;
  K = 3'b101;
#15
  // load 010, apply clock edge in first block separately -> output 110
  Clk[0] = 1'b0;
#7
  tbassert(Q == 3'b110, "Test 5");
  tbassert(Q_bar == 3'b001, "Test 5");
#25
  // load 010, apply clock edge in second block separately -> output 110
  Clk[1] = 1'b0;
#7
  tbassert(Q == 3'b110, "Test 6");
  tbassert(Q_bar == 3'b001, "Test 6");
#25
  // load 010, apply clock edge in third block separately -> output 010
  Clk[2] = 1'b0;
#7
  tbassert(Q == 3'b010, "Test 7");
  tbassert(Q_bar == 3'b101, "Test 7");
#140
  // hold state, end clock pulse in second block separately
  Clk[1] = 1'b1;
#7
  tbassert(Q == 3'b010, "Test 8");
  tbassert(Q_bar == 3'b101, "Test 8");
#10
  // hold state, end clock pulse in first block separately
  Clk[0] = 1'b1;
#7
  tbassert(Q == 3'b010, "Test 8");
  tbassert(Q_bar == 3'b101, "Test 8");
#10
  // hold state, end clock pulse in third block separately
  Clk[2] = 1'b1;
#50
  tbassert(Q == 3'b010, "Test 8");
  tbassert(Q_bar == 3'b101, "Test 8");
#0

  // the following set of tests are for: toggle

  // toggle, set up the data
  J = 3'b111;
  K = 3'b111;
  // Clk = 3'b111;
#75
  tbassert(Q == 3'b010, "Test 9");
  tbassert(Q_bar == 3'b101, "Test 9");
#0
  // toggle -> output 101
  Clk = 3'b000;
#7
  tbassert(Q == 3'b101, "Test 9");
  tbassert(Q_bar == 3'b010, "Test 9");
#50
  // hold state
  Clk = 3'b111;
#50
  tbassert(Q == 3'b101, "Test 10");
  tbassert(Q_bar == 3'b010, "Test 10");
#0
  // J = 3'b111;
  // K = 3'b111;
#15
  tbassert(Q == 3'b101, "Test 11");
  tbassert(Q_bar == 3'b010, "Test 11");
#0
  // toggle -> output 010
  Clk = 3'b000;
#7
  tbassert(Q == 3'b010, "Test 11");
  tbassert(Q_bar == 3'b101, "Test 11");
#10
  // hold state
  Clk = 3'b111;
#75
  tbassert(Q == 3'b010, "Test 12");
  tbassert(Q_bar == 3'b101, "Test 12");
#0
  // J = 3'b111;
  // K = 3'b111;
#15
  // toggle, apply clock edge in third block separately -> output 110
  Clk[2] = 1'b0;
#7
  tbassert(Q == 3'b110, "Test 13");
  tbassert(Q_bar == 3'b001, "Test 13");
#15
  // hold state
  Clk[2] = 1'b1;
#50
  tbassert(Q == 3'b110, "Test 14");
  tbassert(Q_bar == 3'b001, "Test 14");
#0
  // toggle, apply clock edge in second block separately -> output 100
  Clk[1] = 1'b0;
#7
  tbassert(Q == 3'b100, "Test 15");
  tbassert(Q_bar == 3'b011, "Test 15");
#10
  // hold state
  Clk = 3'b111;
#100
  tbassert(Q == 3'b100, "Test 16");
  tbassert(Q_bar == 3'b011, "Test 16");
#0

  // the following set of tests are for: load and toggle in combination

  // load first and second blocks, toggle third block, set up the data
  J = 3'b101;
  K = 3'b110;
  // Clk = 3'b111;
#125
  tbassert(Q == 3'b100, "Test 17");
  tbassert(Q_bar == 3'b011, "Test 17");
#0
  // load first and second blocks, toggle third block -> output 001
  Clk = 3'b000;
#7
  tbassert(Q == 3'b001, "Test 17");
  tbassert(Q_bar == 3'b110, "Test 17");
#50
  // hold state
  Clk = 3'b111;
#40
  tbassert(Q == 3'b001, "Test 18");
  tbassert(Q_bar == 3'b110, "Test 18");
#0
  // load second and third blocks, toggle first block, set up the data
  J = 3'b101;
  K = 3'b011;
#125
  tbassert(Q == 3'b001, "Test 19");
  tbassert(Q_bar == 3'b110, "Test 19");
#0
  // load second and third blocks, toggle first block -> output 001
  Clk = 3'b000;
#7
  tbassert(Q == 3'b100, "Test 19");
  tbassert(Q_bar == 3'b011, "Test 19");
#50
  // hold state
  Clk = 3'b111;
#40
  tbassert(Q == 3'b100, "Test 20");
  tbassert(Q_bar == 3'b011, "Test 20");
#0
  // load second and third blocks, toggle first block, set up the data
  J = 3'b011;
  K = 3'b101;
#15
  // load second and third blocks, toggle first block, apply clock edge in first and
  // second blocks -> output 111
  Clk = 3'b100;
#7
  tbassert(Q == 3'b111, "Test 21");
  tbassert(Q_bar == 3'b000, "Test 21");
#50
  // hold state
  Clk = 3'b111;
#40
  tbassert(Q == 3'b111, "Test 22");
  tbassert(Q_bar == 3'b000, "Test 22");
#0
  // load second and third blocks, toggle first block, apply clock edge in first and
  // second blocks -> output 110
  // J = 3'b011;
  // K = 3'b101;
#15
  tbassert(Q == 3'b111, "Test 23");
  tbassert(Q_bar == 3'b000, "Test 23");
#0
  Clk = 3'b100;
#7
  tbassert(Q == 3'b110, "Test 23");
  tbassert(Q_bar == 3'b001, "Test 23");
#10
  // hold state
  Clk = 3'b111;
#100
  tbassert(Q == 3'b110, "Test 24");
  tbassert(Q_bar == 3'b001, "Test 24");
#0

  // the following set of tests are for: hold state (clocked) and load and toggle in
  // combination

  // load first block, hold second block, toggle third block, set up the data
  J = 3'b101;
  K = 3'b100;
  // Clk = 3'b111;
#40
  tbassert(Q == 3'b110, "Test 25");
  tbassert(Q_bar == 3'b001, "Test 25");
#0
  // load first block, hold second block, toggle third block -> output 011
  Clk = 3'b000;
#7
  tbassert(Q == 3'b011, "Test 25");
  tbassert(Q_bar == 3'b100, "Test 25");
#50
  // hold state
  Clk = 3'b111;
#40
  tbassert(Q == 3'b011, "Test 26");
  tbassert(Q_bar == 3'b100, "Test 26");
#0
  // hold first block, toggle second block, load third block, set up the data
  J = 3'b010;
  K = 3'b110;
#15
  // hold first block, toggle second block, load third block, apply clock edge in
  // first and second blocks -> output 001
  Clk = 3'b100;
#7
  tbassert(Q == 3'b001, "Test 27");
  tbassert(Q_bar == 3'b110, "Test 27");
#50
  // hold state
  Clk = 3'b111;
#40
  tbassert(Q == 3'b001, "Test 28");
  tbassert(Q_bar == 3'b110, "Test 28");
#0
  // hold first and second blocks, toggle third block, apply clock edge in
  // first and third blocks -> output 101
  J = 3'b100;
  K = 3'b100;
#15
  tbassert(Q == 3'b001, "Test 29");
  tbassert(Q_bar == 3'b110, "Test 29");
#0
  Clk = 3'b010;
#7
  tbassert(Q == 3'b101, "Test 29");
  tbassert(Q_bar == 3'b010, "Test 29");
#10
  // hold state
  Clk = 3'b111;
#50
  tbassert(Q == 3'b101, "Test 30");
  tbassert(Q_bar == 3'b010, "Test 30");
#0

  // the following set of tests are for: clear

  // clear from 101, not enough time for output to fall/rise
  Clear_bar = 3'b000;
#2
  tbassert(Q == 3'b101, "Test 31");
  tbassert(Q_bar == 3'b010, "Test 31");
#5
  // clear from 101 -> output 0s
  tbassert(Q == 3'b000, "Test 31");
  tbassert(Q_bar == 3'b111, "Test 31");
#150
  // hold state -> remains clear after clear signal ends
  Clear_bar = 3'b111;
#120
  tbassert(Q == 3'b000, "Test 32");
  tbassert(Q_bar == 3'b111, "Test 32");
#50
  // load new value
  J = 3'b011;
  K = 3'b100;
#15
  Clk = 3'b000;
#15
  Clk = 3'b111;
#15
  tbassert(Q == 3'b011, "Test 33");
  tbassert(Q_bar == 3'b100, "Test 33");
#0
  // set up different data input values, toggle
  J = 3'b111;
  K = 3'b111;
#15
  // clear from 011 in contention with toggle (at clock edge in second and third blocks)
  Clear_bar = 3'b000;
  Clk = 3'b001;
#2
  tbassert(Q == 3'b011, "Test 33");
  tbassert(Q_bar == 3'b100, "Test 33");
#5
  // clear from 011 in contention with toggle -> output 0s
  tbassert(Q == 3'b000, "Test 33");
  tbassert(Q_bar == 3'b111, "Test 33");
#10
  // clear from 011, apply clock edge in first block separately with null effect on output
  Clk[0] = 1'b0;
#7
  tbassert(Q == 3'b000, "Test 33");
  tbassert(Q_bar == 3'b111, "Test 33");
#150
  // hold state, second block -> remains clear after clear signal ends
  Clear_bar[1] = 1'b1;
#20
  tbassert(Q == 3'b000, "Test 34");
  tbassert(Q_bar == 3'b111, "Test 34");
#0
  // hold state, first block
  Clear_bar[0] = 1'b1;
#7
  tbassert(Q == 3'b000, "Test 34");
  tbassert(Q_bar == 3'b111, "Test 34");
#10
  // hold state, third block
  Clear_bar[2] = 1'b1;
#70
  tbassert(Q == 3'b000, "Test 34");
  tbassert(Q_bar == 3'b111, "Test 34");
#0
  // hold state, end clock pulse in first and third blocks
  Clk = 3'b101;
#70
  tbassert(Q == 3'b000, "Test 34");
  tbassert(Q_bar == 3'b111, "Test 34");
#0
  Clk[1] = 1'b1;
#50
  // load new value
  J = 3'b111;
  K = 3'b001;
#15
  Clk = 3'b000;
#15
  Clk = 3'b111;
#15
  tbassert(Q == 3'b111, "Test 35");
  tbassert(Q_bar == 3'b000, "Test 35");
#0
  // set up different data input values
  J = 3'b110;
  K = 3'b011;
#15
  // clear third block separately -> output 011
  Clear_bar[2] = 1'b0;
#20
  tbassert(Q == 3'b011, "Test 35");
  tbassert(Q_bar == 3'b100, "Test 35");
#0
  Clear_bar[2] = 1'b1;
#50
  // load new value
  J = 3'b011;
  K = 3'b100;
#15
  Clk = 3'b000;
#15
  Clk = 3'b111;
#15
  tbassert(Q == 3'b011, "Test 36");
  tbassert(Q_bar == 3'b100, "Test 36");
#0
  // set up different data input values, load and toggle
  J = 3'b110;
  K = 3'b101;
#40
  // clear from 011 in contention with load and toggle (at clock edge in
  // second and third blocks)
  Clear_bar = 3'b000;
  Clk = 3'b001;
#2
  tbassert(Q == 3'b011, "Test 36");
  tbassert(Q_bar == 3'b100, "Test 36");
#5
  // clear from 011 in contention with load and toggle -> output 0s
  tbassert(Q == 3'b000, "Test 36");
  tbassert(Q_bar == 3'b111, "Test 36");
#10
  // clear from 011, apply clock edge in first block separately with null effect on output
  Clk[0] = 1'b0;
#7
  tbassert(Q == 3'b000, "Test 37");
  tbassert(Q_bar == 3'b111, "Test 37");
#70
  // hold state, second block -> remains clear after clear signal ends
  Clear_bar[1] = 1'b1;
#20
  tbassert(Q == 3'b000, "Test 38");
  tbassert(Q_bar == 3'b111, "Test 38");
#0
  // hold state, third block
  Clear_bar[2] = 1'b1;
#7
  tbassert(Q == 3'b000, "Test 38");
  tbassert(Q_bar == 3'b111, "Test 38");
#10
  // hold state, first block
  Clear_bar[0] = 1'b1;
#70
  tbassert(Q == 3'b000, "Test 38");
  tbassert(Q_bar == 3'b111, "Test 38");
#0
  // hold state, end clock pulse in first and third blocks
  Clk = 3'b101;
#70
  tbassert(Q == 3'b000, "Test 38");
  tbassert(Q_bar == 3'b111, "Test 38");
#0
  Clk[1] = 1'b1;
#50

  // the following set of tests are for: hold state and applying clock edge in
  // each block separately

  // load new value
  J = 3'b101;
  K = 3'b010;
#15
  Clk = 3'b000;
#15
  Clk = 3'b111;
#15
  tbassert(Q == 3'b101, "Test 39");
  tbassert(Q_bar == 3'b010, "Test 39");
#0
  // hold state (clocked) with null effect on output 101
  J = 3'b000;
  K = 3'b000;
#7
  Clk = 3'b000;
#25
  Clk = 3'b111;
#15
  tbassert(Q == 3'b101, "Test 39");
  tbassert(Q_bar == 3'b010, "Test 39");
#0
  // load same value appearing at the output with null effect on output 101
  J = 3'b101;
  K = 3'b010;
#7
  // apply clock edge in third block separately
  Clk = 3'b011;
#20
  tbassert(Q == 3'b101, "Test 40");
  tbassert(Q_bar == 3'b010, "Test 40");
#0
  // apply clock edge in first and second blocks separately
  Clk = 3'b000;
#20
  tbassert(Q == 3'b101, "Test 40");
  tbassert(Q_bar == 3'b010, "Test 40");
#0
  Clk = 3'b111;
#15
  // transient (unclocked) change to data input with null effect on output
  Clk = 3'b000;
#7
  J = 3'b011;
  K = 3'b101;
#75
  tbassert(Q == 3'b101, "Test 41");
  tbassert(Q_bar == 3'b010, "Test 41");
#0
  Clk = 3'b111;
#25
  // set up different data input values
  J = 3'bzz0;
  K = 3'bz01;
#50
  tbassert(Q == 3'b101, "Test 41");
  tbassert(Q_bar == 3'b010, "Test 41");
#0
  // load new value in first block separately
  J = 3'bz10;
  K = 3'bz11;
#40
  Clk = 3'b110;
#15
  Clk = 3'b111;
#15
  tbassert(Q == 3'b100, "Test 42");
  tbassert(Q_bar == 3'b011, "Test 42");
#0
  // load same value appearing at the output with null effect on output
  J = 3'b100;
  K = 3'b011;
#7
  // apply clock edge in first block separately
  Clk = 3'b110;
#20
  tbassert(Q == 3'b100, "Test 43");
  tbassert(Q_bar == 3'b011, "Test 43");
#0
  // apply clock edge in second and third blocks, end clock pulse in first block
  Clk = 3'b001;
#40
  tbassert(Q == 3'b100, "Test 44");
  tbassert(Q_bar == 3'b011, "Test 44");
#0
  Clk = 3'b111;
#15
  // hold value in third block separately
  J = 3'b011;
  K = 3'b011;
#40
  Clk = 3'b011;
#15
  Clk = 3'b111;
#15
  tbassert(Q == 3'b100, "Test 45");
  tbassert(Q_bar == 3'b011, "Test 45");
#0
  // toggle value in first block separately
  // J = 3'b011;
  // K = 3'b011;
#40
  Clk = 3'b110;
#15
  Clk = 3'b111;
#15
  tbassert(Q == 3'b101, "Test 46");
  tbassert(Q_bar == 3'b010, "Test 46");
#50
  $finish;
end

endmodule

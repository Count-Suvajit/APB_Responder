module apb_responder(
  input pclk,
  input prstn,
  input pwrite,
  input [3:0] paddr,
  input [7:0] pwdata,
  input psel,
  input penable,
  output reg pready,
  output wire [7:0] prdata
);
  
  reg [7:0] mem[16];
  reg [7:0] prdata_r;
  
  always @(posedge pclk, negedge prstn) begin
    if(prstn==0) begin
      pready<=0;
      prdata_r<=0;
      foreach(mem[i])
        mem[i]<=8'h0;
    end else begin
      if(psel==1 && penable==0 && pwrite==0)
        prdata_r<=mem[paddr];
      if(psel==1 && penable==1 && pwrite==1 && pready==1)  
        mem[paddr]<=pwdata;
    end
    
  end
 
  assign prdata = pwrite==0 && penable==1 && pready==1 ? prdata_r : 8'h0;
  
  always @(posedge pclk) begin
    pready <= $random;
  end
  
  initial begin
    $monitor("RTL DBG [time=%0t] curr=%s", $time,curr.name);
  end
  
endmodule

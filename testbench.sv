module testbench();
  
  reg pclk;
  reg prstn;
  reg pwrite;
  reg [3:0] paddr;
  reg [7:0] pwdata;
  reg psel;
  reg penable;
  reg pready;
  reg [7:0] prdata;
  
  apb_responder dut(.*);
  
  initial begin
    pclk<=0;
    #40 $finish();
  end
  
  initial begin
    #1;
    forever begin
       #1 pclk<=~pclk;
    end
  end
  
  task reset;
    prstn<=0;
    psel<=0;
    penable<=0;
    repeat(2)
    @(posedge pclk);
    prstn<=1;
  endtask
  
  initial begin
    reset();
    /*repeat(50) begin
       randcase
       1: write();
       1: drive_idle();
       1: read();    
       endcase
    end*/
    write(3);
    write(7);
    write(9);    
    read(3);
    read(7);
    read(9);    
    drive_idle;
  end
  
  task write(reg [3:0] addr=16);
    @(posedge pclk);
    paddr<= addr == 16? $urandom(): addr;
    psel<=1;
    pwrite<=1;
    penable<=0;
    pwdata<=$urandom();
    do begin
      @(posedge pclk);
      penable<=1;
    end while(pready==0);
    $display("[WRITE] [time=%0t], addr=%0h, write_data=%0h, ready=%0h", $time,paddr,pwdata,pready);    
  endtask
  
  task drive_idle;
    @(posedge pclk);
    paddr<=8'h0;    
    psel<=0;
    pwrite<=0;
    penable<=0;
  endtask
  
  task read(reg [3:0] addr=16);
    @(posedge pclk);
    paddr<=addr == 16? $urandom(): addr;    
    psel<=1;
    pwrite<=0;
    penable<=0;
    do begin
      @(posedge pclk);
      penable<=1;
    end while(pready==0);
    $display("[READ] [time=%0t], addr=%0h, read_data=%0h, ready=%0h", $time,paddr,prdata,pready);
  endtask
  
  initial begin
    $monitor("[time=%0t], paddr=%0h, penable=%0h, psel=%0h, pready=%0h, pwdata=%0h, pwrite=%0h, prdata=%0h", $time,paddr,penable,psel,pready,pwdata,pwrite,prdata);
  end

endmodule

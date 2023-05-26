`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/26 15:17:13
// Design Name: 
// Module Name: ifetc32_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ifetc32_tb();
    reg clk, rst,Branch,nBranch,Jmp,Jal,Jr,Zero;
    reg[31:0] Addr_result,Read_data_1,Instruction;
    wire [31:0] branch_base_addr,link_addr,PC;
    IFetc32 if33(.Insturction_i(Instruction),.branch_base_addr(branch_base_addr),.Addr_result(Addr_result),.rom_adr_o(PC),
    .Read_data_1(Read_data_1),.Branch(Branch),.nBranch(nBranch),.Jmp(Jmp),.Jal(Jal),.Jr(Jr),.Zero(Zero),.clock(clk),.reset(rst),.link_addr(link_addr));
    
   
    
    
    initial #130 $finish;
    initial begin
        Instruction=32'h0000_0000;
        clk = 1'b0;
        rst=1'b1;
        Branch = 1'b0;
        nBranch = 1'b0;
        Jmp = 1'b0;
        Jal = 1'b0;
        Jr = 1'b0;
        Zero = 1'b0;
        Addr_result = 32'b0;
        Read_data_1 = 32'b0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        #10 begin rst = 1'b0;
        $strobe("@@@@@@@@@@1@@@@@@@@@@");
		$strobe("%d %d %d %d %d %d %d %d %d %d %d",clk, rst,Branch,nBranch,Jmp,Jal,Jr,Zero,Addr_result,Read_data_1,Instruction);
        $strobe("@@@@@@@@@@1@@@@@@@@@@");
		end

		/*beq $t1,$t0,L1*/
        #30 begin Branch=1'b1;
        Instruction=32'h3c02ffff;
        Zero = 1'b1;
        Addr_result = (32'd5)<<2;  // 20 in decimal, which is the address of instruction: bne $t1,$t2,L3
        // (Branch == 1) && (Zero == 1) instruction need to be taken out according to Addr_result
        $strobe("@@@@@@@@@@2@@@@@@@@@@");
		$strobe("%d %d %d %d %d %d %d %d %d %d %d %d",clk, rst,Branch,nBranch,Jmp,Jal,Jr,Zero,Addr_result,Read_data_1,Instruction,branch_base_addr);
        $strobe("@@@@@@@@@@2@@@@@@@@@@");
		end

		/*bne $t1,$t2,L3*/
        #10 begin 
        Instruction=32'h3c02ffff;
        Branch = 1'b0;
        Zero = 1'b0;
        nBranch = 1'b1;
        Addr_result = (32'd8)<<2; // 32 in decimal, which is the address of instruction: jal L2
        // (nBranch == 1) && (Zero == 0) instruction need to be taken out according to Addr_result
        $strobe("@@@@@@@@@@3@@@@@@@@@@");
		$strobe("%d %d %d %d %d %d %d %d %d %d %d %d",clk, rst,Branch,nBranch,Jmp,Jal,Jr,Zero,Addr_result,Read_data_1,Instruction,branch_base_addr);
        $strobe("@@@@@@@@@@3@@@@@@@@@@");
		end
        
		/*jal L2*/
		// recover the initial value of nBranch and Addr_result, test jal
        #10 begin Jal = 1'b1;
        nBranch = 1'b0;
        Addr_result = (32'd0)<<2;
        $strobe("@@@@@@@@@@4@@@@@@@@@@");
		$strobe("%d %d %d %d %d %d %d %d %d %d %d %d",clk, rst,Branch,nBranch,Jmp,Jal,Jr,Zero,Addr_result,Read_data_1,Instruction,link_addr);
        $strobe("@@@@@@@@@@4@@@@@@@@@@");
        end

        /*ori $t3,$zero,44*/
        #10 begin Jal = 1'b0;
        end

        /*j L4*/
		#10 begin Jmp = 1'b1;  
        $strobe("@@@@@@@@@@5@@@@@@@@@@");
        $strobe("%d %d %d %d %d %d %d %d %d %d %d",clk, rst,Branch,nBranch,Jmp,Jal,Jr,Zero,Addr_result,Read_data_1,Instruction);
        $strobe("@@@@@@@@@@5@@@@@@@@@@");
        end

        /*jr $t3*/
        #10 begin Jr = 1'b1;
        Jmp = 1'b0;
        Read_data_1 = 32'd44;  // the address of instruction: beq $t1,$t2,start
        $strobe("@@@@@@@@@@6@@@@@@@@@@");
        $strobe("%d %d %d %d %d %d %d %d %d %d %d",clk, rst,Branch,nBranch,Jmp,Jal,Jr,Zero,Addr_result,Read_data_1,Instruction);
        $strobe("@@@@@@@@@@6@@@@@@@@@@");
        end

        /*beq $t1,$t2,start*/
        #10 begin 
        Read_data_1 =  1'b0;
        Jr =  1'b0;
        Branch = 1'b1;
        Zero = 1'b0;
        Addr_result = (32'd0)<<2;
        // (Branch == 1) && (Zero == 0), no need to jump to label start, the next statement will be execute
        $strobe("@@@@@@@@@@7@@@@@@@@@@");
        $strobe("%d %d %d %d %d %d %d %d %d %d %d %d",clk, rst,Branch,nBranch,Jmp,Jal,Jr,Zero,Addr_result,Read_data_1,Instruction,branch_base_addr);
        $strobe("@@@@@@@@@@7@@@@@@@@@@");
        end

        /*bne $t1,$t0,start*/
        #10 begin 
        Branch =  1'b0;
        nBranch = 1'b1;
        Zero = 1'b1;
        Addr_result = (32'd0)<<2;  // the address of label start
        //  (nBranch == 1) && (Zero == 1) , no need to jump to label start, the next statement will be execute
        $strobe("@@@@@@@@@@8@@@@@@@@@@");
        $strobe("%d %d %d %d %d %d %d %d %d %d %d %d",clk, rst,Branch,nBranch,Jmp,Jal,Jr,Zero,Addr_result,Read_data_1,Instruction,branch_base_addr);
        $strobe("@@@@@@@@@@8@@@@@@@@@@");
        end
        
        /*beq $t1,$t0,start*/
        #10 begin 
        Branch =  1'b1;
        nBranch = 1'b0;
        Zero = 1'b1;
        Addr_result = (32'd0)<<2; // the address of label start
        // (Branch == 1) && (Zero == 1) instruction need to be taken out according to Addr_result
        $strobe("@@@@@@@@@@9@@@@@@@@@@");
        $strobe("%d %d %d %d %d %d %d %d %d %d %d %d",clk, rst,Branch,nBranch,Jmp,Jal,Jr,Zero,Addr_result,Read_data_1,Instruction,branch_base_addr);
        $strobe("@@@@@@@@@@9@@@@@@@@@@");
        end
    end
endmodule

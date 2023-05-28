`timescale 1ns / 1ps


module song(
input sys_clk,           //正常系统时钟
input [1:0] en,          //en   00:不发声        01：放音乐       10：Error     11：结束音
output reg speaker     //引脚    T1
    );
    wire clk_6mhz;       //??¨?????§???????§?é??é??é??????????????é???????
    clk_self #(8) u1(
        .clk(sys_clk),
        .clk_self(clk_6mhz)      //6.25MHz???é???????ˇ
    );                           
    wire clk_4hz;                //??¨?????§???é??é????????????????????é??é???????
    clk_self #(12500000) u2(
        .clk(sys_clk),
        .clk_self(clk_4hz)       //?????°4Hz???????????
    );
    reg [13:0] divider,origin;
    reg carry;
    reg [7:0] counter;
    reg [3:0] high,med,low;
    always @(posedge clk_6mhz) begin   //é?????é???????°?????????é?????
        if (divider==16383) begin
            divider<=origin;
            carry<=1;
        end
        else begin
            divider<=divider+1;
            carry<=0;
        end
    end
    always @(posedge carry) begin
        speaker<=~speaker;
    end
    always @(posedge clk_4hz) begin
        case({high,med,low})
            'h001: origin<=4915; 'h002: origin<=6168;
            'h003: origin<=7281; 'h004: origin<=7792;
            'h005: origin<=8730; 'h006: origin<=9565;
            'h007: origin<=10310; 'h010: origin<=10647;
            'h020: origin<=11272; 'h030: origin<=11831;
            'h040: origin<=12094; 'h050: origin<=12556;
            'h060: origin<=12947; 'h070: origin<=13346;
            'h100: origin<=13516; 'h200: origin<=13829;
            'h300: origin<=14109; 'h400: origin<=14235;
            'h500: origin<=14470; 'h600: origin<=14678;
            'h700: origin<=14864; 'h000: origin<=16383;
        endcase
    end

    always @(posedge clk_4hz) begin
        if (en==2'b01) begin
             if(counter==134)
            counter<=0;
        else
            counter<=counter+1;
        case (counter)  
        0:begin {high,med,low} <= 'h003;   end
        1:begin {high,med,low}<='h003; end
        2:begin {high,med,low}<='h003;  end
        3:begin {high,med,low}<='h003;  end
        4:begin {high,med,low}<='h005;  end
        5:begin {high,med,low}<='h005;  end
        6:begin {high,med,low}<='h005;  end
        7:begin {high,med,low}<='h006;  end
        8:begin {high,med,low}<='h010;  end
        9:begin {high,med,low}<='h010;  end
        10:begin {high,med,low}<='h010;  end
        11:begin {high,med,low}<='h020; end
        12:begin {high,med,low}<='h006;  end
        13:begin {high,med,low}<='h010; end
        14:begin {high,med,low}<='h005; end
        15:begin {high,med,low}<='h005; end
        16:begin {high,med,low}<='h050;  end
        17:begin {high,med,low}<='h050; end
        18:begin {high,med,low}<='h050; end
        19:begin {high,med,low}<='h100; end
        20:begin {high,med,low}<='h060;  end 
        21:begin {high,med,low}<='h050;  end
        22:begin {high,med,low}<='h030;  end
        23:begin {high,med,low}<='h050; end
        24:begin {high,med,low}<='h020;  end
        25:begin {high,med,low}<='h020; end
        26:begin {high,med,low}<='h020; end
        27:begin {high,med,low}<='h020; end 
        28:begin {high,med,low}<='h020;  end
        29:begin {high,med,low}<='h020;  end
        30:begin {high,med,low}<='h000;  end
        31:begin {high,med,low}<='h000;  end
        32:begin {high,med,low}<='h020;  end
        33:begin {high,med,low}<='h020;  end
        34:begin {high,med,low}<='h020;  end
        35:begin {high,med,low}<='h030;  end
        36:begin {high,med,low}<='h007;  end
        37:begin {high,med,low}<='h007;  end
        38:begin {high,med,low}<='h006;  end
        39:begin {high,med,low}<='h006;  end
        40:begin {high,med,low}<='h005;  end 
        41:begin {high,med,low}<='h005; end
        42:begin {high,med,low}<='h005; end
        43:begin {high,med,low}<='h006; end
        44:begin {high,med,low}<='h010;  end
        45:begin {high,med,low}<='h010;  end
        46:begin {high,med,low}<='h020; end
        47:begin {high,med,low}<='h020; end 
        48:begin {high,med,low}<='h003; end
        49:begin {high,med,low}<='h003; end
        50:begin {high,med,low}<='h010;  end
        51:begin {high,med,low}<='h010;end
        52:begin {high,med,low}<='h006; end
        53:begin {high,med,low}<='h005;  end
        54:begin {high,med,low}<='h006; end
        55:begin {high,med,low}<='h010;  end
        56:begin {high,med,low}<='h005;  end
        57:begin {high,med,low}<='h005;  end
        58:begin {high,med,low}<='h005;  end
        59:begin {high,med,low}<='h005;  end
        60:begin {high,med,low}<='h005;  end 
        61:begin {high,med,low}<='h005; end
        62:begin {high,med,low}<='h005; end
        63:begin {high,med,low}<='h005; end
        64:begin {high,med,low}<='h030; end
        65:begin {high,med,low}<='h030; end
        66:begin {high,med,low}<='h030; end
        67:begin {high,med,low}<='h050;end 
        68:begin {high,med,low}<='h007; end
        69:begin {high,med,low}<='h007; end
        70:begin {high,med,low}<='h020; end
        71:begin {high,med,low}<='h020; end
        72:begin {high,med,low}<='h006; end
        73:begin {high,med,low}<='h010;  end
        74:begin {high,med,low}<='h005; end
        75:begin {high,med,low}<='h005; end
        76:begin {high,med,low}<='h005; end
        77:begin {high,med,low}<='h005; end
        78:begin {high,med,low}<='h000; end
        79:begin {high,med,low}<='h000; end
        80:begin {high,med,low}<='h003; end 
        81:begin {high,med,low}<='h005; end
        82:begin {high,med,low}<='h005; end
        83:begin {high,med,low}<='h003; end
        84:begin {high,med,low}<='h005; end
        85:begin {high,med,low}<='h006; end
        86:begin {high,med,low}<='h007; end
        87:begin {high,med,low}<='h020; end 
        88:begin {high,med,low}<='h006; end
        89:begin {high,med,low}<='h006; end
        90:begin {high,med,low}<='h006; end
        91:begin {high,med,low}<='h006; end
        92:begin {high,med,low}<='h006; end
        93:begin {high,med,low}<='h006; end
        94:begin {high,med,low}<='h005; end
        95:begin {high,med,low}<='h006; end
        96:begin {high,med,low}<='h010; end
        97:begin {high,med,low}<='h010; end
        98:begin {high,med,low}<='h010; end
        99:begin {high,med,low}<='h020; end
        100:begin {high,med,low}<='h050; end 
        101:begin {high,med,low}<='h050; end
        102:begin {high,med,low}<='h030; end
        103:begin {high,med,low}<='h030; end
        104:begin {high,med,low}<='h020; end
        105:begin {high,med,low}<='h020; end
        106:begin {high,med,low}<='h030; end
        107:begin {high,med,low}<='h020; end 
        108:begin {high,med,low}<='h010; end
        109:begin {high,med,low}<='h010; end
        110:begin {high,med,low}<='h006; end
        111:begin {high,med,low}<='h005; end
        112:begin {high,med,low}<='h003; end
        113:begin {high,med,low}<='h003; end
        114:begin {high,med,low}<='h003; end
        115:begin {high,med,low}<='h003; end
        116:begin {high,med,low}<='h010; end
        117:begin {high,med,low}<='h010; end
        118:begin {high,med,low}<='h010; end
        119:begin {high,med,low}<='h010; end
        120:begin {high,med,low}<='h006; end 
        121:begin {high,med,low}<='h010; end
        122:begin {high,med,low}<='h006; end
        123:begin {high,med,low}<='h005; end
        124:begin {high,med,low}<='h003; end
        125:begin {high,med,low}<='h005; end
        126:begin {high,med,low}<='h006; end
        127:begin {high,med,low}<='h010; end 
        128:begin {high,med,low}<='h005; end
        129:begin {high,med,low}<='h005; end
        130:begin {high,med,low}<='h005; end
        131:begin {high,med,low}<='h005; end
        132:begin {high,med,low}<='h005; end
        133:begin {high,med,low}<='h000; end
        134:begin {high,med,low}<='h000; end
    endcase
    end
    else if(en==2'b10) begin
        if(counter==134)
          counter<=0;
        else
          counter<=counter+1;
        {high,med,low}<='h010;  
    end
    else if(en==2'b00)begin
        {high,med,low}<='h000; 
        counter<= 0;
    end
    else begin
        counter <= 0;
        if (counter<5) begin
            counter<=counter+1;
            {high,med,low}<='h005;
        end
        else begin
            {high,med,low}<='h000;
        end
    end
    end
endmodule


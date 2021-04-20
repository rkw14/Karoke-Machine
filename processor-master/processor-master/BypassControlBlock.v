module BypassControlBlock(dx_ir,xm_ir,mw_ir,dx_bypassawx,dx_bypassamx,dx_bypassbwx,dx_bypassbmx,xm_bypassbwm);

    input[31:0] dx_ir,xm_ir,mw_ir;
    output dx_bypassawx,dx_bypassamx,dx_bypassbwx,dx_bypassbmx;
    output xm_bypassbwm;
    wire w1,w2,dx_bypassamx_temp,dx_bypassbmx_temp,dx_bypassawx_temp,dx_bypassbwx_temp;
    wire check_dxj,check_dxbne,check_dxblt,check_dxbex,check_dxjal,check_dxjr,check_dxsetx;
    wire ji_instr,i_instr,jii_instr,dx_bypassamx_temp2,dx_bypassamx_temp3,dx_bypassamx_temp4;
    wire dx_bypassawx_temp2,dx_bypassawx_temp3,dx_bypassawx_temp4;

    and and_j(check_dxj, ~dx_ir[31], ~dx_ir[30], ~dx_ir[29], ~dx_ir[28], dx_ir[27]);      
    and and_bne(check_dxbne, ~dx_ir[31], ~dx_ir[30], ~dx_ir[29], dx_ir[28], ~dx_ir[27]);
    and and_blt(check_dxblt, ~dx_ir[31], ~dx_ir[30], dx_ir[29], dx_ir[28], ~dx_ir[27]);     
    and and_bex(check_dxbex, dx_ir[31], ~dx_ir[30], dx_ir[29], dx_ir[28], ~dx_ir[27]);
    and and_setx(check_dxsetx, dx_ir[31], ~dx_ir[30], dx_ir[29], ~dx_ir[28], dx_ir[27]);       
    and and_jal(check_dxjal, ~dx_ir[31], ~dx_ir[30], ~dx_ir[29], dx_ir[28], dx_ir[27]);     
    and and_jr(check_dxjr, ~dx_ir[31], ~dx_ir[30], dx_ir[29], ~dx_ir[28], ~dx_ir[27]);

    or ji_type(ji_instr,check_dxj,check_dxbex,check_dxjal,check_dxsetx);
    or i_type(i_instr,check_dxbne,check_dxblt); 
    assign jii_instr = check_dxjr;    
        
    and sw_truthtable_dx(w1,~xm_ir[31],~xm_ir[30],xm_ir[29],xm_ir[28],xm_ir[27]);
    and sw_truthtable_wx(w2,~mw_ir[31],~mw_ir[30],mw_ir[29],mw_ir[28],mw_ir[27]);


    assign dx_bypassawx_temp = mw_ir[26:22] == dx_ir[21:17];
    assign dx_bypassawx_temp2 = w2 ? 1'b0 : dx_bypassawx_temp;
    assign dx_bypassawx_temp3 = jii_instr ? mw_ir[26:22] == dx_ir[26:22] : dx_bypassawx_temp2;
    assign dx_bypassawx_temp4 = ji_instr ?  1'b0 : dx_bypassawx_temp3;
    assign dx_bypassawx = i_instr ? mw_ir[26:22] == dx_ir[26:22] : dx_bypassawx_temp4;


    assign dx_bypassamx_temp = xm_ir[26:22] == dx_ir[21:17];
    assign dx_bypassamx_temp2 = w1 ? 1'b0 : dx_bypassamx_temp;
    assign dx_bypassamx_temp3 = i_instr ? xm_ir[26:22] == dx_ir[26:22] : dx_bypassamx_temp2;
    assign dx_bypassamx_temp4 = ji_instr ? 1'b0 : dx_bypassamx_temp3;
    assign dx_bypassamx = jii_instr ? xm_ir[26:22] == dx_ir[26:22] : dx_bypassamx_temp4;




    wire dx_bypassbmx_temp2,dx_bypassbmx_temp3,dx_bypassbmx_temp4;
    wire dx_bypassbwx_temp2,dx_bypassbwx_temp3,dx_bypassbwx_temp4;

    assign dx_bypassbwx_temp = mw_ir[26:22] == dx_ir[16:12];
    assign dx_bypassbwx_temp2 = w2 ? 1'b0 : dx_bypassbwx_temp;
    assign dx_bypassbwx_temp3 = ji_instr ? 1'b0 : dx_bypassbwx_temp2;
    assign dx_bypassbwx_temp4 = i_instr ? mw_ir[26:22] == dx_ir[21:17] : dx_bypassbwx_temp3;
    assign dx_bypassbwx = jii_instr ? 1'b0 : dx_bypassbwx_temp4;



    assign dx_bypassbmx_temp = xm_ir[26:22] == dx_ir[16:12];
    assign dx_bypassbmx_temp2 = w1 ? 1'b0 : dx_bypassbmx_temp;
    assign dx_bypassbmx_temp3 = i_instr ? xm_ir[26:22] == dx_ir[21:17] : dx_bypassbmx_temp2;
    assign dx_bypassbmx_temp4 = ji_instr ? 1'b0 : dx_bypassbmx_temp3;
    assign dx_bypassbmx = jii_instr ? 1'b0 : dx_bypassbmx_temp4;



    assign xm_bypassbwm = xm_ir[26:22] == mw_ir[26:22];



endmodule

    

    




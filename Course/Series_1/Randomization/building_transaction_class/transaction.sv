class transaction;
    bit clk;
    bit rst;

    rand bit wreq, rreq;  // Active High

    rand bit [7:0] wdata;
    bit [7:0] rdata;
    bit empty;
    bit full;

    constraint ctrl_wr {
        wreq dist {0 := 30 , 1 := 70};
    }

    constraint ctrl_rd {
        rreq dist {0 := 30, 1 := 70};
    }

    constraint wr_rd {
        wreq != rreq;
    }
endclass
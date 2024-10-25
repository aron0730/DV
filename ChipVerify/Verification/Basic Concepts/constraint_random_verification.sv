class Pkt;
    rand bit [7:0] addr;
    rand bit [7:0] data;

    constraint addr_limit { addr <= 8'hB; }
endclass //Pkt
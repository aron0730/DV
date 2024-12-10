class Packet;
	bit [31:0] addr;

	function new (bit [31:0] addr);
		// addr = addr;          //  Which addr should get assigned ?

		this.addr = addr;     //  addr variable in Packet class should be
		                      //  assigned with local variable addr in new()
	endfunction
endclass
// tsl_ccl_basic_write_iip_main_body.sv
class tsl_ccl_basic_write_iip_main_body extends ss_dut_virtual_sequence;
    rand bit [31:0] data_size;
    bit [31:0] wdata_size;

    constraint c_data_size {
        data_size inside {8,16,32,64,128,256};
    }

    `uvm_object_utils(tsl_ccl_basic_write_iip_main_body)
    extern function new(string name = "tsl_ccl_basic_write_iip_main_body");
    extern virtual task body();
endclass

function tsl_ccl_basic_write_iip_main_body::new(string name);
    super.new(name);
endfunction : new

task tsl_ccl_basic_write_iip_main_body::body();
    logic [31:0] data_iip;

    super.body();

    if (ss_cfg.phase_num == 0) begin
        // ==== 模糊區 1（你補給我的內容）====
        m_ss_env.dut_specific_if.TSL_CCL_En     = 1;
        m_ss_env.dut_specific_if.Ext_Buf_Empty = 0;
        m_ss_env.dut_specific_if.Ext_Buf_Full  = 1;
        m_ss_env.dut_specific_if.CLKREQ        = 0;

        `uvm_info(get_name(), "Program ASPM L1 capability", UVM_LOW)

        `DUT_READ_LOCAL_REG(ss_cfg.pcie_ctrl0_reg_base[dut_n]+12'h8bc, data_iip)  // MISC_CONTROL_1_OFF
        data_iip[0] = 1'b1;

        `DUT_WRITE_LOCAL_REG(ss_cfg.pcie_ctrl0_reg_base[dut_n]+12'h8bc, data_iip, 4'b0001)

        `DUT_READ_LOCAL_REG((ss_cfg.pcie_ctrl0_reg_base[dut_n]+ss_cfg.iip_macro[dut_n].CFG_PCIE_CAP+12'h00C), data_iip)
        data_iip[11:10] = 2'b10;   // Set AS_LINK_PM_SUP to 1, enable L1
        `DUT_WRITE_LOCAL_REG((ss_cfg.pcie_ctrl0_reg_base[dut_n]+ss_cfg.iip_macro[dut_n].CFG_PCIE_CAP+12'h00C), data_iip, 4'b0001)
    end // phase_num == 0

    else if (ss_cfg.phase_num == 1) begin
        `uvm_info(get_name(), "ASPM L1 Entrance", UVM_LOW)
        rc_init_aspm_l1_entry();

        `uvm_info(get_name(), "Waiting DUT to enter L1", UVM_LOW)
        wait_l1ssm(S_L1_IDLE);
        `uvm_info(get_name(), "DUT enters L1 Successfully", UVM_LOW)
    end

    else if (ss_cfg.phase_num == 2) begin
        // ========== Set CLKREQ to 1 when USP in L1 ==========
        if (dut_n == 0) begin
            m_ss_env.dut_specific_if.CLKREQ = 1;
            `uvm_info(get_name(), "Set CLKREQ to 1, when USP in L1", UVM_LOW)
        end

        // ========== DSP EP → CCL send traffic to CCL ==========
        if(dut_n == 5) begin
            this.randomize();
            if (data_size > 128*(1<<ss_cfg.max_payload_size[dut_n])) begin
                wdata_size = 128*(1<<ss_cfg.max_payload_size[dut_n]);
            end else begin
                wdata_size = data_size;
            end

            repeat (5) begin
                if (dut_n == 0) begin
                    if (ss_cfg.pcie_vip_enable[ss_allocate_mem.trgt] == 0 &&
                        ss_cfg.axi_vip_enable[ss_allocate_mem.trgt] == 0)
                        continue;
                    ss_allocate_mom.randomize() with {trgt == 0};
                    `uvm_info(get_name(),
                        $sformatf("%s sends MWr transactions to %s",
                        ss_cfg.pcie_vip_name[dut_n],
                        ss_cfg.ports_name[ss_allocate_mem.trgt]), UVM_LOW)
                    addr_iip = ss_allocate_mom.addr;
                    `DUT_MEM_WRITE_RAND(1'b1, addr_iip, 9, 32)
                end
            end
        end
    end else if (ss_cfg.phase_num == 3) begin
    end
endtask

// tsl_ccl_basic_write_vip_main_body.sv
class tsl_ccl_basic_write_vip_main_body extends ss_pcie_base_sequence;
    `uvm_object_utils(tsl_ccl_basic_write_vip_main_body)

    extern function new(string name = "tsl_ccl_basic_write_vip_main_body");
    extern virtual task body();
endclass : tsl_ccl_basic_write_vip_main_body


function tsl_ccl_basic_write_vip_main_body::new(string name);
    super.new(name);
endfunction : new


task tsl_ccl_basic_write_vip_main_body::body();
    reg [31:0] data_vip;
    reg [63:0] addr_vip;
    int num_tlp_cpld_received;
    int num_tlp_cpld_received_expect;
    bit timeout;

    svt_configuration             tmp_cfg;
    svt_pcie_device_configuration tmp_pcie_vip_cfg;

    super.body();

    if (ss_cfg.phase_num == 0) begin
        pcie_vip_agent.get_cfg(tmp_cfg);
        $cast(tmp_pcie_vip_cfg, tmp_cfg);

        tmp_pcie_vip_cfg.pcie_cfg.dl_cfg.enable_aspm_l0s_entry  = 0;
        tmp_pcie_vip_cfg.pcie_cfg.dl_cfg.enable_aspm_l1_1_entry = 0;
        tmp_pcie_vip_cfg.pcie_cfg.dl_cfg.enable_aspm_l1_2_entry = 0;
        tmp_pcie_vip_cfg.pcie_cfg.dl_cfg.enable_aspm_l1_entry   = 1;

        pcie_vip_agent.reconfigure_via_task(tmp_pcie_vip_cfg);
    end
    else if (ss_cfg.phase_num == 1) begin
        `uvm_info(get_name(), "ASPM L1 Entrance", UVM_LOW)
        rc_init_aspm_l1_entry;

        `uvm_info(get_name(), "Waiting PCIe VIP to enter L1", UVM_LOW)
        wait_l1ssm(S_L1_IDLE);
        `uvm_info(get_name(), "PCIe VIP enters L1 Successfully", UVM_LOW)
    end
    else if (ss_cfg.phase_num == 2) begin
        // Start to send TLP from EP to CCL
        repeat (5) begin
            if (vip_n != 0) begin
                ss_allocate_mem.randomize() with { trgt == 0; };

                if (ss_cfg.pcie_vip_enable[ss_allocate_mem.trgt] == 0 &&
                    ss_cfg.axi_vip_enable[ss_allocate_mem.trgt]  == 0)
                    continue;

                `uvm_info(get_name(),
                    $sformatf("%s sends transactions to %s at 64'h%0h.",
                              ss_cfg.pcie_vip_name[vip_n],
                              ss_cfg.ports_name[ss_allocate_mem.trgt],
                              ss_allocate_mem.addr),
                    UVM_LOW)

                num_tlp_cpld_received        = pcie_vip_status.pcie_status.tl_status.num_tlp_cpld_received;
                num_tlp_cpld_received_expect = num_tlp_cpld_received;

                `uvm_info(get_name(),
                    $sformatf("%s sends a memory write to %s with length 'h%0d.",
                              ss_cfg.pcie_vip_name[vip_n],
                              ss_cfg.ports_name[ss_allocate_mem.trgt],
                              ss_allocate_mem.byte_len),
                    UVM_LOW)

                `PCIE_VIP_MEMWR_RAND(1'b1, ss_allocate_mem.addr, 9, ss_allocate_mem.byte_len)
            end
        end
    end
endtask

// tsl_ccl_basic_write_axi_main_body.sv
class tsl_ccl_basic_write_axi_main_body extends axi_ss_dut_virtual_sequence;
    rand bit [31:0] data_size;
    bit  [31:0] wdata_size;

    constraint c_data_size {
        data_size inside {8,16,32,64,128,256};
    }

    constraint c_tgt_n {
        tgt_n < ss_cfg.num_max_cfgs;
        tgt_n > 1;
    }

    `uvm_object_utils(tsl_ccl_basic_write_axi_main_body)
    extern function new(string name = "tsl_ccl_basic_write_axi_main_body");
    extern virtual task body();
endclass : tsl_ccl_basic_write_axi_main_body


function tsl_ccl_basic_write_axi_main_body::new(string name);
    super.new(name);
endfunction : new


task tsl_ccl_basic_write_axi_main_body::body();
    reg [31:0] data_iip;
    reg [63:0] addr_iip;

    super.body();
    begin
        if (ss_cfg.phase_num == 2) begin
            `uvm_info(get_name(),
                      "CCL start to send downstream traffic", UVM_LOW)

            repeat (5) begin
                this.randomize();
                if (data_size > 128*(1 << ss_cfg.max_payload_size[tgt_n])) begin
                    wdata_size = 128*(1 << ss_cfg.max_payload_size[tgt_n]);
                end
                else begin
                    wdata_size = data_size;
                end

                ss_allocate_mem.randomize() with { trgt == tgt_n; };

                `uvm_info(get_name(),
                          $sformatf("CCL sends MWr transactions to %s.",
                                    ss_cfg.ports_name[ss_allocate_mem.trgt]),
                          UVM_LOW)

                addr_iip = ss_allocate_mem.addr;
                `CCL_WRITE_RAND(1'b1, addr_iip, 9, 32);
            end

            `uvm_info(get_name(),
                      "CCL send all transactions done", UVM_LOW)
        end
    end
endtask

class tsl_ccl_basic_write extends tl_enumeration;
    `uvm_component_utils(tsl_ccl_basic_write)

    tsl_ccl_basic_write_vip_main_body vip_seq[];
    tsl_ccl_basic_write_iip_main_body iip_seq[];
    tsl_ccl_basic_write_axi_main_body ccl_seq;

    function new(string name = "tsl_ccl_basic_write", uvm_component parent = null);
        super.new(name, parent);
        this.randomize();
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        `uvm_info("build_phase", "Entry", UVM_LOW)
        super.build_phase(phase);

        vip_seq = new[ss_cfg.num_max_cfgs];
        foreach (vip_seq[i]) begin
            vip_seq[i] = tsl_ccl_basic_write_vip_main_body::type_id::create(
                           $sformatf("tsl_ccl_basic_write_pcie_vip%0d_seq", i), this);
            vip_seq[i].vip_n = i;
        end

        iip_seq = new[ss_cfg.num_max_cfgs];
        foreach (iip_seq[i]) begin
            iip_seq[i] = tsl_ccl_basic_write_iip_main_body::type_id::create(
                           $sformatf("tsl_ccl_basic_write_iip_main_body_seq%0d", i), this);
            iip_seq[i].dut_n = i;
            iip_seq[i].set_response_queue_error_report_disabled(1);
        end

        ccl_seq = tsl_ccl_basic_write_axi_main_body::type_id::create("ccl_seq", this);
        ccl_seq.set_response_queue_error_report_disabled(1);

        `uvm_info("build_phase", "Exit", UVM_LOW)
    endfunction : build_phase
    task main_phase(uvm_phase phase);
        int done = 0;
        phase.raise_objection(this);
        super.main_phase(phase);

        `uvm_info(get_name(), $psprintf("config L1 feature"), UVM_LOW)
        `START_ALL_SEQUENCE

        `uvm_info(get_name(), $psprintf("phase 1, all ports L1 entry"), UVM_LOW)
        ss_cfg.phase_num = 1;
        `START_ALL_SEQUENCE

        `uvm_info(get_name(), $psprintf("phase 2, DSP L1 exit, and CCL send downstream traffics"), UVM_LOW)
        ss_cfg.phase_num = 2;
        `START_ALL_SEQUENCE
        ccl_seq.start(ss_env.axi_ss_vsqr);
        #5us;

        phase.drop_objection(this);
    endtask : main_phase
endclass : tsl_ccl_basic_write

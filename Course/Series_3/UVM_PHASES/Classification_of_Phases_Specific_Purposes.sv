Phases :
1. Construction Phase :
    a. build_phase : create object of class
    b. connect_phase : Connection in TLM
    c. end_of_elaboration_phase : adjust hierarchy
    d. start_of_simulation
2. Run Phase :
    a. reset_phase : system reset
        pre_reset_phase
        reset_phase
        post_reset_phase
    b. configure_phase : config mem/ arrays/ variable
        pre_configure_phase
        configure_phase
        post_configure_phase
    c. main_phase : Generating stimulus and collecting response
        pre_main_phase
        main_phase
        post_main_phase
    d. shutdown_phase :
        pre_shutdown_phase
        shutdown_phase
        post_shutdown_phase
3. Cleadup Phase : collect and report data / coverage goals are achieved
    a. extract_phase
    b. check_phase
    c. report_phase
    d. final_phase
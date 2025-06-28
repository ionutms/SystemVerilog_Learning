// lookup_table_rom.sv
module lookup_table_rom (
    input  logic [2:0] address_input,           // 3-bit address for 8 entries
    output logic [7:0] data_output              // 8-bit data output
);

    // ROM lookup table with 8 entries of 8-bit data
    logic [7:0] rom_memory [0:7];

    // Initialize ROM with predefined values
    initial begin
        rom_memory[0] = 8'h10;  // Address 0: 0x10
        rom_memory[1] = 8'h25;  // Address 1: 0x25
        rom_memory[2] = 8'h3A;  // Address 2: 0x3A
        rom_memory[3] = 8'h47;  // Address 3: 0x47
        rom_memory[4] = 8'h5C;  // Address 4: 0x5C
        rom_memory[5] = 8'h69;  // Address 5: 0x69
        rom_memory[6] = 8'h7E;  // Address 6: 0x7E
        rom_memory[7] = 8'h83;  // Address 7: 0x83
    end

    // Combinational lookup - output changes immediately with address
    assign data_output = rom_memory[address_input];

endmodule
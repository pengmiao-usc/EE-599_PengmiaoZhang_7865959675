#set_operating_conditions -grade extended
create_clock -period 5.000 -name clk [get_ports clk]
#set_property PACKAGE_PIN Y9 [get_ports clk]
set_property IOSTANDARD LVCMOS25 [get_ports clk]


set_operating_conditions -grade extended

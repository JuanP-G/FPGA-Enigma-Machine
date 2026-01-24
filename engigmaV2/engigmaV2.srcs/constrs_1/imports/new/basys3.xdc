## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Switches (sw)
# Switches 0-4 para la LETRA (A-Z)
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]
set_property PACKAGE_PIN W15 [get_ports {sw[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]


set_property PACKAGE_PIN V15 [get_ports {sw[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
set_property PACKAGE_PIN W14 [get_ports {sw[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]
set_property PACKAGE_PIN W13 [get_ports {sw[7]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
set_property PACKAGE_PIN V2 [get_ports {sw[8]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[8]}]
set_property PACKAGE_PIN T3 [get_ports {sw[9]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[9]}]
set_property PACKAGE_PIN T2 [get_ports {sw[10]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[10]}]
set_property PACKAGE_PIN R3 [get_ports {sw[11]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[11]}]
set_property PACKAGE_PIN W2 [get_ports {sw[12]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[12]}]
	
# Switches de seleccion de rodillo (Rodillo 1/2/3)
set_property PACKAGE_PIN U1 [get_ports {sw[13]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[13]}]
set_property PACKAGE_PIN T1 [get_ports {sw[14]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[14]}]

# Switch 15 para MODO (Cifrar/Descifrar)
set_property PACKAGE_PIN R2 [get_ports {sw[15]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[15]}]


## LEDs
# Leds 0-4 muestran la letra en binario
set_property PACKAGE_PIN U16 [get_ports {leds[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[0]}]
set_property PACKAGE_PIN E19 [get_ports {leds[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[1]}]
set_property PACKAGE_PIN U19 [get_ports {leds[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[2]}]
set_property PACKAGE_PIN V19 [get_ports {leds[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[3]}]
set_property PACKAGE_PIN W18 [get_ports {leds[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[4]}]

# Leds intermedios
set_property PACKAGE_PIN U15 [get_ports {leds[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[5]}]
set_property PACKAGE_PIN U14 [get_ports {leds[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[6]}]
set_property PACKAGE_PIN V14 [get_ports {leds[7]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[7]}]
set_property PACKAGE_PIN V13 [get_ports {leds[8]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[8]}]
set_property PACKAGE_PIN V3 [get_ports {leds[9]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[9]}]
set_property PACKAGE_PIN W3 [get_ports {leds[10]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[10]}]
set_property PACKAGE_PIN U3 [get_ports {leds[11]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[11]}]
set_property PACKAGE_PIN P3 [get_ports {leds[12]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[12]}]
set_property PACKAGE_PIN N3 [get_ports {leds[13]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[13]}]

# Led 14 (Heartbeat 1Hz) y Led 15 (Modo)
set_property PACKAGE_PIN P1 [get_ports {leds[14]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[14]}]
set_property PACKAGE_PIN L1 [get_ports {leds[15]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {leds[15]}]


## 7 segment display
set_property PACKAGE_PIN W7 [get_ports {display[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {display[0]}]
set_property PACKAGE_PIN W6 [get_ports {display[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {display[1]}]
set_property PACKAGE_PIN U8 [get_ports {display[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {display[2]}]
set_property PACKAGE_PIN V8 [get_ports {display[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {display[3]}]
set_property PACKAGE_PIN U5 [get_ports {display[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {display[4]}]
set_property PACKAGE_PIN V5 [get_ports {display[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {display[5]}]
set_property PACKAGE_PIN U7 [get_ports {display[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {display[6]}]

set_property PACKAGE_PIN U2 [get_ports {s_display[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {s_display[0]}]
set_property PACKAGE_PIN U4 [get_ports {s_display[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {s_display[1]}]
set_property PACKAGE_PIN V4 [get_ports {s_display[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {s_display[2]}]
set_property PACKAGE_PIN W4 [get_ports {s_display[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {s_display[3]}]


## Buttons
# Boton Central (RESET)
set_property PACKAGE_PIN U18 [get_ports rst]
	set_property IOSTANDARD LVCMOS33 [get_ports rst]

# Boton Derecho (CIFRAR) - Mapeado a boton_cifrar
set_property PACKAGE_PIN T17 [get_ports boton_cifrar]
	set_property IOSTANDARD LVCMOS33 [get_ports boton_cifrar]
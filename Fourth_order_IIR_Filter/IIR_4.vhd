----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/26/2025 09:39:12 PM
-- Design Name: 
-- Module Name: IIR_4 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.fixed_float_types.all;
use IEEE.fixed_pkg.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IIR_4 is
   Generic(
        INTEGER_BITS : integer := 10;
        FRACTION_BITS : integer := -22;
        INTEGER_BITS_NORM : integer := 2;
        FRACTION_BITS_NORM : integer := -16
   );
   Port ( 
    clk : in std_logic;
    reset : in std_logic;
    start : in std_logic;
    Xn : in sfixed(INTEGER_BITS - 1 downto FRACTION_BITS);
    Yn : out sfixed(INTEGER_BITS - 1 downto FRACTION_BITS);
    CE : out std_logic;
    strobe_test : out std_logic;
    test_data : out sfixed(INTEGER_BITS_NORM - 1 downto FRACTION_BITS_NORM)

  
   
   );
end IIR_4;

architecture Behavioral of IIR_4 is
    -- normalization
    constant right_shift: sfixed(1 downto 40) := to_sfixed(0.0009765625 ,1,40);
    constant left_shift : sfixed(9 downto -1) := to_sfixed(1024,9,-1);
    
    -- AXI-stream signals
    signal m_axis_tvalid : std_logic;
    signal m_axis_tready : std_logic;
    signal m_axis_tdata : sfixed(INTEGER_BITS_NORM - 1 downto FRACTION_BITS_NORM);
    
    --Input data to FILTR_1
    signal data_in : sfixed(INTEGER_BITS_NORM - 1 downto FRACTION_BITS_NORM) := (others => '0');
    
    --Output data from FILTR_2
    signal data_out : sfixed(INTEGER_BITS_NORM - 1 downto FRACTION_BITS_NORM);
    
    -- strobe signal CE
    signal CE_reg : std_logic;
    
begin
    
   data_in <= resize(Xn,INTEGER_BITS_NORM - 1, FRACTION_BITS_NORM);
    
   FILTR_1 : entity work.FILTR_1(Behavioral)
             port map(clk => clk, reset => reset, strobe => CE_reg, start => start, Xn => data_in, m_axis_tvalid => m_axis_tvalid,
             m_axis_tready => m_axis_tready, m_axis_tdata => m_axis_tdata);
             
   FILTR_2 : entity work.FILTR_2(Behavioral)
            port map(clk => clk, reset => reset, s_axis_tvalid => m_axis_tvalid,s_axis_tready => m_axis_tready,  s_axis_tdata => m_axis_tdata, 
            Yn => data_out, strobe_test => strobe_test, test_data => test_data);
    
   TRIGGER_COUNTER : entity work.TRIGGER_COUNTER(Behavioral)
                    port map(clk => clk, reset => reset, start => start, output => CE_reg);
                    
   Yn <= resize(data_out, INTEGER_BITS - 1, FRACTION_BITS);
   CE <= CE_reg;
   
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        o_address : out std_logic_vector(15 downto 0);
        o_done : out std_logic;
        o_en : out std_logic;
        o_we : out std_logic;
        o_data : out std_logic_vector (7 downto 0)
    );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is

component datapath is
    Port ( i_clk : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (7 downto 0);
           o_data : out STD_LOGIC_VECTOR (7 downto 0);
           o_address : out STD_LOGIC_VECTOR (15 downto 0);
           
           sel_addr1 : in STD_LOGIC_vector (1 downto 0);
           sel_addr2 : in STD_LOGIC;
           sel_new_img : in STD_LOGIC;
           r1_load : in STD_LOGIC;
           new_img_load : in STD_LOGIC;
           row_sel : in STD_LOGIC;
           col_sel : in STD_LOGIC;
           temp_row_load : in STD_LOGIC;
           temp_col_load : in STD_LOGIC;
           reg_row_load : in STD_LOGIC;
           reg_column_load : in STD_LOGIC;
           reg_max_load : in STD_LOGIC;
           reg_min_load : in STD_LOGIC;
           shift_level_reg_load : in STD_LOGIC;
           mask_reg_load : in STD_LOGIC;
           current_pixel_reg_load : in STD_LOGIC;
           
           end_img : out STD_LOGIC;
           end_row : out STD_LOGIC;
           change_min : out STD_LOGIC;
           change_max : out STD_LOGIC;
           finish1 : out STD_LOGIC;
           finish2 : out STD_LOGIC);
end component;

signal sel_addr1 : STD_LOGIC_vector (1 downto 0);
signal sel_addr2 : STD_LOGIC;
signal sel_new_img : STD_LOGIC;
signal r1_load : STD_LOGIC;
signal new_img_load : STD_LOGIC;
signal row_sel : STD_LOGIC;
signal col_sel : STD_LOGIC;
signal temp_row_load : STD_LOGIC;
signal temp_col_load : STD_LOGIC;
signal reg_row_load : STD_LOGIC;
signal reg_column_load : STD_LOGIC;
signal reg_max_load : STD_LOGIC;
signal reg_min_load : STD_LOGIC;
signal shift_level_reg_load : STD_LOGIC;
signal mask_reg_load : STD_LOGIC;
signal current_pixel_reg_load : STD_LOGIC;

signal end_img : STD_LOGIC;
signal end_row : STD_LOGIC;
signal change_min : STD_LOGIC;
signal change_max : STD_LOGIC;
signal finish1 : STD_LOGIC;
signal finish2 : STD_LOGIC;
    
type S is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16);
signal cur_state, next_state : S;

begin
    DATAPATH0: datapath port map(
        i_clk                   =>     i_clk,                       
        i_rst                   =>     i_rst,                       
        i_data                  =>     i_data,                      
        o_data                  =>     o_data,                      
        o_address               =>     o_address,                   
      
        sel_addr1               =>     sel_addr1,                   
        sel_addr2               =>     sel_addr2,                   
        sel_new_img             =>     sel_new_img,                 
        r1_load                 =>     r1_load,                     
        new_img_load            =>     new_img_load,                
        row_sel                 =>     row_sel,                     
        col_sel                 =>     col_sel,                     
        temp_row_load           =>     temp_row_load,               
        temp_col_load           =>     temp_col_load,               
        reg_row_load            =>     reg_row_load,                
        reg_column_load         =>     reg_column_load,             
        reg_max_load            =>     reg_max_load,                
        reg_min_load            =>     reg_min_load,                
        shift_level_reg_load    =>     shift_level_reg_load,        
        mask_reg_load           =>     mask_reg_load,               
        current_pixel_reg_load  =>     current_pixel_reg_load,      
       
        end_img                 =>     end_img,                     
        end_row                 =>     end_row,                     
        change_min              =>     change_min,                  
        change_max              =>     change_max,                  
        finish1                 =>     finish1,                     
        finish2                 =>     finish2                      
    );
    
    
--change state action
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            cur_state <= S0;
        elsif rising_edge(i_clk) then
            cur_state <= next_state;
        end if;
    end process;
    
    
--find next state
    process(cur_state, i_start, end_img, end_row, change_min, change_max, finish1, finish2)
    begin
        next_state <= cur_state;
        case cur_state is
            when S0 =>
                if i_start = '1' then
                    next_state <= S1;
                end if;
            when S1 =>
                next_state <= S2;
            when S2 =>
                if finish1 = '1' then
                    next_state <= S16;
                else
                    next_state <= S3;
                end if;
            when S3 =>
                if finish2 = '1' then
                    next_state <= S16;
                else
                    next_state <= S4;
                end if;
            when S4 =>
                if end_row = '1' then
                    next_state <= S9;
                else
                    next_state <= S5;
                end if;
                
            when S5 =>
                if change_max = '1' then
                     next_state <= S6;
                else 
                    if change_min = '1' then
                        next_state <= S7;
                    else 
                         next_state <= S8;
                    end if;
                 end if;
                
            when S6 =>
                if end_row = '1' then
                    next_state <= S9;
                else
                    next_state <= S5;
                end if;
            when S7 =>
                if end_row = '1' then
                    next_state <= S9;
                else
                    next_state <= S5;
                end if;
            when S8 =>
                if end_row = '1' then
                    next_state <= S9;
                else
                    next_state <= S5;
                end if;
                
            when S9 =>
                if end_img = '1' then
                    next_state <= S10;
                else
                    if change_max = '1' then
                         next_state <= S6;
                    else 
                        if change_min = '1' then
                            next_state <= S7;
                        else 
                            next_state <= S8;
                        end if;
                     end if;
                 end if;
                  
            when S10 =>
                next_state <= S11;
            when S11 =>
                next_state <= S12;
            when S12 =>
                next_state <= S13;   
            when S13 =>
                if end_row = '1' then
                    next_state <= S15;
                else
                    next_state <= S14;
                end if;
            when S14 =>
                next_state <= S12;
            when S15 =>
                if end_img = '1' then
                    next_state <= S16;
                else
                    next_state <= S12;
                end if;
            when S16 =>
                if i_start = '0' then
                    next_state <= S0;
                end if;
        end case;
    end process;
    
    
--Building signals 
    process(cur_state)
    begin
        sel_addr1 <= "00";           
        sel_addr2 <= '0';        
        sel_new_img <= '0';         
        r1_load <= '0';       
        new_img_load <= '0';        
        row_sel <= '0';             
        col_sel <= '0';             
        temp_row_load <= '0';       
        temp_col_load <= '0';       
        reg_row_load <= '0';        
        reg_column_load <= '0';     
        reg_max_load <= '0';        
        reg_min_load <= '0';        
        shift_level_reg_load <= '0';
        mask_reg_load <= '0';       
        current_pixel_reg_load <= '0';
        o_done <= '0';
        o_en <= '0';
        o_we <= '0';
         
        case cur_state is
            when S0 =>
            when S1 =>
                sel_addr1 <= "01";
                r1_load <= '1';
                -------------
                o_en <= '1';
            when S2 =>
                r1_load <= '1';
                reg_column_load <= '1';
                -------------
                o_en <= '1';
            when S3 =>
                r1_load <= '1';
                reg_row_load <= '1';
                -------------
                o_en <= '1';
            when S4 =>
                r1_load <= '1';
                row_sel <= '1';
                col_sel <= '1';
                temp_row_load <= '1';
                temp_col_load <= '1';
                reg_max_load <= '1';
                reg_min_load <= '1';
                -------------
                o_en <= '1';
            when S5 =>
                sel_addr1 <= "00";
                r1_load <= '0';
                temp_col_load <= '1';
                -------------
                o_en <= '1';
            when S6 =>
                r1_load <= '1';
                reg_max_load <= '1';
                -------------
                o_en <= '1';
            when S7 =>
                r1_load <= '1';
                reg_min_load <= '1';
                -------------
                o_en <= '1';
            when S8 =>
                r1_load <= '1';
                ------------
                o_en <= '1';
            when S9 =>
                r1_load <= '0';
                col_sel <= '1';
                temp_row_load <= '1';
                temp_col_load <= '1';
                -------------
                o_en <= '1';
            when S10 =>
                sel_new_img <= '1';
                new_img_load <= '1';
                shift_level_reg_load <= '1';
                mask_reg_load <= '1';
            when S11 =>
                sel_addr1 <= "10";
                r1_load <= '1';
                row_sel <= '1';
                col_sel <= '1';
                temp_row_load <= '1';
                temp_col_load <= '1';
                current_pixel_reg_load <= '0';
                -------------
                o_en <= '1';
            when S12 =>
                current_pixel_reg_load <= '1';
                -------------
                o_en <= '1';
            when S13 =>
                sel_addr2 <= '1';
                r1_load <= '1';
                -------------
                o_en <= '1';
                o_we <= '1';
            when S14 =>
                new_img_load <= '1';
                temp_col_load <= '1';
                current_pixel_reg_load <= '0';
                -------------
                o_en <= '1';
            when S15 =>
                new_img_load <= '1';
                col_sel <= '1';
                temp_col_load <= '1';
                temp_row_load <= '1';
                current_pixel_reg_load <= '0';
                -------------
                o_en <= '1';
            when S16 =>
                o_done <= '1';

        end case;
    end process;
    
end Behavioral;

-----------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity datapath is
    Port ( i_clk : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (7 downto 0);
           o_data : out STD_LOGIC_VECTOR (7 downto 0);
           o_address : out STD_LOGIC_VECTOR (15 downto 0);
           
           sel_addr1 : in STD_LOGIC_vector (1 downto 0);
           sel_addr2 : in STD_LOGIC;
           sel_new_img : in STD_LOGIC;
           r1_load : in STD_LOGIC;
           new_img_load : in STD_LOGIC;
           row_sel : in STD_LOGIC;
           col_sel : in STD_LOGIC;
           temp_row_load : in STD_LOGIC;
           temp_col_load : in STD_LOGIC;
           reg_row_load : in STD_LOGIC;
           reg_column_load : in STD_LOGIC;
           reg_max_load : in STD_LOGIC;
           reg_min_load : in STD_LOGIC;
           shift_level_reg_load : in STD_LOGIC;
           mask_reg_load : in STD_LOGIC;
           current_pixel_reg_load : in STD_LOGIC;
           
           end_img : out STD_LOGIC;
           end_row : out STD_LOGIC;
           change_min : out STD_LOGIC;
           change_max : out STD_LOGIC;
           finish1 : out STD_LOGIC;
           finish2 : out STD_LOGIC);
           
end datapath;

architecture Behavioral of datapath is

signal mux_reg1 : STD_LOGIC_VECTOR (15 downto 0);
signal o_reg1 : STD_LOGIC_VECTOR (15 downto 0);
signal sum_address : STD_LOGIC_VECTOR(15 downto 0);
signal mux_new_img : STD_LOGIC_VECTOR(15 downto 0);
signal o_new_img : STD_LOGIC_VECTOR(15 downto 0);
signal sum_new_img : STD_LOGIC_VECTOR(15 downto 0);

signal o_reg_row : STD_LOGIC_VECTOR (7 downto 0);
signal o_reg_column : STD_LOGIC_VECTOR (7 downto 0);
signal mux_temp_row : STD_LOGIC_VECTOR (7 downto 0);
signal o_temp_row : STD_LOGIC_VECTOR (7 downto 0);
signal sum_temp_row : STD_LOGIC_VECTOR (7 downto 0);
signal mux_temp_col : STD_LOGIC_VECTOR (7 downto 0);
signal o_temp_col : STD_LOGIC_VECTOR (7 downto 0);
signal sum_temp_col : STD_LOGIC_VECTOR (7 downto 0);

signal o_reg_max : STD_LOGIC_VECTOR (7 downto 0);
signal o_reg_min : STD_LOGIC_VECTOR (7 downto 0);
signal delta_value : STD_LOGIC_VECTOR (7 downto 0);
signal temp_delta : STD_LOGIC_VECTOR (8 downto 0);
signal shift_level_enc : STD_LOGIC_VECTOR (3 downto 0);
signal mask_enc : STD_LOGIC_VECTOR (7 downto 0);
signal o_shift_level_reg : STD_LOGIC_VECTOR (3 downto 0);
signal o_mask_reg : STD_LOGIC_VECTOR (7 downto 0);
signal o_current_pixel_reg : STD_LOGIC_VECTOR (7 downto 0);
signal diff : STD_LOGIC_VECTOR (7 downto 0);
signal temp_pixel : STD_LOGIC_VECTOR (7 downto 0);
signal overflow : STD_LOGIC_VECTOR (7 downto 0);
signal shift_overflow : STD_LOGIC;

begin
--reg1
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg1 <= "0000000000000000";
        elsif falling_edge(i_clk) then
            if(r1_load = '1') then
                o_reg1 <= mux_reg1;
            end if;
        end if;
    end process;
    
--new_img    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_new_img <= "0000000000000000";
        elsif falling_edge(i_clk) then
            if(new_img_load = '1') then
                o_new_img <= mux_new_img;
            end if;
        end if;
    end process;
    
--adder address    
    sum_address <= o_reg1 + "0000000000000001";
    
--adder new_img    
    sum_new_img <= o_new_img + "0000000000000001";
    
--mux address
    with sel_addr1 select
        mux_reg1 <= sum_address when "00",
                    "0000000000000000" when "01",
                    "0000000000000010" when "10",
                    "XXXXXXXXXXXXXXXX" when others;
                    
--mux address new_img                    
    with sel_new_img select
        mux_new_img <= sum_new_img when '0',
                       o_reg1 when '1',
                       "XXXXXXXXXXXXXXXX" when others;
                       
--mux final address
    with sel_addr2 select
        o_address <= o_reg1 when '0',
                     o_new_img when '1',
                     "XXXXXXXXXXXXXXXX" when others;
                     
----------------------------------------------------------------
--reg_row
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg_row <= "00000001";
        elsif falling_edge(i_clk) then
            if(reg_row_load = '1') then
                o_reg_row <= i_data;
            end if;
        end if;
    end process;
    
--reg_column
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg_column <= "00000001";
        elsif falling_edge(i_clk) then
            if(reg_column_load = '1') then
                o_reg_column <= i_data;
            end if;
        end if;
    end process;
    
--temp_row
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_temp_row <= "00000000";
        elsif falling_edge(i_clk) then
            if(temp_row_load = '1') then
                o_temp_row <= mux_temp_row;
            end if;
        end if;
    end process;
    
--temp_col
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_temp_col <= "00000000";
        elsif falling_edge(i_clk) then
            if(temp_col_load = '1') then
                o_temp_col <= mux_temp_col;
            end if;
        end if;
    end process;
   
--edge cases row or column == 0
    finish1 <= '1' when (o_reg_column = "00000000") else '0';
    finish2 <= '1' when (o_reg_row = "00000000") else '0';
    
--adder temp_row    
    sum_temp_row <= o_temp_row + "00000001";
    
--adder temp_col  
    sum_temp_col <= o_temp_col + "00000001";
    
--mux temp_row
    with row_sel select
        mux_temp_row <= sum_temp_row when '0',
                        "00000000" when '1',
                        "XXXXXXXX" when others;
                        
--mux temp_col
    with col_sel select
        mux_temp_col <= sum_temp_col when '0',
                        "00000001" when '1',
                        "XXXXXXXX" when others;
                        
--end_row and end_img
    end_row <= '1' when (o_reg_column = o_temp_col) else '0';
    end_img <= '1' when (o_reg_row = o_temp_row) else '0';
    
--------------------------------------------------------------------------------
--reg_max
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg_max <= "00000000";
        elsif falling_edge(i_clk) then
            if(reg_max_load = '1') then
                o_reg_max <= i_data;
            end if;
        end if;
    end process;
    
--reg_min
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg_min <= "11111111";
        elsif falling_edge(i_clk) then
            if(reg_min_load = '1') then
                o_reg_min <= i_data;
            end if;
        end if;
    end process;
    
--current_pixel_reg
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_current_pixel_reg <= "00000000";
        elsif falling_edge(i_clk) then
            if(current_pixel_reg_load = '1') then
                o_current_pixel_reg <= i_data;
            end if;
        end if;
    end process;
    
--mask_reg
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_mask_reg <= "00000000";
        elsif falling_edge(i_clk) then
            if(mask_reg_load = '1') then
                o_mask_reg <= mask_enc;
            end if;
        end if;
    end process;
    
--shift_level_reg
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_shift_level_reg <= "0000";
        elsif falling_edge(i_clk) then
            if(shift_level_reg_load = '1') then
                o_shift_level_reg <= shift_level_enc;
            end if;
        end if;
    end process;
    
--change_max and change_min
    change_max <= '1' when (i_data > o_reg_max) else '0';
    change_min <= '1' when (i_data < o_reg_min) else '0';
    
--diff
    diff <= o_current_pixel_reg - o_reg_min;
    
--shifter
    with o_shift_level_reg select
            temp_pixel <= diff when "0000",
                          diff(6 downto 0) & '0' when "0001",
                          diff(5 downto 0) & "00" when "0010",
                          diff(4 downto 0) & "000" when "0011",
                          diff(3 downto 0) & "0000" when "0100",
                          diff(2 downto 0) & "00000" when "0101",
                          diff(1 downto 0) & "000000" when "0110",
                          diff(0) & "0000000" when "0111",
                          "00000000" when "1000",
                          "XXXXXXXX" when others;
                          
--and
    overflow <= diff and o_mask_reg;
    
--shift_overflow
    shift_overflow <= '1' when (overflow > "00000000") else '0';
    
--final mux new_pixel_value
    with shift_overflow select
        o_data <= temp_pixel when '0',
                  "11111111" when '1',
                  "XXXXXXXX" when others;
                  
--calculus
    temp_delta <= ('0' & (o_reg_max - o_reg_min)) + "000000001";
   

--encoder
            shift_level_enc <= "0000" when temp_delta(8) = '1' else
                               "0001" when temp_delta(7) = '1' else
                               "0010" when temp_delta(6) = '1' else
                               "0011" when temp_delta(5) = '1' else
                               "0100" when temp_delta(4) = '1' else
                               "0101" when temp_delta(3) = '1' else
                               "0110" when temp_delta(2) = '1' else
                               "0111" when temp_delta(1) = '1' else
                               "1000" when temp_delta(0) = '1' else
                               "XXXX";


            mask_enc <= "00000000" when temp_delta(8) = '1' else  
                        "10000000" when temp_delta(7) = '1' else  
                        "11000000" when temp_delta(6) = '1' else  
                        "11100000" when temp_delta(5) = '1' else  
                        "11110000" when temp_delta(4) = '1' else  
                        "11111000" when temp_delta(3) = '1' else  
                        "11111100" when temp_delta(2) = '1' else  
                        "11111110" when temp_delta(1) = '1' else  
                        "11111111" when temp_delta(0) = '1' else  
                        "XXXXXXXX";                           

end Behavioral;
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use std.textio.all;
use work.img_data_pkg.all;
-- FPGA4student.com: FPGA/Verilog/VHDL projects for students
-- VHDL tutorial: How to Read images in VHDL
entity read_image is
  generic (
    IMG_WIDTH      : natural := 1280;        
    IMG_HEIGHT      : natural := 720;
    OBJECT_SIZE     : natural := 16;
    PIXEL_SIZE      : natural := 24;
  );
  port(
    video_active       : in  std_logic;
    pixel_x, pixel_y   : in  std_logic_vector(OBJECT_SIZE-1 downto 0);
    rgb                : out std_logic_vector(PIXEL_SIZE-1 downto 0)
  );
end read_image;

architecture behavioral of read_image is

signal image_mem : image_type := image_mem_const;

  
begin
    process (video_active, pixel_y, pixel_x)
        variable pixel : std_logic_vector(23 downto 0);
        variable r, g, b : unsigned(7 downto 0);
        variable gray : unsigned(7 downto 0);
    begin
        if video_active='0' then
            rgb <= x"000000"; --blank
        else
            pixel := image_mem(to_integer(unsigned(pixel_y)), to_integer(unsigned(pixel_x)));

            r := unsigned(pixel(23 downto 16));
            g := unsigned(pixel(15 downto 8));
            b := unsigned(pixel(7 downto 0));

            --gray := resize((r + g + b)/3, 8);
            gray := resize((R * 30 + G * 59 + B * 11) / 100, 8);

            rgb <= std_logic_vector(gray & gray & gray);

            --rgb <= image_mem(pixel_y, pixel_x);
            --rgb <= image_mem(to_integer(unsigned(pixel_y)), to_integer(unsigned(pixel_x)))(23 downto 16) & x"0000";          
        end if;
    end process;

end behavioral;
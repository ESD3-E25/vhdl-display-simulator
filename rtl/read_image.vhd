library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use std.textio.all;
-- FPGA4student.com: FPGA/Verilog/VHDL projects for students
-- VHDL tutorial: How to Read images in VHDL
entity read_image is
  generic (
    IMG_WIDTH      : natural := 1280;        
    IMG_HEIGHT      : natural := 720;
    OBJECT_SIZE     : natural := 16;
    PIXEL_SIZE      : natural := 24;
    IMAGE_FILE_NAME : string :="IMAGE_FILE.MIF"
  );
  port(
    video_active       : in  std_logic;
    pixel_x, pixel_y   : in  std_logic_vector(OBJECT_SIZE-1 downto 0);
    rgb                : out std_logic_vector(PIXEL_SIZE-1 downto 0)
  );
end read_image;

architecture behavioral of read_image is

type image_type is array (0 to IMG_HEIGHT-1, 0 to IMG_WIDTH-1) of std_logic_vector(PIXEL_SIZE-1 downto 0);


--TYPE mem_type IS ARRAY(0 TO IMAGE_SIZE) OF std_logic_vector((DATA_WIDTH-1) DOWNTO 0);

impure function init_mem(mif_file_name : in string) return image_type is
    file mif_file : text open read_mode is mif_file_name;
    variable mif_line : line;
    variable temp_bv : bit_vector(PIXEL_SIZE-1 downto 0);
    variable temp_img : image_type;
begin
    report "Opening file: " & mif_file_name severity note;
    for y in 0 to IMG_HEIGHT-1 loop
        for x in 0 to IMG_WIDTH-1 loop
            exit when endfile(mif_file);
            readline(mif_file, mif_line);
            read(mif_line, temp_bv);
            temp_img(y,x) := to_stdlogicvector(temp_bv);
        end loop;
        report "y: " & integer'image(y) severity note;
    end loop;
    return temp_img;
end function;

signal image_mem : image_type := init_mem(IMAGE_FILE_NAME);

  
begin
    process (video_active, pixel_y, pixel_x)
    begin
        if video_active='0' then
            rgb <= x"000000"; --blank
        else
            --rgb <= image_mem(pixel_y, pixel_x);
            rgb <= image_mem(to_integer(unsigned(pixel_y)), to_integer(unsigned(pixel_x)));          
        end if;
    end process;

end behavioral;
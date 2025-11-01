from PIL import Image

input_image = "house.tiff"
output_pkg = "img_data_pkg.vhd"

img_width = 1280
img_height = 720
pixel_size = 24

img = Image.open(input_image)
img = img.resize((img_width, img_height))

pixels = list(img.getdata())


with open(output_pkg, "w") as pkg:
    pkg.write("library ieee;\n")
    pkg.write("use ieee.std_logic_1164.ALL;\n")
    pkg.write("use ieee.numeric_std.ALL;\n\n")

    pkg.write("package img_data_pkg is\n\n")

    pkg.write(f"    constant IMG_WIDTH      : natural := {img_width};\n")
    pkg.write(f"    constant IMG_HEIGHT     : natural := {img_height};\n")
    pkg.write(f"    constant PIXEL_SIZE     : natural := {pixel_size};\n\n")

    pkg.write("    type image_type is array (0 to IMG_HEIGHT-1, 0 to IMG_WIDTH-1) of std_logic_vector(PIXEL_SIZE-1 downto 0);\n\n")

    pkg.write("    constant image_mem_const : image_type := (\n")
    px_index = 0
    for y in range(0, img_height):
        pkg.write(f"        {y} =>(")

        for x in range(0, img_width):
            pkg.write(f"{x} => x\"{pixels[px_index][0]:02X}{pixels[px_index][1]:02X}{pixels[px_index][2]:02X}\"")
            if (not x == img_width -1):
                pkg.write(", ")
            px_index += 1
        if (y == img_height-1):
            pkg.write(")\n")
        else:
            pkg.write("),\n")


    #pkg.write("        0 => (0 => x\"FF0000\", 1 => x\"00FF00\", 2 => x\"0000FF\", ...),\n")
    #pkg.write("        1 => (0 => x\"808080\", 1 => x\"FFFFFF\", 2 => x\"000000\", ...),\n")
    pkg.write("    );\n\n")

    pkg.write("end package img_data_pkg;\n\n")

    pkg.write("package body img_data_pkg is\n")
    pkg.write("end package body img_data_pkg;\n")
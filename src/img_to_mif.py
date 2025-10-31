from PIL import Image

input_image = "rasmus_meme.jpeg"
output_mif = "IMAGE_FILE.MIF"

img_width = 1280
img_height = 720

img = Image.open(input_image)
img = img.resize((img_width, img_height))

pixels = list(img.getdata())

#print(pixels[1][0])

with open(output_mif, "w") as file:
    for i, p in enumerate(pixels):
        file.write(f"{p[0]:08b}")
        file.write(f"{p[1]:08b}")
        file.write(f"{p[2]:08b}\n")

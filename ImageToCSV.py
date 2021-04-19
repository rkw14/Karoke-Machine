from PIL import Image
import numpy as np
def decToBinary(num):

    return bin(num).replace("0b", "")

im = Image.open('C4.png', 'r')
#im.show()
print(im.size)

x, y = im.size
imArray = np.zeros((x, y), dtype=object)
print(imArray)
for i in range(x):
    for j in range(y):

        pix = im.getpixel((i, j))
        r = pix[0]
        g = pix[1]
        b = pix[2]
        rB = decToBinary(r)
        gB = decToBinary(g)
        bB = decToBinary(b)
        pixelS = str(rB)[0:3]+str(gB)[0:3]+str(bB)[0:3]
        #pixelB = int(pixelS)
        #print(pixelB)
        pixelH = hex(int(pixelS, 2))
        #print(pixelH, i, j)
        imArray[i,j] = pixelH


print(imArray[0,0])

imArray.tofile('C4.csv', sep=',')

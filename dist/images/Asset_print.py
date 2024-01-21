import os

source = []
asset = '''Assets =
{
'''
img = '''nametoimage = {
'''
if __name__ == '__main__':
    for root, dirs, files in os.walk("tex"):
        for file in files:
            name = file.split(".")[0]
            asset += "\tAsset(\"ATLAS\", \"images/tex/" + file + "\"),\n"
            img += "\t" + name + "\t= " + "\"images/tex/" + file + "\"\n"
    asset += "}"
    img += "}"
    print(asset)
    print(img)

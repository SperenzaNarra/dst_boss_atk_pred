import os

source = []
textHead = '''<Atlas>
	<Texture filename="../tex/'''
textMid = '''" />
    <Elements>
		<Element name="../tex/'''
textEnd = '''" u1="0" u2="1" v1="0" v2="1" />
	</Elements>
</Atlas>'''

if __name__ == '__main__':
	for root, dirs, files in os.walk("tex"):
		for file in files:
			name = file.split(".")[0]
			text = textHead + file + textMid + file + textEnd
			f = open("script/" + name + ".xml", "w")
			f.write(text)
			f.close()
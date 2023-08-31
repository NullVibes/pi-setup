from guizero import App, TextBox, PushButton, Text, Box

import os, subprocess

def btnA():
    label.value = "Hunting for  XYZ List"
    txtBox1.show()
    txtBox1.bg="white"
    button1.hide()
    button1.height=0
    button2.visible=False
    button2.height=0
    button3.visible=True
    result = subprocess.run(["ls","-l"], capture_output=True, text=True)
    txtBox1.command = result
    print(result.stdout)

def btnB():
    label.value = "Hunting for ALL XYZs"

def btnC():
    label.value = "Help"

#def chngTgt():

app = App(layout="auto", bg="grey", height=400, width=800, title="EPC Hunter")

label = Text(app, text="Select Command", align="top", width="fill", height=2)

contentBox = Box(app, align="top", width="fill", height="fill", border=False)

button3 = PushButton(app, command=btnC, text="Help", width="fill", align="bottom")

formBox = Box(contentBox, border=False, width="fill", height="fill", layout="auto")
button1 = PushButton(formBox, command=btnA, text="Hunt w/ List", height="fill", width="fill", align="left")
button2 = PushButton(formBox, command=btnB, text="Hunt ALL", height="fill", width="fill", align="right")
txtBox1 = TextBox(formBox, visible=False, width="fill", height="fill", text="DATA", align="top", multiline=True)

app.display()

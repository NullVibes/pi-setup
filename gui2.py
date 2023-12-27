from tkinter import *
import os, subprocess

window = Tk()
window.title('App Selector')
window.geometry('800x400')

c1 = Canvas(window, height=400, width=800, bg="#22303C")
c1.place(x=-1, y=-1)

btn1 = Button(c1, text='XYZ\nHunter', width=5, height=3, bd='1', command=window.destroy)

btn2 = Button(c1, text='Kismet', width=5, height=3, bd='1', command=window.destroy)

btn1.place(x=10, y=10)
btn2.place(x=90, y=10)

#c2 = Canvas(window, height=400, width=800, bg="#22303C")
#c2.place(x=-1, y=-1)

window.mainloop()

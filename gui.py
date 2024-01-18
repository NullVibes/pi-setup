# GUI for RPI 4:3" Display
# Written by NullVibes

import sqlite3
import os, subprocess, sys

try:
    from tkinter import *
except ModuleNotFoundError:
    print("Please install tkinter module first.")
    print("pip install tk")
    sys.exit(1)

try:
    from tkinter import ttk
except ModuleNotFoundError:
    print("Please install tkinter module first.")
    print("pip install tk")
    sys.exit(1)


UHF_DIR = "/opt/UHF-Sweep/"


def hide(widget):
    widget.pack_forget()

def show(widget):
    widget.pack()

def app_layout(self):
    hide(cApp1)
    cApp2.pack_forget()
    self.button = []
    self.label = []
    appList = ["UHF\nSweep", "Kismet", "Option 3"]
    x = 0

    # Dynamically add button objects to the canvas, based on the items in appList[]
    for i in range(len(appList)):
        self.button.append(Button(self, text=appList[i], width=8, height=4, bd='0', command=lambda i=i: open_app(i)))
        self.button[i].config(bg="#22303C", fg="#888888", highlightthickness=2, highlightbackground="orange", highlightcolor="orange", font=('Arial 15 bold'))
        self.button[i].grid(row=0, column=i, sticky=N+E+S+W, pady=2, padx=10, ipadx=2, ipady=2)

    # Add an empty Label object for Help spacing
    self.label.append(Label(self, text='', width=10, height=1, bd='0'))
    self.label[0].config(bg="#22303C", highlightthickness=0, borderwidth=0)
    self.label[0].grid(row=1, column=0, columnspan=(i+1), sticky=E+W, pady=2, padx=10, ipadx=2, ipady=2)

    s = ttk.Style()
    s.configure('TSeparator', background='#5daed7')
    ttk.Separator(master=self, orient='horizontal', style='TSeparator').grid(row=2, column=0, columnspan=(i+1), sticky=E+W, pady=0, padx=5, ipadx=0, ipady=0)
    
    # Add the actual Help button
    self.button.append(Button(self, text='Help ?', width=10, height=1, bd='0', command=window.destroy))
    self.button[i+1].config(bg="#22303C", fg="#888888", highlightthickness=2, highlightbackground="orange", highlightcolor="orange", font=('Arial 15 bold'))
    self.button[i+1].grid(row=3, column=0, columnspan=(i+1), sticky=E+W, pady=2, padx=10, ipadx=2, ipady=2)
    
def app1():
    if os.path.exists(UHF_DIR + "uhf-sweep.sh") == True:
        subprocess.run(["sudo " + UHF_DIR + "./uhf-sweep.sh"], shell=True, capture_output=True, text=True)
        if os.path.exists(UHF_DIR + "uhf_sweep.csv") == True:
            #LAST_TAG = str(subprocess.run(["tail -n1 " + UHF_DIR + "uhf_sweep.csv | cut -d',' -f5"], shell=True, capture_output=True, text=True).stdout[:-1])
            with open(UHF_DIR + 'uhf_sweep.csv', 'r') as UHF_FILE:
                F_LINES = UHF_FILE.read().splitlines()
                LAST_LINE = F_LINES[-1]
            #UHF_FILE = open(UHF_DIR + "uhf_sweep.csv", "r")
            #LAST_TAG = UHF_FILE.readline().split(",")
            LAST_TAG =  LAST_LINE.split(",")
            TAG_TIME = LAST_TAG[0].split(".")
            TAG_RSSI = b'{LAST_TAG[3]}
            ALL_TAGS = tree.get_children()
            TAG_CHECK = 0
            if len(ALL_TAGS) > 0:
                for i in ALL_TAGS:
                    TAG_COUNT = tree.item(i)['values'][1]
                    if LAST_TAG[4] == tree.item(i)['values'][0]:
                        TAG_CHECK += 1
                        #print(tree.item(i)['values'][1])
                        #print(tree.item(i)['values'])
                        tree.set(i, '# 2', (tree.item(i)['values'][1] + 1))
                        tree.set(i, '# 4', TAG_TIME[0])
                        tree.set(i, '# 5', 
                        
                #if TAG_CHECK == 0:
                    #tree.insert('', 'end', values=(LAST_TAG[4], 1, 'FSeen', 'LSeen', 'RSSI', 'GPS'))
                    #treeview.set(item, "lastmod", "19:30")
            else:
                #tree.set('', 'end', values=(LAST_TAG[4], (tree.item(i)['values'][1] + 1), 'FSeen', 'LSeen', 'RSSI', 'GPS'))
                tree.insert('', 'end', values=(LAST_TAG[4], 1, TAG_TIME[0], TAG_TIME[0], 'RSSI', 'GPS'))

            window.after(500, app1)  # run again after 1000ms (1s)
        else:
            tree.insert('', 'end', values=('INPUT', 'FILE', 'NOT', 'FOUND', '', ''))
        

def open_app(appNum):
    cMenu.pack_forget()
    
    if appNum == 0:
        cApp1.pack()
        tree.pack()
        cApp2.pack_forget()
        app1()
        #window.after(500, app1)  # run again after 1000ms (1s)
    elif appNum == 1:
        cApp2.pack()
        cApp1.pack_forget()
        tree.pack_forget()
        result = subprocess.run(["sudo systemctl status kismet"], shell=True, text=True, capture_output=True)

    else:
        pass
        
    #scrollbar1.pack(side = RIGHT, fill = BOTH)

def btnB():
    #label.value = "Hunting for ALL XYZs"
    pass

def btnC():
    #label.value = "Help"
    pass

window = Tk()
window.title('App Selector')
window.geometry('790x420')
window.resizable(False, False)


# --- Canvas: App #2 (Kismet)(?) ---
cApp2 = Canvas(window, height=400, width=800, bg="#22303C", bd='0', borderwidth=0, highlightthickness=0)
cApp2.place(x=0, y=0)
cApp2.pack_forget()


# --- Canvas: App #1 (UHF Sweep) ---
cApp1 = Canvas(window, height=420, width=800, bg="#22303C", bd='0', borderwidth=0, highlightthickness=0)
cApp1.place(x=0, y=0)

#lstBox1 = Listbox(cApp1, height=3, width=50, bd='0')
#lstBox1.pack(side = LEFT, fill = BOTH)
#scrollbar1 = Scrollbar(cApp1)
#scrollbar1.pack(side = RIGHT, fill = BOTH)
#lstBox1.config(yscrollcommand = scrollbar1.set)
#scrollbar1.config(command = lstBox1.yview)

tree = ttk.Treeview(cApp1, column=("tag_id", "tag_count", "tag_fseen", "tag_lseen", "tag_rssi", "tag_gps"), show='headings', height=5)
tree.column("# 1", anchor=CENTER, width=215)
tree.heading("# 1", text="Tag ID")
tree.column("# 2", anchor=CENTER, width=60)
tree.heading("# 2", text="Count")
tree.column("# 3", anchor=CENTER, width=175)
tree.heading("# 3", text="F_Seen")
tree.column("# 4", anchor=CENTER, width=175)
tree.heading("# 4", text="L_Seen")
tree.column("# 5", anchor=CENTER, width=80)
tree.heading("# 5", text="RSSI")
tree.column("# 6", anchor=CENTER)
tree.heading("# 6", text="GPS")
tree.pack_forget()

cApp1.pack_forget()

# --- Canvas: Main Menu ---
cMenu = Canvas(window, height=420, width=800, bg="#22303C", bd='0', borderwidth=0, highlightthickness=0)
cMenu.place(x=-1, y=-1)
cMenu.pack()

app_layout(cMenu)

#btnHelp = Button(cMenu, text='Help ?', width=96, height=1, bd='1', command=window.destroy)
#btnHelp.config(bg="#22303C", highlightthickness=2, highlightbackground="orange", highlightcolor="orange")
#btnHelp.place(x=10, y=365)

window.mainloop()

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
    from tkinter import messagebox
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


# --- Main App Directory
UHF_DIR = "/opt/UHF-Sweep/"
# ---
UHF_TGT_MODE = 0

def hide(widget):
    widget.pack_forget()


def show(widget):
    widget.pack()


def target_id(TGT_ID):
    UHF_TGT_MODE = 1
    UHF_SCRIPT = subprocess.run(["sudo " + UHF_DIR + "./uhf-sweep.sh --epc " + TGT_ID], shell=True, capture_output=True, text=True)
    #print(UHF_SCRIPT.stdout)
    window.after(500, target_id(TGT_ID))  # run again after 1000ms (1s)
    

def selectTreeItem(item):
    TGT_ITEM = tree.focus()
    if tree.item(TGT_ITEM)['values'] != '':
        TGT_ASK = tree.item(TGT_ITEM)['values'][0]
        TGT_ANSWER = messagebox.askokcancel("Question","Target ID: "+ TGT_ASK +"?\n\nThis will clear current list.")
        #print(TGT_ANSWER)
        if TGT_ANSWER == True:
            target_id(TGT_ASK)
        else:
            pass
    else:
        pass


def app_layout(self):
    hide(cApp1)
    cApp2.pack_forget()
    self.button = []
    self.label = []
    appList = ["UHF\nSweep", "Kismet", "Option 3"]
    x = 0

    
# -- Dynamically add button objects to the canvas, based on the items in appList[]
    for i in range(len(appList)):
        self.button.append(Button(self, text=appList[i], width=8, height=4, bd='0', command=lambda i=i: open_app(i)))
        self.button[i].config(bg="#22303C", fg="#888888", highlightthickness=2, highlightbackground="orange", highlightcolor="orange", font=('Arial 15 bold'))
        self.button[i].grid(row=0, column=i, sticky=N+E+S+W, pady=2, padx=10, ipadx=2, ipady=2)

# -- Add an empty Label object for Help spacing
    self.label.append(Label(self, text='', width=10, height=1, bd='0'))
    self.label[0].config(bg="#22303C", highlightthickness=0, borderwidth=0)
    self.label[0].grid(row=1, column=0, columnspan=(i+1), sticky=E+W, pady=2, padx=10, ipadx=2, ipady=2)

    s = ttk.Style()
    s.configure('TSeparator', background='#5daed7')
    ttk.Separator(master=self, orient='horizontal', style='TSeparator').grid(row=2, column=0, columnspan=(i+1), sticky=E+W, pady=0, padx=5, ipadx=0, ipady=0)
    
# -- Add the actual Help button
    self.button.append(Button(self, text='Help ?', width=10, height=1, bd='0', command=window.destroy))
    self.button[i+1].config(bg="#22303C", fg="#888888", highlightthickness=2, highlightbackground="orange", highlightcolor="orange", font=('Arial 15 bold'))
    self.button[i+1].grid(row=3, column=0, columnspan=(i+1), sticky=E+W, pady=2, padx=10, ipadx=2, ipady=2)


def app1():
    tree.bind('<ButtonRelease-1>', selectTreeItem)
    if os.path.exists(UHF_DIR + "uhf-sweep.sh") == True:
        UHF_SCRIPT = subprocess.run(["sudo " + UHF_DIR + "./uhf-sweep.sh"], shell=True, capture_output=True, text=True)
        if os.path.exists(UHF_DIR + "uhf_sweep.csv") == True:
            UHF_FILE = open(UHF_DIR + 'uhf_sweep.csv', 'r')
            F_LINES = UHF_FILE.read().splitlines()
            LAST_LINE = F_LINES[-1]
            UHF_FILE.close()
            if LAST_LINE != '' and LAST_LINE != '0,0,0,0,0':
                LAST_TAG =  LAST_LINE.split(",")
                TAG_TIME = LAST_TAG[0].split(".")
                TAG_RSSI = LAST_TAG[2]
                #TAG_RSSI = int(LAST_TAG[2]).to_bytes(2, 'big')
                ALL_TAGS = tree.get_children()
                TAG_CHECK = 0
                if len(ALL_TAGS) > 0:
                    for i in ALL_TAGS:
                        TAG_COUNT = tree.item(i)['values'][1]
                        if LAST_TAG[4] == tree.item(i)['values'][0]:
                            TAG_CHECK += 1
                            if TAG_TIME[0] != tree.item(i)['values'][3]:
                                tree.set(i, '# 2', (tree.item(i)['values'][1] + 1))
                                tree.set(i, '# 4', TAG_TIME[0])
                                tree.set(i, '# 5', TAG_RSSI)
                    if TAG_CHECK == 0:
                        tree.insert('', 'end', values=(LAST_TAG[4], 1, TAG_TIME[0], TAG_TIME[0], TAG_RSSI, 'GPS'), tags=('TREE_LINE',))
                else:
                    tree.insert('', 'end', values=(LAST_TAG[4], 1, TAG_TIME[0], TAG_TIME[0], TAG_RSSI, 'GPS'), tags=('TREE_LINE',))
            
                #os.remove(UHF_DIR + "uhf_sweep.csv")
                UHF_FILE = open(UHF_DIR + 'uhf_sweep.csv', 'w')
                UHF_FILE.write('0,0,0,0,0' + '\n')
                UHF_FILE.close()
                window.after(500, app1)  # run again after 1000ms (1s)
            else:
                window.after(500, app1)  # run again after 1000ms (1s)
        else:
            tree.insert('', 'end', values=('INPUT', 'FILE', 'NOT', 'FOUND', '', ''))
    else:
        tree.insert('', 'end', values=('SCRIPT', 'NOT', 'FOUND', '', '', ''))


def open_app(appNum):
    cMenu.pack_forget()
    if appNum == 0:
        cApp1.pack()
        tree.pack()
        cApp2.pack_forget()
        app1()
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
#cApp1 = Canvas(window, height=420, width=800, bg="#22303C", bd='0', borderwidth=0, highlightthickness=0)
cApp1 = Canvas(window, height=500, width=800, bg="#22303C", bd='0', borderwidth=0, highlightthickness=0)
cApp1.place(x=0, y=0)

#lstBox1 = Listbox(cApp1, height=3, width=50, bd='0')
#lstBox1.pack(side = LEFT, fill = BOTH)
#scrollbar1 = Scrollbar(cApp1)
#scrollbar1.pack(side = RIGHT, fill = BOTH)
#lstBox1.config(yscrollcommand = scrollbar1.set)
#scrollbar1.config(command = lstBox1.yview)

tree = ttk.Treeview(cApp1, column=("tag_id", "tag_count", "tag_fseen", "tag_lseen", "tag_rssi", "tag_gps"), show='headings', height=10)
tree.tag_configure('TREE_LINE', background='#22303C', font=(None, 14))
style = ttk.Style()
style.configure('Treeview.Heading', font=(None, 14))
style.configure('Treeview', background='#22303C', fieldbackground='#22303C', foreground='white', font=(None, 14))
tree.column("# 1", anchor=CENTER, width=250)
tree.heading("# 1", text="Tag ID")
tree.column("# 2", anchor=CENTER, width=55)
tree.heading("# 2", text="#")
tree.column("# 3", anchor=CENTER, width=213)
tree.heading("# 3", text="First")
tree.column("# 4", anchor=CENTER, width=213)
tree.heading("# 4", text="Last")
tree.column("# 5", anchor=CENTER, width=60)
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

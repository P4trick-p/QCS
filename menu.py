import os
import qsharp


os.system('cls' if os.name == 'nt' else 'clear');

ans=True
while ans:
    print ("""
    1.Algorytm 1
    2.Algorytm 2
    3.Algorytm 3
    4.Algorytm 4
    5.Wyjdz
    """)
    ans=raw_input("Wybierz opcje: ")
    if ans=="1":
      print("\n Uruchamianie algorytmu 1");
      os.system('cls' if os.name == 'nt' else 'clear');
      execfile("main.qs");
    elif ans=="2":
      print("\n Uruchamianie algorytmu 2");

    elif ans=="3":
      print("\n Uruchamianie algorytmu 3");

    elif ans=="4":
      print("\n Uruchamianie algorytmu 4");

    elif ans=="5":
      print("\n Do widzenia");

    elif ans !="":
      print("\n Nieprawidłowy argument");
      os.system('cls' if os.name == 'nt' else 'clear');
      execfile("menu.py");

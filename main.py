import os
import qsharp
from Microsoft.Quantum.Samples.SimpleGrover import SearchForMarkedInput
import argparse
from Measurement import RunQuantumMain
from Teleportation import TeleportClassicalMessage, TeleportRandomMessage
from qsharp import IQSharpError
from IntegerFactorization import FactorInteger
from SimpleGrover import SearchForMarkedInput

os.system('cls' if os.name == 'nt' else 'clear')
ans=True
while ans:
    print ("""
    1. Qbit measure
    2. Teleportation
    3. Grover's quantum search algorithm
    4. Shor's quantum algorithm for factoring integer
    5. Exit
    """)
    ans=input("Wybierz opcje: ")
    if ans=="1":
        print("\n Launching Qbit measure ")
        os.system('cls' if os.name == 'nt' else 'clear')
        RunQuantumMain.simulate()
    elif ans=="2":
        os.system('cls' if os.name == 'nt' else 'clear')
        print("\n Launching Teleportation")

        TeleportRandomMessage.simulate()
        print("------------------")

        r = TeleportClassicalMessage.simulate(message=True)
        print("Sent True, Received:", r)
        r = TeleportClassicalMessage.simulate(message=False)
        print("Sent False, Received:", r)
        print("------------------")

        resources = TeleportRandomMessage.estimate_resources()
        print("Estimated resources needed for teleport:\n", resources)
        print("------------------")

        for i  in range(10):
            TeleportRandomMessage.simulate()
            print("------------------")

    elif ans=="3":
        os.system('cls' if os.name == 'nt' else 'clear')
        print("\n Launching Grover's quantum search algorithm")

        n_qubits = 5
        result = SearchForMarkedInput.simulate(nQubits=n_qubits)
        print(result)


    elif ans=="4":
        os.system('cls' if os.name == 'nt' else 'clear');
        print("\n Shor's quantum algorithm for factoring integer");
        def factor_integer(number_to_factor, n_trials , use_robust_phase_estimation ):
                      """ Use Shor's algorithm to factor an integer.
                      Shor's algorithm is a probabilistic algorithm and can fail with certain probability in several ways.
                      For more details see Shor.qs.
                      """
                      for i in range(n_trials):
                          print("==========================================")
                          print(f'Factoring {number_to_factor}')
                          try:
                              output = FactorInteger.simulate(
                                number=number_to_factor,
                                useRobustPhaseEstimation=use_robust_phase_estimation,
                                raise_on_stderr=True)


                              factor_1, factor_2 = output
                              print(f"Factors are {factor_1} and {factor_2}.")
                          except IQSharpError as error:
                              print("This run of Shor's algorithm failed:")
                              print(error)

        if __name__ == "__main__":
            parser = argparse.ArgumentParser(
            description="Factor Integers using Shor's algorithm.")
            parser.add_argument(
            '-n',
            '--number',
            type=int,
            help='number to be factored.(default=15)',
            default=15
            )
            parser.add_argument(
            '-t',
            '--trials',
            type=int,
            help='number of trial to perform.(default=10)',
            default=10
            )
            parser.add_argument(
            '-u',
            '--use-robust-pe',
            action='store_true',
            help='if true uses Robust Phase Estimation, otherwise uses Quantum Phase Estimation.(default=False)',
            default=False)
            args = parser.parse_args()
            if args.number >= 1:
                factor_integer(args.number, args.trials, args.use_robust_pe)
            else:
                print("Error: Invalid number. The number '-n' must be greater than or equal to 1.")

    elif ans=="5":
        os.system('cls' if os.name == 'nt' else 'clear')
        print("\n Goodbye")
        break

    elif ans !="":
        print("\n Invalid argument")
        os.system('cls' if os.name == 'nt' else 'clear')
        #execfile("C:/Users/tom98/Documents/Testownik 2/QCS/QCS-master/main.py")

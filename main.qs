namespace Quantum
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;

        operation SetToPlus(q: Qubit) : Unit {
            Reset(q);
            H(q);
        }

        operation SetToMinus(q: Qubit) : Unit {
            Reset(q);
            X(q);
            H(q);
        }

        operation IsPlus(q: Qubit) : Bool {
            return (Measure([PauliX], [q]) == Zero);
        }
        operation IsMinus(q: Qubit) : Bool {
            return (Measure([PauliX], [q]) == One);
        }
        operation PrepareRandomMessage(q: Qubit) : Unit {
            let choice = RandomInt(2);

            if (choice == 0) {
                Message("Sending |->");
                SetToMinus(q);
            } else {
                Message("Sending |+>");
                SetToPlus(q);
            }
        }
    operation SampleQrng() : Result {
       using (qubit = Qubit()) {
           H(qubit);

           AssertProb([PauliZ], [qubit], Zero, 0.5, "Error: Outcomes of the measurement must be equally likely", 1E-05);

           let result = M(qubit);

           if (result == One) {
               X(qubit);
           }

           return result;
       }
   }
   operation MeasureTwoQubits() : (Result, Result) {
       using ((left, right) = (Qubit(), Qubit())) {

           ApplyToEach(H, [left, right]);

           AssertProb([PauliZ], [left], Zero, 0.5, "Error: Outcomes of the measurement must be equally likely", 1E-05);

           AssertProb([PauliZ], [right], Zero, 0.5, "Error: Outcomes of the measurement must be equally likely", 1E-05);

           return (MResetZ(left), MResetZ(right));
       }
   }

   operation MeasureInBellBasis() : (Result, Result) {
       using ((left, right) = (Qubit(), Qubit())) {
           H(left);
           CNOT(left, right);

           Assert([PauliZ, PauliZ], [left, right], Zero, "Error: Bell state must be eigenstate of ZZ");
           Assert([PauliX, PauliX], [left, right], Zero, "Error: Bell state must be eigenstate of XX");
           AssertProb([PauliZ, PauliZ], [left, right], One, 0.0, "Error: 01 or 10 should never occur as an outcome", 1E-05);

           return (MResetZ(left), MResetZ(right));
       }
   }
   operation RunQuantumMain() : Unit {

       Message("## SampleQrng() ##");
       mutable count = 0;

       for (idx in 0..99) {
           set count += SampleQrng() == One ? 1 | 0;
       }

       Message($"Est. probability of Zero given H|0⟩: {count} / 100");

       Message("## MeasureTwoQubits() ##");
       for (idx in 0..7) {
           let (left, right) = MeasureTwoQubits();
           Message($"Measured HH|00⟩ and observed ({left}, {right}).");
       }

       Message("## MeasureInBellBasis() ##");
       for (idx in 0..7) {
           let (left, right) = MeasureInBellBasis();
           Message($"Measured CNOT · H |00⟩ and observed ({left}, {right})");
       }

   }
}

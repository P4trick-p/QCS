namespace qsharp_main
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;

    operation Teleport (msg : Qubit, target : Qubit) : Unit {
        using (register = Qubit()) {
              H(register);
            CNOT(register, target);
            CNOT(msg, register);
            H(msg);
            let data1 = M(msg);
            let data2 = M(register);

            if (MResetZ(msg) == One) {
              Z(target);
             }
            if (IsResultOne(MResetZ(register))) {
              X(target);
            }
        }
    }
    operation TeleportClassicalMessage (message : Bool) : Bool {
        using ((msg, target) = (Qubit(), Qubit())) {

            if (message) {
                X(msg);
            }
            Teleport(msg, target);
            return MResetZ(target) == One;
        }
    }
    operation TeleportRandomMessage () : Unit {
      using ((msg, target) = (Qubit(), Qubit())) {
          PrepareRandomMessage(msg);

          Teleport(msg, target);

          if (IsPlus(target))  {
              Message("Received |+>");
            }
          if (IsMinus(target)) {
              Message("Received |->");
          }

          Reset(msg);
          Reset(target);
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

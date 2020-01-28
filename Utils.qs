namespace Teleportation {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
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
            Message("Sending |-> Random1");
            SetToMinus(q);
        } else {
            Message("Sending |+> Random2");
            SetToPlus(q);
        }
    }
}

namespace Microsoft.Quantum.Samples.Teleportation {
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

            if (MResetZ(msg) == One) { Z(target); }
            if (IsResultOne(MResetZ(register))) { X(target); }
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

            if (IsPlus(target))  { Message("Received |+>"); }
            if (IsMinus(target)) { Message("Received |->"); }

            Reset(msg);
            Reset(target);
        }
    }
}

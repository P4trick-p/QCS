namespace Microsoft.Quantum.Samples.SimpleGrover {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Measurement;

    operation ReflectAboutMarked(inputQubits : Qubit[]) : Unit {
        Message("Reflecting about marked state...");
        using (outputQubit = Qubit()) {
            within {
                // Inicjalizacja outputQubit do (|0⟩ - |1⟩) / √2, by byl w fazie (-1)
                X(outputQubit);
                H(outputQubit);
                // Odwracanie outputQubit dla stanow zaznaczonych
                ApplyToEachA(X, inputQubits[...2...]);
            } apply {
                Controlled X(inputQubits, outputQubit);
            }
        }
    }
    // Odbijanie jednolitego stanu superpozycji
    operation ReflectAboutUniform(inputQubits : Qubit[]) : Unit {
        within {
            // Transformacja jednolitej superpozycji do stanu all-zeros
            Adjoint PrepareUniform(inputQubits);
            // Transformacja stanow all-zeros do stanow all-ones
            PrepareAllOnes(inputQubits);
        } apply {
            // Odbijanie stanow all-ones
            ReflectAboutAllOnes(inputQubits);
        }
    }
    // Odbijanie stanow all-ones
    operation ReflectAboutAllOnes(inputQubits : Qubit[]) : Unit {
        Controlled Z(Most(inputQubits), Tail(inputQubits));
    }
    // Z rejestrem stanow all-zeros, przygotowywanie jednolitej superpozycji
    // na wszystkich bazowych stanach
    operation PrepareUniform(inputQubits : Qubit[]) : Unit is Adj + Ctl {
        ApplyToEachCA(H, inputQubits);
    }
    // Z rejestrem stanow all-zeros, przygotowywanie stanu all-ones odwracajac kazdy qubit
    operation PrepareAllOnes(inputQubits : Qubit[]) : Unit is Adj + Ctl {
        ApplyToEachCA(X, inputQubits);
    }

}

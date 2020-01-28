namespace Microsoft.Quantum.Samples.SimpleGrover {
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Measurement;
    // Algorytm Grover'a wyszukuje wszystkie mozliwe wejscia operacji
    // by znalezc konkretny stan zaznaczony
    operation SearchForMarkedInput(nQubits : Int) : Result[] {
        using (qubits = Qubit[nQubits]) {
            // Inicjalizacja jednolitej superpozycji dla wszystkich mozliwych wejsc
            PrepareUniform(qubits);
            // Wyszukiwanie porownujac stan zaznaczony i stan startowy
            for (idxIteration in 0..NIterations(nQubits) - 1) {
                ReflectAboutMarked(qubits);
                ReflectAboutUniform(qubits);
            }
            // Mierzenie i zwracanie odpowiedzi
            return ForEach(MResetZ, qubits);
        }
    }
    //  Zwraca liczbę iteracji Grover'a potrzebnych do
    //  znalezienia pojedynczego zaznaczonego elementu
    function NIterations(nQubits : Int) : Int {
        let nItems = 1 <<< nQubits; // 2^numQubits
        // Obliczanie liczby iteracji
        let angle = ArcSin(1. / Sqrt(IntAsDouble(nItems)));
        let nIterations = Round(0.25 * PI() / angle - 0.5);
        return nIterations;
    }
}

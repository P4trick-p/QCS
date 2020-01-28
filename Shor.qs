namespace IntegerFactorization {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Oracles;
    open Microsoft.Quantum.Characterization;
    open Microsoft.Quantum.Diagnostics;

    operation FactorInteger(number : Int, useRobustPhaseEstimation : Bool) : (Int, Int) {

        if (number % 2 == 0) {
            Message("An even number has been passed; 2 is the factor.");
            return (number / 2, 2);
        }

        let coprimeCandidate = RandomInt(number - 2) + 1;

        if (IsCoprimeI(coprimeCandidate, number)) {

            Message($"Estimating period of {coprimeCandidate}");

            let period = EstimatePeriod(coprimeCandidate, number, useRobustPhaseEstimation);

            if (period % 2 == 0) {

                let halfPower = ExpModI(coprimeCandidate, period / 2, number);

                if (halfPower != number - 1) {

                    let factor = MaxI(GreatestCommonDivisorI(halfPower - 1, number), GreatestCommonDivisorI(halfPower + 1, number));

                    return (factor, number / factor);
                } else {
                    fail "Residue xᵃ = -1 (mod N) where a is a period.";
                }
            } else {
                fail "Period is odd.";
            }
        }
        else {
            let gcd = GreatestCommonDivisorI(number, coprimeCandidate);

            Message($"We have guessed a divisor of {number} to be {gcd} by accident.");

            return (gcd, number / gcd);
        }
    }

    operation ApplyOrderFindingOracle(generator : Int, modulus : Int, power : Int, target : Qubit[])
    : Unit is Adj + Ctl {
        Fact(IsCoprimeI(generator, modulus), "`generator` and `modulus` must be co-prime");

        MultiplyByModularInteger(ExpModI(generator, power, modulus), modulus, LittleEndian(target));
    }
    operation EstimatePeriod(generator : Int, modulus : Int, useRobustPhaseEstimation : Bool) : Int {
        EqualityFactB(IsCoprimeI(generator, modulus), true, "`generator` and `modulus` must be co-prime");

        mutable result = 1;

        let bitsize = BitSizeI(modulus);

        let bitsPrecision = 2 * bitsize + 1;

        repeat {

            mutable dyadicFractionNum = 0;

            using (eigenstateRegister = Qubit[bitsize]) {

                let eigenstateRegisterLE = LittleEndian(eigenstateRegister);
                ApplyXorInPlace(1, eigenstateRegisterLE);

                let oracle = DiscreteOracle(ApplyOrderFindingOracle(generator, modulus, _, _));

                if (useRobustPhaseEstimation) {
                    let phase = RobustPhaseEstimation(bitsPrecision, oracle, eigenstateRegisterLE!);

                    set dyadicFractionNum = Round(((phase * IntAsDouble(2 ^ bitsPrecision)) / 2.0) / PI());
                } else {
                    using (register = Qubit[bitsPrecision]) {
                        let dyadicFractionNumerator = LittleEndian(register);

                        QuantumPhaseEstimation(oracle, eigenstateRegisterLE!, LittleEndianAsBigEndian(dyadicFractionNumerator));

                        set dyadicFractionNum = MeasureInteger(dyadicFractionNumerator);
                    }
                }

                ResetAll(eigenstateRegister);
            }

            if (dyadicFractionNum == 0) {
                fail "We measured 0 for the numerator";
            }

            Message($"Estimated eigenvalue is {dyadicFractionNum}/2^{bitsPrecision}.");

            let (numerator, period) = (ContinuedFractionConvergentI(Fraction(dyadicFractionNum, 2 ^ bitsPrecision), modulus))!;

            let (numeratorAbs, periodAbs) = (AbsI(numerator), AbsI(period));

            Message($"Estimated divisor of period is {periodAbs}, " + $" we have projected on eigenstate marked by {numeratorAbs}.");

            set result = (periodAbs * result) / GreatestCommonDivisorI(result, periodAbs);
        }
        until (ExpModI(generator, result, modulus) == 1)
        fixup {

            Message("It looks like the period has divisors and we have " + "found only a divisor of the period. Trying again ...");
        }

        return result;
    }

}

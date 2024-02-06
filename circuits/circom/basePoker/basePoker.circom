pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/gates.circom";
include "../../node_modules/circomlib/circuits/comparators.circom";


template Poker () {

    signal input cards[5]; // Each 2..14
    signal input isSee; // 1 or 0
    signal input isFold; // 1 or 0
    signal input raise; // int
    signal output out; // 1 or 0

    // Intermediate results
    signal isBid;
    signal isRaise;
    signal hasChosen;

    var pairsCount = 0;
    for (var first_card_considered = 0; first_card_considered <= 5; first_card_considered++) {
        for (var second_card_considered = 1; second_card_considered <= 5; second_card_considered++) {
            if (cards[first_card_considered] == cards[second_card_considered]) {
                pairsCount ++;
                first_card_considered = 5;
                second_card_considered = 5;
            }
        }
    }

    isRaise <-- (raise > 0);
    isBid <-- (isSee || isRaise);

    component evaluateChoice = XOR();
    evaluateChoice.a <-- isBid;
    evaluateChoice.b <-- isFold;

    evaluateChoice.out === 1;

    var hasPairs = (pairsCount > 0);
    component notBid = NOT();

    notBid.in <-- isBid;

    // Result
    component pairsOrNotBid = OR();
    pairsOrNotBid.a <-- hasPairs;
    pairsOrNotBid.b <-- notBid.out;

    // Player must have a pair, else he can't bet
    pairsOrNotBid.out === 1;

    out <-- pairsOrNotBid.out;
}

component main {public [isSee, isFold, raise]} = Poker();
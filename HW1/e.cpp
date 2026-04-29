#include <iostream>
using namespace std;

int eval_good(int A, int C, int D, int E, int F, int G) {
    int pull_down = A || (C && D) || (E && F && G);
    return !pull_down;
}

char eval_faulty_open(int A, int C, int D, int E, int F, int G) {
    bool pull_down = A || (C && D) || (E && F && G);
    bool pull_up = (!A) && ((!C) || (!D)) && ((!F) || (!G));

    if (pull_up) return '1';
    if (pull_down) return '0';
    return 'Z';
}

void decode(int x, int &A, int &C, int &D, int &E, int &F, int &G) {
    A = (x >> 5) & 1;
    C = (x >> 4) & 1;
    D = (x >> 3) & 1;
    E = (x >> 2) & 1;
    F = (x >> 1) & 1;
    G = (x >> 0) & 1;
}

int main() {
    int total_tests = 0;

    cout << "All 2-pattern tests (V1 -> V2):" << endl;
    cout << "V1 (A C D E F G) -> V2 (A C D E F G)" << endl;
    cout << "-------------------------------------" << endl;

    for (int v1 = 0; v1 < 64; v1++) {
        int A1, C1, D1, E1, F1, G1;
        decode(v1, A1, C1, D1, E1, F1, G1);

        int y1_good = eval_good(A1, C1, D1, E1, F1, G1);

        if (y1_good != 0) continue;

        for (int v2 = 0; v2 < 64; v2++) {
            int A2, C2, D2, E2, F2, G2;
            decode(v2, A2, C2, D2, E2, F2, G2);

            int y2_good = eval_good(A2, C2, D2, E2, F2, G2);
            char y2_fault = eval_faulty_open(A2, C2, D2, E2, F2, G2);

            if (y2_good == 1 && y2_fault == 'Z') {
                cout << A1 << " " << C1 << " " << D1 << " "
                     << E1 << " " << F1 << " " << G1
                     << " -> "
                     << A2 << " " << C2 << " " << D2 << " "
                     << E2 << " " << F2 << " " << G2 << endl;
                total_tests++;
            }
        }
    }

    cout << "-------------------------------------" << endl;
    cout << "Total number of 2-pattern tests = " << total_tests << endl;

    return 0;
}
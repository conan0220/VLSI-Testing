#include <iostream>
using namespace std;

int main() {
    int on_set = 0;
    int off_set = 0;

    cout << "A C D E F G | Y" << endl;
    cout << "-----------------" << endl;

    for (int i = 0; i < 64; i++) {
        int A = (i >> 5) & 1;
        int C = (i >> 4) & 1;
        int D = (i >> 3) & 1;
        int E = (i >> 2) & 1;
        int F = (i >> 1) & 1;
        int G = (i >> 0) & 1;

        int inner = A || (C && D) || (E && F && G);
        int Y = !inner;

        cout << A << " "
             << C << " "
             << D << " "
             << E << " "
             << F << " "
             << G << " | "
             << Y << endl;

        if (Y == 1) on_set++;
        else off_set++;
    }

    cout << "-----------------" << endl;
    cout << "ON-SET  = " << on_set << endl;
    cout << "OFF-SET = " << off_set << endl;

    return 0;
}
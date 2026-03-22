#include <iostream>
using namespace std;

int main() {
    int count_X = 0;
    int count_1 = 0;
    int count_0 = 0;
    cout << "A C D E F G | Y" << endl;
    cout << "-----------------" << endl;

    for (int i = 0; i < 64; i++) {
        int A = (i >> 5) & 1;
        int C = (i >> 4) & 1;
        int D = (i >> 3) & 1;
        int E = (i >> 2) & 1;
        int F = (i >> 1) & 1;
        int G = (i >> 0) & 1;

        bool pull_up = (!A) && ((!C) || (!D)) && ((!E) || (!F) || (!G));
        bool pull_down = A || (C && D) || (F && G);

        char Y;
        if (pull_up && pull_down) {
            Y = 'X';
            count_X++;
        } else if (pull_up) {
            Y = '1';
            count_1++;
        } else {
            Y = '0';
            count_0++;
        }

        cout << A << " "
             << C << " "
             << D << " "
             << E << " "
             << F << " "
             << G << " | "
             << Y << endl;
    }

    cout << "-----------------" << endl;
    cout << "Number of 1 outputs = " << count_1 << endl;
    cout << "Number of 0 outputs = " << count_0 << endl;
    cout << "Number of X outputs = " << count_X << endl;

    return 0;
}
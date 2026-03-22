#include <iostream>
using namespace std;

int main() {
    int count_Z = 0;
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

        bool pull_down = A || (C && D) || (E && F && G);
        bool pull_up = (!A) && ((!C) || (!D)) && ((!F) || (!G));

        char Y;
        if (pull_up) {
            Y = '1';
            count_1++;
        } else if (pull_down) {
            Y = '0';
            count_0++;
        } else {
            Y = 'Z';
            count_Z++;
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
    cout << "Number of Z outputs = " << count_Z << endl;

    return 0;
}
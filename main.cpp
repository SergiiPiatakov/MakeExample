int main (int argc, char **)
{
    int x = argc;
    if (x < 10) {
        for (int i = 1; i < 1000000; ++i) {
            x += i;
        }
    }
    else {
        x += 100;
    }

    return x % 42;
}

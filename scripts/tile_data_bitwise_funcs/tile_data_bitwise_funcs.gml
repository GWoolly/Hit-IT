/// swap_bits(n, bit1, bit2)
/// @param n      The number to modify
/// @param bit1   Index of first bit to swap (0 = least significant bit)
/// @param bit2   Index of second bit to swap

function swap_bits(n, bit1, bit2) {
    var b1 = (n >> bit1) & 1;
    var b2 = (n >> bit2) & 1;

    // If they're different, toggle both
    if (b1 != b2) {
        n ^= (1 << bit1) | (1 << bit2);
    }

    return n;
}
Surreal Numbers in Perl 6
=========================

This is an attempt to implement surreal numbers in Perl 6.

Synopis
-------

    use Surreal;

    constant zero = Surreal.new: left => set(), right => set();
    constant one  = Surreal.new: left => set(zero), right => set();
    constant minus-one  = Surreal.new: left => set(), right => set(zero);

    say zero < one;  # True
    say one ≤ zero;  # False
    say minus-one ≤ one;  # True
    

# References

* L<http://www.tondering.dk/download/sur16.pdf>

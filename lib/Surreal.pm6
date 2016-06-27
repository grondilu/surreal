unit class Surreal;

# A surreal number is a pair of sets of previously created surreal numbers. The
# sets are known as the “left set” and the “right set”.
has Set ($.left, $.right);

# No member of the right set may be less than or equal to any member of the
# left set.
submethod BUILD(Set :$left, Set :$right) {
    fail "wrong type found in left set" unless  $left.keys.all ~~ Surreal;
    fail "wrong type found in right set" unless $right.keys.all ~~ Surreal;
    fail "found a member of the right set to be less than or equal to a member of the left set" if ($right.keys X[<=] $left.keys).any;
    $!left = $left;
    $!right = $right;
}

multi method new(0) { self.bless: left => set(), right => set() }
multi method new(1) { self.bless: left => set(self.new(0)), right => set() }
multi method new(-1) { self.bless: left => set(), right => set(self.new(0)) }

multi method new(::?CLASS $left, ::?CLASS $right) {
    self.bless: left => set($left), right => set($right)
}


# A surreal number x is less than or equal to a surreal number y if and only if
# y is less than or equal to no member of x’s left set, and no member of y’s
# right set is less than or equal to x.
multi infix:«<=»(Surreal $x, Surreal $y) is export {
    so $y <= $x.left.keys.none && $y.right.keys.none <= $x;
}
multi infix:<≤>(Surreal $x, Surreal $y) is export { $x <= $y }
multi infix:<≰>(Surreal $x, Surreal $y) is export { !($x ≤ $y) }

multi infix:<≥>(Surreal $x, Surreal $y) is export { $y ≤ $x }
multi infix:<≱>(Surreal $x, Surreal $y) is export { !($x ≱ $y) }

# x < y ≡ (x ≤ y) && (y ≰ x)
multi infix:«<»(Surreal $x, Surreal $y) is export { ($x ≤ $y) && ($y ≰ $x) }
multi infix:<≮>(Surreal $x, Surreal $y) is export { !($x < $y) }

multi infix:«>»(Surreal $x, Surreal $y) is export { $y < $x }
multi infix:<≯>(Surreal $x, Surreal $y) is export { !($x < $y) }

# x == y ≡ (x ≤ y) && (y ≤ x)
multi infix:<==>(Surreal $x, Surreal $y) is export { ($x ≤ $y) && ($y ≤ $x) }
multi infix:<!==>(Surreal $x, Surreal $y) is export { !($x == $y) }

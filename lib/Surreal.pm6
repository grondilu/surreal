unit class Surreal;

# A surreal number is a pair of sets of previously created surreal numbers. The
# sets are known as the “left set” and the “right set”.
subset SurrealSet of Set is export where .keys.all ~~ ::?CLASS;
has SurrealSet ($.left, $.right);

submethod BUILD(
    SurrealSet :$left,
    SurrealSet :$right
# No member of the right set may be less than or equal to any member of the
# left set.
    where ($right.keys X[<=] $left.keys).none
) {
    $!left = $left;
    $!right = $right;
}

multi method gist {
    '{' ~
    $!left.keys».gist.join(',') ~
    '|' ~
    $!right.keys».gist.join(',') ~
    '}'
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

multi infix:«<»(SurrealSet $A, Surreal $c) is export { $A.keys.all < $c }
multi infix:«<»(Surreal $c, SurrealSet $A) is export { $c < $A.keys.all }
multi infix:«>»(SurrealSet $A, Surreal $c) is export { $A.keys.all > $c }
multi infix:«>»(Surreal $c, SurrealSet $A) is export { $c > $A.keys.all }
multi infix:«≰»(SurrealSet $A, Surreal $c) is export { $A.keys.all ≰ $c }
multi infix:«≰»(Surreal $c, SurrealSet $A) is export { $c ≰ $A.keys.all }
multi infix:«≱»(SurrealSet $A, Surreal $c) is export { $A.keys.all ≱ $c }
multi infix:«≱»(Surreal $c, SurrealSet $A) is export { $c ≱ $A.keys.all }

multi infix:<==>(SurrealSet $A, SurrealSet $B) is export {
    for $A.keys -> $a { return False unless $B.keys.any == $a }
    for $B.keys -> $b { return False unless $A.keys.any == $b }
    return True
}


# vim: syntax=off

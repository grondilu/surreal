use Test;
use Surreal;

plan *;

constant zero = Surreal.new(0);

ok zero ~~ Surreal, '{|} is surreal';
ok zero ≤ zero, '{|} ≤ {|}';
ok zero ≥ zero, '{|} ≥ {|}';
ok zero == zero, '{|} == {|}';

constant uno = Surreal.new(1);
constant dos = Surreal.new(left => set(uno), right => set());
constant minus-uno = Surreal.new(-1);

ok zero <= uno, '{|} ≤ {0|}';
nok uno <= zero, '¬({0|} ≤ {|})';
ok uno <= uno,  '{0|} ≤ {0|}';

ok zero < uno, '{|} < {0|}';
ok uno == uno, '{0|} == {0|}';

ok minus-uno < zero, '-1 < 0';
ok minus-uno == minus-uno, '-1 == -1';
ok minus-uno ≤ uno, '-1 < 1';

ok Surreal.new(minus-uno, uno) ≤ zero, '{-1|1} ≤ {|}';
ok zero ≤ Surreal.new(minus-uno, uno), '{|} ≤ {-1|1}';

ok set(zero, dos) == set(
    Surreal.new(minus-uno, uno),
    zero,
    Surreal.new(left => set(minus-uno, zero, uno), right => set())
), '{{|},{1|}} = {{-1|1}, {|}, {-1,0,1|}}';
# vim: ft=perl6

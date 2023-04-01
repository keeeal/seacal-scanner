
module superellipse(r, p, e=1) {
    function x(r,p,e,a) =   r*pow(abs(cos(a)),2/p)*sign(cos(a));
    function y(r,p,e,a) = e*r*pow(abs(sin(a)),2/p)*sign(sin(a));
    da = 360/$fn;
    for (i = [0:$fn-1]) polygon([
        [0,0],
        [x(r,p,e,da*i), y(r,p,e,da*i)],
        [x(r,p,e,da*(i+1)), y(r,p,e,da*(i+1))]
    ]);
}

module squircle(r) {
    superellipse(r, 4);
}

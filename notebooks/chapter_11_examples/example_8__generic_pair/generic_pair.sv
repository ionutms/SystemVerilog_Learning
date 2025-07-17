// Design module: generic_pair
module generic_pair #(
    type T1,
    type T2
) (
    input  T1 value1,
    input  T2 value2,
    output T1 first,
    output T2 second
);
    assign first = value1;
    assign second = value2;
endmodule
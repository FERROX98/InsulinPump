block Monitor

InputReal glucosio;  
OutputReal y;

Boolean ct;

initial equation
y = 0;
equation

ct = (glucosio >=  200) or (glucosio <= 50);

algorithm

when edge(ct) then
y := 1;
end when;

end Monitor;
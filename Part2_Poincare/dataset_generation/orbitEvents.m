function [value,isterminal,direction] = orbitEvents(t,F)

if F(4) < 0
    value = F(3);
else
    value = 1;
end

isterminal = 1;         
direction  = 0;         
end
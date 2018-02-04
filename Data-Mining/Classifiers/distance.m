function dist = distance(x,y)

dist = abs(1 - dot(x,y)/(norm(x)*norm(y)));

end
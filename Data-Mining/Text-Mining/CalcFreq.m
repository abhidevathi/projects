function xx=CalcFreq(str,len,wid)

disp('Cutting in fragments...');
i=1; k=1; nn = size(str);
while i+wid<nn(2)
    if round(k/200)==k/200
        disp(strcat(int2str(k),' fragments'));
    end
    frag = str(i:i+wid-1); vf(k) = calcf(frag,len);    
    i = i+wid; k=k+1;
end

disp('Merging into table...');
names = java.util.Vector; n = 0;
for i=1:size(vf)
   if size(vf(i))~=0
   keys = vf(i).keys;
   while keys.hasMoreElements
       key = keys.nextElement;
       if names.indexOf(key)==-1
       names.add(key);
       end
   end
   n=n+1;
   end    
end
xx = zeros(n,size(names));
for i=1:size(vf)
   if size(vf(i))~=0
    if round(i/200)==i/200
        disp(strcat(int2str(i),' points'));
    end
       for j=1:size(names)
           xx(i,j) = getwf(names.elementAt(j-1),vf(i));
       end,    end,    end


function vf=calcf(str,num)
vf = java.util.Hashtable;
i = 1; nn = size(str);
while i+num<nn(2)
    wrd = str(i:i+num-1); i = i+num; addwf(wrd,vf,1);
end

function addwf(word,hash,fr)
wf = hash.get(word);
if size(wf)==0 hash.put(word,fr); else hash.put(word,fr+wf); end

function fr=getwf(word,hash)
wf = hash.get(word);
if size(wf)==0 fr=0; else fr=wf; end
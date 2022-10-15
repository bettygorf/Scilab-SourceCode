function cors=shiftcors(cors,ns)
n=size(cors)
for k=1:n
  if type(cors(k))==15 then
    cors(k)=shiftcors(cors(k),ns)
  else
    cors(k)=cors(k)+ns
  end
end





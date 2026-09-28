% Exercises - Intro to Matlab

%Ex 1
a = 5;
x = 2;
y = 8;
z = exp(-a)*sin(x) + 10*sqrt(y);
disp(z);

%Ex 2
A = rand(3,4);
disp(A)
disp(A(1,2))
disp(A(:,3))
disp(A(1,:))
disp(A(2,3:4))

%Ex 3
C = 5*eye(3);
C(2,2)= 3;
disp(C)

%Ex 4
M = [1 -1 3; 4 8 -2; 0 5 -9];
x1 = M(1,:);
y = M(2:3,:);
sum(M)
sum(sum(M))
max(max(abs(M)))
b = [1,3,2]';
x = M\b;
M(find(M<0))=0;
disp(M)

%Ex 5
for k = 0:20
    if mod(k,2) == 0
        disp([num2str(k) ' is even'])
    else
        disp([num2str(k) ' is odd'])
    end
end

%Ex 6
ExpValue(100) %94.50
ExpValue(30) %28.35

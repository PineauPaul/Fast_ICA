
[x1,f1] = audioread('DDN1.wav');
[x2,f2] = audioread('DDN2.wav');
[x3,f3] = audioread('DDN3.wav');

%creation of the mixed signals
a = 1/sqrt(2);
s1 = a*x1 + a*x2;
s2 = a*x2 - a*x1 + 0.1 * x3;
s3 = 2*a*x2 + a*x3 + x1;


%some plot

% figure
% plot(x1)
% title('signal 1 (x1) : original')
% xlim([0,500000])
% figure
% 
% plot(s2)
% title('mixed signal (a*x2 - a*x1 + 0.1*x3')
% sound(s1,f1)


A = fastica(1e-10,[s1,s2,s3]);
% sound(A(1,:),f2)
% 
% figure
% plot(A(2,:))
% title('unmixed : x1')
% xlim([0,500000])



function x_center= center(x)
    %center signals
    m = mean(x);

    x_center = x - m;
    
end

function x_tild = whiten(x)
   %mean(x) equal to 0
   E = cov(x);
   [V,D] = eig(E);
   x_tild = V*(D^(-1/2))*V'*x;
end

function v = ortho(x)
    n = length(x);
    v = zeros(1,n);
    if mod(n,2) == 0
        for i = 1:2:n
            v(i) = -x(i+1);
            v(i+1) = x(i);
        end
    end
    if mod(n,2) == 1
        for i = 1:2:n-1
            v(i) = -x(i+1);
            v(i+1) = x(i);
        end
    end
end
   

function [w,v] = compute_wi(z,wi_1)
    w_tild = mean(z*[wi_1'*z]') - 3*wi_1;
    
    w = w_tild/norm(w_tild);
    v = ortho(w);
    v_norm = v/norm(v);
    
end

     
function A = fastica(delta,X)
    [n,m] = size(X);
    X_whiten_center = zeros(m,n);
    for k = 1:m
        
        xk = X(:,k);
        xk_clean = whiten(center(xk));
        
        X_whiten_center(k,:) = xk_clean;
        
    end
    
    w0 = rand(m,1);
    w0 = w0/norm(w0);%norm(w0) = 1
    size(X_whiten_center)
    [w1,v] = compute_wi(X_whiten_center,w0);
    
    while (abs(w1'*w0 - 1 ) > delta)
        w0 = w1;
        [w1,v] = compute_wi(X_whiten_center,w0);
        
     
    end
    
    A = [w1';v]*X_whiten_center;
    
    
    
end
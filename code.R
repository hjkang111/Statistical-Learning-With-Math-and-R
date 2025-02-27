# example 19
min.sq = function(x, y){
  x.bar = mean(x) 
  y.bar = mean(y)
  beta.1 = sum((x - x.bar)*(y-y.bar))/sum((x - x.bar)^2)
  beta.0 = y.bar - beta.1*x.bar
  return(list(a = beta.0, b = beta.1))
}

a = rnorm(1)
b = rnorm(1)
N = 100
x = rnorm(N)
y = a*x + b + rnorm(N)

plot(x, y)
abline(h = 0)
abline(v = 0)
abline(min.sq(x, y)$a, min.sq(x, y)$b, col = "red")

x = x - mean(x)
y = y - mean(y)

abline(min.sq(x, y)$a, min.sq(x, y)$b, col = "blue")

legend("topleft", c("BEFORE", "AFTER"), lty = 1, col = c("red", "blue"))

# example 20
n = 100 ; p = 2
beta = c(1, 2, 3)
x = matrix(rnorm(n*p), nrow = n, ncol = p)
y = beta[1] + beta[2]*x[,1] + beta[3]*x[,2] + rnorm(n)
x = cbind(1, x)
solve(t(x)%*%x) %*% t(x) %*% y


# example 21
i = 1
curve(dchisq(x, i), 0, 20, col = i)
for(i in 2:10)curve(dchisq(x, i), 0, 20, col = i, add = TRUE, ann = FALSE)
legend("topright", legend = 1:10, lty = 1, col = 1:10)


# example 22
curve(dnorm(x), -10, 10, ann = FALSE, ylim = c(0, 0.5), lwd = 5)
for(i in 1:10)curve(dt(x, df= i), -10, 10, col = i, add = TRUE, ann = FALSE)
legend("topright", legend = 1:10, lty = 1, col = 1:10)

# figure
n = 100
x = rnorm(n) + 2
plot(1, 1, xlim = c(0.5, 1.5), ylim = c(0.5, 1.5), xlab = "beta.0", ylab = "beta.1")
for (i in 1:100){
  y = 1+ x + rnorm(n)
  z = cbind(1, x)
  beta.est = solve(t(z)%*%z)%*%t(z)%*%y
points(beta.est[1], beta.est[2], col = i)
}
abline(v = 1)
abline(h = 1)

sum(x)/n
sum(x^2)/n


N = 100
x = rnorm(N); y = rnorm(N)
x.bar = mean(x); y.bar = mean(y)
beta.0=sum(y.bar*sum(x^2)-x.bar*sum(x*y))/sum((x-x.bar)^2)
beta.1=sum((x-x.bar)*(y-y.bar))/sum((x-x.bar)^2)
RSS=sum((y-beta.0-beta.1*x)^2); RSE=sqrt(RSS/(N-1-1))
B.0=sum(x^2)/N/sum((x-x.bar)^2); B.1=1/sum((x-x.bar)^2)
se.0=RSE*sqrt(B.0); se.1=RSE*sqrt(B.1)
t.0=beta.0/se.0; t.1=beta.1/se.1
p.0=2*(1-pt(abs(t.0),N-2)) # p value （the outside probability）
p.1=2*(1-pt(abs(t.1),N-2)) # p value （the outside probability）
beta.0;se.0;t.0;p.0;
beta.1;se.1;t.1;p.1
lm(y~x)

summary(lm(y~x))

N=100; r=1000
T=NULL
for(i in 1:r){
  x=rnorm(N); y=rnorm(N); x.bar=mean(x); y.bar=mean(y)
  fit=lm(y~x);beta=fit$coefficients
  RSS=sum((y-fit$fitted.values)^2); RSE=sqrt(RSS/(N-1-1))
  B.1=1/sum((x-x.bar)^2); se.1=RSE*sqrt(B.1)
  T=c(T,beta[2]/se.1)
}
hist(T,breaks=sqrt(r),probability=TRUE, xlab="t Value",ylab="Probability Density",
     main="The Histgram of t Values and the Theoretical Curve in red")
curve(dt(x, N-2),-3,3,type="l", col="red",add=TRUE)


## 2.6 The Coefficients of Determination and detection of Colinearlity

R2=function(x,y){
  y.hat=lm(y~x)$fitted.values; y.bar=mean(y)
  RSS=sum((y-y.hat)^2); TSS=sum((y-y.bar)^2)
  return(1-RSS/TSS)
}
N=100; m=2; x=matrix(rnorm(m*N),ncol=m); y=rnorm(N); R2(x,y)
N=100; m=1; x=matrix(rnorm(m*N),ncol=m); y=rnorm(N)
R2(x,y)
cor(x,y)^2

vif=function(x){
  p=ncol(x); values=array(dim=p); for(j in 1:p)values[j]=1/(1-R2(x[,-j],x[,j]))
  return(values)
}
library(MASS) 
x=as.matrix(Boston) 
vif(x)


## 2.7 Reliable and Prediction Intervals

# Data Generation
N=100; p=1; X=matrix(rnorm(N*p),ncol=p); X=cbind(rep(1,N),X)
beta=c(1,1); epsilon=rnorm(N); y=X%*%beta+epsilon
#Define f(x) and g(x). U is the inverse of t(X)%*%X
U=solve(t(X)%*%X); beta.hat=U%*%t(X)%*%y;
RSS=sum((y-X%*%beta.hat)^2); RSE=sqrt(RSS/(N-p-1)); alpha=0.05
f=function(x, a){ #a=0 and a=1 mean reliable and prediction intervals
  x=cbind(1,x); range=qt(df=N-p-1,1-alpha/2)*RSE*sqrt(a+x%*%U%*%t(x));
  return(list(lower=x%*%beta.hat-range,upper=x%*%beta.hat+range))
}
x.seq=seq(-10,10,0.1)
# The graph will display the reliable interval
lower.seq=NULL; for(x in x.seq)lower.seq=c(lower.seq, f(x,0)$lower)
upper.seq=NULL; for(x in x.seq)upper.seq=c(upper.seq, f(x,0)$upper)
x.lim=c(min(x.seq),max(x.seq)); y.lim=c(min(lower.seq),max(upper.seq))
plot(x.seq, lower.seq, col="blue",xlim=x.lim, ylim=y.lim, xlab="x",
     ylab="y", type="l")
par(new=TRUE); 
plot(x.seq, upper.seq,col="red", xlim=x.lim, ylim=y.lim, 
     xlab="",ylab="", type="l", axes=FALSE)
par(new=TRUE); 
# The graph will display the confident interval
lower.seq=NULL; for(x in x.seq)lower.seq=c(lower.seq, f(x,1)$lower)
upper.seq=NULL; for(x in x.seq)upper.seq=c(upper.seq, f(x,1)$upper)
x.lim=c(min(x.seq),max(x.seq)); y.lim=c(min(lower.seq),max(upper.seq))
plot(x.seq, lower.seq, col="blue",xlim=x.lim, ylim=y.lim, 
     xlab="",ylab="", type="l", lty=4, axes=FALSE)
par(new=TRUE); 
plot(x.seq, upper.seq, col="red", xlim=x.lim, ylim=y.lim, 
     xlab="",ylab="", type="l", lty=4,
     axes=FALSE)
abline(beta.hat[1],beta.hat[2])
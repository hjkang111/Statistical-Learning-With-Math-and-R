#environment의 개념?
#4개의 작업창 중 오른쪽 상단에 있는 것
#환경 -> 내가 사용하는 모든 객체들 저장
#사용하는 변수, 함수 모두를 객체라고 부름
#환경에 객체가 있어야 우리가 찾아서 실행할 수 있음
#겹겹이 쌓일 때 헷갈리는 상황을 방지해야 함
a=1:5

library(pryr)
parenvs(all=TRUE) #부모 환경 -> parents environment
#내 global env의 부모 환경은 어떻게 되냐
#순서를 봐주어야 함
#1번에 있는 거-> global environment
#그 다음에 나오는 게 pryr
#그 아래 패키지들.. r base
#다음과 같은 계층을 가지고 있음

library(dplyr)
#최근 base보다 더 많이 사용하는 framework=> tidey verse
#ex) ggplot, ...
#다음 패키지를 부착합니다 .. =? 어디서 문제 발생?
#함수를 찾으려고 하는 검색 경로 path가 꼬이면
#library를 못 찾아오거나 다른 이상한 함수를 찾앚옴
#The following objects are masked from ‘package:stats => 'mask'가려짐
#같은 이름으로 겹치는 함수들이 새로운 패키지에 있어서 충돌
#R에서 global environment를 먼저 찾음
#오른쪽 위에 없는 객체를 불러오려면
#parenv에 있었던 객체 불러오는데, 우선 순위가 위에서부터임2에서 못찾으면 3
#최근에 불러온 패키지 우선적으로 검색됨
#앞으로 filter함수를 쓴다면 stat 패키지에 있는 함수가 아니라 dplyr에 있는 함수를 이용하게 됨
#stat에 있는 filter함수를 쓰기 위해서는 namespace이용
# stats::filter
#외부 library를 이용해서 패키지 개발할 때 => namespace를 명시해주는 게 좋음
#다른 사람들의 환경 경우에는 충돌할 수 있음


#스코핑 -> 객체를 찾으려는 구조
#environment 경로의 환경
#search path 저장되어 있는 경로
#엄밀히 말하면 다른지만 같다고 이해해도 여기서는 무방
#console에서 search()라고 입력해주면
#내가 사용하고 있는 경로 나옴


#아래 함수를 R에서 base로 제공
parent.env(globalenv())

#시뮬레이션 코드를 짤 때 기본적으로 다음과 같은 코드를 입력해줌
rm(list=ls())
#코드 중복되거나 시뮬레이션 결과 충돌 등이 발생할 수 있기 때문에
#list인자는 내가 지우고자 하는 객체들의 벡터

a=1:5
b = 2:4
d= 1:10
#R에서는 c함수가 있는 때문에 vector이름으로 c를 사용하지 않음
#environment 충돌할 수 있기 때문에-> 웬만해서는 같은 이름을 피하자

T = 1:4
T #True때문에 T말고 True라고 작성하는 게 좋음
#리눅스 명령어들이 R에 많이 있음
#현재 저장되어 있는 객체들 나열 코드
ls()
#값들 및 타입 출력
ls.str()
#객체 하나를 지우고 싶을 때
#rm이랑 remove 같은 함수임
rm(a)
ls()
#ls함수는 environment를 argue로 받음(list object)
#현재 환경에서 가지고 있는 객체를 지우는 것이 기본
rm(list=ls(globalenv())) ###해당 코드 다시 보기

#env를 왜 이해해야 하냐?
#search path가 충돌하는 것을 막기 위해서
#함수를 짜고 실행될 때 어떤 env에서 실행되고 저장되는지를 이해해야 함

#이제 함수로 넘어가서 설명
#함수에 인자 전달, 함수가 실행되고 있는 환경은 전역 환경이 아님(global env)가 아님
#함수가 실행되고 있을 때 새로운 env가 생기고, 거기서 실행되는 것임
#함수가 종료되면 해당 env는 사라짐
#함수가 return없이 끝나면 그냥 사라지는 것

nums =1:5
print(nums) #global env에서 가져온 객체임
#해당 함수에 인자는 없음
#return을 안하면 밖에 global에서 볼 수 없음
#return안하고 보려면 디버깅 모드로 접근해야 함
add_numbers = function()
{
  nums = 1:10
  sum_nums = sum(nums)
  return(list(value=sum_nums, runtime_env = environment(), parent_env()= parent.env(environment()),objects_env=ls.str(environment())
              ))
}
add_numbers()

#environment() 코드가 저 함수가 실행되는 환경이 global이라는 의미
####################################여기 다시 들으셈

#env는 실체가 없이 메모리 주소에만 의존해서 저장된 것임
#함수가 끝나면 소멸할 runtime_environment
#호출되는 환경은 global env
#ls.str(environment())에서의 environment는 runtime environment를 의미하는것임

nums
#해당 결과는 1 2 3 4 5임
#함수가 종료되면서 함수 안의 1:10은 사라지는 것임



#함수 하나 더
add_numbers_2 = function()
{
  sum_nums = sum(nums)
  return(sum_nums)
}
add_numbers_2()

#nums가 함수 안에서 선언되어 있지 않음
#없는데 어떻게 쓰냐..
#원래대로라면 error가 나와야 함
#그런데, R에서는 에러가 안남
#왜 돌아갈까?
#함수가 돌았기 때문에 runtime env
#runtime 에는 없는데
#global에는 있어서그냥 그거 가져온거임
##예???????????????
#함수에서 사용하고 있는 변수들이 해당 함수에 모두 정의를 했는지 확인해주어야 함
#함수 안에 함수가 있는 구조 -> 스코핑 제대로 하고 있는지 확인해주어야 함

#함수를 정의할 때 해당 함수에서 사용하고자 하는 변수들을 본격적인 함수 서술 전에 정의해주게
#되어 있음
#코드를 vectorize해라!!(for문 돌리지 말고 ...)
#이너 프로덕트 계산-> 계산해주는 함수 만듦

ip = function(a,b)
{
  temp=0
  for (i in 1:length(a))
    temp = temp + a[i] + b[i]
  return(temp)
}

#너무 느리니까 for문 많이 써서 함수 정의하지 마라 !!
#R은 컴파일 언어가 아님
#그때그때 한 줄한줄을 해석 -> 속도가 느림
#만약에 for문을 사용하지 않고 base에 있는 함수로 계산할 수 있음

sum(a*b) #base함수로 inner product 계산해주는 코드
#R에서 제공하는 base 함수는 모두 컴파일 언어로 작성되어 있음
#코드를 짤 때 베이스에 있는 함수를 많이 이용하면 계산이 매우 빨라짐
#R이 왜 느리냐?
a=1:3
#for문을 돌리면 반복해서 vec에 저장
a = c(a,4)
a
#1000번을 돌리면 돌리면서 vector를 키워나가는 것임
#but 이것은 안 좋은 코드다 !!!!!!!
#왜 ??
#c언어는 컴파일 언어라서 메모리를 미리 잡아놓음
#R은 컴파일 언어가 아니라서 메모미를 미리 잡아놓지 않음
#메모리에 할당이 안 되어 있으면 a가 시작되는 위치를 바꿔주어야 함
#원래 있던 a에 4만 채우는 게 아니라
#새로운 1:3 a를 만들어내는 것임
#메모리 잡아놓는 방법
a= numeric(6)
# or
a = rep(0,6)

#여기도 무슨 말인지 잘 모르겠다..
#메모리 구조와 env를 잘 이해하고 있어야 함

#하나만 더
#코드가 돌아가야지 의미가 있음
#돌아가는 코드로 최적화하는 것임




#새로운 예제
nums=1:5
modify_nums = function(nums)
{ #가장 왼쪽에 있는 nums가 global이라고 생각하지 말기
  nums = nums +1 #runtime env안에 nums라는 객체가 생김 전달받은 값임
  return(nums)
}
nums = modify_nums(nums=nums) #여기 제일 오른쪽에 있는 nums는 global것임
nums
#global->runtime -> global env
#####################################
#새로운 예제
nums=1:5
modify_nums = function(a)
{ 
  a = a +1 
  return(a)
}
nums = modify_nums(a=nums) 
nums
#global->runtime -> global env
###################################
#라쏘 적합 함수를 짠다고 가정함
lasso = fucntion(X, Y, lambda) #여기 있는 세 개의 인자는 그냥 이름일 뿐임
#xy가 아니라 ab로 바꿔도 코드가 그대로 돌아감
#귀찮으니까 함수의 인자 이름이랑 gloenv의 객체 이름을 동일하게 하는 경우들이 있음

X
Y
lambda =2
lasso(X,Y, lambda)
lasso(X=X,Y=Y, lambda=lambda)
#global에서 X, Y, lambda 설정


###########################################이제 markdown
#간단하게review형식
#qurto(퀄도)가 뭔지 이해
#코드 기반으로 커뮤니케이션 예?
#퀄도와 마크다운의 문법이 비슷함
#-> 마크다운 쓸 줄 알면 퀄토도 가능함
#퀄도는 통합된 framework
#장점 -> R 마크다운에서 패키지 받아써야 하는것들을 기본적으로 사용가능
#마크다운에서 잘 안되던 것들 구현 가능
#마크ㅏ운은 R에서만 쓸 수 있음
#퀄도는 R 뿐만 아니라 파이썬 등에서도 사용할 수 있음 

#파이토치는 파이썬이 아니라 C++로 작성된 언어임
#r코드는 r, 파이썬은 파이썬 통합 문서 -> 퀄토 사용하면 좋음
#퀄토는 R이랑 독립적으로 만들어진 것임

#마크다운이나 퀄토 생성 방법ㅂ은 비슷함
#마크다운 만드는 곳에서 qurto document
#source editor vs visual editor
#html파일로 사용하는 것이 가장 결과가 깔끔하게 나옴(pdf도 쓰긴 함)
#html의 헤더 구조를 그대로 가지고 온다고 보면 됨
#내가 분석한 코드와 결과를 문서와 interactive하게 사용가능함 -> 장점
#교수님한테 코드 질문할 때 노트북 가져가지 말고 마크다운으로 문서 보내드리기
#그냥 text일 때 'r n'이면 코드에서 n선언한 게 그대로 text로 들어감
#표 만드는 건 레이텍이랑 다름

#header 작성하는 부분
#output -> html, pdf
#헤더에서 indent 띄울 때 띄워도 되고 안띄워도 됨 벗 칸 수 틀리면 오류 발생
#html파일의 스타일을 내 마음대로 적용할 수 있음
#pdf를 만들 때는 사용할 패키지를 header include에 넣어주어야 함
#아니면 충돌해서 오류 남

#마크다운에서 까다로운 것 -> cross referencing
#그림, 표, 식 번호를 직접 입력해서 reference를 입력해서는 안됨
#상호참조를 이용해서 자동으로 번호가 매겨지게 한다 !!


#bib tex사용하는 거 배워놔야 함
#reference에 들어가는 목록들을 직접 손으로 작성하는것아님
#latex에서 내 논문에 들어가는 reference들의bib파일
#이거에 대한 latex의 문법도 알아놓아야 함

#html header에서 bibliography
#맨 마지막에 reference section만들어줘야 함
#퀄토에서는 header에 title format이 있음
#퀄토는 header에서 다중format관리가 쉬움
#마크다운을 그냥 퀄토에서 돌릴 수 있음

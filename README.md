추가한 패키지
- table_calendar: ^3.0.9
- intl: ^0.18.1
- drift: ^2.10.0
- get_it: ^7.6.0

drift 추가시 
https://drift.simonbinder.eu/docs/getting-started/


## 에러 처리 
### 1. Failed assertion: line 128 pos 12: 'shape != BoxShape.circle || borderRadius == null': is not true.
<image width='600' src='https://velog.velcdn.com/images/miniso/post/37daf9c1-1282-4a68-9533-9716b8fed01f/image.png'/><br/>
 BoxShape가 circle인 경우에는 borderRadius가 null이 아니어야 한다는 조건을 만족하지 않을 때 발생

CalendarStyle에 다음 코드 추가  

```
outsideDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
        ),
```
<br/>
<br/>

## 남겨두기
### WidgetsFlutterBinding.ensureInitialized();
https://api.flutter.dev/flutter/widgets/WidgetsFlutterBinding/ensureInitialized.html
- 바인딩이 초기화되지 않았다면, WidgetsFlutterBinding 클래스를 사용하여 새로운 바인딩 인스턴스를 생성하고 초기화
- runApp을 호출하기 전에 바인딩이 초기화되어야 하는 경우에만 이 메서드를 호출
- Flutter 애플리케이션에서 비동기 작업을 수행하기 전에 초기화 작업을 수행하기 위해 사용
- 왜 비동기 작업 전에 초기화를 진행해야할까? 
  - 앱의 안정성을 높이고 일관된 상태를 보장하기 위해서. 만약 초기화 진행하지 않고 비동기 작업을 수행하면 오류가 발생할 수 있음
  - 나의 경우 main함수내에서 intl 작업을 비동기적으로 진행하고 있기 때문에 해당 작업 전에 초기화 작업을 수행.
  
<br/>
  
### textFormField를 두가지 방법으로 저장하기 
- textFormField 아웃포커싱 되면 저장 
- 키보드 내 done 버튼 누르면 저장
 
<br/>

### 스케줄 카드의 수정하기 버튼을 눌렀을 때 해당 필드로 포커스되게 하기
#### - 기존코드
스케줄 카드의 수정하기 버튼을 처음 누른 경우 해당 필드로 포커스 되지 않고, <br/> 
다시 한번 수정하기 버튼을 눌러야 해당 필드로 포커스가 되었다.
```dart
  void onPressedEdit() {
    Navigator.pop(context);
    setState(() {
      editable = true;
    });
    _focusNode.requestFocus();
  }
```
onPressedEdit함수 내에서 _focusNode 값을 print해보니 <br/>
첫번째 클릭시 `flutter: FocusNode#e072f(context: Focus, NOT FOCUSABLE)` <br/>
두번째 클릭시 `flutter: FocusNode#e072f(context: Focus)`

이는 FocusNode가 렌더링 된 이후에 포커스를 요청해야한다는 것.
위 코드에서 onPressedEdit 함수가 호출되었을 때 setState를 통해 위젯이 다시 렌더링되면서 _focusNode.requestFocus()를 호출하기 때문에 문제가 발생하는 것. 

`WidgetsBinding.instance?.addPostFrameCallback`은 위젯이 렌더링된 후에 특정 작업을 실행시킨다.
때문에 `WidgetsBinding.instance?.addPostFrameCallback`을 사용하여 위젯이 다시 렌더링된 후에 포커스를 요청하도록 한다.

#### - 수정코드
```dart
    WidgetsBinding.instance?.addPostFrameCallback((_){
      FocusScope.of(context).requestFocus(_focusNode);
    });
```
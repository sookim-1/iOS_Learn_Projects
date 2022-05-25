# 프로젝트 요약서

## 앱 기능:

- 사용자는 GitHub 사용자 이름을 입력하고 해당 사용자 이름의 팔로워 목록을 검색할 수 있습니다.
- 사용자는 팔로워 내에서 특정 팔로워를 검색할 수 있습니다.
- 사용자는 팔로워 목록에 있는 팔로워를 눌러 팔로워에 대한 자세한 정보를 얻을 수 있습니다.
- 사용자는 즐겨찾는 사용자 이름 검색을 저장할 수 있습니다. (앱 실행 사이에 지속되어야 합니다.)

## 요구사항:

- 100% 프로그래밍 UI - 스토리보드 없음
- 타사 라이브러리 없음

## 세부 정보:

- GitHub API 사용 - 인증 필요 없음
    - Followers endpoint - https://developer.github.com/v3/users/followers/
    - User info endpoint - https://developer.github.com/v3/users/

## 사용한 기술:

- **Stack** : Swift, Github API, Programmatic UI, DiffableDataSource, URLSession, CustomView

## 고민 한 점:

### `let usernameTextField = GFTextField()`  구문에서 초기화하는 경우 파라미터가 없기때문에 NSObject의 기본 이니셜라이저를 사용하지 않을까? 그렇다면 이것은 frame 이니셜라이저 안에서 호출된다는 의미라서 `configure()`가 호출되지 않을 수 있지 않을까?

- 각 계층별 init() 메서드 호출 순서
    
    ```swift
    
    import Foundation
    
    class NSObject {
        init() {
            print("NSObject init")
        }
    }
    
    class UIResponder: NSObject {}
    
    class UIView: UIResponder {
        var frame: Float
        
        init(frame: Float) {
            print("UIView Frame init")
            self.frame = frame
            super.init()
        }
        
        override convenience init() {
            print("UIView Convenience init")
            self.init(frame: .zero)
        }
    }
    
    class UITextField: UIView {}
    
    class GFTextField: UITextField {
        override init(frame: Float) {
            super.init(frame: frame)
            configure()
        }
        
        private func configure() {
            print("Configure function called")
        }
    }
    
    let instance = GFTextField()
    
    출력값:
    
    UIView Convenience init
    UIView Frame init
    NSObject init
    Configure function called
    ```
    

각 계층별 init메서드 호출 순서를 확인한 후 UIView의 Convenience init()때문에 매개변수와 관계없이 호출되는 것을 확인해볼 수 있었습니다.

### PersistenceManager - UserDefaults를 사용하여 커스텀타입을 저장하는 타입에서 왜 구조체가 아닌 열거형을 사용했는지?

열거형에서 `static` 을  사용하면 빈 열거형을 초기화할 수 없는데 구조체에서는 빈구조체를 초기화할 수도 있으므로 오류를 방지하기 위해 열거형으로 사용 

→ 즉, 인스턴스를 만들 필요가없을 때 `static` 키워드를 사용한다면 Enum으로 사용하는 것도 한 방법일듯

- [https://stackoverflow.com/questions/38585344/swift-constants-struct-or-enum](https://stackoverflow.com/questions/38585344/swift-constants-struct-or-enum)

열거형을 싱글톤으로 구현하기 (싱글톤은 클래스로 권장)

- [https://medium.com/@cgoldsby/swift-an-enum-for-a-singleton-9f8a1780a21f](https://medium.com/@cgoldsby/)

### static 함수를 사용하는 것과 싱글톤을 사용하는 것의 차이점?

- [https://stackoverflow.com/questions/519520/difference-between-static-class-and-singleton-pattern](https://stackoverflow.com/questions/519520/difference-between-static-class-and-singleton-pattern)

가장 큰 차이점은 싱글톤을 사용하면 내부메서드등을 프로토콜 및 상속등 인터페이스를 구현할 수 있지만 static함수로 사용하면 인터페이스를 구현할 수 없다. 

하지만, 너무 많은 싱글톤 사용은 자제해야한다고 권장하기 때문에 추후 확장성이 필요한 경우 싱글톤을 사용하고 아닌 경우에는 static함수로 사용하는 것이 좋을 것 같다.

## 트러블 슈팅:

### 페이지네이션을 통해 추가로 데이터를 받아 이미지를 표시하는 경우 빠르게 스크롤 하면 placeholder이미지 대신 이전 이미지를 재사용하는 문제

가장 근본적인 이유는 collectionView가 재사용큐를 사용하기 때문에 이전 셀에 있는 데이터를 재사용한 문제입니다.

- 컬렉션뷰는 아이템을 재사용 Dequeue하기 때문에 사용하기전에 초기화를 해야합니다.
    
    ```swift
    override func prepareForReuse() {
    	super.prepareForReuse()
    	avataImageView.image = avatarImageView.placeholderImage
    }
    ```
    

- prepareForReuse에서 이미지를 다루면 안된다는 공식문서가 있어서 다른방법
    - [https://developer.apple.com/documentation/uikit/uitableviewcell/1623223-prepareforreuse](https://developer.apple.com/documentation/uikit/uitableviewcell/1623223-prepareforreuse)
    
    ```swift
    // FollowerListVC.swift의 configureDataSource메서드에서 추가
    
    cell.avatarImageView.image = cell.avatarImageView.placeholderImage
    ```

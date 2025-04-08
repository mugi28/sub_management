-- 사용자 정보 테이블
CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY,        -- 사용자 ID (기본키)
    password VARCHAR(255) NOT NULL,         -- 암호화된 비밀번호
    user_name VARCHAR(50) NOT NULL,         -- 사용자 실명
    email VARCHAR(100) UNIQUE NOT NULL,     -- 이메일 (중복 불가)
    phone VARCHAR(20)          -- 전화번호
);

-- 비밀번호 인덱스 추가 (검색 최적화)
CREATE INDEX idx_password ON users(password);

-- 구독 가능한 서비스 목록 테이블
CREATE TABLE subscription_services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,  -- 서비스 ID
    service_name VARCHAR(100) NOT NULL,        -- 서비스명 (넷플릭스, 유튜브 프리미엄 등)
    description TEXT,                         -- 서비스 설명
    base_price DECIMAL(10, 2) NOT NULL,       -- 기본 가격
    billing_cycle VARCHAR(20) NOT NULL,       -- 결제 주기 (monthly, yearly 등)
    is_active BOOLEAN DEFAULT TRUE            -- 서비스 활성 상태
);


-- 사용자 구독 정보 테이블
CREATE TABLE user_subscriptions (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,  -- 구독 ID
    user_id VARCHAR(50) NOT NULL,                   -- 사용자 ID (외래키)
    service_id INT NOT NULL,                        -- 서비스 ID (외래키)
    subscribed_price DECIMAL(10, 2) NOT NULL,       -- 실제 구독 가격 (할인 적용 가능)
    payment_method VARCHAR(50) NOT NULL,            -- 결제 수단 (credit_card, bank_transfer 등)
    payment_account VARCHAR(100),                   -- 결제 계좌/카드 마스킹 정보
    subscription_date DATE NOT NULL,                -- 구독 시작일
    next_payment_date DATE NOT NULL,                -- 다음 결제 예정일
    last_payment_date DATE,                        -- 마지막 결제일, syntax 에러? DATE로 수정
    last_payment_amount DECIMAL(10, 2),            -- 마지막 결제 금액
    subscription_status ENUM('active', 'paused', 'cancelled') DEFAULT 'active', -- 구독 상태 , syntax 에러? subscription_status로 수정
    auto_renewal BOOLEAN DEFAULT TRUE,              -- 자동 갱신 여부
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  -- 구독 생성일시
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 정보 수정일시
    
    -- 외래키 제약조건
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES subscription_services(service_id)
);

-- 사용자 ID + 서비스 ID 조합 인덱스 (중복 구독 방지)
CREATE UNIQUE INDEX idx_user_service ON user_subscriptions(user_id, service_id);

-- 결제 내역 테이블
CREATE TABLE payment_history (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,  -- 결제 ID
    subscription_id INT NOT NULL,              -- 구독 ID (외래키)
    user_id VARCHAR(50) NOT NULL,              -- 사용자 ID (외래키)
    amount DECIMAL(10, 2) NOT NULL,            -- 결제 금액
    payment_date DATETIME NOT NULL,            -- 결제 일시
    payment_method VARCHAR(50) NOT NULL,       -- 결제 수단
    payment_status ENUM('completed', 'failed', 'refunded') DEFAULT 'completed', -- 결제 상태
    transaction_id VARCHAR(100),               -- 거래 ID (PG사에서 발급)
    receipt_url VARCHAR(255),                  -- 영수증 URL
    notes TEXT,                                -- 비고
    
    -- 외래키 제약조건
    FOREIGN KEY (subscription_id) REFERENCES user_subscriptions(subscription_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 결제일자 인덱스 (기간별 조회 최적화)
CREATE INDEX idx_payment_date ON payment_history(payment_date);

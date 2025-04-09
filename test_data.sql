-- test_data.sql
-- 구독 관리 시스템(subs_db) 테스트 데이터를 삽입하는 쿼리

-- 1. 테이블 초기화
-- 외래키 제약조건 때문에 순서대로 초기화
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE payment_history;
TRUNCATE TABLE user_subscriptions;
TRUNCATE TABLE subscription_services;
TRUNCATE TABLE users;
SET FOREIGN_KEY_CHECKS = 1;

-- 2. users 테이블 데이터 삽입
INSERT INTO users (user_id, password, user_name, email, phone)
VALUES ('user1', 'hashed_password', 'John Doe', 'john@example.com', '123-456-7890');

-- 3. subscription_services 테이블 데이터 삽입
INSERT INTO subscription_services (service_name, description, base_price, billing_cycle, is_active)
VALUES ('Netflix', 'Streaming service', 15.99, 'monthly', TRUE),
       ('Spotify', 'Music streaming', 9.99, 'monthly', TRUE);

-- 4. user_subscriptions 테이블 데이터 삽입
INSERT INTO user_subscriptions (user_id, service_id, subscribed_price, payment_method, subscription_date, next_payment_date, subscription_status)
VALUES ('user1', 1, 15.99, 'credit_card', '2025-01-01', '2025-02-01', 'active'),
       ('user1', 2, 9.99, 'credit_card', '2025-01-01', '2025-02-01', 'active');

-- 5. payment_history 테이블 데이터 삽입
INSERT INTO payment_history (subscription_id, user_id, amount, payment_date, payment_method, payment_status)
VALUES (1, 'user1', 15.99, '2025-01-01 10:00:00', 'credit_card', 'completed'),
       (1, 'user1', 15.99, '2025-02-01 10:00:00', 'credit_card', 'completed'),
       (1, 'user1', 15.99, '2025-03-01 10:00:00', 'credit_card', 'completed'),
       (2, 'user1', 9.99, '2025-01-01 10:00:00', 'credit_card', 'completed'),
       (2, 'user1', 9.99, '2025-02-01 10:00:00', 'credit_card', 'completed'),
       (2, 'user1', 9.99, '2025-03-01 10:00:00', 'credit_card', 'completed');
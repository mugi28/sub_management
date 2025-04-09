-- 1. 월별 지출 합계를 계산하는 쿼리
-- 결제 상태가 'completed'인 레코드를 대상으로 월별 구독료 지출 합계를 계산
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    SUM(amount) AS total_expense
FROM payment_history
WHERE payment_status = 'completed'
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY month;


-- 2. 서비스별 지출 분석 쿼리
-- 결제 상태가 'completed'인 레코드를 대상으로 서비스별 구독료 지출 합계를 계산
SELECT 
    ss.service_name,
    SUM(ph.amount) AS total_expense
FROM payment_history ph
JOIN user_subscriptions us ON ph.subscription_id = us.subscription_id
JOIN subscription_services ss ON us.service_id = ss.service_id
WHERE ph.payment_status = 'completed'
GROUP BY ss.service_name;
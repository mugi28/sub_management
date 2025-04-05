import pymysql 

# 데이터베이스 설정
DB_HOST = "localhost"  # 데이터베이스 호스트 (localhost 또는 IP 주소)
DB_USER = "root"
DB_PASSWORD = "ghdwhdgy0328!"  # ❗실제 운영에서는 환경변수로 관리 권장
DB_NAME = "subs_manage"  # 데이터베이스 이름

# 데이터베이스 연결 함수
def get_db_connection():
    connection = pymysql.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        cursorclass=pymysql.cursors.DictCursor  # 결과를 딕셔너리로 반환
    )
    return connection

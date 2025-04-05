from flask import Blueprint, render_template, request, redirect, url_for, flash
from DB import get_db_connection
import pymysql
import pandas as pd  # ID 중복 확인 함수에서 사용

auth_bp = Blueprint('auth', __name__, url_prefix='/auth')


@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        user_id = request.form['user_id']
        password = request.form['password']
        conn = get_db_connection()
        if conn:
            cursor = conn.cursor(pymysql.cursors.DictCursor)  # 결과를 딕셔너리 형태로 받기
            try:
                sql = 'select password from users where user_id=%s'
                cursor.execute(sql, user_id)
                user = cursor.fetchone()
                if user is None:
                    flash('존재하지 않는 아이디입니다.', 'error')
                elif user['password'] != password:  # 실제로는 비밀번호 해싱 후 비교해야 함
                    flash('비밀번호가 잘못되었습니다.', 'error')
                else:
                    flash('로그인 성공!', 'success')
                    return redirect(url_for('main.dashboard'))
            except pymysql.Error as err:
                print(f"데이터베이스 오류 (PyMySQL): {err}")
                flash('로그인 중 오류가 발생했습니다.', 'error')
            finally:
                cursor.close()
                conn.close()
        else:
            flash('데이터베이스 연결에 실패했습니다.', 'error')
        return render_template('auth/login.html', user_id=user_id)
    return render_template('auth/login.html')

@auth_bp.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        user_id = request.form['user_id']
        user_name = request.form['name']
        email = request.form['email']
        phone = request.form['phone_number']
        password = request.form['password']
        confirm_password = request.form['confirm_password']

        if password != confirm_password:
            flash('비밀번호가 일치하지 않습니다.', 'error')
            return render_template('auth/register.html', user_id=user_id, name=user_name, email=email, phone_number=phone)

        conn = get_db_connection()
        if conn:
            cursor = conn.cursor(pymysql.cursors.DictCursor)  # 결과를 딕셔너리 형태로 받기
            try:
                # 아이디 중복 확인
                sql = 'select user_id from users where user_id=%s'
                cursor.execute(sql, user_id)
                existing_user_id = cursor.fetchone()
                if check_already_resisted([existing_user_id], user_id):
                    flash('이미 사용 중인 아이디입니다.', 'error')
                    return render_template('auth/register.html', user_id=user_id, name=user_name, email=email, phone_number=phone)

                # 이메일 중복 확인
                sql = 'select email from users where email=%s'
                cursor.execute(sql, email)
                existing_email = cursor.fetchone()
                if existing_email:
                    flash('이미 사용 중인 이메일입니다.', 'error')
                    return render_template('auth/register.html', user_id=user_id, name=user_name, email=email, phone_number=phone)

                # 비밀번호 해싱 (보안을 위해 필수!) - 여기서는 임시로 평문 저장
                sql = 'insert into users (user_id, password, user_name, email, phone) values(%s, %s, %s, %s, %s)'
                cursor.execute(sql, (user_id, password, user_name, email, phone))
                conn.commit()
                flash('회원가입이 완료되었습니다.', 'success')
                return redirect(url_for('auth.login'))
            except pymysql.Error as err:
                print(f"데이터베이스 오류 (PyMySQL): {err}")
                flash('회원가입 중 오류가 발생했습니다.', 'error')
            finally:
                cursor.close()
                conn.close()
        else:
            flash('데이터베이스 연결에 실패했습니다.', 'error')
            return render_template('auth/register.html', user_id=user_id, name=user_name, email=email, phone_number=phone)

    return render_template('auth/register.html') # GET 요청 시에는 회원가입 페이지를 보여줍니다.

# ID 중복여부 확인 (기존 코드를 가져옴)
def check_already_resisted(data, ID):
    df = pd.DataFrame(data)
    if len(df) == 0 or df.iloc[0, 0] is None:  # 데이터가 없거나 첫 번째 값이 None인 경우
        return False
    return True
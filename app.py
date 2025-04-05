from flask import Flask, render_template
from API.register import auth_bp

app = Flask(__name__)
app.register_blueprint(auth_bp)

@app.route('/')
def index():
    return render_template('/html/login.html')

@app.route('/register')
def register():
    return render_template('/html/register.html')

if __name__ == '__main__':
    app.run(debug=True)
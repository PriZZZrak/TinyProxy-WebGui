from flask import Flask, render_template, request
import html
import subprocess

app = Flask(__name__)
CONFIG_FILE_PATH = '/etc/tinyproxy/tinyproxy.conf'

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        line_text = request.form['line']

        # Sanitize the input line
        line_text = html.escape(line_text)

        # Check if the line is not empty
        if line_text.strip() != "":
            
            line_text = sanitize_line(line_text)

            # Check if the line already exists in the configuration file
            if line_exists(line_text):
                return "Сайт уже существует в прокси!"

            add_line_to_config(line_text)
            restart_proxy_service()

            return "Сайт успешно добавлен в прокси!"
        else:
            return "Поле не может быть пустым!"
        
    # Get the list of existing sites from the configuration file
    existing_sites = get_existing_sites()
    
    return render_template('index.html', existing_sites=existing_sites)
    
@app.route('/delete', methods=['POST'])
def delete():
    site = request.form['site']

    # Remove the site from the configuration file
    remove_site_from_config(site)
    restart_proxy_service()
    
    return "Сайт успешно удален!"
    
@app.route('/get_sites', methods=['GET'])
def get_sites():
    existing_sites = get_existing_sites()

    return render_template('site_list.html', existing_sites=existing_sites)
    
def sanitize_line(line_text):
    if line_text.startswith("http://"):
        line_text = line_text[7:]
    elif line_text.startswith("https://"):
        line_text = line_text[8:]
    
    line_text = line_text.split('/')[0]
    
    if not line_text.startswith('.'):
        line_text = '.' + line_text
    
    return line_text

def remove_site_from_config(site):
    # Read the lines from the configuration file
    with open(CONFIG_FILE_PATH, 'r') as file:
        lines = file.readlines()

    # Remove the line containing the site
    lines = [line for line in lines if site not in line]

    # Write the modified lines back to the configuration file
    with open(CONFIG_FILE_PATH, 'w') as file:
        file.writelines(lines)

def line_exists(line):
    # Check if the line already exists in the configuration file
    with open(CONFIG_FILE_PATH, 'r') as file:
        for existing_line in file:
            if line in existing_line:
                return True
    return False

def get_existing_sites():
    existing_sites = []
    with open(CONFIG_FILE_PATH, 'r') as file:
        for existing_line in file:
            if existing_line.startswith('upstream socks5'):
                site = existing_line.split('"')[1]
                existing_sites.append(site)
    return existing_sites

def add_line_to_config(line):
    with open(CONFIG_FILE_PATH, 'a') as file:
        file.write(f'upstream socks5 127.0.0.1:9050 "{line}"\n')

def restart_proxy_service():
    subprocess.run(['service', 'tinyproxy', 'restart'])
    
if __name__ == '__main__':
    app.run(host='0.0.0.0')

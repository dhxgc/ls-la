import os
import sys
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import unquote
import mimetypes

try:
    import markdown
    HAVE_MARKDOWN = True
except ImportError:
    HAVE_MARKDOWN = False


class SimpleFileServer(BaseHTTPRequestHandler):
    base_path = os.getcwd()

    def do_GET(self):
        path = unquote(self.path.lstrip('/'))
        fs_path = os.path.join(self.base_path, path)

        if os.path.isdir(fs_path):
            self.list_directory(fs_path, path)
        elif os.path.isfile(fs_path):
            if fs_path.endswith('.md') and HAVE_MARKDOWN:
                self.render_markdown(fs_path)
            else:
                self.serve_file(fs_path)
        else:
            self.send_error(404, 'Not Found')

    def list_directory(self, fs_path, web_path):
        try:
            entries = os.listdir(fs_path)
            entries.sort()
            self.send_response(200)
            self.send_header('Content-type', 'text/html; charset=utf-8')
            self.end_headers()

            self.wfile.write(f"""<html>
<head><meta charset="utf-8"><title>Index of /{web_path}</title></head>
<body>
<h2>Index of /{web_path}</h2>
<ul>""".encode('utf-8'))

            if web_path:
                parent = '/'.join(web_path.strip('/').split('/')[:-1])
                self.wfile.write(f'<li><a href="/{parent}">..</a></li>'.encode('utf-8'))

            for entry in entries:
                full_path = os.path.join(fs_path, entry)
                display_name = entry + '/' if os.path.isdir(full_path) else entry
                link = os.path.join('/', web_path, entry).replace('\\', '/')
                self.wfile.write(f'<li><a href="{link}">{display_name}</a></li>'.encode('utf-8'))

            self.wfile.write("</ul></body></html>".encode('utf-8'))
        except Exception as e:
            self.send_error(500, f'Error listing directory: {e}')

    def serve_file(self, fs_path):
        try:
            mime, _ = mimetypes.guess_type(fs_path)
            mime = mime or 'text/plain'

            # Force .sh and similar to render as text
            if mime.startswith('application') and fs_path.endswith(('.sh', '.py', '.conf', '.ini')):
                mime = 'text/plain'

            self.send_response(200)
            self.send_header('Content-Type', f'{mime}; charset=utf-8')
            self.send_header('Content-Disposition', 'inline')
            self.end_headers()

            with open(fs_path, 'rb') as f:
                self.wfile.write(f.read())
        except Exception as e:
            self.send_error(500, f'Error serving file: {e}')


    def render_markdown(self, fs_path):
        try:
            with open(fs_path, 'r', encoding='utf-8') as f:
                text = f.read()

            html = markdown.markdown(text, extensions=['fenced_code', 'codehilite'])

            self.send_response(200)
            self.send_header('Content-type', 'text/html; charset=utf-8')
            self.end_headers()

            self.wfile.write(b"""
<html>
<head>
    <meta charset="utf-8">
    <title>Markdown</title>
    <style>
        body {
            font-family: sans-serif;
            padding: 20px;
            max-width: 900px;
            margin: auto;
        }
        h1, h2, h3 {
            border-bottom: 1px solid #ddd;
            padding-bottom: 4px;
        }
        a {
            color: #0366d6;
            text-decoration: none;
        }
        pre {
            overflow-x: auto;
            padding: 10px;
            background: #f4f4f4;
            border-radius: 4px;
            white-space: pre;
        }
        pre code {
            font-family: monospace;
            white-space: pre-wrap;
            word-break: break-word;
            display: block;
            overflow-wrap: break-word;
        }
        code {
            background: #f4f4f4;
            padding: 2px 4px;
            border-radius: 3px;
            font-family: monospace;
        }
    </style>
</head>
<body>
""")
            self.wfile.write(html.encode('utf-8'))
            self.wfile.write(b"</body></html>")
        except Exception as e:
            self.send_error(500, f'Error rendering markdown: {e}')




def run(directory='.', port=8000):
    SimpleFileServer.base_path = os.path.abspath(directory)
    server = HTTPServer(('0.0.0.0', port), SimpleFileServer)
    print(f"Serving {directory} at http://0.0.0.0:{port}")
    server.serve_forever()


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--dir', default='.', help='Directory to serve')
    parser.add_argument('--port', type=int, default=8000, help='Port to serve on')
    args = parser.parse_args()
    run(args.dir, args.port)

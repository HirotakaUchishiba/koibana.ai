# [WIP] koibana.ai

## Setup

### Server

```sh
# パッケージをインストール
cd server
pip install -r requierments.txt

# .envファイルを作る
touch .env
# 岩田から環境変数を貰って記入する

# 動かす

cd app
uvicorn main:app --reload

# ↑ こうすると localhost:8000 が立ち上がるので

# ↓ こうするとレスポンスが返ってくる

curl localhost:8000

# ↓ こうすると LLM が動く

curl -N -X POST \ ─╯
-H "Accept: text/event-stream" -H "Content-Type: application/json" \
 -d '{"query": "あなたは誰ですか？？"}' \
 http://localhost:8000/chat

```
